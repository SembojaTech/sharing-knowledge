#!/usr/bin/env bash
#
# bootstrap.sh — Create the LocalStack AWS resources for the ITE-SPA-06 SNS/SQS demo.
#
# Idempotent: safe to run multiple times. Creates the SNS topics, the SQS queue,
# and the SNS->SQS subscription that the producer (serverless-nestjs-api-sns) and
# consumer (serverless-nestjs-sqs-consumer) expect.
#
# Prerequisites:
#   - Docker running
#   - LocalStack running on :4566   (localstack start, or docker compose)
#   - aws CLI v2 installed
#
# Usage:
#   ./bootstrap.sh            # create resources + write missing .env.local files
#   ./bootstrap.sh --no-env   # create resources only, skip .env.local generation
#
set -euo pipefail

# ---- Config (must match serverless.yml + simulate-sns-*.sh) -------------------
ENDPOINT="${LOCALSTACK_ENDPOINT:-http://localhost:4566}"
REGION="${AWS_REGION:-ap-southeast-1}"
ACCOUNT="000000000000"

QUEUE_NAME="MyLocalNestJSQueue"
TOPIC_WITH_SQS="WithSQSTopic"        # SNS -> SQS -> consumer Lambda
TOPIC_WITHOUT_SQS="WithoutSQSTopic"  # SNS -> consumer Lambda directly
TOPIC_DEFAULT="MyLocalNestJSSNSTopic" # producer default SNS_TOPIC_ARN (troubleshooting.md)

QUEUE_ARN="arn:aws:sqs:${REGION}:${ACCOUNT}:${QUEUE_NAME}"

# Dummy credentials so the aws CLI talks to LocalStack without a configured profile.
export AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID:-test}"
export AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY:-test}"
export AWS_DEFAULT_REGION="$REGION"

WRITE_ENV=true
[[ "${1:-}" == "--no-env" ]] && WRITE_ENV=false

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ---- Helpers -----------------------------------------------------------------
# Log helpers write to stderr so $(...) command substitution captures only the
# value a function intentionally prints to stdout (e.g. an ARN).
say()  { printf '\033[1;34m==>\033[0m %s\n' "$*" >&2; }
ok()   { printf '\033[1;32m  ✓\033[0m %s\n' "$*" >&2; }
warn() { printf '\033[1;33m  !\033[0m %s\n' "$*" >&2; }
die()  { printf '\033[1;31m  ✗ %s\033[0m\n' "$*" >&2; exit 1; }

aws_ls() { aws --endpoint-url "$ENDPOINT" --region "$REGION" "$@"; }

# ---- Preflight ---------------------------------------------------------------
command -v aws >/dev/null 2>&1 || die "aws CLI not found. Install AWS CLI v2 first."

say "Checking LocalStack at ${ENDPOINT} ..."
if ! curl -sf "${ENDPOINT}/_localstack/health" >/dev/null 2>&1; then
  die "LocalStack is not reachable at ${ENDPOINT}. Start it first: 'localstack start' (or docker compose up)."
fi
ok "LocalStack is up."

# ---- SQS queue ---------------------------------------------------------------
say "Creating SQS queue: ${QUEUE_NAME}"
QUEUE_URL="$(aws_ls sqs create-queue --queue-name "$QUEUE_NAME" \
  --query 'QueueUrl' --output text)"
ok "Queue URL: ${QUEUE_URL}"
ok "Queue ARN: ${QUEUE_ARN}"

# Allow SNS to deliver into the queue (LocalStack is lenient, but mirror real AWS).
if command -v jq >/dev/null 2>&1; then
  POLICY="$(jq -n --arg arn "$QUEUE_ARN" '{
    Version: "2012-10-17",
    Statement: [{
      Effect: "Allow",
      Principal: {Service: "sns.amazonaws.com"},
      Action: "sqs:SendMessage",
      Resource: $arn
    }]
  }')"
  ATTRS="$(jq -n --arg p "$POLICY" '{Policy: $p}')"
  aws_ls sqs set-queue-attributes --queue-url "$QUEUE_URL" --attributes "$ATTRS" >/dev/null 2>&1 \
    && ok "Queue policy set (allow SNS sqs:SendMessage)." \
    || warn "Could not set queue policy (LocalStack does not enforce it — safe to ignore)."
else
  warn "jq not found — skipping queue policy (LocalStack does not enforce it)."
fi

# ---- SNS topics --------------------------------------------------------------
create_topic() {
  local name="$1"
  local arn
  arn="$(aws_ls sns create-topic --name "$name" --query 'TopicArn' --output text)"
  ok "Topic: ${arn}"
  printf '%s' "$arn"
}

say "Creating SNS topics"
ARN_WITH_SQS="$(create_topic "$TOPIC_WITH_SQS")"
ARN_WITHOUT_SQS="$(create_topic "$TOPIC_WITHOUT_SQS")"
ARN_DEFAULT="$(create_topic "$TOPIC_DEFAULT")"

# ---- SNS -> SQS subscription (the "with SQS" path) ---------------------------
say "Subscribing ${TOPIC_WITH_SQS} -> ${QUEUE_NAME}"
EXISTING="$(aws_ls sns list-subscriptions-by-topic --topic-arn "$ARN_WITH_SQS" \
  --query "Subscriptions[?Endpoint=='${QUEUE_ARN}'].SubscriptionArn" --output text 2>/dev/null || true)"
if [[ -n "$EXISTING" && "$EXISTING" != "None" ]]; then
  ok "Subscription already exists: ${EXISTING}"
else
  SUB_ARN="$(aws_ls sns subscribe \
    --topic-arn "$ARN_WITH_SQS" \
    --protocol sqs \
    --notification-endpoint "$QUEUE_ARN" \
    --query 'SubscriptionArn' --output text)"
  # RawMessageDelivery=false keeps the SNS envelope so the consumer can read JSON .Message
  aws_ls sns set-subscription-attributes \
    --subscription-arn "$SUB_ARN" \
    --attribute-name RawMessageDelivery --attribute-value false >/dev/null 2>&1 || true
  ok "Subscribed: ${SUB_ARN}"
fi

# Note: WithoutSQSTopic -> Lambda subscription is created automatically when you
# deploy the consumer to LocalStack (the `sns` event in its serverless.yml).

# ---- .env.local files --------------------------------------------------------
if $WRITE_ENV; then
  write_env() {
    local file="$1"; shift
    if [[ -f "$file" ]]; then
      warn "Exists, leaving untouched: ${file}"
    else
      printf '%s\n' "$@" > "$file"
      ok "Wrote ${file}"
    fi
  }
  say "Writing .env.local files (dummy LocalStack credentials)"
  write_env "${ROOT_DIR}/serverless-nestjs-api-sns/.env.local" \
    "AWS_ACCESS_KEY_ID=test" \
    "AWS_SECRET_ACCESS_KEY=test" \
    "AWS_DEFAULT_REGION=${REGION}" \
    "IS_OFFLINE=true" \
    "LOCALSTACK_ENDPOINT=${ENDPOINT}" \
    "SNS_TOPIC_ARN=${ARN_DEFAULT}"
  write_env "${ROOT_DIR}/serverless-nestjs-sqs-consumer/.env.local" \
    "AWS_ACCESS_KEY_ID=test" \
    "AWS_SECRET_ACCESS_KEY=test" \
    "AWS_DEFAULT_REGION=${REGION}" \
    "IS_OFFLINE=true" \
    "LOCALSTACK_ENDPOINT=${ENDPOINT}" \
    "SQS_QUEUE_URL=${QUEUE_URL}" \
    "SQS_QUEUE_ARN=${QUEUE_ARN}"
fi

# ---- Summary -----------------------------------------------------------------
echo
say "Done. Resources in LocalStack:"
cat <<EOF
  SQS queue        ${QUEUE_NAME}
    URL            ${QUEUE_URL}
    ARN            ${QUEUE_ARN}
  SNS topics
    with SQS       ${ARN_WITH_SQS}        (-> ${QUEUE_NAME})
    without SQS    ${ARN_WITHOUT_SQS}     (-> consumer Lambda on deploy)
    default        ${ARN_DEFAULT}

Next:
  1. Start the producer:   cd serverless-nestjs-api-sns && npx serverless offline start
  2. Deploy the consumer:  cd serverless-nestjs-sqs-consumer && npx serverless deploy
  3. Drive traffic:        ./ite-spa-06/simulate-sns-with-sqs.sh
  See RUNBOOK.md for the full end-to-end walkthrough.
EOF

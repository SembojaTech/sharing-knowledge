#!/usr/bin/env bash
#
# watch.sh — live dashboard for the SNS/SQS demo. Project on screen during the talk.
#
# Shows, refreshing ~1.5s:
#   • SQS queue depth (waiting + in-flight) as a bar  -> the "buffer" the audience can see
#   • recent Lambda activity, colour-coded by path:
#       green  = processed via SQS  (API -> SNS -> SQS -> Lambda)
#       cyan   = processed via SNS  (API -> SNS -> Lambda directly)
#
# Usage:  ./ite-spa-06/watch.sh        (Ctrl-C to quit)
#
set -euo pipefail
export AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID:-test}"
export AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY:-test}"
export AWS_DEFAULT_REGION="${AWS_DEFAULT_REGION:-ap-southeast-1}"

EP="http://localhost:4566"
QURL="http://localhost:4566/000000000000/MyLocalNestJSQueue"
LG="/aws/lambda/sqs-consumer-dev-consume"
aws_ls() { aws --endpoint-url "$EP" --region ap-southeast-1 "$@"; }

bar() { # $1 = count -> prints that many blocks (capped)
  local n="$1" out="" cap=40
  [[ "$n" =~ ^[0-9]+$ ]] || { printf '?'; return; }
  (( n > cap )) && n=$cap
  for ((i=0;i<n;i++)); do out+="▉"; done
  printf '%s' "$out"
}

trap 'tput cnorm 2>/dev/null || true; exit 0' INT TERM
tput civis 2>/dev/null || true

while true; do
  attrs="$(aws_ls sqs get-queue-attributes --queue-url "$QURL" \
            --attribute-names ApproximateNumberOfMessages ApproximateNumberOfMessagesNotVisible \
            --query 'Attributes' --output json 2>/dev/null || echo '{}')"
  avail="$(printf '%s' "$attrs" | jq -r '.ApproximateNumberOfMessages // "0"')"
  inflt="$(printf '%s' "$attrs" | jq -r '.ApproximateNumberOfMessagesNotVisible // "0"')"

  clear
  printf '\033[1m  SNS / SQS demo — live\033[0m   (LocalStack %s)\n' "$EP"
  printf '  ────────────────────────────────────────────────────────────\n'
  printf '  \033[1mSQS queue\033[0m  MyLocalNestJSQueue\n'
  printf '    waiting   %3s  \033[33m%s\033[0m\n' "$avail" "$(bar "$avail")"
  printf '    in-flight %3s  \033[35m%s\033[0m\n' "$inflt" "$(bar "$inflt")"
  printf '  ────────────────────────────────────────────────────────────\n'
  printf '  \033[1mLambda activity\033[0m (last ~25s)   \033[32m■ via SQS\033[0m   \033[36m■ via SNS direct\033[0m\n\n'

  aws_ls logs tail "$LG" --since 25s --format short 2>/dev/null \
    | grep -aE "Received message:|Processing SNS message:" \
    | sed -E 's/.*Received message: /  \x1b[32m[SQS]\x1b[0m /; s/.*Processing SNS message: /  \x1b[36m[SNS]\x1b[0m /' \
    | tail -12 \
    || printf '  (no Lambda logs yet — deploy the consumer and send some messages)\n'

  printf '\n  Ctrl-C to quit\n'
  sleep 1.5
done

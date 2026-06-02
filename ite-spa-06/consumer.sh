#!/usr/bin/env bash
#
# consumer.sh — take the SQS consumer "offline" / "online" for the durability demo.
#
# Toggles the Lambda's SQS event-source mapping. With it OFF, messages published to
# WithSQSTopic pile up safely in the queue (SQS buffers them); turning it ON drains
# the queue. This is the visible contrast with the direct-SNS path, which has no
# buffer — if the consumer is down, those messages are simply lost.
#
# Usage:
#   ./ite-spa-06/consumer.sh off    # stop polling — messages buffer in the queue
#   ./ite-spa-06/consumer.sh on     # resume polling — queue drains
#   ./ite-spa-06/consumer.sh status
#
set -euo pipefail
export AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID:-test}"
export AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY:-test}"
export AWS_DEFAULT_REGION="${AWS_DEFAULT_REGION:-ap-southeast-1}"

EP="http://localhost:4566"
aws_ls() { aws --endpoint-url "$EP" --region ap-southeast-1 "$@"; }

UUID="$(aws_ls lambda list-event-source-mappings \
  --query "EventSourceMappings[?contains(EventSourceArn, 'MyLocalNestJSQueue')].UUID | [0]" \
  --output text 2>/dev/null)"

[[ -z "$UUID" || "$UUID" == "None" ]] && { echo "No SQS event-source mapping found. Deploy the consumer first."; exit 1; }

case "${1:-status}" in
  off)
    aws_ls lambda update-event-source-mapping --uuid "$UUID" --no-enabled >/dev/null
    echo "🔴 Consumer OFFLINE — SQS polling disabled. Messages will buffer in the queue." ;;
  on)
    aws_ls lambda update-event-source-mapping --uuid "$UUID" --enabled >/dev/null
    echo "🟢 Consumer ONLINE — SQS polling enabled. The queue will drain." ;;
  status)
    st="$(aws_ls lambda get-event-source-mapping --uuid "$UUID" --query 'State' --output text)"
    echo "Consumer SQS mapping state: $st" ;;
  *)
    echo "Usage: $0 {on|off|status}"; exit 2 ;;
esac

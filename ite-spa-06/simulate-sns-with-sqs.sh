#!/bin/bash
#
# WITH SQS path:  producer API -> SNS (WithSQSTopic) -> SQS queue -> consumer Lambda
# The queue buffers messages, so the consumer can be slow or briefly down without loss.
#
COUNT=${1:-10}
TOPIC_ARN="arn:aws:sns:ap-southeast-1:000000000000:WithSQSTopic"
URL="http://localhost:4000/dev/sns/publish"

echo "==> WITH SQS    API → SNS → [ SQS queue ] → Lambda   (buffered / durable)"
echo "    topic: WithSQSTopic"
echo "    sending $COUNT messages to $URL"
echo

for i in $(seq 1 "$COUNT"); do
  resp=$(curl -s -X POST -H "Content-Type: application/json" \
    -d "{\"message\": \"Hello from job $i\", \"subject\": \"With-SQS $i\", \"topicArn\": \"$TOPIC_ARN\"}" \
    "$URL")
  mid=$(printf '%s' "$resp" | jq -r '.messageId // "FAILED"' 2>/dev/null || echo "FAILED")
  printf "  msg %2d  →  SNS MessageId %s\n" "$i" "$mid"
done

echo
echo "==> sent. Watch ./ite-spa-06/watch.sh: messages land in the queue, then the Lambda drains it."

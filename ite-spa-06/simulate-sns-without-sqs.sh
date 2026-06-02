#!/bin/bash
#
# WITHOUT SQS path:  producer API -> SNS (WithoutSQSTopic) -> consumer Lambda directly
# No queue, no buffer. If the consumer is down, SNS does not retain the message — it is lost.
#
COUNT=${1:-10}
TOPIC_ARN="arn:aws:sns:ap-southeast-1:000000000000:WithoutSQSTopic"
URL="http://localhost:4000/dev/sns/publish"

echo "==> WITHOUT SQS    API → SNS → Lambda   (direct fan-out / fire-and-forget)"
echo "    topic: WithoutSQSTopic"
echo "    sending $COUNT messages to $URL"
echo

for i in $(seq 1 "$COUNT"); do
  resp=$(curl -s -X POST -H "Content-Type: application/json" \
    -d "{\"message\": \"Hello from job $i\", \"subject\": \"Without-SQS $i\", \"topicArn\": \"$TOPIC_ARN\"}" \
    "$URL")
  mid=$(printf '%s' "$resp" | jq -r '.messageId // "FAILED"' 2>/dev/null || echo "FAILED")
  printf "  msg %2d  →  SNS MessageId %s\n" "$i" "$mid"
done

echo
echo "==> sent. These go straight to the Lambda — no queue to inspect. If the consumer were"
echo "    offline, there would be nowhere for them to wait (compare with the WITH-SQS path)."

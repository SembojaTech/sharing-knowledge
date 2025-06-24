#!/bin/bash

# Number of messages to send
COUNT=10

# SNS Topic ARN (replace with your actual topic ARN)
TOPIC_ARN="arn:aws:sns:ap-southeast-1:000000000000:WithoutSQSTopic" # Example topic ARN

# Endpoint
URL="http://localhost:4000/dev/sns/publish"

echo "Sending $COUNT curl requests sequentially..."

for i in $(seq 1 $COUNT); do
  echo "Sending message $i..."
  curl -X POST -H "Content-Type: application/json" \
    -d "{\"message\": \"Hello from job $i\", \"subject\": \"Test Subject $i\", \"topicArn\": \"$TOPIC_ARN\"}" \
    "$URL" &> /dev/null # Suppress curl output to keep terminal clean, or remove &> /dev/null to see it
done

echo "All requests sent."

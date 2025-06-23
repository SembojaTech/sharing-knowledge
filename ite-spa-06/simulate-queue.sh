#!/bin/bash

# Number of messages to send
COUNT=10

# Endpoint
URL="http://localhost:4000/dev/sns/publish"

echo "Sending $COUNT curl requests sequentially..."

for i in $(seq 1 $COUNT); do
  echo "Sending message $i..."
  curl -X POST -H "Content-Type: application/json" \
    -d "{\"message\": \"Hello from job $i\", \"subject\": \"Test Subject $i\"}" \
    "$URL" &> /dev/null # Suppress curl output to keep terminal clean, or remove &> /dev/null to see it
done

echo "All requests sent."

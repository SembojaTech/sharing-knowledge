# Postman — Testing the SNS/SQS API

Demonstrates the two testing styles from the **Testing & Evaluation Impact** slide,
using the producer API (`serverless-nestjs-api-sns`).

| Lecture concept | Postman folder |
|---|---|
| **API-based integration** — *"response-based → simple assertion-driven tests"* | **1. Response-based** |
| **Event-driven integration** — *"we test not what comes back, but what happens as a result"* | **2. Side-effect** |

## Import

In Postman: **Import** → drop `ITE-SPA-06.postman_collection.json`.
The collection ships its own variables (`baseUrl = http://localhost:4000/dev`, topic ARNs,
`queueName`), so there's no separate environment to import.

## Prerequisites

LocalStack up, `./bootstrap.sh` run, and the **producer running** on :4000:

```bash
docker compose up -d
./bootstrap.sh
cd serverless-nestjs-api-sns && nvm use && npm run build && npx serverless offline start
```

## Folder 1 — Response-based (run any time)

Assert on what the call **returns**:

- `GET /users/hi` → 200, body is `"Hello World!"`
- `POST /sns/publish` → 200, `success === true`, `messageId` is present

Click each request → **Send**, or run the folder in the **Collection Runner**.

## Folder 2 — Side-effect (run in order, consumer offline)

Assert on what **happens as a result** — the message landing in the queue. Because the
consumer drains the queue, take it **offline** first so the side effect is observable:

```bash
./ite-spa-06/consumer.sh off      # stop the consumer draining the queue
```

Then run the folder top-to-bottom (use the **Collection Runner** so the requests run in order):

1. **Baseline queue depth** — reads `GET /sns/queue-status`, stores the current count
2. **Publish #1–#3** — three `POST /sns/publish` to `WithSQSTopic`
3. **Verify side effect** — reads queue depth again, asserts it grew by exactly **3**

That assertion (`messages === baseline + 3`) is the event-driven test: the publish
*responses* told us nothing about delivery — we verified the **result** in the queue.

Bring the consumer back when done:

```bash
./ite-spa-06/consumer.sh on       # queue drains; re-running folder 2 would then read 0
```

> The new `GET /sns/queue-status?queue=MyLocalNestJSQueue` endpoint (added to the
> producer for this) returns `{ queue, messages, inFlight }` straight from SQS.

## Run headless (CI / no GUI)

```bash
npx newman run ite-spa-06/postman/ITE-SPA-06.postman_collection.json
# (run folder 2 with the consumer offline, or it will assert against a drained queue)
```

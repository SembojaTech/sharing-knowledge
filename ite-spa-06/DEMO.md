# ITE-SPA-06 — Live Demo Playbook (SNS vs SNS+SQS)

Goal for the audience: see that **both integration paths work**, and **why they differ** —
SQS buffers and protects messages; direct SNS is fire-and-forget.

## Screen layout

Use **two terminals** side by side (or one projected, one on your laptop):

- **Terminal L — the dashboard** (project this):
  ```bash
  ./ite-spa-06/watch.sh
  ```
  Shows the SQS queue depth as a bar and recent Lambda activity, colour-coded
  `[SQS]` (green) vs `[SNS]` (cyan).

- **Terminal R — you type commands here** (producer must already be running from RUNBOOK step 5).

> Prereq: LocalStack up, `./bootstrap.sh` run, consumer deployed, producer running on :4000.
> See `../RUNBOOK.md` steps 2–5.

> **Pacing — slow the drain so the audience can see it.** By default the consumer
> empties the queue almost instantly. Deploy it with a per-message delay so the
> bar shrinks visibly:
> ```bash
> cd serverless-nestjs-sqs-consumer
> PROCESS_DELAY_MS=1500 npx serverless deploy      # ~1.5s "work" per message
> cd ..
> ```
> Set `PROCESS_DELAY_MS=0` (or omit) to redeploy at full speed. Keep it ≤ 2500ms:
> a full batch of 10 must finish within the queue's 30s visibility window.

---

## Act 1 — "Both paths work" (≈1 min)

Run each script in Terminal R and point at the dashboard:

```bash
./ite-spa-06/simulate-sns-with-sqs.sh        # API → SNS → SQS → Lambda
./ite-spa-06/simulate-sns-without-sqs.sh     # API → SNS → Lambda (direct)
```

**What the audience sees on the dashboard:**
- WITH-SQS: the `waiting` bar jumps, then drains to 0 as the Lambda pulls from the queue —
  activity lines appear in **green `[SQS]`**.
- WITHOUT-SQS: no queue movement (there is no queue) — activity lines appear in **cyan `[SNS]`**.

**Say:** "Same API call, same Lambda — but one route parks the message in a durable queue
first, the other hands it straight to the function. Watch what that buys us next."

---

## Act 2 — "Why they differ: durability" (≈2 min) ← the key lesson

Take the consumer **offline**, then flood both paths:

```bash
./ite-spa-06/consumer.sh off                 # 🔴 stop the Lambda polling SQS

./ite-spa-06/simulate-sns-with-sqs.sh        # 10 messages → queue
./ite-spa-06/simulate-sns-without-sqs.sh     # 10 messages → (nowhere to wait)
```

**What the audience sees:** the dashboard `waiting` bar climbs to **10 and stays there** —
the WITH-SQS messages are safely buffered. The WITHOUT-SQS messages had no queue to land in;
with the consumer down they are **gone** (SNS does not store undelivered messages).

Now bring the consumer **back**:

```bash
./ite-spa-06/consumer.sh on                  # 🟢 resume polling
```

The `waiting` bar **drains to 0** and 10 green `[SQS]` lines stream in — every buffered
message is processed, none lost.

**Say:** "The queue absorbed the load while the consumer was down and replayed it on recovery.
Without the queue, those ten messages vanished. That's load-leveling, decoupling and
durability — the reason we put SQS between SNS and the worker."

---

## Act 3 — "Testing the integration" with Postman (≈2 min)

Ties to the **Testing & Evaluation Impact** slide: API-based integration is tested by
its **response**; event-driven integration is tested by its **side effect**.

Import `ite-spa-06/postman/ITE-SPA-06.postman_collection.json` and run the two folders:

- **Folder 1 — Response-based:** `POST /sns/publish` → asserts `200`, `success`, `messageId`.
  *"With an API, we assert on what comes back."*
- **Folder 2 — Side-effect:** with `./ite-spa-06/consumer.sh off`, publish 3 → the
  `GET /sns/queue-status` assertion proves the queue grew by 3.
  *"With events, we test not what comes back, but what happens as a result."*

Headless option (projector-friendly): `npx newman run ite-spa-06/postman/ITE-SPA-06.postman_collection.json --delay-request 600`
(run with the consumer offline). See `ite-spa-06/postman/README.md`.

## One-liner recap for the slide

| | Without SQS | With SQS |
|---|---|---|
| Path | SNS → Lambda | SNS → SQS → Lambda |
| Consumer down | message **lost** | message **waits in queue** |
| Spikes / backpressure | hits Lambda directly | queue levels the load |
| Delivery | push, fire-and-forget | pull, at consumer's pace (batched) |

## Reset between runs / rehearsals

```bash
# purge anything left in the queue
AWS_ACCESS_KEY_ID=test AWS_SECRET_ACCESS_KEY=test aws --endpoint-url http://localhost:4566 \
  --region ap-southeast-1 sqs purge-queue \
  --queue-url http://localhost:4566/000000000000/MyLocalNestJSQueue
./ite-spa-06/consumer.sh on    # make sure the consumer is online again
```

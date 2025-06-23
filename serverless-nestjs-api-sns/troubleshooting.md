# Troubleshooting SNS Local Testing

This document provides a comprehensive guide to setting up and testing SNS locally using LocalStack, addressing common issues like `InvalidParameterException: Invalid parameter: TopicArn` and `InvalidClientTokenId: The security token included in the request is invalid.`.

## Prerequisites

Ensure you have `pip` (Python package installer) and `aws-cli` installed.

## Steps to Test SNS Locally

**1. Install LocalStack:**
```bash
pip install localstack
```

**2. Start LocalStack:**
```bash
localstack start
```

**3. Configure Dummy AWS Credentials (for LocalStack):**
Ensure your `serverless-nestjs-api-sns/.env.local` file contains the following. These are dummy credentials for local development and should **not** be used in production.

```
AWS_ACCESS_KEY_ID=test
AWS_SECRET_ACCESS_KEY=test
AWS_DEFAULT_REGION=ap-southeast-3
```
*Note: `AWS_DEFAULT_REGION` should match the region configured in your `serverless.yml` and the region used when creating the SNS topic.*

**4. Deploy the service locally using `serverless-offline`:**
Navigate to the `serverless-nestjs-api-sns` directory and run:
```bash
sls offline start
```

**5. Create the local SNS topic in LocalStack:**
Open a **new terminal** (after starting LocalStack) and run:
```bash
aws sns create-topic --name MyLocalNestJSSNSTopic --endpoint-url http://localhost:4566 --region ap-southeast-3
```

**6. Test the SNS publish endpoint:**
Once `sls offline start` is running, open another terminal and use `curl` to test the endpoint:
```bash
curl -X POST -H "Content-Type: application/json" -d '{"message": "Hello, world!", "subject": "Test Subject"}' http://localhost:4000/dev/sns/publish
```

## Summary of Changes Made to the Project

To enable this local testing setup, the following modifications were applied to your `serverless-nestjs-api-sns` project:

*   **`serverless-nestjs-api-sns/serverless.yml`**:
    *   The `serverless-offline` and `serverless-offline-aws-proxy` plugins were added and enabled.
    *   A `custom` section was added to configure LocalStack endpoints for SNS.
    *   The `SNS_TOPIC_ARN` environment variable was updated to a LocalStack-compatible ARN (`arn:aws:sns:ap-southeast-3:000000000000:MyLocalNestJSSNSTopic`).

*   **`serverless-nestjs-api-sns/src/sns/sns.service.ts`**:
    *   The `SNSClient` initialization was modified to conditionally use the local endpoint and explicitly pass dummy credentials (`accessKeyId: 'test'`, `secretAccessKey: 'test'`) when `process.env.IS_OFFLINE` is true.

These changes ensure that your application correctly interacts with LocalStack for SNS operations during local development.
import { Injectable, Logger } from '@nestjs/common';
import {
  SQSClient,
  GetQueueUrlCommand,
  GetQueueAttributesCommand,
} from '@aws-sdk/client-sqs';

/**
 * Read-only SQS inspection used by the Postman "side-effect" tests.
 * The event-driven path can't be verified from the publish response alone —
 * "we test not what comes back, but what happens as a result" — so this exposes
 * the queue depth over HTTP for assertion.
 */
@Injectable()
export class QueueService {
  private readonly logger = new Logger(QueueService.name);
  private readonly sqs: SQSClient;

  constructor() {
    const isOffline = process.env.IS_OFFLINE === 'true';
    const config: any = { region: process.env.AWS_REGION || 'ap-southeast-1' };

    if (isOffline) {
      config.endpoint = process.env.LOCALSTACK_ENDPOINT || 'http://localhost:4566';
      config.credentials = {
        accessKeyId: process.env.AWS_ACCESS_KEY_ID || 'test',
        secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY || 'test',
      };
    }

    this.sqs = new SQSClient(config);
  }

  async getStatus(queueName: string) {
    const { QueueUrl } = await this.sqs.send(
      new GetQueueUrlCommand({ QueueName: queueName }),
    );
    const { Attributes } = await this.sqs.send(
      new GetQueueAttributesCommand({
        QueueUrl,
        AttributeNames: [
          'ApproximateNumberOfMessages',
          'ApproximateNumberOfMessagesNotVisible',
        ],
      }),
    );

    return {
      queue: queueName,
      messages: Number(Attributes?.ApproximateNumberOfMessages ?? 0),
      inFlight: Number(Attributes?.ApproximateNumberOfMessagesNotVisible ?? 0),
    };
  }
}

import { Injectable, Logger } from '@nestjs/common';
import { SQSClient, DeleteMessageCommand } from '@aws-sdk/client-sqs';

@Injectable()
export class SqsConsumerService {
  private readonly logger = new Logger(SqsConsumerService.name);
  private readonly sqsClient: SQSClient;

  constructor() {
    const isOffline = process.env.IS_OFFLINE === 'true';
    const sqsConfig: any = {
      region: process.env.AWS_REGION || 'ap-southeast-1',
    };

    if (isOffline) {
      sqsConfig.endpoint = process.env.LOCALSTACK_ENDPOINT || 'http://localhost:4566';
      sqsConfig.credentials = {
        accessKeyId: process.env.AWS_ACCESS_KEY_ID || 'test',
        secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY || 'test',
      };
    }

    this.sqsClient = new SQSClient(sqsConfig);
  }

  async processMessage(messageBody: string, receiptHandle: string): Promise<void> {
    this.logger.log(`Received message: ${JSON.parse(messageBody)?.Message}`);
    // Implement your message processing logic here
    // For example, parse the message, interact with other services, etc.

    try {
      if (receiptHandle && process.env.SQS_QUEUE_URL) {
        const deleteCommand = new DeleteMessageCommand({
          QueueUrl: process.env.SQS_QUEUE_URL,
          ReceiptHandle: receiptHandle,
        });
        await this.sqsClient.send(deleteCommand);
        this.logger.log(`Message with ReceiptHandle ${receiptHandle} deleted from queue.`);
      } else {
        this.logger.warn('ReceiptHandle or SQS_QUEUE_URL is not set. Message not deleted.');
      }
    } catch (error) {
      this.logger.error(`Error processing message: ${error.message}`, error.stack);
      // Depending on your error handling strategy, you might re-throw or handle differently
    }
  }
}
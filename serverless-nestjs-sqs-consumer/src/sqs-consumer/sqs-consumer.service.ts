import { Injectable, Logger } from '@nestjs/common';
import { SQSClient, DeleteMessageCommand } from '@aws-sdk/client-sqs';

@Injectable()
export class SqsConsumerService {
  private readonly logger = new Logger(SqsConsumerService.name);
  private readonly sqsClient: SQSClient;

  constructor() {
    this.sqsClient = new SQSClient({ region: process.env.AWS_REGION || 'us-east-1' });
  }

  async processMessage(messageBody: string): Promise<void> {
    this.logger.log(`Received message: ${messageBody}`);
    // Implement your message processing logic here
    // For example, parse the message, interact with other services, etc.

    try {
      // Assuming the messageBody contains a receiptHandle for deletion
      const message = JSON.parse(messageBody);
      if (message.receiptHandle && process.env.SQS_QUEUE_URL) {
        const deleteCommand = new DeleteMessageCommand({
          QueueUrl: process.env.SQS_QUEUE_URL,
          ReceiptHandle: message.receiptHandle,
        });
        await this.sqsClient.send(deleteCommand);
        this.logger.log(`Message with ReceiptHandle ${message.receiptHandle} deleted from queue.`);
      } else {
        this.logger.warn('Message does not contain receiptHandle or SQS_QUEUE_URL is not set. Message not deleted.');
      }
    } catch (error) {
      this.logger.error(`Error processing message: ${error.message}`, error.stack);
      // Depending on your error handling strategy, you might re-throw or handle differently
    }
  }
}
import { Injectable } from '@nestjs/common';
import { SNSClient, PublishCommand } from '@aws-sdk/client-sns';

@Injectable()
export class SnsService {
  private readonly sns: SNSClient;

  constructor() {
    const isOffline = process.env.IS_OFFLINE === 'true';
    const snsConfig: any = {
      region: process.env.AWS_REGION || 'ap-southeast-3',
    };

    if (isOffline) {
      snsConfig.endpoint = process.env.LOCALSTACK_ENDPOINT || 'http://localhost:4566';
      snsConfig.credentials = {
        accessKeyId: process.env.AWS_ACCESS_KEY_ID || 'test',
        secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY || 'test',
      };
    }

    this.sns = new SNSClient(snsConfig);
    if (!process.env.SNS_TOPIC_ARN) {
      console.warn('Default SNS_TOPIC_ARN is not set. Messages without an explicit topic ARN may not be published.');
    }
  }

  async publishMessage(message: string, subject: string = 'NestJS SNS Message', topicArn?: string): Promise<any> {
    const targetTopicArn = topicArn || process.env.SNS_TOPIC_ARN;

    if (!targetTopicArn) {
      console.error('No SNS Topic ARN provided or configured. Cannot publish message.');
      return { success: false, message: 'SNS Topic ARN not configured' };
    }

    const params = {
      Message: message,
      TopicArn: targetTopicArn,
      Subject: subject,
    };

    try {
      const result = await this.sns.send(new PublishCommand(params));
      console.log('SNS Publish successful:', result);
      return { success: true, messageId: result.MessageId };
    } catch (error) {
      console.error('Error publishing to SNS:', error);
      return { success: false, error: error.message };
    }
  }
}
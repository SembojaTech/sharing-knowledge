import { Injectable } from '@nestjs/common';
import { SNSClient, PublishCommand } from '@aws-sdk/client-sns';

@Injectable()
export class SnsService {
  private readonly sns: SNSClient;
  private readonly snsTopicArn: string;

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
    this.snsTopicArn = process.env.SNS_TOPIC_ARN;

    if (!this.snsTopicArn) {
      console.warn('SNS_TOPIC_ARN is not set. SNS publishing will not work.');
    }
  }

  async publishMessage(message: string, subject: string = 'NestJS SNS Message'): Promise<any> {
    if (!this.snsTopicArn) {
      console.error('SNS_TOPIC_ARN is not configured. Cannot publish message.');
      return { success: false, message: 'SNS Topic ARN not configured' };
    }

    const params = {
      Message: message,
      TopicArn: this.snsTopicArn,
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
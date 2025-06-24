import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { INestApplication } from '@nestjs/common';
import { Context, SNSEvent, SQSEvent } from 'aws-lambda';
import { SqsConsumerService } from './sqs-consumer/sqs-consumer.service';

let cachedApp: INestApplication;

async function bootstrap(): Promise<INestApplication> {
  if (!cachedApp) {
    const app = await NestFactory.create(AppModule);
    await app.init();
    cachedApp = app;
  }
  return cachedApp;
}

export const handler = async (event: SQSEvent | SNSEvent, context: Context) => {
  const app = await bootstrap();
  const sqsConsumerService = app.get(SqsConsumerService);

  for (const record of event.Records) {
    if (record.body) {
      console.log('Processing SQS message:', record.body);
      await sqsConsumerService.processMessage(record.body, record.receiptHandle);
    } else if (record.Sns) {
      console.log('Processing SNS message:', record.Sns?.Message);
    }
  }

  return {
    statusCode: 200,
    body: JSON.stringify({ message: 'Messages processed successfully' }),
  };
};

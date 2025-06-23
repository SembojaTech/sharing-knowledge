import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { INestApplication } from '@nestjs/common';
import { Context, SQSEvent } from 'aws-lambda';
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

export const handler = async (event: SQSEvent, context: Context) => {
  const app = await bootstrap();
  const sqsConsumerService = app.get(SqsConsumerService);

  for (const record of event.Records) {
    console.log('Processing SQS message:', record.body);
    await sqsConsumerService.processMessage(record.body, record.receiptHandle);
  }

  return {
    statusCode: 200,
    body: JSON.stringify({ message: 'Messages processed successfully' }),
  };
};

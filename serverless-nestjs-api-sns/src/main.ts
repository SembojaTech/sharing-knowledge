import { NestFactory } from '@nestjs/core';
import { Callback, Context, Handler } from 'aws-lambda';
import serverlessExpress from '@codegenie/serverless-express';
import { AppModule } from './app.module';

let cachedServer: any;

async function bootstrap() {
  if (!cachedServer) {
    const app = await NestFactory.create(AppModule, { rawBody: true });

    await app.init();
    const expressApp = app.getHttpAdapter().getInstance();

    cachedServer = serverlessExpress({ app: expressApp })
  }
  return cachedServer;
}

export const handler: Handler = async (event: any, context: Context, callback: Callback) => {
  const server = await bootstrap();
  return server(event, context, callback);
};
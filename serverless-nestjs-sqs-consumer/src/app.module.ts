import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { SqsConsumerService } from './sqs-consumer/sqs-consumer.service';

@Module({
  imports: [],
  controllers: [AppController],
  providers: [AppService, SqsConsumerService],
})
export class AppModule {}

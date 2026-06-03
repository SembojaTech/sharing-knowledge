import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { SnsController } from './sns/sns.controller';
import { SnsService } from './sns/sns.service';
import { QueueService } from './sns/queue.service';

@Module({
  imports: [],
  controllers: [AppController, SnsController],
  providers: [AppService, SnsService, QueueService],
})
export class AppModule {}

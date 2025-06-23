import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { SnsController } from './sns/sns.controller';
import { SnsService } from './sns/sns.service';

@Module({
  imports: [],
  controllers: [AppController, SnsController],
  providers: [AppService, SnsService],
})
export class AppModule {}

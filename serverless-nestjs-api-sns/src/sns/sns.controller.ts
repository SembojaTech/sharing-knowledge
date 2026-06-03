import { Controller, Post, Get, Body, Query, HttpCode, HttpStatus } from '@nestjs/common';
import { SnsService } from './sns.service';
import { QueueService } from './queue.service';

@Controller('sns')
export class SnsController {
  constructor(
    private readonly snsService: SnsService,
    private readonly queueService: QueueService,
  ) {}

  @Post('publish')
  @HttpCode(HttpStatus.OK)
  async publishMessage(
    @Body('message') message: string,
    @Body('subject') subject?: string,
    @Body('topicArn') topicArn?: string,
  ) {
    if (!message) {
      return { success: false, message: 'Message body is required.' };
    }
    console.info('Topic:', topicArn);
    const result = await this.snsService.publishMessage(message, subject, topicArn);
    return result;
  }

  // Read-only inspection for the Postman "side-effect" tests: report how many
  // messages are sitting in (or in-flight from) the SQS queue.
  @Get('queue-status')
  async queueStatus(@Query('queue') queue = 'MyLocalNestJSQueue') {
    return this.queueService.getStatus(queue);
  }
}

import { Controller, Post, Body, HttpCode, HttpStatus } from '@nestjs/common';
import { SnsService } from './sns.service';

@Controller('sns')
export class SnsController {
  constructor(private readonly snsService: SnsService) {}

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
    const result = await this.snsService.publishMessage(message, subject, topicArn);
    return result;
  }
}
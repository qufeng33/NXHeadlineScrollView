//
//  NSTimer+BlocksTimer.h
//  NXHeadlineScrollViewDemo
//
//  Created by 蒋瞿风 on 2017/8/23.
//  Copyright © 2017年 nightx. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ExecuteTimerBlock)(NSTimer *timer);

@interface NSTimer (BlocksTimer)

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti
                                      block:(ExecuteTimerBlock)block
                                    repeats:(BOOL)yesOrNo;

@end

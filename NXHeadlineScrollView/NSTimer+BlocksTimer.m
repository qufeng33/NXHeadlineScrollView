//
//  NSTimer+BlocksTimer.m
//  NXHeadlineScrollViewDemo
//
//  Created by 蒋瞿风 on 2017/8/23.
//  Copyright © 2017年 nightx. All rights reserved.
//

#import "NSTimer+BlocksTimer.h"

@implementation NSTimer (BlocksTimer)

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti block:(ExecuteTimerBlock)block repeats:(BOOL)yesOrNo{
    NSTimer *timer = [self scheduledTimerWithTimeInterval:ti target:self selector:@selector(executeTimer:) userInfo:[block copy] repeats:yesOrNo];
    return timer;
}

+ (void)executeTimer:(NSTimer *)timer{
    ExecuteTimerBlock block = timer.userInfo;
    if (block) {
        block(timer);
    }
}

@end

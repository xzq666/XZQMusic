//
//  XZQRotateImage.m
//  XZQMusic
//
//  Created by qhzc-iMac-02 on 2020/5/22.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "XZQRotateImage.h"

@interface XZQRotateImage ()

@end

@implementation XZQRotateImage

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)startRotating {
    CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotateAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    rotateAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2];  // 旋转一周
    rotateAnimation.duration = 10;  // 旋转一周的时间 单位秒
    rotateAnimation.repeatCount = MAXFLOAT;  // 重复次数 使用最大次数即无限循环
    [self.layer addAnimation:rotateAnimation forKey:nil];
}

- (void)stopRotating {
    CFTimeInterval pausedTime = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    self.layer.speed = 0.0;  // 停止旋转
    self.layer.timeOffset = pausedTime;  // 保存时间，恢复旋转时使用
}

- (void)resumeRotating {
    // 如果此前未开始旋转，直接重新开始旋转
    if (self.layer.timeOffset == 0) {
        [self startRotating];
        return;
    }
    CFTimeInterval pausedTime = self.layer.timeOffset;
    self.layer.speed = 1.0;
    self.layer.timeOffset = 0.0;
    self.layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;  // 恢复时间
    self.layer.beginTime = timeSincePause;  // 从暂停的时间点开始旋转
}

@end

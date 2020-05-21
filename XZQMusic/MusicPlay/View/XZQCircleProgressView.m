//
//  XZQCircleProgressView.m
//  XZQMusic
//
//  Created by qhzc-iMac-02 on 2020/5/21.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "XZQCircleProgressView.h"

@interface XZQCircleProgressView ()

// 圆环宽度
@property(nonatomic,assign) CGFloat lineWidth;

// 默认圆环
@property(nonatomic,strong) CAShapeLayer *outLayer;
// 进度条圆环
@property(nonatomic,strong) CAShapeLayer *progressLayer;

@end

@implementation XZQCircleProgressView

- (instancetype)initWithFrame:(CGRect)frame lineWidth:(CGFloat)width
{
    self = [super initWithFrame:frame];
    if (self) {
        self.lineWidth = width;
        
        self.layer.cornerRadius = frame.size.width;
        self.layer.masksToBounds = NO;
        
        // 整体旋转90度，使进度起点在12点钟方向
        self.transform = CGAffineTransformMakeRotation(-M_PI_2);
        [self.layer addSublayer:self.outLayer];
        [self.layer addSublayer:self.progressLayer];
    }
    return self;
}

- (CAShapeLayer *)outLayer {
    if (!_outLayer) {
        _outLayer = [CAShapeLayer layer];
        CGRect rect = CGRectMake(self.lineWidth / 2, self.lineWidth / 2, self.frame.size.width, self.frame.size.height);
        // 内切圆
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
        _outLayer.strokeColor = [UIColor hexStringToColor:@"#866E28"].CGColor;
        _outLayer.lineWidth = self.lineWidth;
        _outLayer.fillColor = [UIColor clearColor].CGColor;
        _outLayer.lineCap = kCALineCapRound;
        _outLayer.path = path.CGPath;
    }
    return _outLayer;
}

- (CAShapeLayer *)progressLayer {
    if (!_progressLayer) {
        _progressLayer = [CAShapeLayer layer];
        CGRect rect = CGRectMake(self.lineWidth / 2, self.lineWidth / 2, self.frame.size.width, self.frame.size.height);
        // 内切圆
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
        _progressLayer.fillColor = [UIColor clearColor].CGColor;
        _progressLayer.strokeColor = TitleSelectColor.CGColor;
        _progressLayer.lineWidth = self.lineWidth;
        _progressLayer.lineCap = kCALineCapRound;
        _progressLayer.path = path.CGPath;
    }
    return _progressLayer;
}

- (void)updateProgressWithNumber:(CGFloat)progress {
    self.progressLayer.strokeEnd = progress;
}

@end

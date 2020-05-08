//
//  XZQSectionIndicatorView.m
//  XZQMusic
//
//  Created by qhzc-iMac-02 on 2020/5/8.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "XZQSectionIndicatorView.h"

@interface XZQSectionIndicatorView()

@property (nonatomic, strong) UIImageView *indicatorView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation XZQSectionIndicatorView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
//        [self addSubview:self.indicatorView];
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void)setOrigin:(CGPoint)origin title:(NSString *)title {
    [self setCt_x:origin.x - self.frame.size.width];
    [self setCt_centerY:origin.y];
    self.titleLabel.text = title;
}

#pragma mark - frame设置
- (void)setCt_x:(CGFloat)x {
    self.frame = CGRectMake(x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

- (void)setCt_centerY:(CGFloat)centerY {
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

#pragma mark - getter
- (UIImageView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _indicatorView.image = [UIImage imageNamed:@"index_indicator"];
        _indicatorView.transform = CGAffineTransformRotate(_indicatorView.transform, -90*M_PI / 180.0);
    }
    return _indicatorView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end

//
//  XZQCircleProgressView.h
//  XZQMusic
//
//  Created by qhzc-iMac-02 on 2020/5/21.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XZQCircleProgressView : UIView

- (instancetype)initWithFrame:(CGRect)frame lineWidth:(CGFloat)width;

- (void)updateProgressWithNumber:(CGFloat)progress;

@end

NS_ASSUME_NONNULL_END
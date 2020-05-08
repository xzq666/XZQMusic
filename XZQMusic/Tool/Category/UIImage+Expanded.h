//
//  UIImage+Expanded.h
//  XZQMusic
//
//  Created by qhzc-iMac-02 on 2020/5/7.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Expanded)

/*
 UIImageV高效圆角
 */
- (UIImage *)drawRectWithRoundedCorner;

/*
 颜色转UIImage
 */
+ (nullable UIImage *)imageFromColor:(nonnull UIColor *)color withSize:(CGSize)size;

@end

NS_ASSUME_NONNULL_END

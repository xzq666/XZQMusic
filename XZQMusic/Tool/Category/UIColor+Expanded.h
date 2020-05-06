//
//  UIColor+Expanded.h
//  XZQMusic
//
//  Created by qhzc-iMac-02 on 2020/5/6.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Expanded)

/*
 16进制颜色转UIColor
 */
+ (UIColor *)hexStringToColor:(NSString *)stringToConvert;
+ (UIColor *)hexStringToColor:(NSString *)stringToConvert andAlpha:(CGFloat)alpha;

/*
 颜色转UIImage
 */
+ (nullable UIImage *)imageFromColor:(nonnull UIColor *)color withSize:(CGSize)size;

@end

NS_ASSUME_NONNULL_END

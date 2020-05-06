//
//  CommonUtils.h
//  AudioAndVideo
//
//  Created by qhzc-iMac-02 on 2020/4/10.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommonUtils : NSObject

/*
 获取状态栏高度
 */
+ (double)getDeviceStatusHeight;

/*
 暗黑模式适配
 */
+ (void)initDarkTheme;

/*
 颜色转图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/*
 字典转JSON字符串
 */
+ (NSString *)convert2JSONWithDictionary:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END

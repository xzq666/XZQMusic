//
//  XZQBaseDefinition.h
//  AudioAndVideo
//
//  Created by qhzc-iMac-02 on 2020/4/8.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#ifndef XZQBaseDefinition_h
#define XZQBaseDefinition_h

// 屏幕
#define SCREEN_BOUNDS ([[UIScreen mainScreen] bounds])
#define SCREEN_WIDTH (SCREEN_BOUNDS.size.width)
#define SCREEN_HEIGHT (SCREEN_BOUNDS.size.height)
#define SCREEN_SCALE ([[UIScreen mainScreen] scale])
#define SINGLE_LINE_ONE ([[UIScreen mainScreen] scale]/[[UIScreen mainScreen] scale])

#define SafeAreaNoTopHeight ([CommonUtils getDeviceStatusHeight] >= 44 ? 44 : 20)
#define SafeAreaTopHeight ([CommonUtils getDeviceStatusHeight] >= 44 ? 88 : 64)
#define SafeAreaBottomHeight ([CommonUtils getDeviceStatusHeight] >= 44 ? 34 : 0)

#define LEFT_X(a)               CGRectGetMinX(a.frame)         // 控件左边面的X坐标
#define RIGHT_X(a)              CGRectGetMaxX(a.frame)         // 控件右面的X坐标
#define TOP_Y(a)                CGRectGetMinY(a.frame)         // 控件上面的Y坐标
#define BOTTOM_Y(a)             CGRectGetMaxY(a.frame)         // 控件下面的Y坐标
#define HEIGH(a)                CGRectGetHeight(a.frame)       // 控件的高度
#define WIDTH(a)                CGRectGetWidth(a.frame)        // 控件的宽度

// 字体与View适配
#define IsIphone6P          SCREEN_WIDTH==414
#define SizeScale           (IsIphone6P ? 1.3 : 1)
#define kViewSize(value)    value*SizeScale
#define kFontSize(value)    [UIFont systemFontOfSize:value*SizeScale]

#define WeakSelf(weakSelf) __weak __typeof(self) weakSelf = self;

// 一些固定值
#define GTK (@"1928093487")

// 颜色
#define TitleUnSelectColor ([UIColor hexStringToColor:@"#999999"])
#define TitleSelectColor ([UIColor hexStringToColor:@"#FEC428"])
#define CellViewBackgroundColor ([ZXTheme defaultTheme].zx_isDarkTheme ? [UIColor hexStringToColor:@"#262626"] : [UIColor hexStringToColor:@"#F0F0F0"])
#define TagViewBackgroundColor ([ZXTheme defaultTheme].zx_isDarkTheme ? [UIColor hexStringToColor:@"#282828"] : [UIColor hexStringToColor:@"#F0F0F0"])

// singer头像url前缀
#define SingerAvatarUrl (@"https://y.gtimg.cn/music/photo_new/T001R300x300M000")

#endif /* XZQBaseDefinition_h */

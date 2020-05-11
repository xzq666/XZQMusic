//
//  XZQHotTag.h
//  XZQMusic
//
//  Created by qhzc-iMac-02 on 2020/5/8.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XZQHotTag : NSObject

// 标签内容
@property(copy,nonatomic,nullable) NSString *text;
@property(copy,nonatomic,nullable) NSAttributedString *attributedText;
// 标签字体颜色
@property(strong,nonatomic,nullable) UIColor *textColor;
// 标签背景色
@property(strong,nonatomic,nullable) UIColor *bgColor;
@property(strong,nonatomic,nullable) UIColor *highlightedBgColor;
@property(assign,nonatomic) CGFloat cornerRadius;
// 边距
@property(assign,nonatomic) UIEdgeInsets padding;
@property(strong,nonatomic,nullable) UIFont *font;
// 标签默认字体大小
@property(assign,nonatomic) CGFloat fontSize;
// 是否可以点击，默认可点
@property(assign,nonatomic) BOOL enable;

- (nonnull instancetype)initWithText: (nonnull NSString *)text;

@end

NS_ASSUME_NONNULL_END

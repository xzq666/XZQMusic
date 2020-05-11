//
//  XZQHotTag.m
//  XZQMusic
//
//  Created by qhzc-iMac-02 on 2020/5/8.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "XZQHotTag.h"

static const CGFloat kDefaultFontSize = 14.0;

@implementation XZQHotTag

- (instancetype)init {
    self = [super init];
    if (self) {
        _fontSize = kDefaultFontSize;
        _textColor = TitleUnSelectColor;
        _bgColor = CellViewBackgroundColor;
        _enable = YES;
    }
    return self;
}

- (instancetype)initWithText: (NSString *)text {
    self = [self init];
    if (self) {
        _text = text;
    }
    return self;
}

@end

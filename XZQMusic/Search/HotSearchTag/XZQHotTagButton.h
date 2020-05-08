//
//  XZQHotTagButton.h
//  XZQMusic
//
//  Created by qhzc-iMac-02 on 2020/5/8.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XZQHotTag;

@interface XZQHotTagButton : UIButton

+ (nonnull instancetype)buttonWithTag:(nonnull XZQHotTag *)tag;

@end

NS_ASSUME_NONNULL_END

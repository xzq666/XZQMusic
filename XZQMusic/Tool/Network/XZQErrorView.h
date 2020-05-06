//
//  XZQErrorView.h
//  AudioAndVideo
//
//  Created by qhzc-iMac-02 on 2020/4/22.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XZQErrorView : UIView

- (instancetype)initWithFrame:(CGRect)frame
                errorImageUrl:(NSString *)imageUrl
                     errorTip:(NSString *)tip
                  operateText:(NSString *)operateText
            errorOperateBlock:(void (^)(void))errorOperateBlock;

@end

NS_ASSUME_NONNULL_END

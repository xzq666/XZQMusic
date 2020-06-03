//
//  XZQRotateImage.h
//  XZQMusic
//
//  Created by qhzc-iMac-02 on 2020/5/22.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XZQRotateImage : UIImageView

/*
 开始旋转
 */
- (void)startRotating;

/*
 停止旋转
 */
- (void)stopRotating;

/*
 恢复旋转 从暂停中恢复
 */
- (void)resumeRotating;

@end

NS_ASSUME_NONNULL_END

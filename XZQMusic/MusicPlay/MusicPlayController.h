//
//  MusicPlayController.h
//  XZQMusic
//
//  Created by qhzc-iMac-02 on 2020/6/2.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^BackBlock)(void);

@interface MusicPlayController : UIViewController

@property(nonatomic,copy) BackBlock backBlock;

@end

NS_ASSUME_NONNULL_END

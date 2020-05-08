//
//  RecommendHeaderView.h
//  XZQMusic
//
//  Created by qhzc-iMac-02 on 2020/5/7.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDCycleScrollView.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^BannerBlock)(NSInteger);

@interface RecommendHeaderView : UIView

@property(nonatomic,copy) BannerBlock block;

@property(nonatomic,strong) SDCycleScrollView *cycleScrollView;

- (instancetype)initWithFrame:(CGRect)frame images:(NSArray *)imageUrls;

@end

NS_ASSUME_NONNULL_END

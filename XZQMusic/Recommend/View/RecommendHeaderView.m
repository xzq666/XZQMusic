//
//  RecommendHeaderView.m
//  XZQMusic
//
//  Created by qhzc-iMac-02 on 2020/5/7.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "RecommendHeaderView.h"

@interface RecommendHeaderView ()<SDCycleScrollViewDelegate>

@end

@implementation RecommendHeaderView

- (instancetype)initWithFrame:(CGRect)frame images:(NSArray *)imageUrls
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUIWithImages:imageUrls];
    }
    return self;
}

- (void)setupUIWithImages:(NSArray *)imageUrls {
    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 432 / 1080) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.cycleScrollView.imageURLStringsGroup = imageUrls;
    self.cycleScrollView.autoScrollTimeInterval = 3.0;
    [self addSubview:self.cycleScrollView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, SCREEN_WIDTH * 432 / 1080, SCREEN_WIDTH-30, 50)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"热门歌单推荐";
    titleLabel.textColor = TitleSelectColor;
    titleLabel.font = [UIFont systemFontOfSize:16.0];
    [self addSubview:titleLabel];
}

/* 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    if (self.block) {
        self.block(index);
    }
}

@end

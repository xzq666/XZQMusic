//
//  RankListCell.h
//  XZQMusic
//
//  Created by qhzc-iMac-02 on 2020/5/7.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RankListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RankListCell : UITableViewCell

@property(nonatomic,strong) UIImageView *coverImage;
@property(nonatomic,strong) UILabel *top1Label;
@property(nonatomic,strong) UILabel *top2Label;
@property(nonatomic,strong) UILabel *top3Label;

- (void)cellWithModel:(RankListModel *)model;

@end

NS_ASSUME_NONNULL_END

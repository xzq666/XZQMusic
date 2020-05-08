//
//  RecommendListCell.h
//  XZQMusic
//
//  Created by qhzc-iMac-02 on 2020/5/7.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiscListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RecommendListCell : UITableViewCell

@property(nonatomic,strong) UIImageView *coverImage;
@property(nonatomic,strong) UILabel *nameLabel;
@property(nonatomic,strong) UILabel *descLabel;

- (void)cellWithModel:(DiscListModel *)model;

@end

NS_ASSUME_NONNULL_END

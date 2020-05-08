//
//  SingerListCell.h
//  XZQMusic
//
//  Created by qhzc-iMac-02 on 2020/5/7.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingerListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SingerListCell : UITableViewCell

@property(nonatomic,strong) UIImageView *avatarImage;
@property(nonatomic,strong) UILabel *singerNameLabel;

- (void)cellWithModel:(SingerListModel *)model;

@end

NS_ASSUME_NONNULL_END

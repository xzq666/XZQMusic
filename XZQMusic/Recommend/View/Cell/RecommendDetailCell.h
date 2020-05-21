//
//  RecommendDetailCell.h
//  XZQMusic
//
//  Created by qhzc-iMac-02 on 2020/5/20.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QQMusicModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RecommendDetailCell : UITableViewCell

@property(nonatomic,strong) UILabel *songNameLabel;
@property(nonatomic,strong) UILabel *describeLabel;

- (void)cellWithModel:(QQMusicModel *)model;

@end

NS_ASSUME_NONNULL_END

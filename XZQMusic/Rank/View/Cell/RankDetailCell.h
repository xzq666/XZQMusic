//
//  RankDetailCell.h
//  XZQMusic
//
//  Created by qhzc-iMac-02 on 2020/5/21.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QQMusicModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RankDetailCell : UITableViewCell

@property(nonatomic,strong) UILabel *rankLabel;
@property(nonatomic,strong) UIImageView *rankImage;
@property(nonatomic,strong) UILabel *songNameLabel;
@property(nonatomic,strong) UILabel *describeLabel;

- (void)cellWithModel:(QQMusicModel *)model rankNum:(NSInteger)index showImage:(NSString *)imageUrl;

@end

NS_ASSUME_NONNULL_END

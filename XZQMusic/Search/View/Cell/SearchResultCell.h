//
//  SearchResultCell.h
//  XZQMusic
//
//  Created by qhzc-iMac-02 on 2020/5/11.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QQMusicModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchResultCell : UITableViewCell

@property(nonatomic,strong) UIImageView *iconImage;  // 音乐图标
@property(nonatomic,strong) UILabel *resultLabel;  // 搜索结果歌曲名

- (void)cellWithModel:(QQMusicModel *)model;

@end

NS_ASSUME_NONNULL_END

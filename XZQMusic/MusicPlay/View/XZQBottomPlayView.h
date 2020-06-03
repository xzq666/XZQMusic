//
//  XZQBottomPlayView.h
//  XZQMusic
//
//  Created by qhzc-iMac-02 on 2020/5/22.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XZQBottomPlayView : UIView

@property(nonatomic,strong) UIButton *playBtn;
@property(nonatomic,strong) UILabel *songnameLabel;
@property(nonatomic,strong) UILabel *singernameLabel;
@property(nonatomic,strong) UIImageView *musiclistImage;

- (instancetype)initWithFrame:(CGRect)frame coverUrl:(NSString *)coverUrl songName:(NSString *)songName singerName:(NSString *)singerName;

- (void)playWithCoverUrl:(NSString *)coverUrl songName:(NSString *)songName singerName:(NSString *)singerName;

@end

NS_ASSUME_NONNULL_END

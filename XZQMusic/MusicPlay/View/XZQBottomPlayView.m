//
//  XZQBottomPlayView.m
//  XZQMusic
//
//  Created by qhzc-iMac-02 on 2020/5/22.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "XZQBottomPlayView.h"
#import "XZQCircleProgressView.h"
#import "XZQRotateImage.h"
#import "MusicPlayController.h"

@interface XZQBottomPlayView ()

@property(nonatomic,strong) XZQRotateImage *rotateImage;
@property(nonatomic,strong) XZQCircleProgressView *circleProcessView;

@property(nonatomic,assign) int playType;  // 0播放 1暂停

@property(nonatomic,strong) NSTimer *timer;
@property(nonatomic,assign) float playTime;

@end

@implementation XZQBottomPlayView

- (instancetype)initWithFrame:(CGRect)frame coverUrl:(NSString *)coverUrl songName:(NSString *)songName singerName:(NSString *)singerName
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = CellViewBackgroundColor;
        self.playType = 0;
        self.playTime = 0.0;
        [self setupUIWithCoverUrl:coverUrl songName:songName singerName:singerName];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoBigView)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)gotoBigView {
    [self setHidden:YES];
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    MusicPlayController *vc = [[MusicPlayController alloc] init];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    vc.backBlock = ^{
        [self setHidden:NO];
    };
    [window.rootViewController presentViewController:vc animated:YES completion:^{
        
    }];
}

- (void)setupUIWithCoverUrl:(NSString *)coverUrl songName:(NSString *)songName singerName:(NSString *)singerName {
    self.rotateImage = [[XZQRotateImage alloc] initWithFrame:CGRectMake(25, 12.5, 50, 50)];
    [self addSubview:self.rotateImage];
    
    self.circleProcessView = [[XZQCircleProgressView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-120, 17.5, 40, 40) lineWidth:2.0];
    [self.circleProcessView updateProgressWithNumber:0.0];
    [self addSubview:self.circleProcessView];
    
    self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.playBtn.frame = CGRectMake(SCREEN_WIDTH-107.5, 30, 15, 15);
    [self.playBtn setBackgroundImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    [self addSubview:self.playBtn];
    [self.playBtn addTarget:self action:@selector(playClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.musiclistImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-69, 15.5, 44, 44)];
    self.musiclistImage.image = [UIImage imageNamed:@"musiclist"];
    [self addSubview:self.musiclistImage];
    
    self.songnameLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, 15, SCREEN_WIDTH-205, 25)];
    self.songnameLabel.font = [UIFont systemFontOfSize:15.0 weight:1.1];
    self.songnameLabel.text = songName;
    [self addSubview:self.songnameLabel];
    
    self.singernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, 40, SCREEN_WIDTH-205, 20)];
    self.singernameLabel.font = [UIFont systemFontOfSize:12.0];
    self.singernameLabel.text = singerName;
    self.singernameLabel.textColor = TitleUnSelectColor;
    [self addSubview:self.singernameLabel];
    
    [self play:coverUrl];
}

- (void)playWithCoverUrl:(NSString *)coverUrl songName:(NSString *)songName singerName:(NSString *)singerName {
    self.playType = 0;
    self.playTime = 0.0;
    [self.circleProcessView updateProgressWithNumber:self.playTime / 180];
    [self.rotateImage stopRotating];
    [self.playBtn setBackgroundImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    self.songnameLabel.text = songName;
    self.singernameLabel.text = singerName;
    [self play:coverUrl];
}

- (void)playClick {
    if (self.playType == 0) {
        [self invalidateTimer];
        [self.rotateImage stopRotating];
        self.playType = 1;
        [self.playBtn setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    } else {
        [self invalidateTimer];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
            self.playTime = self.playTime + 1.0;
            [self.circleProcessView updateProgressWithNumber:self.playTime / 180];
            [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        }];
        [self.rotateImage resumeRotating];
        [self.playBtn setBackgroundImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        self.playType = 0;
    }
}

- (void)invalidateTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)play:(NSString *)coverUrl {
    [self.rotateImage sd_setImageWithURL:[NSURL URLWithString:coverUrl] placeholderImage:[UIImage imageNamed:@"placeholder"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        self.rotateImage.image = [image drawRectWithRoundedCorner];
        [self.rotateImage resumeRotating];
    }];
    [self invalidateTimer];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        self.playTime = self.playTime + 1.0;
        [self.circleProcessView updateProgressWithNumber:self.playTime / 180];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }];
}

- (void)dealloc
{
    [self invalidateTimer];
}

@end

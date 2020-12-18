//
//  XZQMusicPlayer.m
//  XZQMusic
//
//  Created by qhzc-iMac-02 on 2020/6/3.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "XZQMusicPlayer.h"
#import "XZQPlayerFileManager.h"

static XZQMusicPlayer *instance;

@interface XZQMusicPlayer ()

/*播放器相关*/
@property(nonatomic,strong) AVPlayer *player;
@property(nonatomic,strong) AVPlayerItem *playerItem;

/*播放进度监测*/
@property(nonatomic,strong) id timeObserver;

@end

@implementation XZQMusicPlayer

+ (XZQMusicPlayer *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[XZQMusicPlayer alloc] init];
    });
    return instance;
}

- (void)xzq_initPlayerWithUserId:(NSString *)userId {
    // 记录当前用户
    [XZQPlayerFileManager xzq_playerCreateCachePathWithUserId:userId];
    
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];  // 支持锁屏播放

    self.state = XZQMusicPlayStateStopped;  // 播放状态默认停止
    self.isObserveProgress = YES;
    self.isNeedCache = YES;
    self.isCached = NO;
    
    // 添加观察者
    [self addPlayerObserver];
}

#pragma mark - 播放器监听
- (void)addPlayerObserver {
    
}

// 预播放处理
- (void)xzq_playerPlayWithAudioId:(NSUInteger)audioId {
    [self audioPrePlay];
}

// 预播放
- (void)audioPrePlay {
    // 移除播放进度观察者
    if (self.timeObserver) {
        [self.player removeTimeObserver:self.timeObserver];
        self.timeObserver = nil;
    }
    [self audioPrePlayToResetAudio];
    [self audioPrePlayToLoadAudio];
}

// 重置音频信息
- (void)audioPrePlayToResetAudio {
    // 暂停播放
    if (self.isPlaying) {
        [self xzq_musicPause];
    }
    // 移除播放进度观察者
    if (self.timeObserver) {
        [self.player removeTimeObserver:self.timeObserver];
        self.timeObserver = nil;
    }
}

// 加载音频
- (void)audioPrePlayToLoadAudio {
    self.currentAudioModel.purl = @"http://aqqmusic.tc.qq.com/amobile.music.tc.qq.com/C400001PLl3C4gPSCI.m4a?guid=1467504790&vkey=EE40535791C7501925FD6FD5A15E4603B847E5B0EFA8D9A42D841441AB9FAC69C9FC51C8F532610E60FC1951F2E57C0B1110B2398CA52E86&uin=0&fromtag=38";
    if ([CommonUtils isLocalWithUrlString:self.currentAudioModel.purl]) {
        self.isCached = YES;
        [self loadPlayerItemWithUrl:[NSURL URLWithString:self.currentAudioModel.purl]];
    } else {
        NSString *cacheFilePath = [XZQPlayerFileManager xzq_isExistAudioFileWithURL:[NSURL URLWithString:self.currentAudioModel.purl]];
        NSLog(@"当前音频是否有缓存：%@",cacheFilePath ? @"有" : @"无");
        self.isCached = cacheFilePath ? YES : NO;
        [self loadPlayerItemWithUrl:[NSURL URLWithString:self.currentAudioModel.purl] cacheFilePath:cacheFilePath];
    }
}

// 播放
- (void)xzq_musicPlay {
    if (!self.isPlaying) {
        self.isPlaying = YES;
        self.state = XZQMusicPlayStatePlaying;
        [self.player play];
    }
}

// 暂停
- (void)xzq_musicPause {
    if (self.isPlaying) {
        self.isPlaying = NO;
        self.state = XZQMusicPlayStatePause;
        [self.player pause];
    }
}

// 播放上一首
- (void)xzq_playLast {
    
}

// 播放下一首
- (void)xzq_playNext {
    
}

- (void)xzq_seekToTimeWithValue:(CGFloat)value {
    
}

// 加载AVPlayerItem
- (void)loadPlayerItemWithAsset:(AVURLAsset *)asset {
    self.playerItem = [AVPlayerItem playerItemWithAsset:asset];
    NSLog(@"歌曲时间-->%f", CMTimeGetSeconds(self.playerItem.duration));
    [self loadPlayer];
}
- (void)loadPlayerItemWithUrl:(NSURL *)url {
    self.playerItem = [AVPlayerItem playerItemWithURL:url];
    NSLog(@"歌曲时间-->%f", CMTimeGetSeconds(self.playerItem.duration));
    [self loadPlayer];
}
- (void)loadPlayerItemWithUrl:(NSURL *)url cacheFilePath:(NSString *)cacheFilePath {
    if (!self.isNeedCache) {
        [self loadPlayerItemWithUrl:url];
    } else {
        if (cacheFilePath) { // 有缓存直接播放缓存
            [self loadPlayerItemWithUrl:[NSURL fileURLWithPath:cacheFilePath]];
        } else {  // 无缓存
            NSLog(@"无缓存播放");
            [self loadPlayerItemWithUrl:url];
        }
    }
}

// 加载AVPlayer
- (void)loadPlayer {
    self.player = [[AVPlayer alloc] initWithPlayerItem:self.playerItem];
    // 监听播放进度
    if (self.isObserveProgress) {
        [self addPlayProgresstimeObserver];
    }
    // 开始播放
    [self xzq_musicPlay];
}

- (void)addPlayProgresstimeObserver {
    WeakSelf(weakSelf);
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        float total = CMTimeGetSeconds(weakSelf.playerItem.duration);
        float current = CMTimeGetSeconds(time);
        NSLog(@"total-->%f/%f", current, total);
    }];
}

@end

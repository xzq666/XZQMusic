//
//  XZQMusicPlayer.m
//  XZQMusic
//
//  Created by qhzc-iMac-02 on 2020/6/3.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "XZQMusicPlayer.h"

static XZQMusicPlayer *instance;

@implementation XZQMusicPlayer

+ (XZQMusicPlayer *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[XZQMusicPlayer alloc] init];
    });
    return instance;
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

@end

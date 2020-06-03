//
//  XZQMusicPlayer.h
//  XZQMusic
//
//  Created by qhzc-iMac-02 on 2020/6/3.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 播放状态
typedef NS_ENUM(NSInteger, XZQMusicPlayState) {
    XZQMusicPlayStateFailed,     // 播放失败
    XZQMusicPlayStateBuffering,  // 缓冲中
    XZQMusicPlayStatePlaying,    // 播放中
    XZQMusicPlayStatePause,      // 暂停播放
    XZQMusicPlayStateStopped     // 停止播放
};

@interface XZQMusicPlayer : NSObject

/*播放器相关*/
@property(nonatomic,strong) AVPlayer *player;
@property(nonatomic,strong) AVPlayerItem *playerItem;

/*是否正在播放*/
@property(nonatomic,assign) BOOL isPlaying;
/*播放器状态*/
@property(nonatomic,assign) XZQMusicPlayState state;

#pragma mark - 初始化

// 播放器为一个单例
+ (XZQMusicPlayer *)sharedInstance;

#pragma mark - 相关功能

/**
 播放
 */
- (void)xzq_musicPlay;
/**
 暂停
 */
- (void)xzq_musicPause;
/**
 上一首
 */
- (void)xzq_playLast;
/**
 下一首
 */
- (void)xzq_playNext;
/**
 音频跳转
 @param value 时间百分比
 */
- (void)xzq_seekToTimeWithValue:(CGFloat)value;

@end

NS_ASSUME_NONNULL_END

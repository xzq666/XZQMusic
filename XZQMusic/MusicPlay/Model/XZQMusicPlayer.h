//
//  XZQMusicPlayer.h
//  XZQMusic
//
//  Created by qhzc-iMac-02 on 2020/6/3.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QQMusicModel.h"

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

/*是否监听播放进度 默认YES*/
@property(nonatomic,assign) BOOL isObserveProgress;
/*是否需要缓存 默认YES*/
@property(nonatomic,assign) BOOL isNeedCache;

/*当前音频是否已有缓存*/
@property(nonatomic,assign) BOOL isCached;
/*是否正在播放*/
@property(nonatomic,assign) BOOL isPlaying;
/*播放器状态*/
@property(nonatomic,assign) XZQMusicPlayState state;
/*当前正在播放的Music*/
@property(nonatomic,strong) QQMusicModel *currentAudioModel;

/*当前音频当前播放时间*/
@property(nonatomic,assign) CGFloat currentTime;
/*当前音频总播放时间*/
@property(nonatomic,assign) CGFloat totalTime;

#pragma mark - 初始化

// 播放器为一个单例
+ (XZQMusicPlayer *)sharedInstance;

/**
 初始化播放器
 @param userId 用户唯一Id。
 isNeedCache（默认YES）为YES时，若同一设备登录不同账号：
 1.userId存在时，DFPlayer将为每位用户建立不同的缓存文件目录。例如，user_001,user_002...
 2.userId为nil或@""时，统一使用DFPlayerCache文件夹下的user_public文件夹作为缓存目录。
 isNeedCache为NO时,userId设置无效，此时不会在沙盒创建缓存目录
 */
- (void)xzq_initPlayerWithUserId:(nullable NSString *)userId;

#pragma mark - 相关功能

/**
 预播放处理
 */
- (void)xzq_playerPlayWithAudioId:(NSUInteger)audioId;

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

//
//  XZQLyricsAnalysis.h
//  XZQMusic
//
//  Created by qhzc-iMac-02 on 2020/6/2.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XZQLyricsAnalysis : NSObject

@property(nonatomic,strong) NSString *ar;  // 演唱
@property(nonatomic,strong) NSString *ti;  // 歌曲名
@property(nonatomic,strong) NSString *al;  // 专辑名
@property(nonatomic,strong) NSString *by;  // 歌词作者
@property(nonatomic,strong) NSString *t_time;  // 歌曲总时长
@property(nonatomic,strong) NSMutableArray *lrcArrayTime;  // 时间数组
@property(nonatomic,strong) NSMutableArray *lrcArrayStr;  // 歌词数组

- (instancetype)init;
// 带文件名的初始化
- (instancetype)initWithFileName:(NSString *)name ofType:(NSString *)type;
// 带文件路径的初始化
- (instancetype)initWithFilePath:(NSString *)filePath;
// 处理文件名歌词
- (void)lyricsAnalysisWithFileName:(NSString *)name ofType:(NSString *)type;
// 处理文件路径
- (void)lyricsAnalysisWithFilePath:(NSString *)filePath;
// 处理字符串歌词
- (void)lyricsAnalysisWithString:(NSString *)lyrics;

@end

NS_ASSUME_NONNULL_END

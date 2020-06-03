//
//  XZQLyricsAnalysis.m
//  XZQMusic
//
//  Created by qhzc-iMac-02 on 2020/6/2.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "XZQLyricsAnalysis.h"

@interface XZQLyricsAnalysis ()

// 歌词时间调整变量
@property double offset;

@end

@implementation XZQLyricsAnalysis

- (instancetype)init {
    if (self = [super init]) {
        self.ar = [[NSString alloc] init];
        self.ti = [[NSString alloc] init];
        self.by = [[NSString alloc] init];
        self.al = [[NSString alloc] init];
        self.offset = 0;
        self.t_time = [[NSString alloc] init];  // 歌曲总时长单位（s）
        self.lrcArrayStr = [[NSMutableArray alloc] init];  // 歌词数组初始化
        self.lrcArrayTime = [[NSMutableArray alloc] init];  // 时间数组初始化
    }
    return self;
}

- (instancetype)initWithFileName:(NSString *)name ofType:(NSString *)type {
    self = [self init];
    [self lyricsAnalysisWithFileName:name ofType:type];
    return self;
}

- (instancetype)initWithFilePath:(NSString *)filePath {
    self = [self init];
    [self lyricsAnalysisWithFilePath:filePath];
    return self;
}

- (void)lyricsAnalysisWithFileName:(NSString *)name ofType:(NSString *)type {
    // 构建filePath
    [self lyricsAnalysisWithFilePath:[[NSBundle mainBundle] pathForResource:name ofType:type]];
}

- (void)lyricsAnalysisWithFilePath:(NSString *)filePath {
    NSString *strlrc = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    [self lyricsAnalysisWithString:strlrc];
}

- (void)lyricsAnalysisWithString:(NSString *)lyrics {
    NSMutableArray *arraylrc = [[NSMutableArray alloc] initWithArray:[lyrics componentsSeparatedByString:@"\n"]];
    NSArray *strToInt = [NSArray arrayWithObjects:@"ar", @"ti", @"al", @"by", @"of", @"t_",nil];  // NSString switch 配置
    BOOL flag = arraylrc.count > 0 ? YES : NO;  // 防止错误路径或者歌词文件为空导致的概率性崩溃
    while (flag) {
        NSString *temp = arraylrc[0];
        switch ((int)[strToInt indexOfObject:[temp substringWithRange:NSMakeRange(1, 2)]]) {
            case 0:
                self.ar = [[temp substringFromIndex:4] stringByReplacingOccurrencesOfString:@"]" withString:@"\0"];
                break;
            case 1:
                self.ti = [[temp substringFromIndex:4] stringByReplacingOccurrencesOfString:@"]" withString:@"\0"];
                break;
            case 2:
                self.al = [[temp substringFromIndex:4] stringByReplacingOccurrencesOfString:@"]" withString:@"\0"];
                break;
            case 3:
                self.by = [[temp substringFromIndex:4] stringByReplacingOccurrencesOfString:@"]" withString:@"\0"];
                break;
            case 4:
                self.offset = [[[temp substringFromIndex:8] stringByReplacingOccurrencesOfString:@"]" withString:@"\0"] doubleValue];
                break;
            case 5:
                self.t_time = [[temp substringFromIndex:9] stringByReplacingOccurrencesOfString:@")]" withString:@"\0"];
                break;
            default:
                flag = NO;
                break;
        }
        flag ? [arraylrc removeObjectAtIndex:0] : nil;  // 判断是否需要移除已经被读取的信息（是歌词则不移除）
    }
    // lrc时间的格式分3种:[mm:ss.SS]、[mm:ss:SS]、[mm:ss];
    // 第一种是标准形式，后面两种存在但是不标准;
    // 先把时间字符串按照“:”拆分，生成{mm ss.SS}、{mm ss SS}、{mm ss};
    // 对于1、3，直接取doubleValue即可，注意分钟*60;
    // 对于第二种情况需要单独处理SS(毫秒)位
    for (NSString *str in arraylrc) {
        // 分割每一句歌词
        NSArray *arrayTemp = [str componentsSeparatedByString:@"]"];
        for(int j = 0; j < arrayTemp.count -1; j++) {
            // 分割时间字符串
            NSArray *arraytime = [[arrayTemp[j] substringFromIndex:1] componentsSeparatedByString:@":"];
            // 处理分钟和秒
            double timedouble = [arraytime[0] doubleValue]*60.0 + [arraytime[1] doubleValue];
            // 处理毫秒位
            timedouble += arraytime.count > 2 ? [[[NSString alloc]initWithFormat:@"0.%@", arraytime[2]] doubleValue]:0;
            // 时间调整
            timedouble += (self.offset / 1000.0);
            // 避免因为时间调整导致的时间<0
            timedouble = timedouble > 0 ? timedouble : 0;
            int i = 0;
            // 查找当前歌词的插入位置
            while (i < self.lrcArrayTime.count && [self.lrcArrayTime[i++] doubleValue] < timedouble);
            // 插入时间数组
            [self.lrcArrayTime insertObject:[[NSString alloc]initWithFormat:@"%lf",timedouble] atIndex:i];
            // 插入歌词数组
            [self.lrcArrayStr insertObject:arrayTemp[arrayTemp.count-1] atIndex:i];
        }
    }
    if (self.lrcArrayTime.count == 0) {
        [self.lrcArrayTime insertObject:@"0" atIndex:0];
        [self.lrcArrayStr insertObject:@"未找到歌词！" atIndex:0];
    }
}

@end

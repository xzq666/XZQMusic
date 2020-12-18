//
//  XZQPlayerFileManager.m
//  XZQMusic
//
//  Created by qhzc-iMac-02 on 2020/6/5.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "XZQPlayerFileManager.h"

static NSString *XZQPlayer_fileId = @"cacheFileId";  // 缓存文件id，用于获取缓存文件夹
static NSString *XZQPlayer_fileName = @"XZQPlayerCache";  // 所有缓存文件都放在沙盒Cache文件夹下的XZQPlayerCache文件夹里

@implementation XZQPlayerFileManager

// Cache文件夹创建用户缓存目录的用户id
+ (void)xzq_playerCreateCachePathWithUserId:(NSString *)userId {
    NSString *uniqueId = @"public";
    if (userId) {
        if ([userId rangeOfString:@" "].location != NSNotFound) {
            userId = [userId stringByReplacingOccurrencesOfString:@" " withString:@""];
        }
        if (userId.length > 0) {
            uniqueId = userId;
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:userId forKey:XZQPlayer_fileId];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// XZQPlayerCache文件夹所在文件路径
+ (NSString *)getPlayerCachePath {
    NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    NSString *cachePath = [path stringByAppendingPathComponent:XZQPlayer_fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:cachePath]) {
        [fileManager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return cachePath;
}

// 当前用户id缓存文件夹地址
+ (NSString *)xzq_playerUserCachePath {
    NSString *fileId = [[NSUserDefaults standardUserDefaults] objectForKey:XZQPlayer_fileId];
    NSString *fileName = [NSString stringWithFormat:@"user_%@", fileId];
    NSString *userPath = [[XZQPlayerFileManager getPlayerCachePath] stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:userPath]) {
        [fileManager createDirectoryAtPath:userPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return userPath;
}

// 获取临时文件路径
+ (NSString *)getTempAudioFilePath {
    return [NSTemporaryDirectory() stringByAppendingPathComponent:@"MusicTemp.mp4"];
}

// 创建临时文件
+ (BOOL)xzq_createTempFile {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [XZQPlayerFileManager getTempAudioFilePath];
    if ([fileManager fileExistsAtPath:path]) {
        [fileManager removeItemAtPath:path error:nil];
    }
    return [fileManager createFileAtPath:path contents:nil attributes:nil];
}

// 写临时文件
+ (void)xzq_writeDataToTempAudioFileWithData:(NSData *)data {
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:[XZQPlayerFileManager getTempAudioFilePath]];
    [fileHandle seekToEndOfFile];
    [fileHandle writeData:data];
}

// 读临时文件
+ (NSData *)xzq_readTempAudioFileDataWithOffset:(NSUInteger)offset length:(NSUInteger)length {
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:[XZQPlayerFileManager getTempAudioFilePath]];
    [fileHandle seekToFileOffset:offset];
    return [fileHandle readDataOfLength:length];
}

// 保存临时文件到缓存文件夹
+ (void)xzq_saveTempAudioFileToCachePath:(NSURL *)url complete:(void (^)(BOOL, NSError * _Nonnull))complete {
    NSString *path = [XZQPlayerFileManager getAudioFileCachePathWithUrl:url];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]) {
        NSError *error;
        NSNumber *accountID = [NSNumber numberWithInt:[[[NSUserDefaults standardUserDefaults] objectForKey:XZQPlayer_fileId] intValue]];
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:@{NSFileOwnerAccountID: accountID} error:&error];
        if (error) {
            NSLog(@"-缓存文件夹创建失败-:%@",[error localizedDescription]);
        }
    }
    NSString *audioFileName = [url.absoluteString lastPathComponent];
    NSString *cacheFilePath = [NSString stringWithFormat:@"%@/%@", path, audioFileName];
    NSError *error;
    BOOL success = [[NSFileManager defaultManager] copyItemAtPath:[XZQPlayerFileManager getTempAudioFilePath] toPath:cacheFilePath error:&error];
    if (!success) {
        // 安全性处理 如果没有保存成功，删除归档文件中的对应键值对
    }
    if (complete) {
        complete(success, error);
    }
}

// 缓存文件路径
+ (NSString *)getAudioFileCachePathWithUrl:(NSURL *)url {
    NSString *filePath = [XZQPlayerFileManager xzq_playerUserCachePath];
    NSString *backStr = [[url.absoluteString componentsSeparatedByString:@"//"].lastObject stringByDeletingLastPathComponent];  // 删除最后一个路径节点
    NSString *path = [filePath stringByAppendingPathComponent:backStr];
    return path;
}

// 缓存文件是否存在
+ (NSString *)xzq_isExistAudioFileWithURL:(NSURL *)url {
    NSString *path = [XZQPlayerFileManager getAudioFileCachePathWithUrl:url];
    NSString *audioFileName = [url.absoluteString lastPathComponent];
    NSString *cacheFilePath = [NSString stringWithFormat:@"%@/%@", path, audioFileName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:cacheFilePath]) {
        return cacheFilePath;
    }
    return nil;
}

@end

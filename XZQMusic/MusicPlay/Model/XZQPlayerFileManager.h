//
//  XZQPlayerFileManager.h
//  XZQMusic
//
//  Created by qhzc-iMac-02 on 2020/6/5.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XZQPlayerFileManager : NSObject

/**
 Cache文件夹创建用户缓存目录的用户id
 */
+ (void)xzq_playerCreateCachePathWithUserId:(nullable NSString *)userId;

/**
 当前用户id缓存文件夹地址
 */
+ (NSString *)xzq_playerUserCachePath;

/**
 创建临时文件
 */
+ (BOOL)xzq_createTempFile;

/**
 数据写入临时文件
 */
+ (void)xzq_writeDataToTempAudioFileWithData:(NSData *)data;

/**
 读取临时文件数据
 @param offset : 偏移量，即开始读取数据的位置
 @param length : 长度，即读取数据的大小长度
 */
+ (NSData *)xzq_readTempAudioFileDataWithOffset:(NSUInteger)offset length:(NSUInteger)length;

/**
 保存临时文件到缓存文件夹
 */
+ (void)xzq_saveTempAudioFileToCachePath:(NSURL *)url complete:(void(^)(BOOL isSuccess, NSError *error))complete;

/**
 是否已存在缓存文件
 */
+ (NSString *)xzq_isExistAudioFileWithURL:(NSURL *)url;

@end

NS_ASSUME_NONNULL_END

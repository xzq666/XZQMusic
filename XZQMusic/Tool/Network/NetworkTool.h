//
//  NetworkTool.h
//  AudioAndVideo
//
//  Created by qhzc-iMac-02 on 2020/4/22.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetworkTool : NSObject

+ (void)getXSRFInfo:(void (^)(id obj))completeBlock;

+ (void)getUrl:(NSString *)url withParams:(NSDictionary *)params backInfoWhenErrorBlock:(void (^)(id obj, NSError *error))completeBlock;

+ (void)getUrl:(NSString *)url withParams:(NSDictionary *)params backViewWhenErrorBlock:(void (^)(id obj, UIView *errorView))completeBlock;

+ (void)postUrl:(NSString *)url withParams:(NSDictionary *)params backInfoWhenErrorBlock:(void (^)(id obj, NSError *error))completeBlock;

@end

NS_ASSUME_NONNULL_END

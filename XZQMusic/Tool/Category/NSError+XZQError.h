//
//  NSError+XZQError.h
//  AudioAndVideo
//
//  Created by qhzc-iMac-02 on 2020/4/27.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSError (XZQError)

+ (NSError *)returnErrorWithError:(NSError *)error;

@end

NS_ASSUME_NONNULL_END

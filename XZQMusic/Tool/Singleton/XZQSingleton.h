//
//  XZQSingleton.h
//  XZQMusic
//
//  Created by qhzc-iMac-02 on 2020/5/8.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XZQSingleton : NSObject

@property(nonatomic,copy) NSString *cookie;
@property(nonatomic,copy) NSString *xsrfToken;
@property(nonatomic,copy) NSString *csrf;

+ (XZQSingleton *)sharedInstance;

@end

NS_ASSUME_NONNULL_END

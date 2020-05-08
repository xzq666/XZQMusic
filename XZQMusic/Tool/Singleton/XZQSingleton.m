//
//  XZQSingleton.m
//  XZQMusic
//
//  Created by qhzc-iMac-02 on 2020/5/8.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "XZQSingleton.h"

static XZQSingleton *instance;

@implementation XZQSingleton

+ (XZQSingleton *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[XZQSingleton alloc] init];
    });
    return instance;
}

@end

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

- (instancetype)init
{
    self = [super init];
    if (self) {
        _currentPlaySongs = [NSMutableArray array];
        _isPlayMusic = NO;
    }
    return self;
}

+ (XZQSingleton *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[XZQSingleton alloc] init];
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    if (instance == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            instance = [super allocWithZone:zone];
        });
    }
    return instance;
}

@end

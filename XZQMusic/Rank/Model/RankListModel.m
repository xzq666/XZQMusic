//
//  RankListModel.m
//  XZQMusic
//
//  Created by qhzc-iMac-02 on 2020/5/7.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "RankListModel.h"

@implementation Song

@end

@implementation RankListModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"topId": @"id"
    };
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"songList": @"Song"
    };
}

@end

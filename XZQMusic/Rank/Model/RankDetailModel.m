//
//  RankDetailModel.m
//  XZQMusic
//
//  Created by qhzc-iMac-02 on 2020/5/21.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "RankDetailModel.h"

@implementation TopInfo

@end

@implementation SongListContent

@end

@implementation RankDetailModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"songlist": @"SongListContent"
    };
}

@end

//
//  QQMusicModel.m
//  
//
//  Created by qhzc-iMac-02 on 2020/4/26.
//

#import "QQMusicModel.h"

@implementation QQMusicModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"singer": @"Singer"
    };
}

@end

@implementation Singer

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"singerId": @"id"
    };
}

@end

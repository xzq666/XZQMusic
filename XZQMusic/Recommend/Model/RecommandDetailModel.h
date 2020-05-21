//
//  RecommandDetailModel.h
//  XZQMusic
//
//  Created by qhzc-iMac-02 on 2020/5/20.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QQMusicModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RecommandDetailModel : NSObject

@property(nonatomic,copy) NSString *disstid;
@property(nonatomic,assign) NSInteger dissid;
@property(nonatomic,copy) NSString *dissname;
@property(nonatomic,copy) NSString *logo;
@property(nonatomic,copy) NSString *desc;
@property(nonatomic,copy) NSString *songids;
@property(nonatomic,copy) NSString *songtypes;
@property(nonatomic,strong) NSArray *songlist;

@end

NS_ASSUME_NONNULL_END

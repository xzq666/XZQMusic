//
//  RankListModel.h
//  XZQMusic
//
//  Created by qhzc-iMac-02 on 2020/5/7.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Song : NSObject

@property(nonatomic,copy) NSString *singername;
@property(nonatomic,copy) NSString *songname;

@end

@interface RankListModel : NSObject

@property(nonatomic,assign) NSInteger topId;
@property(nonatomic,assign) NSInteger listenCount;
@property(nonatomic,copy) NSString *picUrl;
@property(nonatomic,copy) NSString *topTitle;
@property(nonatomic,assign) NSInteger type;
@property(nonatomic,strong) NSArray *songList;

@end

NS_ASSUME_NONNULL_END

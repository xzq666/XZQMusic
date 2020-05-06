//
//  DiscListModel.h
//  XZQMusic
//
//  Created by qhzc-iMac-02 on 2020/5/6.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DiscCreator : NSObject

@property(nonatomic,assign) NSInteger type;
@property(nonatomic,copy) NSString *qq;
@property(nonatomic,copy) NSString *encrypt_uin;
@property(nonatomic,copy) NSString *name;
@property(nonatomic,assign) NSInteger isVip;
@property(nonatomic,copy) NSString *avatarUrl;
@property(nonatomic,assign) NSInteger followflag;

@end

@interface DiscListModel : NSObject

@property(nonatomic,copy) NSString *dissid;
@property(nonatomic,copy) NSString *createtime;
@property(nonatomic,copy) NSString *commit_time;
@property(nonatomic,copy) NSString *dissname;
@property(nonatomic,copy) NSString *imgurl;
@property(nonatomic,copy) NSString *introduction;
@property(nonatomic,copy) NSString *listennum;
@property(nonatomic,assign) CGFloat score;
@property(nonatomic,assign) NSInteger version;
@property(nonatomic,strong) DiscCreator *creator;

@end

NS_ASSUME_NONNULL_END

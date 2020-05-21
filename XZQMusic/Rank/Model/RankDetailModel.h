//
//  RankDetailModel.h
//  XZQMusic
//
//  Created by qhzc-iMac-02 on 2020/5/21.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QQMusicModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TopInfo : NSObject

@property(nonatomic,copy) NSString *ListName;
@property(nonatomic,copy) NSString *MacDetailPicUrl;
@property(nonatomic,copy) NSString *MacListPicUrl;
@property(nonatomic,copy) NSString *UpdateType;
@property(nonatomic,copy) NSString *albuminfo;
@property(nonatomic,copy) NSString *headPic_v12;
@property(nonatomic,copy) NSString *info;
@property(nonatomic,assign) NSInteger listennum;
@property(nonatomic,copy) NSString *pic;
@property(nonatomic,copy) NSString *picDetail;
@property(nonatomic,copy) NSString *pic_album;
@property(nonatomic,copy) NSString *pic_h5;
@property(nonatomic,copy) NSString *pic_v11;
@property(nonatomic,copy) NSString *pic_v12;
@property(nonatomic,copy) NSString *topID;
@property(nonatomic,copy) NSString *type;

@end

@interface SongListContent : NSObject

@property(nonatomic,copy) NSString *Franking_value;
@property(nonatomic,copy) NSString *cur_count;
@property(nonatomic,strong) QQMusicModel *data;
@property(nonatomic,copy) NSString *in_count;
@property(nonatomic,copy) NSString *old_count;

@end

@interface RankDetailModel : NSObject

@property(nonatomic,strong) TopInfo *topinfo;
@property(nonatomic,strong) NSArray *songlist;

@end

NS_ASSUME_NONNULL_END

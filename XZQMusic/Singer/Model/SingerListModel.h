//
//  SingerListModel.h
//  XZQMusic
//
//  Created by qhzc-iMac-02 on 2020/5/7.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SingerListModel : NSObject

@property(nonatomic,copy) NSString *Farea;
@property(nonatomic,copy) NSString *Fattribute_3;
@property(nonatomic,copy) NSString *Fattribute_4;
@property(nonatomic,copy) NSString *Fgenre;
@property(nonatomic,copy) NSString *Findex;
@property(nonatomic,copy) NSString *Fother_name;
@property(nonatomic,copy) NSString *Fsinger_id;
@property(nonatomic,copy) NSString *Fsinger_mid;
@property(nonatomic,copy) NSString *Fsinger_name;
@property(nonatomic,copy) NSString *Fsinger_tag;
@property(nonatomic,assign) NSInteger Fsort;
@property(nonatomic,copy) NSString *Ftrend;
@property(nonatomic,copy) NSString *Ftype;
@property(nonatomic,copy) NSString *voc;

@end

NS_ASSUME_NONNULL_END

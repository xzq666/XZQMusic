//
//  QQMusicModel.h
//  
//
//  Created by qhzc-iMac-02 on 2020/4/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^CompleteBlock)(id obj, NSError *error);

@interface QQMusicModel : NSObject

@property(nonatomic,assign) NSInteger albumid;
@property(nonatomic,copy) NSString *albummid;
@property(nonatomic,copy) NSString *albumname;
@property(nonatomic,copy) NSString *albumname_hilight;
@property(nonatomic,assign) NSInteger songid;
@property(nonatomic,copy) NSString *songmid;
@property(nonatomic,copy) NSString *songname;
@property(nonatomic,copy) NSString *songname_hilight;
@property(nonatomic,strong) NSArray *singer;

@end

@interface Singer : NSObject

@property(nonatomic,assign) NSInteger singerId;
@property(nonatomic,copy) NSString *mid;
@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *name_hilight;

@end

NS_ASSUME_NONNULL_END

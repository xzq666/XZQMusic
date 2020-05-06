//
//  TopBannerModel.h
//  XZQMusic
//
//  Created by qhzc-iMac-02 on 2020/5/6.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TopBannerModel : NSObject

@property(nonatomic,assign) NSInteger bannerId;
@property(nonatomic,copy) NSString *linkUrl;
@property(nonatomic,copy) NSString *picUrl;

@end

NS_ASSUME_NONNULL_END

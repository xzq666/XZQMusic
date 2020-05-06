//
//  SwitchHeaderView.h
//  XZQMusic
//
//  Created by qhzc-iMac-02 on 2020/5/6.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SwitchBlock)(NSInteger selectIdx);

@interface SwitchHeaderView : UIView

@property(nonatomic,copy) SwitchBlock block;

- (instancetype)initWithFrame:(CGRect)frame
               withTitleArray:(NSArray *)titles
                withSelectIdx:(NSInteger)selectIdx
            withUnSelectColor:(UIColor *)unSelectColor
              withSelectColor:(UIColor *)selectColor;

@end

NS_ASSUME_NONNULL_END

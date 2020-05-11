//
//  HistorySearchCell.h
//  XZQMusic
//
//  Created by qhzc-iMac-02 on 2020/5/9.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HistorySearchCell;

@protocol HistorySearchDelegate <NSObject>

- (void)deleteHistorySearchKey:(HistorySearchCell *)cell;

@end

@interface HistorySearchCell : UITableViewCell

@property(nonatomic,strong) UILabel *searchKeyLabel;
@property(nonatomic,strong) UIButton *deleteBtn;

@property(nonatomic,weak) id<HistorySearchDelegate> delegate;

- (void)cellWithKeyword:(NSString *)keyword;

@end

NS_ASSUME_NONNULL_END

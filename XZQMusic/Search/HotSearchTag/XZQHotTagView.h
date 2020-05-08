//
//  XZQHotTagView.h
//  XZQMusic
//
//  Created by qhzc-iMac-02 on 2020/5/8.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XZQHotTag.h"

NS_ASSUME_NONNULL_BEGIN

@interface XZQHotTagView : UIView

@property (assign, nonatomic) UIEdgeInsets padding;
@property (assign, nonatomic) CGFloat lineSpacing;
@property (assign, nonatomic) CGFloat interitemSpacing;
@property (assign, nonatomic) CGFloat preferredMaxLayoutWidth;
// 固定宽度
@property (assign, nonatomic) CGFloat regularWidth;
// 固定高度
@property (nonatomic,assign ) CGFloat regularHeight;
@property (assign, nonatomic) BOOL singleLine;
@property (copy, nonatomic, nullable) void (^didTapTagAtIndex)(NSUInteger index);

- (void)addTag: (nonnull XZQHotTag *)tag;
- (void)insertTag: (nonnull XZQHotTag *)tag atIndex:(NSUInteger)index;
- (void)removeTag: (nonnull XZQHotTag *)tag;
- (void)removeTagAtIndex: (NSUInteger)index;
- (void)removeAllTags;

@end

NS_ASSUME_NONNULL_END

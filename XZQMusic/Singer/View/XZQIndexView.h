//
//  XZQIndexView.h
//  XZQMusic
//
//  Created by qhzc-iMac-02 on 2020/5/8.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/*
 代理方法
 */
@protocol XZQIndexViewDelegate <NSObject>

@required

/* 当前选中section的title与index */
- (void)selectedSectionIndexTitle:(NSString *_Nullable)title atIndex:(NSInteger)index;

/* 添加索引视图 */
- (void)addIndicatorView:(UIView *_Nullable)view;

@end

/*
 数据源方法
 */
@protocol XZQIndexViewDataSource <NSObject>

/* 标题数组 */
- (NSArray *)sectionIndexTitles;

@end

@interface XZQIndexView : UIControl <CAAnimationDelegate>

@property(nonatomic,weak,nullable) id<XZQIndexViewDelegate> delegate;
@property(nonatomic,weak,nullable) id<XZQIndexViewDataSource> dataSource;

// 字体大小
@property(nonatomic,assign) CGFloat titleFontSize;
// 字体颜色
@property(nonatomic,strong) UIColor *titleColor;
// 右边距
@property(nonatomic,assign) CGFloat marginRight;
// 文字间距
@property(nonatomic,assign) CGFloat titleSpace;
// 索引视图距离右侧的偏移量
@property(nonatomic,assign) CGFloat indicatorMarginRight;
// 设置 --> 声音与触感 --> 系统触感反馈打开 开启震动反馈 (iOS10及以上)
@property (nonatomic, assign) BOOL vibrationOn;
// 开启搜索功能
@property (nonatomic, assign) BOOL searchOn;

/* 设置当前选中组 */
- (void)setSelectionIndex:(NSInteger)index;

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section;
- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

- (void)reload;

@end

NS_ASSUME_NONNULL_END

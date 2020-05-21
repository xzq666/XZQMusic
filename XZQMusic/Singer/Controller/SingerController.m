//
//  SingerController.m
//  XZQMusic
//
//  Created by qhzc-iMac-02 on 2020/5/6.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "SingerController.h"
#import "SingerListModel.h"
#import "SingerListCell.h"
#import "XZQIndexView.h"
#import "SingerDetailController.h"

@interface CategorySingers : NSObject

@property(nonatomic,copy) NSString *titleTip;
@property(nonatomic,strong) NSMutableArray *singers;

@end

@implementation CategorySingers

@end

@interface SingerController ()<UITableViewDelegate, UITableViewDataSource, XZQIndexViewDelegate, XZQIndexViewDataSource>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) XZQIndexView *indexView;  // 索引条
@property (nonatomic, assign) BOOL isSearchMode;

@property(nonatomic,strong) NSArray *tips;
@property(nonatomic,strong) NSMutableArray *singerDataSource;

@end

@implementation SingerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CommonBgColor;
    
    self.isSearchMode = NO;
    self.singerDataSource = [[NSMutableArray alloc] init];
    self.tips = @[@"热门", @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z"];
    
    [self requestDataSource];
}

- (void)requestDataSource {
    [SVProgressHUD showWithStatus:@"加载中..."];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    NSDictionary *params = @{
        @"g_tk": GTK,
        @"inCharset": @"utf-8",
        @"outCharset": @"utf-8",
        @"notice": @0,
        @"format": @"jsonp",
        @"channel": @"singer",
        @"page": @"list",
        @"key": @"all_all_all",
        @"pagesize": @100,
        @"pagenum": @1,
        @"hostUin": @0,
        @"needNewCode": @1,
        @"jsonpCallback": @"callback"
    };
    [NetworkTool getUrl:SingerList withParams:params backInfoWhenErrorBlock:^(id  _Nonnull obj, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        if (obj && obj[@"data"] && obj[@"data"][@"list"] && [obj[@"data"][@"list"] isKindOfClass:[NSArray class]]) {
            NSArray *list = obj[@"data"][@"list"];
            [self dealData:list];
        }
        if (![self.view.subviews containsObject:self.tableView]) {
            [self.view addSubview:self.tableView];
            [self.view addSubview:self.indexView];
            if (self.singerDataSource.count > 0) {
                [self.indexView setSelectionIndex:0];
            }
        }
        [self.tableView reloadData];
    }];
}

// 初始化
- (void)initDataSource {
    [self.singerDataSource removeAllObjects];
    for (int i=0; i<self.tips.count; i++) {
        NSMutableArray *singers = [[NSMutableArray alloc] init];
        CategorySingers *model = [[CategorySingers alloc] init];
        model.titleTip = self.tips[i];
        model.singers = singers;
        [self.singerDataSource addObject:model];
    }
}

// 整理数据源
- (void)dealData:(NSArray *)list {
    // 先清空
    [self initDataSource];
    // 热门
    CategorySingers *categorySingers = self.singerDataSource[0];
    for (NSDictionary *dict in list) {
        SingerListModel *model = [SingerListModel mj_objectWithKeyValues:dict context:nil];
        if (model.Fsort <= 10) {
            [categorySingers.singers addObject:model];
        }
        if ([self.tips containsObject:model.Findex]) {
            NSUInteger index = [self.tips indexOfObject:model.Findex];
            CategorySingers *s = self.singerDataSource[index];
            [s.singers addObject:model];
        }
    }
    // 将没有数据的索引去除
    NSArray *arr = [self.singerDataSource mutableCopy];
    for (CategorySingers *c in arr) {
        if (c.singers.count == 0) {
            [self.singerDataSource removeObject:c];
        }
    }
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-SafeAreaBottomHeight-SafeAreaTopHeight-45) style:UITableViewStylePlain];
        _tableView.backgroundColor = ([ZXTheme defaultTheme].zx_isDarkTheme ? ZXThemeDarkLevel2Color : [UIColor whiteColor]);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 25)];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, -25, 0);
        _tableView.sectionIndexColor = [UIColor lightGrayColor];
    }
    return _tableView;
}

- (XZQIndexView *)indexView {
    if (!_indexView) {
        _indexView = [[XZQIndexView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-30, 0, 30, SCREEN_HEIGHT-45-SafeAreaTopHeight-SafeAreaBottomHeight)];
        _indexView.delegate = self;
        _indexView.dataSource = self;
    }
    return _indexView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.singerDataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    CategorySingers *singers = self.singerDataSource[section];
    return singers.singers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SingerListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[SingerListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    CategorySingers *category = self.singerDataSource[indexPath.section];
    SingerListModel *model = category.singers[indexPath.row];
    [cell cellWithModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"SingerHeaderView"];
    if (!headView) {
        headView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"SingerHeaderView"];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-30, 35)];
        titleLabel.tag = 30001;
        titleLabel.textColor = TitleUnSelectColor;
        titleLabel.font = [UIFont systemFontOfSize:14.5];
        [headView addSubview:titleLabel];
    }
    UILabel *titleLabel = [headView viewWithTag:30001];
    if (titleLabel) {
        CategorySingers *category = self.singerDataSource[section];
        titleLabel.text = category.titleTip;
    }
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 25.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UITableViewHeaderFooterView *footView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"SingerFooterView"];
    if (!footView) {
        footView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"SingerFooterView"];
        footView.backgroundView = ({
            UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 25)];
            view.backgroundColor = ([ZXTheme defaultTheme].zx_isDarkTheme ? ZXThemeDarkLevel2Color : [UIColor whiteColor]);
            view;
        });
    }
    return footView;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    [self.indexView tableView:tableView willDisplayHeaderView:view forSection:section];
}

- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section {
    [self.indexView tableView:tableView didEndDisplayingHeaderView:view forSection:section];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.indexView scrollViewDidScroll:scrollView];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SingerDetailController *vc = [[SingerDetailController alloc] init];
    CategorySingers *category = self.singerDataSource[indexPath.section];
    SingerListModel *model = category.singers[indexPath.row];
    vc.naviTitle = model.Fsinger_name;
    vc.singermid = model.Fsinger_mid;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - IndexView
- (NSArray *)sectionIndexTitles {
    NSMutableArray *resultArray = self.isSearchMode ? [NSMutableArray arrayWithObject:UITableViewIndexSearch] : [NSMutableArray array];
    for (CategorySingers *c in self.singerDataSource) {
        if ([c.titleTip isEqualToString:@"热门"]) {
            [resultArray addObject:@"热"];
        } else {
            [resultArray addObject:c.titleTip];
        }
    }
    return resultArray;
}

// 当前选中组
- (void)selectedSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    if (self.isSearchMode && (index == 0)) {
        // 搜索视图头视图(这里不能使用scrollToRowAtIndexPath，因为搜索组没有cell)
        [self.tableView setContentOffset:CGPointZero animated:NO];
        return;
    }
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

//将指示器视图添加到当前视图上
- (void)addIndicatorView:(UIView *)view {
    [self.view addSubview:view];
}

@end

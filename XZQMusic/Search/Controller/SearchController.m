//
//  SearchController.m
//  XZQMusic
//
//  Created by qhzc-iMac-02 on 2020/5/6.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "SearchController.h"
#import "HotSearchModel.h"
#import "XZQHotTagView.h"
#import "HistorySearchCell.h"
#import "SearchResultCell.h"
#import "QQMusicModel.h"

#define CommonColor ([ZXTheme defaultTheme].zx_isDarkTheme ? ZXThemeDarkLevel2Color : [UIColor whiteColor])

@interface SearchController ()<UITableViewDelegate, UITableViewDataSource, HistorySearchDelegate, UISearchBarDelegate>

@property(nonatomic,strong) UISearchBar *searchBar;
@property(nonatomic,strong) XZQHotTagView *tagView;

@property(nonatomic,strong) NSMutableArray *hotKeyDataSource;  // 热门搜索
@property(nonatomic,strong) NSMutableArray *historyKeyDataSource;  // 搜索历史
@property(nonatomic,strong) NSMutableArray *resultDataSource;  // 搜索结果

@property(nonatomic,strong) UITableView *tableView;  // 历史搜索列表与搜索结果列表共用一个列表

@property(nonatomic,assign) BOOL isSearch;  // 标记是否是搜索结果，默认不是

@end

@implementation SearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CommonColor;
    
    self.isSearch = NO;
    self.hotKeyDataSource = [NSMutableArray array];
    self.historyKeyDataSource = [NSMutableArray array];
    self.resultDataSource = [NSMutableArray array];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"XZQSearchHistory"]) {
        [self.historyKeyDataSource addObjectsFromArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"XZQSearchHistory"]];
    }
    
    [self setupUI];
    
    [self requestHotKey];
}

- (void)requestHotKey {
    NSDictionary *params = @{
        @"g_tk": GTK,
        @"inCharset": @"utf-8",
        @"outCharset": @"utf-8",
        @"notice": @0,
        @"format": @"jsonp",
        @"uin": @0,
        @"needNewCode": @1,
        @"jsonpCallback": @"callback"
    };
    [NetworkTool getUrl:HotKey withParams:params backInfoWhenErrorBlock:^(id  _Nonnull obj, NSError * _Nonnull error) {
        if (obj && obj[@"data"] && obj[@"data"][@"hotkey"] && [obj[@"data"][@"hotkey"] isKindOfClass:[NSArray class]]) {
            NSArray *hotkeys = obj[@"data"][@"hotkey"];
            [self.hotKeyDataSource removeAllObjects];
            for (NSDictionary *hotkey in hotkeys) {
                HotSearchModel *model = [HotSearchModel mj_objectWithKeyValues:hotkey context:nil];
                [self.hotKeyDataSource addObject:model];
                // 最多只要10个
                if (self.hotKeyDataSource.count == 10) {
                    break;
                }
            }
        }
        if (self.hotKeyDataSource.count > 0) {
            [self configTagView];
        }
        if (![self.view.subviews containsObject:self.tableView]) {
            [self.view addSubview:self.tableView];
        }
        [self.tableView reloadData];
    }];
}

- (void)setupUI {
    [self.view addSubview:self.searchBar];
}

// 配置
- (void)configTagView {
    [self.tagView removeAllTags];
    self.tagView = [[XZQHotTagView alloc] init];
    // 整个tagView对应其SuperView的上左下右距离
    self.tagView.padding = UIEdgeInsetsMake(10, 20, 10, 20);
    // 上下行之间的距离
    self.tagView.lineSpacing = 10;
    // item之间的距离
    self.tagView.interitemSpacing = 20;
    // 最大宽度
    self.tagView.preferredMaxLayoutWidth = SCREEN_WIDTH;
    // 开始加载
    [self.hotKeyDataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HotSearchModel *model = self.hotKeyDataSource[idx];
       // 初始化标签
        XZQHotTag *tag = [[XZQHotTag alloc] initWithText:model.k];
        // 标签相对于自己容器的上左下右的距离
        tag.padding = UIEdgeInsetsMake(4, 8, 4, 8);
        // 弧度
        tag.cornerRadius = 4.0f;
        // 字体
        tag.font = [UIFont systemFontOfSize:15.5];
        // 是否可点击
        tag.enable = YES;
        // 加入到tagView
        [self.tagView addTag:tag];
    }];
    // 点击事件回调
    WeakSelf(weakSelf);
    self.tagView.didTapTagAtIndex = ^(NSUInteger idx){
        HotSearchModel *model = weakSelf.hotKeyDataSource[idx];
        weakSelf.searchBar.text = model.k;
        [weakSelf searchSong:model.k];
    };
    // 获取刚才加入所有tag之后的内在高度
    CGFloat tagHeight = self.tagView.intrinsicContentSize.height;
    self.tagView.frame = CGRectMake(0, 40, SCREEN_WIDTH, tagHeight);
    [self.tagView layoutSubviews];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 70, SCREEN_WIDTH, SCREEN_HEIGHT-SafeAreaTopHeight-SafeAreaBottomHeight-70-44) style:UITableViewStyleGrouped];
        _tableView.alwaysBounceVertical = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(15, 15, SCREEN_WIDTH-30, 44)];
        _searchBar.backgroundImage = [UIImage imageFromColor:CommonColor withSize:_searchBar.frame.size];
        _searchBar.searchTextField.font = [UIFont systemFontOfSize:16.0];
        _searchBar.placeholder = @"搜索歌曲、歌手";
        _searchBar.delegate = self;
    }
    return _searchBar;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [self searchSong:searchBar.text];
}

// 搜索结果，同时记录搜索历史
- (void)searchSong:(NSString *)keyword {
    self.isSearch = YES;
    if ([self.historyKeyDataSource containsObject:keyword]) {
        [self.historyKeyDataSource removeObject:keyword];  // 若已经存在先移除
    }
    [self.historyKeyDataSource insertObject:keyword atIndex:0];
    [[NSUserDefaults standardUserDefaults] setObject:self.historyKeyDataSource forKey:@"XZQSearchHistory"];
    [self.tableView reloadData];
    // 获取搜索结果
    [self requestSearchResult:keyword];
}

- (void)requestSearchResult:(NSString *)keyword {
    [SVProgressHUD showWithStatus:@"加载中..."];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    NSDictionary *params = @{
        @"g_tk": GTK,
        @"inCharset": @"utf-8",
        @"outCharset": @"utf-8",
        @"notice": @0,
        @"format": @"json",
        @"w": keyword,
        @"p": @1,
        @"perpage": @20,
        @"n": @20,
        @"catZhida": @1,
        @"zhidaqu": @1,
        @"t": @0,
        @"flag": @1,
        @"ie": @"utf-8",
        @"sem": @1,
        @"aggr": @0,
        @"remoteplace": @"txt.mqq.all",
        @"uin": @0,
        @"needNewCode": @1
    };
    [NetworkTool getUrl:Search withParams:params backInfoWhenErrorBlock:^(id  _Nonnull obj, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        if (obj && obj[@"data"] && obj[@"data"][@"song"] && obj[@"data"][@"song"][@"list"] && [obj[@"data"][@"song"][@"list"] isKindOfClass:[NSArray class]]) {
            NSArray *list = obj[@"data"][@"song"][@"list"];
            [self.resultDataSource removeAllObjects];
            for (NSDictionary *dict in list) {
                QQMusicModel *model = [QQMusicModel mj_objectWithKeyValues:dict context:nil];
                [self.resultDataSource addObject:model];
            }
        }
        [self.tableView reloadData];
    }];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchBar.text.length == 0) {
        [self performSelector:@selector(hideKeybordWithSearchBar:) withObject:searchBar afterDelay:0];
    }
}

- (void)hideKeybordWithSearchBar:(UISearchBar *)searchBar {
    self.isSearch = NO;
    [searchBar resignFirstResponder];
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.isSearch ? 1 : 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.isSearch ? self.resultDataSource.count : (section == 1 ? self.historyKeyDataSource.count : 0);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.isSearch ? 40 : (indexPath.section == 1 ? 35 : 0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isSearch) {
        SearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchResultCell"];
        if (!cell) {
            cell = [[SearchResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SearchResultCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        QQMusicModel *model = self.resultDataSource[indexPath.row];
        [cell cellWithModel:model];
        return cell;
    }
    HistorySearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HistorySearchCell"];
    if (!cell) {
        cell = [[HistorySearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HistorySearchCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    [cell cellWithKeyword:self.historyKeyDataSource[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.isSearch) {
        // 播放音乐
    } else {
        NSString *result = self.historyKeyDataSource[indexPath.row];
        self.searchBar.text = result;
        [self searchSong:result];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.isSearch) {
        return 0.01;
    } else {
        if (section == 0 && self.tagView && self.hotKeyDataSource.count > 0) {
            return 40 + self.tagView.frame.size.height + 15;
        } else if (section == 1 && self.historyKeyDataSource.count > 0) {
            return 40;
        }
        return 0.01;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.isSearch) {
        UITableViewHeaderFooterView *headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ResultHeaderView"];
        if (!headView) {
            headView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"ResultHeaderView"];
            headView.backgroundView = ({
                UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
                view.backgroundColor = ([ZXTheme defaultTheme].zx_isDarkTheme ? ZXThemeDarkLevel2Color : [UIColor whiteColor]);
                view;
            });
        }
        return headView;
    }
    UITableViewHeaderFooterView *headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HistoryHeaderView"];
    CGFloat height = 0.f;
    if (section == 0 && self.tagView && self.hotKeyDataSource.count > 0) {
        height = 40 + self.tagView.frame.size.height + 15;
    } else if (section == 1 && self.historyKeyDataSource.count > 0) {
        height = 40;
    }
    if (!headView) {
        headView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"HistoryHeaderView"];
        headView.backgroundView = ({
            UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
            view.backgroundColor = ([ZXTheme defaultTheme].zx_isDarkTheme ? ZXThemeDarkLevel2Color : [UIColor whiteColor]);
            view;
        });
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH-95, 35)];
        titleLabel.tag = 30002;
        titleLabel.textColor = TitleUnSelectColor;
        titleLabel.font = [UIFont systemFontOfSize:16];
        [headView addSubview:titleLabel];
        
        UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        clearBtn.tag = 40000;
        clearBtn.frame = CGRectMake(SCREEN_WIDTH-55, 0, 35, 35);
        [clearBtn setImage:[UIImage imageNamed:@"clear"] forState:UIControlStateNormal];
        [clearBtn addTarget:self action:@selector(clearHistorySearch) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:clearBtn];
    }
    UILabel *titleLabel = [headView viewWithTag:30002];
    if (titleLabel) {
        titleLabel.text = section == 0 ? @"热门搜索" : @"搜索历史";
    }
    if (section == 0 && ![headView.subviews containsObject:self.tagView]) {
        [headView addSubview:self.tagView];
    }
    UIButton *clearBtn = [headView viewWithTag:40000];
    [titleLabel setHidden:((section == 0 && self.hotKeyDataSource > 0) || (section == 1 && self.historyKeyDataSource.count > 0)) ? NO : YES];
    [clearBtn setHidden:(section == 1 && self.historyKeyDataSource.count > 0) ? NO : YES];
    return headView;
}

// 清空搜索历史记录
- (void)clearHistorySearch {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定清空搜索历史记录？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self.historyKeyDataSource removeAllObjects];
        [[NSUserDefaults standardUserDefaults] setObject:self.historyKeyDataSource forKey:@"XZQSearchHistory"];
        [self.tableView reloadData];
    }];
    [alertController addAction:okAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma HistorySearchDelegate代理
// 删除历史记录
- (void)deleteHistorySearchKey:(nonnull HistorySearchCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSString *deleteSearch = self.historyKeyDataSource[indexPath.row];
    [self.historyKeyDataSource removeObject:deleteSearch];
    [[NSUserDefaults standardUserDefaults] setObject:self.historyKeyDataSource forKey:@"XZQSearchHistory"];
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UITableViewHeaderFooterView *footView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HistoryFooterView"];
    if (!footView) {
        footView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"HistoryFooterView"];
    }
    return footView;
}

@end

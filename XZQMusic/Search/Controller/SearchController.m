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

#define CommonColor ([ZXTheme defaultTheme].zx_isDarkTheme ? ZXThemeDarkLevel2Color : [UIColor whiteColor])

@interface SearchController ()

@property(nonatomic,strong) UISearchBar *searchBar;
@property(nonatomic,strong) XZQHotTagView *tagView;

@property(nonatomic,strong) NSMutableArray *hotKeyDataSource;

@end

@implementation SearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CommonColor;
    
    self.hotKeyDataSource = [NSMutableArray array];
    
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
    self.tagView.preferredMaxLayoutWidth = SCREEN_WIDTH-40;
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
        NSLog(@"点击了%@", model.k);
    };
    // 获取刚才加入所有tag之后的内在高度
    CGFloat tagHeight = self.tagView.intrinsicContentSize.height;
    self.tagView.frame = CGRectMake(0, 110, SCREEN_WIDTH, tagHeight);
    [self.tagView layoutSubviews];
    [self.view addSubview:self.tagView];

}

- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(15, 15, SCREEN_WIDTH-30, 44)];
        _searchBar.backgroundImage = [UIImage imageFromColor:CommonColor withSize:_searchBar.frame.size];
        _searchBar.searchTextField.font = [UIFont systemFontOfSize:16.0];
        _searchBar.placeholder = @"搜索歌曲、歌手";
    }
    return _searchBar;
}

@end

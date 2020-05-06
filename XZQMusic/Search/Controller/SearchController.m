//
//  SearchController.m
//  XZQMusic
//
//  Created by qhzc-iMac-02 on 2020/5/6.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "SearchController.h"

#define CommonColor ([ZXTheme defaultTheme].zx_isDarkTheme ? ZXThemeDarkLevel2Color : [UIColor whiteColor])

@interface SearchController ()

@property(nonatomic,strong) UISearchBar *searchBar;

@end

@implementation SearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CommonColor;
    [self setupUI];
}

- (void)setupUI {
    [self.view addSubview:self.searchBar];
}

- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(30, 15, SCREEN_WIDTH-60, 44)];
        _searchBar.backgroundImage = [UIColor imageFromColor:CommonColor withSize:_searchBar.frame.size];
        _searchBar.searchTextField.font = [UIFont systemFontOfSize:16.0];
        _searchBar.placeholder = @"搜索歌曲、歌手";
    }
    return _searchBar;
}

@end

//
//  RankController.m
//  XZQMusic
//
//  Created by qhzc-iMac-02 on 2020/5/6.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "RankController.h"
#import "RankListModel.h"
#import "RankListCell.h"

@interface RankController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;

@property(nonatomic,strong) NSMutableArray *rankDataSource;

@end

@implementation RankController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.rankDataSource = [NSMutableArray array];
    
    // 获取列表数据
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
        @"uin": @0,
        @"needNewCode": @1,
        @"jsonpCallback": @"callback"
    };
    [NetworkTool getUrl:TopList withParams:params backInfoWhenErrorBlock:^(id  _Nonnull obj, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        if (obj && obj[@"data"] && obj[@"data"][@"topList"] && [obj[@"data"][@"topList"] isKindOfClass:[NSArray class]]) {
            NSArray *topList = obj[@"data"][@"topList"];
            [self.rankDataSource removeAllObjects];
            for (NSDictionary *top in topList) {
                RankListModel *model = [RankListModel mj_objectWithKeyValues:top context:nil];
                [self.rankDataSource addObject:model];
            }
        }
        if (![self.view.subviews containsObject:self.tableView]) {
            [self.view addSubview:self.tableView];
        }
        [self.tableView reloadData];
    }];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-SafeAreaBottomHeight-SafeAreaTopHeight-45) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.rankDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RankListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RankListCell"];
    if (!cell) {
        cell = [[RankListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RankListCell"];
    }
    RankListModel *model = self.rankDataSource[indexPath.row];
    [cell cellWithModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 115;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 7.5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"RankHeaderView"];
    if (!headView) {
        headView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"RankHeaderView"];
    }
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 7.5;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UITableViewHeaderFooterView *footView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"RankFooterView"];
    if (!footView) {
        footView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"RankFooterView"];
    }
    return footView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

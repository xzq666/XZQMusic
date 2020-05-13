//
//  RecommendController.m
//  XZQMusic
//
//  Created by qhzc-iMac-02 on 2020/5/6.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "RecommendController.h"
#import "TopBannerModel.h"
#import "DiscListModel.h"
#import "RecommendHeaderView.h"
#import "RecommendListCell.h"
#import "WebController.h"

@interface RecommendController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;

@property(nonatomic,strong) NSMutableArray *bannerDataSource;  // Banner图数据
@property(nonatomic,strong) NSMutableArray *recommendDataSource;  // 推荐数据

@end

@implementation RecommendController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bannerDataSource = [[NSMutableArray alloc] init];
    self.recommendDataSource = [[NSMutableArray alloc] init];
    
    // 因为接口做了CSRF保护，因此需要先获取XSRF-TOKEN
    [NetworkTool getXSRFInfo:^(id  _Nonnull obj) {
        if (obj[@"XSRF-TOKEN"]) {
            [XZQSingleton sharedInstance].xsrfToken = obj[@"XSRF-TOKEN"];
        }
        if (obj[@"_csrf"]) {
            [XZQSingleton sharedInstance].csrf = obj[@"_csrf"];
        }
        [self requestDataSource];
    }];
}

- (void)requestDataSource {
    [SVProgressHUD showWithStatus:@"加载中..."];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    // 保证请求结束后再刷新列表
    dispatch_group_t group = dispatch_group_create();

    // 获取Top Banner
    dispatch_group_enter(group);
    NSDictionary *bannerParams = @{
        @"g_tk": GTK,
        @"inCharset": @"utf8",
        @"outCharset": @"utf-8",
        @"notice": @0,
        @"format": @"json",
        @"hostUin": @0,
        @"needNewCode": @0,
        @"-": @"recom7487255878826877",
        @"data": @{@"comm":@{@"ct":@24},@"category":@{@"method":@"get_hot_category",@"param":@{@"qq":@""},@"module":@"music.web_category_svr"},@"recomPlaylist":@{@"method":@"get_hot_recommend",@"param":@{@"async":@1,@"cmd":@2},@"module":@"playlist.HotRecommendServer"},@"playlist":@{@"method":@"get_playlist_by_category",@"param":@{@"id":@8,@"curPage":@1,@"size":@40,@"order":@5,@"titleid":@8},@"module":@"playlist.PlayListPlazaServer"},@"new_song":@{@"module":@"newsong.NewSongServer",@"method":@"get_new_song_info",@"param":@{@"type":@5}},@"new_album":@{@"module":@"newalbum.NewAlbumServer",@"method":@"get_new_album_info",@"param":@{@"area":@1,@"sin":@0,@"num":@10}},@"new_album_tag":@{@"module":@"newalbum.NewAlbumServer",@"method":@"get_new_album_area",@"param":@{}},@"toplist":@{@"module":@"musicToplist.ToplistInfoServer",@"method":@"GetAll",@"param":@{}},@"focus":@{@"module":@"QQMusic.MusichallServer",@"method":@"GetFocus",@"param":@{}}}
    };
    [NetworkTool getUrl:GetTopBanner withParams:bannerParams backInfoWhenErrorBlock:^(id  _Nonnull obj, NSError * _Nonnull error) {
        if (obj && obj[@"data"] && obj[@"data"][@"slider"] && [obj[@"data"][@"slider"] isKindOfClass:[NSArray class]]) {
            NSArray *sliders = obj[@"data"][@"slider"];
            [self.bannerDataSource removeAllObjects];
            for (NSDictionary *slider in sliders) {
                TopBannerModel *model = [TopBannerModel mj_objectWithKeyValues:slider context:nil];
                [self.bannerDataSource addObject:model];
            }
        }
        dispatch_group_leave(group);
    }];

    // 获取热门歌单推荐
    dispatch_group_enter(group);
    NSDictionary *params = @{
        @"g_tk": GTK,
        @"inCharset": @"utf8",
        @"outCharset": @"utf-8",
        @"notice": @0,
        @"format": @"json",
        @"hostUin": @0,
        @"sin": @0,
        @"ein": @29,
        @"sortId": @5,
        @"needNewCode": @0,
        @"categoryId": @"10000000",
        @"rnd": @"0.013530590371761408"
    };
    [NetworkTool getUrl:GetDiscList withParams:params backInfoWhenErrorBlock:^(id  _Nonnull obj, NSError * _Nonnull error) {
        if (obj && obj[@"data"] && obj[@"data"][@"list"] && [obj[@"data"][@"list"] isKindOfClass:[NSArray class]]) {
            NSArray *arr = obj[@"data"][@"list"];
            [self.recommendDataSource removeAllObjects];
            for (NSDictionary *dict in arr) {
                DiscListModel *model = [DiscListModel mj_objectWithKeyValues:dict context:nil];
                [self.recommendDataSource addObject:model];
            }
        }
        dispatch_group_leave(group);
    }];

    // 刷新列表
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        if (![self.view.subviews containsObject:self.tableView]) {
            [self.view addSubview:self.tableView];
        }
        [self.tableView reloadData];
    });
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
    return self.recommendDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RecommendListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecommendListCell"];
    if (!cell) {
        cell = [[RecommendListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RecommendListCell"];
    }
    DiscListModel *model = self.recommendDataSource[indexPath.row];
    [cell cellWithModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return SCREEN_WIDTH * 432 / 1080 + 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"RecommendHeaderView"];
    if (!headView) {
        headView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"RecommendHeaderView"];
        NSMutableArray *imageUrls = [NSMutableArray array];
        for (TopBannerModel *model in self.bannerDataSource) {
            [imageUrls addObject:model.picUrl];
        }
        RecommendHeaderView *recommendHeaderView = [[RecommendHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 432 / 1080 + 50) images:imageUrls];
        recommendHeaderView.tag = 30000;
        [headView addSubview:recommendHeaderView];
    }
    // UI复用但需要更新轮播图
    RecommendHeaderView *recommendHeaderView = [headView viewWithTag:30000];
    if (recommendHeaderView) {
        NSMutableArray *imageUrls = [NSMutableArray array];
        for (TopBannerModel *model in self.bannerDataSource) {
            [imageUrls addObject:model.picUrl];
        }
        recommendHeaderView.cycleScrollView.imageURLStringsGroup = imageUrls;
    }
    recommendHeaderView.block = ^(NSInteger index) {
        [self gotoWebController:index];
    };
    return headView;
}

- (void)gotoWebController:(NSInteger)index {
    WebController *vc = [[WebController alloc] init];
    TopBannerModel *model = self.bannerDataSource[index];
    NSLog(@"url-->%@", model.linkUrl);
    vc.url = model.linkUrl;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UITableViewHeaderFooterView *headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"RecommendFooterView"];
    if (!headView) {
        headView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"RecommendFooterView"];
    }
    return headView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

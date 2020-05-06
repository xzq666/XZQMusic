//
//  RecommendController.m
//  XZQMusic
//
//  Created by qhzc-iMac-02 on 2020/5/6.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "RecommendController.h"
#import "DiscListModel.h"

@interface RecommendController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;

@end

@implementation RecommendController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
}

// 获取Top Banner
- (void)requestTopBanner {
    NSDictionary *params = @{
        @"g_tk": GTK,
        @"inCharset": @"utf8",
        @"outCharset": @"utf-8",
        @"notice": @0,
        @"format": @"json",
        @"hostUin": @0,
        @"needNewCode": @0,
        @"-": @"recom4782007425237845",
        @"data": @{@"comm":@{@"ct":@24},@"category":@{@"method":@"get_hot_category",@"param":@{@"qq":@""},@"module":@"music.web_category_svr"},@"recomPlaylist":@{@"method":@"get_hot_recommend",@"param":@{@"async":@1,@"cmd":@2},@"module":@"playlist.HotRecommendServer"},@"playlist":@{@"method":@"get_playlist_by_category",@"param":@{@"id":@8,@"curPage":@1,@"size":@40,@"order":@5,@"titleid":@8},@"module":@"playlist.PlayListPlazaServer"},@"new_song":@{@"module":@"newsong.NewSongServer",@"method":@"get_new_song_info",@"param":@{@"type":@5}},@"new_album":@{@"module":@"newalbum.NewAlbumServer",@"method":@"get_new_album_info",@"param":@{@"area":@1,@"sin":@0,@"num":@10}},@"new_album_tag":@{@"module":@"newalbum.NewAlbumServer",@"method":@"get_new_album_area",@"param":@{}},@"toplist":@{@"module":@"musicToplist.ToplistInfoServer",@"method":@"GetAll",@"param":@{}},@"focus":@{@"module":@"QQMusic.MusichallServer",@"method":@"GetFocus",@"param":@{}}}
    };
    [NetworkTool getUrl:GetTopBanner withParams:params backInfoWhenErrorBlock:^(id  _Nonnull obj, NSError * _Nonnull error) {
        
    }];
}

// 获取热门歌单推荐
- (void)requestDiscList {
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
        NSArray *arr = obj[@"data"][@"list"];
        for (NSDictionary *dict in arr) {
            DiscListModel *model = [DiscListModel mj_objectWithKeyValues:dict context:nil];
            NSLog(@"name-->%@", model.creator.name);
        }
    }];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-SafeAreaBottomHeight-SafeAreaTopHeight-45) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"推荐 ---- %zd", indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

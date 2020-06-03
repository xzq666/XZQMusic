//
//  SingerDetailController.m
//  XZQMusic
//
//  Created by qhzc-iMac-02 on 2020/5/20.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "SingerDetailController.h"
#import "SingerDetailModel.h"
#import "RecommendDetailCell.h"

@interface SingerDetailController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic,strong) UILabel *titleLabel;

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) UIView *headerView;

// 头部视图
@property(nonatomic,strong) UIImageView *headerImage;

@property(nonatomic,strong) NSMutableArray *dataSource;

@property(nonatomic,strong) NSMutableArray *songmids;
@property(nonatomic,strong) NSMutableArray *songtypes;

@end

@implementation SingerDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CommonBgColor;
    [self setupNavigationBar];
    
    self.dataSource = [NSMutableArray array];
    self.songmids = [NSMutableArray array];
    self.songtypes = [NSMutableArray array];
    [self requestRecommodDetail];
}

- (void)initUI {
    if (![self.view.subviews containsObject:self.tableView]) {
        [self.view addSubview:self.headerImage];
        [self.view addSubview:self.tableView];
        self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*0.7+10)];
        CALayer *layer = [[CALayer alloc] init];
        layer.frame = CGRectMake(0, SCREEN_WIDTH*0.7, SCREEN_WIDTH, 10);
        layer.backgroundColor = CommonBgColor.CGColor;
        [self.headerView.layer addSublayer:layer];
        UIButton *playBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-150)/2, SCREEN_WIDTH*0.7-70, 150, 40)];
        playBtn.tag = 40001;
        playBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
        playBtn.layer.borderColor = TitleSelectColor.CGColor;
        playBtn.layer.borderWidth = 1.0;
        playBtn.layer.cornerRadius = 20;
        [playBtn setTitle:@"随机播放全部" forState:UIControlStateNormal];
        [playBtn setTitleColor:TitleSelectColor forState:UIControlStateNormal];
        [playBtn addTarget:self action:@selector(playAll) forControlEvents:UIControlEventTouchUpInside];
        [self.headerView addSubview:playBtn];
        self.tableView.tableHeaderView = self.headerView;
    }
    [self.headerImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@.jpg", SingerAvatarUrl, self.singermid]] placeholderImage:[UIImage imageNamed:@"placeholder"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        self.headerImage.image = [CommonUtils image:image setAlpha:0.5];
    }];
    [self.tableView reloadData];
}

// 随机播放全部
- (void)playAll {
    NSLog(@"随机播放");
}

- (void)requestRecommodDetail {
    [SVProgressHUD showWithStatus:@"加载中..."];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    NSDictionary *params = @{
        @"g_tk": GTK,
        @"inCharset": @"utf-8",
        @"outCharset": @"utf-8",
        @"notice": @0,
        @"format": @"jsonp",
        @"order": @"listen",
        @"type": @1,
        @"json": @1,
        @"utf8": @1,
        @"onlysong": @0,
        @"hostUin": @0,
        @"needNewCode": @0,
        @"begin": @0,
        @"num": @80,
        @"songstatus": @1,
        @"singermid": self.singermid,
        @"jsonpCallback": @"callback"
    };
    [NetworkTool getUrl:SingerDetail withParams:params backInfoWhenErrorBlock:^(id  _Nonnull obj, NSError * _Nonnull error) {
        if (obj && obj[@"data"] && obj[@"data"][@"list"] && [obj[@"data"][@"list"] isKindOfClass:[NSArray class]]) {
            [self.dataSource removeAllObjects];
            [self.songmids removeAllObjects];
            [self.songtypes removeAllObjects];
            for (NSDictionary *dict in obj[@"data"][@"list"]) {
                SingerDetailModel *model = [SingerDetailModel mj_objectWithKeyValues:dict context:nil];
                [self.dataSource addObject:model];
                [self.songmids addObject:model.musicData.songmid];
                [self.songtypes addObject:@0];
            }
            if (self.songmids.count > 0) {
                [self requestSongsInfo];
            }
            [self initUI];
        }
    }];
}

- (void)requestSongsInfo {
    NSDictionary *params = @{
        @"comm":@{
            @"g_tk":@5381,
            @"inCharset":@"utf-8",
            @"outCharset":@"utf-8",
            @"notice":@0,
            @"format":@"json",
            @"platform":@"ios",
            @"needNewCode":@1,
            @"uin":@0
        },
        @"req_0":@{
            @"module":@"vkey.GetVkeyServer",
            @"method":@"CgiGetVkey",
            @"param":@{
                @"guid":@"2663275568",
                @"songmid":self.songmids,
                @"songtype":self.songtypes,
                @"uin":@"0",
                @"loginflag":@0,
                @"platform":@"23"
            }
        }
    };
    [NetworkTool postUrl:GetPurlUrl withParams:params backInfoWhenErrorBlock:^(id  _Nonnull obj, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        if (obj && obj[@"req_0"] && obj[@"req_0"][@"data"] && obj[@"req_0"][@"data"][@"midurlinfo"] && [obj[@"req_0"][@"data"][@"midurlinfo"] isKindOfClass:[NSArray class]]) {
            NSArray *midurlinfo = obj[@"req_0"][@"data"][@"midurlinfo"];
            for (int i=0; i<midurlinfo.count; i++) {
                NSDictionary *dict = midurlinfo[i];
                SingerDetailModel *model = self.dataSource[i];
                if ([dict[@"songmid"] isEqualToString:model.musicData.songmid]) {
                    model.musicData.purl = dict[@"purl"];
                    [self.dataSource replaceObjectAtIndex:i withObject:model];
                }
            }
        }
    }];
}

- (void)setupNavigationBar {
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.text = self.naviTitle;
    self.navigationItem.titleView = self.titleLabel;
}

- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-SafeAreaBottomHeight) style:UITableViewStylePlain];
        if ([XZQSingleton sharedInstance].isPlayMusic) {
            tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-SafeAreaBottomHeight-75);
        } else {
            tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-SafeAreaBottomHeight);
        }
        tableView.backgroundColor = [UIColor hexStringToColor:@"#000000" andAlpha:0.0];
        tableView.delegate = self;
        tableView.dataSource = self;
        _tableView = tableView;
    }
    return _tableView;
}

- (UIImageView *)headerImage {
    if (!_headerImage) {
        UIImageView *headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, SCREEN_WIDTH, SCREEN_WIDTH)];
        _headerImage = headerImage;
    }
    return _headerImage;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RecommendDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecommendDetailCell"];
    if (!cell) {
        cell = [[RecommendDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RecommendDetailCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    SingerDetailModel *singerDetail = self.dataSource[indexPath.row];
    QQMusicModel *model = singerDetail.musicData;
    [cell cellWithModel:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SingerDetailModel *model = self.dataSource[indexPath.row];
    NSLog(@"url-->%@", model.musicData.purl);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat yOffset = scrollView.contentOffset.y + SafeAreaTopHeight;  // 偏移的y值
    if (yOffset < 0) {
        CGFloat totalOffset = SCREEN_WIDTH + ABS(yOffset);
        CGFloat f = totalOffset / (SCREEN_WIDTH);
        // 拉伸后的图片的frame应该是同比例缩放
        self.headerImage.frame = CGRectMake(- (SCREEN_WIDTH * f - SCREEN_WIDTH) / 2, SafeAreaTopHeight, SCREEN_WIDTH * f, totalOffset);
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([XZQSingleton sharedInstance].isPlayMusic && [self.view.subviews containsObject:self.tableView] && self.tableView.frame.size.height == SCREEN_HEIGHT-SafeAreaBottomHeight) {
        self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-SafeAreaBottomHeight-75);
    } else if (![XZQSingleton sharedInstance].isPlayMusic && [self.view.subviews containsObject:self.tableView] && self.tableView.frame.size.height == SCREEN_HEIGHT-SafeAreaBottomHeight-75) {
        self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-SafeAreaBottomHeight);
    }
}

@end

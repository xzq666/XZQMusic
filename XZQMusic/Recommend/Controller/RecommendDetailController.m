//
//  RecommendDetailController.m
//  XZQMusic
//
//  Created by qhzc-iMac-02 on 2020/5/14.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "RecommendDetailController.h"
#import "RecommandDetailModel.h"
#import "RecommendDetailCell.h"

@interface RecommendDetailController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic,strong) UILabel *titleLabel;

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) UIView *headerView;

// 头部视图
@property(nonatomic,strong) UIImageView *headerImage;

@property(nonatomic,strong) RecommandDetailModel *model;

@end

@implementation RecommendDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CommonBgColor;
    [self setupNavigationBar];
    
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
    [self.headerImage sd_setImageWithURL:[NSURL URLWithString:self.model.logo] placeholderImage:[UIImage imageNamed:@"placeholder"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
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
        @"disstid": self.disstid,
        @"type": @1,
        @"json": @1,
        @"utf8": @1,
        @"onlysong": @0,
        @"hostUin": @0,
        @"needNewCode": @0
    };
    [NetworkTool getUrl:GetCdInfo withParams:params backInfoWhenErrorBlock:^(id  _Nonnull obj, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        if (obj && obj[@"cdlist"] && [obj[@"cdlist"] isKindOfClass:[NSArray class]]) {
            NSDictionary *dict = obj[@"cdlist"][0];
            self.model = [RecommandDetailModel mj_objectWithKeyValues:dict context:nil];
            [self initUI];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.model ? self.model.songlist.count : 0;
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
    QQMusicModel *song = self.model.songlist[indexPath.row];
    [cell cellWithModel:song];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    QQMusicModel *song = self.model.songlist[indexPath.row];
    [[XZQMusicPlayer sharedInstance] xzq_initPlayerWithUserId:nil];
    [XZQMusicPlayer sharedInstance].currentAudioModel = song;
    NSString *singerInfo = @"";
    for (Singer *singer in song.singer) {
        singerInfo = singerInfo.length > 0 ? [NSString stringWithFormat:@"%@/%@", singerInfo, singer.name] : singer.name;
    }
    singerInfo = song.albumname.length > 0 ? [NSString stringWithFormat:@"%@·%@", singerInfo, song.albumname] : singerInfo;
    NSDictionary *dict = @{
        @"coverUrl": [NSString stringWithFormat:@"%@%@.jpg", AlbumCoverUrl, song.albummid],
        @"songName": song.songname,
        @"singerName": singerInfo
    };
    [[NSNotificationCenter defaultCenter] postNotificationName:@"playMusic" object:dict];
    if (self.tableView.frame.size.height == SCREEN_HEIGHT-SafeAreaBottomHeight) {
        self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-SafeAreaBottomHeight-75);
    }
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

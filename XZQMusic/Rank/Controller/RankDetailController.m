//
//  RankDetailController.m
//  XZQMusic
//
//  Created by qhzc-iMac-02 on 2020/5/20.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "RankDetailController.h"
#import "RankDetailModel.h"
#import "RankDetailCell.h"

@interface RankDetailController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic,strong) UILabel *titleLabel;

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) UIView *headerView;

// 头部视图
@property(nonatomic,strong) UIImageView *headerImage;

@property(nonatomic,strong) NSArray *rankImages;
@property(nonatomic,strong) RankDetailModel *model;

@end

@implementation RankDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CommonBgColor;
    [self setupNavigationBar];
    
    self.rankImages = @[@"No1", @"No2", @"No3"];
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
    if (self.model.songlist.count > 0) {
        SongListContent *content = self.model.songlist[0];
        QQMusicModel *music = content.data;
        [self.headerImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@.jpg", AlbumCoverUrl, music.albummid]] placeholderImage:[UIImage imageNamed:@"placeholder"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            self.headerImage.image = [CommonUtils image:image setAlpha:0.5];
        }];
    }
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
        @"topid": @(self.topId),
        @"type": @"top",
        @"json": @1,
        @"utf8": @1,
        @"page": @"detail",
        @"uin": @0,
        @"tpl": @3,
        @"jsonpCallback": @"callback"
    };
    [NetworkTool getUrl:TopListDetail withParams:params backInfoWhenErrorBlock:^(id  _Nonnull obj, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        if (obj && obj[@"songlist"] && obj[@"topinfo"]) {
            NSDictionary *dict = obj;
            self.model = [RankDetailModel mj_objectWithKeyValues:dict context:nil];
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
    RankDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RankDetailCell"];
    if (!cell) {
        cell = [[RankDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RankDetailCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    SongListContent *content = self.model.songlist[indexPath.row];
    indexPath.row < 3 ? [cell cellWithModel:content.data rankNum:indexPath.row+1 showImage:self.rankImages[indexPath.row]] : [cell cellWithModel:content.data rankNum:indexPath.row+1 showImage:@""];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

@end

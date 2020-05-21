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

@end

@implementation SingerDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CommonBgColor;
    [self setupNavigationBar];
    
    self.dataSource = [NSMutableArray array];
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
        [SVProgressHUD dismiss];
        if (obj && obj[@"data"] && obj[@"data"][@"list"] && [obj[@"data"][@"list"] isKindOfClass:[NSArray class]]) {
            [self.dataSource removeAllObjects];
            for (NSDictionary *dict in obj[@"data"][@"list"]) {
                SingerDetailModel *model = [SingerDetailModel mj_objectWithKeyValues:dict context:nil];
                [self.dataSource addObject:model];
            }
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
    cell.songNameLabel.text = model.songname;
    NSString *singerInfo = @"";
    for (Singer *singer in model.singer) {
        singerInfo = singerInfo.length > 0 ? [NSString stringWithFormat:@"%@/%@", singerInfo, singer.name] : singer.name;
    }
    singerInfo = model.albumname.length > 0 ? [NSString stringWithFormat:@"%@·%@", singerInfo, model.albumname] : singerInfo;
    cell.describeLabel.text = singerInfo;    return cell;
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

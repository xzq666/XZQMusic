//
//  MineController.m
//  XZQMusic
//
//  Created by qhzc-iMac-02 on 2020/5/21.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "MineController.h"
#import "RecommendDetailCell.h"
#import "XZQCircleProgressView.h"

@interface MineController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;

@property(nonatomic,assign) int type;  // 0我喜欢的 1最近听的
@property(nonatomic,strong) NSMutableArray *likeMusicDataSource;
@property(nonatomic,strong) NSMutableArray *recentlyDataSource;

@end

@implementation MineController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CommonBgColor;
    
    self.type = 0;
    self.likeMusicDataSource = [NSMutableArray array];
    self.recentlyDataSource = [NSMutableArray array];
    
    [self setupNavigationBar];
    
    [self setupUI];
}

- (void)setupUI {
    UIButton *playBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-150)/2, SafeAreaTopHeight + 20, 150, 34)];
    playBtn.tag = 40001;
    playBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    playBtn.layer.borderColor = CommonLabelColor.CGColor;
    playBtn.layer.borderWidth = 1.0;
    playBtn.layer.cornerRadius = 17;
    [playBtn setTitle:@"随机播放全部" forState:UIControlStateNormal];
    [playBtn setTitleColor:CommonLabelColor forState:UIControlStateNormal];
    [playBtn addTarget:self action:@selector(playAll) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playBtn];
    
//    [self.view addSubview:self.tableView];
//    [self.tableView reloadData];
    XZQCircleProgressView *circle = [[XZQCircleProgressView alloc] initWithFrame:CGRectMake(100, SafeAreaTopHeight + 100, 100, 100) lineWidth:2.0];
    [circle updateProgressWithNumber:0.5];
    [self.view addSubview:circle];
    
    UIImageView *playImage = [[UIImageView alloc] initWithFrame:CGRectMake(102, SafeAreaTopHeight+102, 96, 96)];
    playImage.image = [[UIImage imageNamed:@"placeholder"] drawRectWithRoundedCorner];
    [self.view addSubview:playImage];
}

- (void)playAll {
    NSLog(@"随机播放");
}

- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight+60, SCREEN_WIDTH, SCREEN_HEIGHT-SafeAreaTopHeight-SafeAreaBottomHeight-60) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = CommonBgColor;
        tableView.isAutoControlErrorView = YES;
        _tableView = tableView;
    }
    return _tableView;
}

- (void)setupNavigationBar {
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"我喜欢的", @"最近听的"]];
    segmentedControl.frame = CGRectMake((SCREEN_WIDTH-200)/2, 7, 200, 30);
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.tintColor = TitleSelectColor;
    [segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:14.0f]} forState:UIControlStateSelected];
    [segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:TitleUnSelectColor, NSFontAttributeName:[UIFont boldSystemFontOfSize:14.0f]} forState:UIControlStateNormal];
    [segmentedControl addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segmentedControl;
}

- (void)segmentValueChanged:(UISegmentedControl *)seg {
    self.type = (int)seg.selectedSegmentIndex;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.type == 0 ? self.likeMusicDataSource.count : self.recentlyDataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RecommendDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecommendDetailCell"];
    if (!cell) {
        cell = [[RecommendDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RecommendDetailCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.songNameLabel.text = @"歌曲名";
    cell.describeLabel.text = @"详细介绍啦啦啦";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

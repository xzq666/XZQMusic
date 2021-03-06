//
//  ViewController.m
//  XZQMusic
//
//  Created by qhzc-iMac-02 on 2020/5/6.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "ViewController.h"
#import "SwitchHeaderView.h"
#import "RecommendController.h"
#import "SingerController.h"
#import "RankController.h"
#import "SearchController.h"
#import "MineController.h"
#import "MusicPlayController.h"

@interface ViewController ()

@property(nonatomic,strong) SwitchHeaderView *switchHeaderView;

@property(nonatomic,strong) RecommendController *recommendController;  // 推荐
@property(nonatomic,strong) SingerController *singerController;        // 歌手
@property(nonatomic,strong) RankController *rankController;            // 排行
@property(nonatomic,strong) SearchController *searchController;        // 搜索

@property (nonatomic, strong) UIViewController *currentController;  // 当前显示的控制器
@property(nonatomic,strong) UIView *contentView;  // 承载控制器的容器

@property(nonatomic,strong) XZQBottomPlayView *bottomView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 标题栏
    [self setupNavigationBar];
    // 顶部页签视图与控制器承载视图
    [self setupUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playMusic:) name:@"playMusic" object:nil];
}

- (void)setupNavigationBar {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"XZQ音乐";
    self.navigationItem.titleView = titleLabel;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"mine"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(junpToMine)];
}

- (void)junpToMine {
    MineController *vc = [[MineController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setupUI {
    NSArray *titleArray = @[@"推荐", @"歌手", @"排行", @"搜索"];
    self.switchHeaderView = [[SwitchHeaderView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, SCREEN_WIDTH, 45) withTitleArray:titleArray withSelectIdx:0 withUnSelectColor:TitleUnSelectColor withSelectColor:TitleSelectColor];
    WeakSelf(weakSelf);
    self.switchHeaderView.block = ^(NSInteger selectIdx) {
        [weakSelf headerViewClick:selectIdx];
    };
    [self.view addSubview:self.switchHeaderView];
    
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, BOTTOM_Y(self.switchHeaderView), SCREEN_WIDTH,  SCREEN_HEIGHT-SafeAreaBottomHeight-BOTTOM_Y(self.switchHeaderView))];
    self.contentView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.contentView];
    
    // 添加控制器
    [self addControllers];
}

- (void)headerViewClick:(NSInteger)idx {
    // 如果选中的是当前选中的控制器，不做任何处理
    if ((idx == 0 && self.currentController == self.recommendController) ||
        (idx == 1 && self.currentController == self.singerController) ||
        (idx == 2 && self.currentController == self.rankController) ||
        (idx == 3 && self.currentController == self.searchController)) {
        return;
    }
    switch (idx) {
        case 0: {
            [self fitFrameForChildViewController:self.recommendController];
            [self transitionFromOldViewController:self.currentController toNewViewController:self.recommendController];
            break;
        }

        case 1: {
            [self fitFrameForChildViewController:self.singerController];
            [self transitionFromOldViewController:self.currentController toNewViewController:self.singerController];
            break;
        }
            
        case 2: {
            [self fitFrameForChildViewController:self.rankController];
            [self transitionFromOldViewController:self.currentController toNewViewController:self.rankController];
            break;
        }
            
        case 3: {
            [self fitFrameForChildViewController:self.searchController];
            [self transitionFromOldViewController:self.currentController toNewViewController:self.searchController];
            break;
        }
            
        default:
            break;
    }
}

//转换子视图控制器
- (void)transitionFromOldViewController:(UIViewController *)oldViewController toNewViewController:(UIViewController *)newViewController{
    [self transitionFromViewController:oldViewController toViewController:newViewController duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished) {
        if (finished) {
            [newViewController didMoveToParentViewController:self];
            self.currentController = newViewController;
        } else {
            self.currentController = oldViewController;
        }
    }];
}

- (void)addControllers {
    self.recommendController = [[RecommendController alloc] init];
    [self addChildViewController:self.recommendController];
    
    self.singerController = [[SingerController alloc] init];
    [self addChildViewController:self.singerController];
    
    self.rankController = [[RankController alloc] init];
    [self addChildViewController:self.rankController];
    
    self.searchController = [[SearchController alloc] init];
    [self addChildViewController:self.searchController];
    
    // 调整子视图控制器的frame适应容器View
    [self fitFrameForChildViewController:self.recommendController];
    // 默认显示在容器View的控制器内容
    [self.contentView addSubview:self.recommendController.view];
    self.currentController = self.recommendController;
}

- (void)fitFrameForChildViewController:(UIViewController *)chileViewController {
    CGRect frame = self.contentView.frame;
    frame.origin.y = 0;
    chileViewController.view.frame = frame;
}

// 移除所有子视图控制器（不需要时移除）
- (void)removeAllChildViewControllers{
    for (UIViewController *vc in self.childViewControllers) {
        [vc willMoveToParentViewController:nil];
        [vc removeFromParentViewController];
    }
}

- (void)playMusic:(NSNotification *)notification {
    [self getLyric];
    NSDictionary *infoDic = [notification object];
    if (infoDic[@"coverUrl"] && infoDic[@"songName"] && infoDic[@"singerName"]) {
        if ([XZQSingleton sharedInstance].isPlayMusic) {
            [self.bottomView playWithCoverUrl:infoDic[@"coverUrl"] songName:infoDic[@"songName"] singerName:infoDic[@"singerName"]];
        } else {
            self.bottomView = [[XZQBottomPlayView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-SafeAreaBottomHeight-75, SCREEN_WIDTH, 75) coverUrl:infoDic[@"coverUrl"] songName:infoDic[@"songName"] singerName:infoDic[@"singerName"]];
            UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
            [window addSubview:self.bottomView];
            [XZQSingleton sharedInstance].isPlayMusic = YES;
        }
    }
    [self.bottomView setHidden:YES];
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    MusicPlayController *vc = [[MusicPlayController alloc] init];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    vc.backBlock = ^{
        [self.bottomView setHidden:NO];
    };
    [window.rootViewController presentViewController:vc animated:YES completion:^{
        [[XZQMusicPlayer sharedInstance] xzq_playerPlayWithAudioId:0];
    }];
}

- (void)getLyric {
    NSDictionary *params = @{
        @"g_tk": GTK,
        @"inCharset": @"utf-8",
        @"outCharset": @"utf-8",
        @"notice": @0,
        @"format": @"json",
        @"songmid": @"001PLl3C4gPSCI",
        @"hostUin": @0,
        @"needNewCode": @0,
        @"categoryId": @"10000000",
        @"pcachetime": @"1591067809246"
    };
    [NetworkTool getUrl:Lyric withParams:params backInfoWhenErrorBlock:^(id  _Nonnull obj, NSError * _Nonnull error) {
        if (obj && obj[@"retcode"] && [obj[@"retcode"] integerValue]==0 && obj[@"lyric"]) {
            NSString *lyric = [CommonUtils base64Decode:obj[@"lyric"]];
            NSLog(@"lyric-->\n%@", lyric);
            XZQLyricsAnalysis *model = [[XZQLyricsAnalysis alloc] init];
            [model lyricsAnalysisWithString:lyric];
            NSLog(@"ar = %@", model.ar);
            NSLog(@"ti = %@", model.ti);
            NSLog(@"by = %@", model.by);
            NSLog(@"al = %@", model.al);
            NSLog(@"t_time = %@", model.t_time);
            NSLog(@"lrcArrayStr = %@", model.lrcArrayStr);
            NSLog(@"lrcArrayTime = %@", model.lrcArrayTime);
        }
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"playMusic" object:nil];
}

@end

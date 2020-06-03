//
//  MusicPlayController.m
//  XZQMusic
//
//  Created by qhzc-iMac-02 on 2020/6/2.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "MusicPlayController.h"

@interface MusicPlayController ()

@end

@implementation MusicPlayController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CommonBgColor;
    [self setupTitle];
}

- (void)setupTitle {
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(20, SafeAreaNoTopHeight+5, 40, 40);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"down_back"] forState:UIControlStateNormal];
    [self.view addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)backClick {
    if (self.backBlock) {
        self.backBlock();
    }
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end

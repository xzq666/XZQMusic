//
//  SwitchHeaderView.m
//  XZQMusic
//
//  Created by qhzc-iMac-02 on 2020/5/6.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "SwitchHeaderView.h"

@interface SwitchHeaderView ()

@property(nonatomic,strong) NSArray *titles;
@property(nonatomic,assign) NSInteger selectIdx;
@property(nonatomic,strong) UIColor *unSelectColor;
@property(nonatomic,strong) UIColor *selectColor;

@end

@implementation SwitchHeaderView

- (instancetype)initWithFrame:(CGRect)frame
               withTitleArray:(NSArray *)titles
                withSelectIdx:(NSInteger)selectIdx
            withUnSelectColor:(UIColor *)unSelectColor
              withSelectColor:(UIColor *)selectColor {
    if (self = [super initWithFrame:frame]) {
        self.titles = titles;
        self.selectIdx = selectIdx;
        self.unSelectColor = unSelectColor;
        self.selectColor = selectColor;
        [self createUI];
    }
    return self;
}

- (void)createUI {
    CGFloat buttonWidth = SCREEN_WIDTH/self.titles.count;
    for (NSInteger i = 0; i < self.titles.count; ++i) {
        // 按钮
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i*buttonWidth, 5, buttonWidth, HEIGH(self)-12)];
        button.tag = 10000+i;
        [button setTitle:self.titles[i] forState:UIControlStateNormal];
        [button setTitleColor:self.unSelectColor forState:UIControlStateNormal];
        [button setTitleColor:self.selectColor forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        // 选中时下方的小横线
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(LEFT_X(button)+(buttonWidth-30)/2, BOTTOM_Y(button), 30, 2)];
        bottomView.layer.cornerRadius = 1;
        bottomView.tag = 20000+i;
        bottomView.backgroundColor = self.selectColor;
        [self addSubview:bottomView];
        
        if (self.selectIdx == i) {
            button.selected = YES;
            [bottomView setHidden:NO];
        } else {
            [bottomView setHidden:YES];
        }
    }
}

- (void)buttonClick:(UIButton *)sender {
    for (NSInteger i = 0; i < self.titles.count; ++i)  {
        UIButton *button = [self viewWithTag:10000+i];
        UIView *bottomView = [self viewWithTag:20000+i];
        if (sender.tag-10000 == i) {
            button.selected = YES;
            [bottomView setHidden:NO];
        } else {
            button.selected = NO;
            [bottomView setHidden:YES];
        }
    }
    if (self.block) {
        self.block(sender.tag - 10000);
    }
}

@end

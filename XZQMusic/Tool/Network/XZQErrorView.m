//
//  XZQErrorView.m
//  AudioAndVideo
//
//  Created by qhzc-iMac-02 on 2020/4/22.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "XZQErrorView.h"

@interface XZQErrorView ()

@property(nonatomic,strong) UIImageView *tipImage;
@property(nonatomic,strong) UILabel *tipLabel;
@property(nonatomic,strong) UIButton *operateBtn;

/** 按钮点击回调 */
@property (nonatomic, copy) void (^errorOperateBlock)(void);

@end

@implementation XZQErrorView

- (instancetype)initWithFrame:(CGRect)frame
                errorImageUrl:(NSString *)imageUrl
                     errorTip:(NSString *)tip
                  operateText:(NSString *)operateText
            errorOperateBlock:(void (^)(void))errorOperateBlock
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI:frame errorImageUrl:imageUrl errorTip:tip operateText:operateText errorOperateBlock:errorOperateBlock];
    }
    return self;
}

- (void)setupUI:(CGRect)frame errorImageUrl:(NSString *)imageUrl errorTip:(NSString *)tip operateText:(NSString *)operateText errorOperateBlock:(void (^)(void))errorOperateBlock {
    self.errorOperateBlock = errorOperateBlock;
    CGFloat viewWidth = frame.size.width;
    CGFloat viewHeight = frame.size.height;
    
    // 有图片
    if (imageUrl && imageUrl.length > 0) {
        CGFloat height = 0.0;
        if (tip && tip.length > 0) {
            height += 40;
        }
        if (operateText && operateText.length > 0) {
            height += 40;
        }
        self.tipImage = [[UIImageView alloc] initWithFrame:CGRectMake(viewWidth * 0.25, (viewHeight - viewWidth * 0.5 - height) / 2, viewWidth * 0.5, viewWidth * 0.5)];
        [self addSubview:self.tipImage];
        if ([imageUrl hasPrefix:@"http"]) {
            [self.tipImage sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        } else {
            self.tipImage.image = [UIImage imageNamed:imageUrl];
        }
    }
    
    // 有提示文字
    if (tip && tip.length > 0) {
        self.tipLabel = [[UILabel alloc] init];
        self.tipLabel.textAlignment = NSTextAlignmentCenter;
        self.tipLabel.font = [UIFont systemFontOfSize:13.0];
        self.tipLabel.text = tip;
        [self addSubview:self.tipLabel];
    }
    
    // 有操作按钮
    if (operateText && operateText.length > 0) {
        self.operateBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.operateBtn setTitle:operateText forState:UIControlStateNormal];
        [self.operateBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.operateBtn];
    }
    
    __weak typeof(self) weakSelf = self;
    
    if (tip && tip.length > 0) {
        [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            imageUrl && imageUrl.length > 0 ? make.top.equalTo(weakSelf.tipImage.mas_bottom).offset(10) : (operateText && operateText.length > 0 ? make.centerY.equalTo(weakSelf.mas_centerY).offset(-20) : make.centerY.equalTo(weakSelf.mas_centerY));
            make.centerX.equalTo(weakSelf.mas_centerX);
            make.left.equalTo(weakSelf).offset(10);
            make.height.mas_equalTo(30);
        }];
    }
    
    if (operateText && operateText.length > 0) {
        [self.operateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            tip && tip.length > 0 ? make.top.equalTo(weakSelf.tipLabel.mas_bottom).offset(5) : (imageUrl && imageUrl.length > 0 ? make.top.equalTo(weakSelf.tipImage.mas_bottom).offset(10) : make.centerY.equalTo(weakSelf.mas_centerY));
            make.centerX.equalTo(weakSelf.mas_centerX);
            make.height.mas_equalTo(35);
            make.width.mas_equalTo(100);
        }];
    }
}

- (void)buttonClicked:(UIButton *)sender {
    if (self.errorOperateBlock) {
        self.errorOperateBlock();
    }
}

@end

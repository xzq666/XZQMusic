//
//  XZQWebView.m
//  XZQMusic
//
//  Created by qhzc-iMac-02 on 2020/5/13.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "XZQWebView.h"

@interface XZQWebView ()

// 进度条的颜色
@property(nonatomic,strong) UIColor *progressColor;
// 进度条
@property(nonatomic,strong) CALayer *progresslayer;

@end

@implementation XZQWebView

- (instancetype)initWithFrame:(CGRect)frame progressColor:(UIColor *)color {
    if (self = [super initWithFrame:frame]) {
        self.progressColor = color;
        [self initDefaultSettings];
    }
    return self;
}

// 初始化设置
- (void)initDefaultSettings {
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.frame];
    // 添加观察者 观察WKWebView的estimatedProgress属性
    [webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    NSString *_userAgent = @"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_4) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.1 Safari/605.1.15";
    if (@available(iOS 12.0, *)){
        NSString *baseAgent = [webView valueForKey:@"applicationNameForUserAgent"];
        NSString *userAgent = [NSString stringWithFormat:@"%@ %@",baseAgent,_userAgent];
        [webView setValue:userAgent forKey:@"applicationNameForUserAgent"];
    }
    [webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSString *newUA = [NSString stringWithFormat:@"%@ %@", result, _userAgent];
        webView.customUserAgent = newUA;
    }];
    [self addSubview:webView];
    self.webView = webView;
    
    UIView *progress = [[UIView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, WIDTH(self), 3)];
    progress.backgroundColor = [UIColor clearColor];
    [self addSubview:progress];
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, 0, 3);
    layer.backgroundColor = self.progressColor.CGColor;
    [progress.layer addSublayer:layer];
    self.progresslayer = layer;
}

- (void)loadUrl:(NSURL *)url {
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progresslayer.opacity = 1;
        // 不要让进度条倒着走...有时候goback会出现这种情况
        if ([change[@"new"] floatValue] < [change[@"old"] floatValue]) {
            return;
        }
        self.progresslayer.frame = CGRectMake(0, 0, WIDTH(self) * [change[@"new"] floatValue], 3);
        if ([change[@"new"] floatValue] == 1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progresslayer.opacity = 0;
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progresslayer.frame = CGRectMake(0, 0, 0, 3);
            });
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

@end

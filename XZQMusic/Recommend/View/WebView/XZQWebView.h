//
//  XZQWebView.h
//  XZQMusic
//
//  Created by qhzc-iMac-02 on 2020/5/13.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XZQWebView : UIView

// WebView
@property(nonatomic,strong) WKWebView *webView;

- (instancetype)initWithFrame:(CGRect)frame progressColor:(UIColor *)color;

/*
 请求页面
 */
- (void)loadUrl:(NSURL *)url;

@end

NS_ASSUME_NONNULL_END

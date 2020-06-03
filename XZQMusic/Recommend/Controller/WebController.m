//
//  WebController.m
//  XZQMusic
//
//  Created by qhzc-iMac-02 on 2020/5/13.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "WebController.h"
#import "XZQWebView.h"

@interface WebController ()<WKNavigationDelegate, WKScriptMessageHandler>

@property(nonatomic,strong) XZQWebView *webView;

@end

@implementation WebController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView = [[XZQWebView alloc] initWithFrame:CGRectZero progressColor:TitleSelectColor];
    if ([XZQSingleton sharedInstance].isPlayMusic) {
        self.webView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-SafeAreaBottomHeight-75);
    } else {
        self.webView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-SafeAreaBottomHeight);
    }
    self.webView.webView.navigationDelegate = self;
    [self.webView loadUrl:[NSURL URLWithString:[self.url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
    [self.view addSubview:self.webView];
}

#pragma mark - WKWebview
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if ([navigationAction.request.URL.absoluteString hasPrefix:@"http"]) {
        decisionHandler(WKNavigationActionPolicyAllow);
    } else {
        decisionHandler(WKNavigationActionPolicyCancel);
    }
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"error: %@", error);
    if(error.code == NSURLErrorCancelled)  {
        return;
    }
    if (error.code == NSURLErrorUnsupportedURL) {
        return;
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    self.title = webView.title;
}

#pragma mark - 加载JS处理
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSLog(@"%@ - %@", message.name, message.body);
}

@end

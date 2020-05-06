//
//  UIViewController+HideBackItemText.m
//  AudioAndVideo
//
//  Created by qhzc-iMac-02 on 2020/4/27.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "UIViewController+HideBackItemText.h"
#import <objc/runtime.h>

@implementation UIViewController (HideBackItemText)

+ (void)load
{
    Method oldMethod = class_getInstanceMethod([self class], @selector(viewDidLoad));
    Method newMethod = class_getInstanceMethod([self class], @selector(viewDidLoadNew));
    method_exchangeImplementations(oldMethod, newMethod);
    
    Method oldWillAppearMethod = class_getInstanceMethod([self class], @selector(viewWillAppear:));
    Method newWillAppearMethod = class_getInstanceMethod([self class], @selector(viewWillAppearNew:));
    method_exchangeImplementations(oldWillAppearMethod, newWillAppearMethod);
}

- (void)viewDidLoadNew {
    [self setAutomaticallyAdjustsScrollViewInsets:YES];
    [self setExtendedLayoutIncludesOpaqueBars:YES];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    [self viewDidLoadNew];
}

- (void)viewWillAppearNew:(BOOL)animated {
    [self viewWillAppearNew:animated];
    UIScrollView *scrollView = nil;
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[UITableView class]] || [view isKindOfClass:[UICollectionView class]]) {
            scrollView = (UIScrollView *)view;
            break;
        }
    }
    if (!self.automaticallyAdjustsScrollViewInsets) {
        if (@available(iOS 11.0, *)) {
            scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    else {
        if (@available(iOS 11.0, *)) {
            scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
        }
    }
}

@end

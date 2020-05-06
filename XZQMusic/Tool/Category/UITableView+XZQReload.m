//
//  UITableView+XZQReload.m
//  AudioAndVideo
//
//  Created by qhzc-iMac-02 on 2020/4/28.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "UITableView+XZQReload.h"
#import <objc/runtime.h>

// 如果当前队列已经是主队列就直接执行，否则回调到主队列之后再执行
#ifndef dispatch_main_async_safe
#define dispatch_main_async_safe(block)\
    if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {\
        block();\
    } else {\
        dispatch_async(dispatch_get_main_queue(), block);\
    }
#endif

static NSUInteger const XZQErrorViewTag = 1024;

@implementation UITableView (XZQReload)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method oldMethod = class_getInstanceMethod([self class], @selector(reloadData));
        Method newMethod = class_getInstanceMethod([self class], @selector(xzq_reloadData));
        method_exchangeImplementations(oldMethod, newMethod);
//        BOOL needAddMethod = class_addMethod([self class], @selector(reloadData), method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
//        if (needAddMethod) {
//            class_replaceMethod([self class], @selector(xzq_reloadData), method_getImplementation(oldMethod), method_getTypeEncoding(oldMethod));
//        } else {
//            method_exchangeImplementations(oldMethod, newMethod);
//        }
    });
}

- (void)xzq_reloadData {
    if (self.isAutoControlErrorView) {
        [self checkIsErrorOrEmpty];
    }
    [self xzq_reloadData];
}

/*
 * 检测是否发生错误或是空列表
 */
- (void)checkIsErrorOrEmpty {
    // 获取section数量
    NSInteger sections = 1;
    if ([self.dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
        sections = [self.dataSource numberOfSectionsInTableView:self];
    }
    // 判断是否是空数据
    BOOL isEmpty = YES;
    for (int i = 0; i < sections; i++) {
        NSInteger rows = [self.dataSource tableView:self numberOfRowsInSection:i];
        if (rows > 0) {
            isEmpty = NO;
            break;
        }
    }
    dispatch_main_async_safe(^{
        if (isEmpty) {
            // 显示异常页
            [self showErrorView];
        } else {
            // 移除异常页
            [self removeErrorView];
        }
    });
}

// 显示异常页
- (void)showErrorView {
    XZQErrorView *errorView = [self isExistErrorView];
    if (!errorView) {
        errorView = [[XZQErrorView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) errorImageUrl:@"https://pic640.weishi.qq.com/879a31aac8a9404b8a8242104e2dcover.jpg" errorTip:@"暂无数据" operateText:@"" errorOperateBlock:^{
        }];
        errorView.tag = XZQErrorViewTag;
        [self addSubview:errorView];
    }
    [self bringSubviewToFront:errorView];
}

// 移除异常页
- (void)removeErrorView {
    XZQErrorView *errorView = [self isExistErrorView];
    if (errorView) {
        [errorView removeFromSuperview];
    }
}

// 检测当前页面是否存在异常页
- (XZQErrorView *)isExistErrorView {
    return [self viewWithTag:XZQErrorViewTag];
}

- (void)setIsAutoControlErrorView:(BOOL)isAutoControlErrorView {
    objc_setAssociatedObject(self, @selector(isAutoControlErrorView), @(isAutoControlErrorView), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)isAutoControlErrorView {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

@end

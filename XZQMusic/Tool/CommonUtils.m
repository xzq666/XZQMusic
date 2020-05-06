//
//  CommonUtils.m
//  AudioAndVideo
//
//  Created by qhzc-iMac-02 on 2020/4/10.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "CommonUtils.h"

#pragma mark 获取Tabbar的背景色
#define TabbarTintColor ([ZXTheme defaultTheme].zx_isDarkTheme ? ZXThemeDarkLevel2Color : [UIColor whiteColor])
#pragma mark 获取NavBar的背景色
#define NavBarTintColor ([ZXTheme defaultTheme].zx_isDarkTheme ? ZXThemeDarkLevel2Color : [UIColor whiteColor])
#pragma mark 获取NavBar标题的颜色
#define NavBarTitleColor ([ZXTheme defaultTheme].zx_isDarkTheme ? ZXThemeDarkLevel2Color : [UIColor whiteColor])
#pragma mark 获取TableView背景色
#define TableViewBacColor ([ZXTheme defaultTheme].zx_isDarkTheme ? ZXThemeDarkLevel2Color : [UIColor colorWithRed:240 / 255.0 green:240 / 255.0 blue:240 / 255.0 alpha:1])
#pragma mark 获取TableViewCell背景色
#define TableViewCellBacColor ([ZXTheme defaultTheme].zx_isDarkTheme ? ZXThemeDarkLevel2Color : [UIColor whiteColor])
#pragma mark 获取TableViewCell中Label文字颜色
#define TableViewCellLabelTextColor ([ZXTheme defaultTheme].zx_isDarkTheme ? ZXThemeLightLevel2Color : [UIColor blackColor])
#pragma mark 获取TableViewCell中ImageView图片渲染颜色
#define TableViewCellImageViewRenderColor ([ZXTheme defaultTheme].zx_isDarkTheme ? ZXThemeLightLevel2Color : [UIColor blackColor])
#pragma mark 获取TableViewHeaderView背景色
#define TableViewHeaderViewBacColor ([ZXTheme defaultTheme].zx_isDarkTheme ? ZXThemeDarkLevel2Color : [UIColor whiteColor])
#pragma mark 获取TableViewHeaderView中label文字颜色
#define TableViewHeaderViewLabelTextColor ([ZXTheme defaultTheme].zx_isDarkTheme ? ZXThemeLightLevel2Color : [UIColor blackColor])
#pragma mark 获取CollectionView背景色
#define CollectionViewBacColor ([ZXTheme defaultTheme].zx_isDarkTheme ? ZXThemeDarkLevel1Color : [UIColor colorWithRed:240 / 255.0 green:240 / 255.0 blue:240 / 255.0 alpha:1])
#pragma mark 获取CollectionViewCell背景色
#define CollectionViewCellBacColor ([ZXTheme defaultTheme].zx_isDarkTheme ? ZXThemeDarkLevel2Color : [UIColor whiteColor])
#pragma mark 获取CollectionViewCell中Label文字颜色
#define CollectionViewCellLabelTextColor ([ZXTheme defaultTheme].zx_isDarkTheme ? ZXThemeLightLevel2Color : [UIColor blackColor])
#pragma mark 获取CollectionViewHeaderView&CollectionViewFooterView背景色
#define CollectionViewHeaderViewBacColor ([ZXTheme defaultTheme].zx_isDarkTheme ? ZXThemeDarkLevel2Color : [UIColor whiteColor])
#pragma mark 获取CollectionViewHeaderView&CollectionViewFooterView中label文字颜色
#define CollectionViewHeaderViewLabelTextColor ([ZXTheme defaultTheme].zx_isDarkTheme ? ZXThemeLightLevel2Color : [UIColor blackColor])
#pragma mark 获取控制器背景色
#define ControllerBacViewColor ([ZXTheme defaultTheme].zx_isDarkTheme ? ZXThemeDarkLevel2Color : [UIColor whiteColor])

@implementation CommonUtils

+ (double)getDeviceStatusHeight {
    double statusBarHeight = 0.0f;
    if (@available(iOS 13.0, *)) {
        UIStatusBarManager *statusBarManager = [UIApplication sharedApplication].windows.firstObject.windowScene.statusBarManager;
        statusBarHeight = statusBarManager.statusBarFrame.size.height;
    } else {
        statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    }
    return statusBarHeight;
}

// 暗黑模式适配
+ (void)initDarkTheme {
    //设置TabBar主题
    [ZXTheme defaultTheme].zx_tabBarThemeBlock  = ^ZXTabBarTheme * _Nonnull(UITabBar * _Nonnull tabBar) {
        ZXTabBarTheme *tabBarTheme = [[ZXTabBarTheme alloc]init];
        tabBarTheme.translucent = NO;
        tabBarTheme.barTintColor = TabbarTintColor;
        return tabBarTheme;
    };
    //设置NavigationBar主题
    [ZXTheme defaultTheme].zx_navigationBarThemeBlock = ^ZXNavigationBarTheme * _Nonnull(UINavigationBar * _Nonnull navigationBar) {
        ZXNavigationBarTheme *navigationBarTheme  = [[ZXNavigationBarTheme alloc]init];
        navigationBarTheme.translucent = NO;
        NSMutableDictionary *titleTextAttributes = [navigationBar.titleTextAttributes mutableCopy];
        if(!titleTextAttributes){
            titleTextAttributes = [NSMutableDictionary dictionary];
        }
        navigationBarTheme.barTintColor = NavBarTintColor;
        [titleTextAttributes setValue:NavBarTitleColor forKey:NSForegroundColorAttributeName];
        navigationBarTheme.titleTextAttributes = titleTextAttributes;
        return navigationBarTheme;
    };
    //设置TableView主题
    [ZXTheme defaultTheme].zx_tableViewThemeBlock = ^ZXTableViewTheme * _Nonnull(UITableView * _Nonnull tableView) {
        ZXTableViewTheme *tableViewTheme = [[ZXTableViewTheme alloc]init];
        tableViewTheme.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableViewTheme.backgroundColor = TableViewBacColor;
        tableViewTheme.viewForHeaderInSection = ^UIView * _Nonnull(UIView * _Nonnull headerView, NSUInteger section) {
            headerView.backgroundColor = TableViewHeaderViewBacColor;
            for (UIView *view in headerView.subviews) {
                if([view isKindOfClass:[UILabel class]]){
                    ((UILabel *)view).textColor = TableViewHeaderViewLabelTextColor;
                }
               
            }
            return headerView;
        };
        tableViewTheme.cellForRowAtIndexPath = ^UITableViewCell * _Nonnull(UITableViewCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath) {
            cell.backgroundColor = TableViewCellBacColor;
            for (UIView *view in cell.contentView.subviews) {
                if([view isKindOfClass:[UILabel class]]){
                    ((UILabel *)view).textColor = TableViewCellLabelTextColor;
                }
            }
            return cell;
        };
        return tableViewTheme;
    };
    //设置CollectionView主题
    [ZXTheme defaultTheme].zx_collectionViewThemeBlock = ^ZXCollectionViewTheme * _Nonnull(UICollectionView * _Nonnull collectionView) {
        ZXCollectionViewTheme *collectionViewTheme = [[ZXCollectionViewTheme alloc]init];
        collectionViewTheme.backgroundColor = CollectionViewBacColor;
        collectionViewTheme.cellForItemAtIndexPath = ^UICollectionViewCell * _Nonnull(UICollectionViewCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath) {
            cell.backgroundColor = CollectionViewCellBacColor;
            for (UIView *view in cell.contentView.subviews) {
                if([view isKindOfClass:[UILabel class]]){
                    ((UILabel *)view).textColor = CollectionViewCellLabelTextColor;
                }
            }
            return cell;
        };
        collectionViewTheme.viewForSupplementaryElement = ^UICollectionReusableView * _Nonnull(UICollectionReusableView * _Nonnull reusableView, NSString * _Nonnull kind, NSIndexPath * _Nonnull indexPath) {
            reusableView.backgroundColor = CollectionViewHeaderViewBacColor;
            for (UIView *view in reusableView.subviews) {
                if([view isKindOfClass:[UILabel class]]){
                    ((UILabel *)view).textColor = CollectionViewHeaderViewLabelTextColor;
                }
                
            }
            return reusableView;
        };
        return collectionViewTheme;
    };
    //设置View主题
    [ZXTheme defaultTheme].zx_viewThemeBlock = ^ZXViewTheme * _Nonnull(UIView * _Nonnull view) {
        ZXViewTheme *viewTheme = [[ZXViewTheme alloc]init];
        // 指定自定义View设置背景色
        if ([view isMemberOfClass:[SwitchHeaderView class]]) {
            viewTheme.backgroundColor = ControllerBacViewColor;
        }
        return viewTheme;
    };
    //设置Button主题
    [ZXTheme defaultTheme].zx_buttonThemeBlock = ^ZXButtonTheme * _Nonnull(UIButton * _Nonnull button) {
        ZXButtonTheme *buttonTheme = [[ZXButtonTheme alloc]init];
        if (button.tag < 10000) {
            if([ZXTheme defaultTheme].zx_isDarkTheme) {
//                buttonTheme.backgroundColor = ZXThemeDarkLevel1Color;
                [buttonTheme setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [buttonTheme setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
//                button.layer.borderColor = [UIColor whiteColor].CGColor;
            }else{
//                buttonTheme.backgroundColor = [UIColor whiteColor];
                [buttonTheme setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [buttonTheme setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
//                button.layer.borderColor = [UIColor blackColor].CGColor;
            }
        }
        return buttonTheme;
    };
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (NSString *)convert2JSONWithDictionary:(NSDictionary *)dic {
    NSError *err;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&err];
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"%@",err);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

@end

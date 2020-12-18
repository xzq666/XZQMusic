//
//  CommonUtils.m
//  AudioAndVideo
//
//  Created by qhzc-iMac-02 on 2020/4/10.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "CommonUtils.h"
#import "SwitchHeaderView.h"
#import "RecommendHeaderView.h"
#import "XZQHotTagButton.h"
#import <Accelerate/Accelerate.h>

#pragma mark 获取Tabbar的背景色
#define TabbarTintColor ([ZXTheme defaultTheme].zx_isDarkTheme ? ZXThemeDarkLevel2Color : [UIColor whiteColor])
#pragma mark 获取NavBar的背景色
#define NavBarTintColor ([ZXTheme defaultTheme].zx_isDarkTheme ? ZXThemeDarkLevel2Color : [UIColor whiteColor])
#pragma mark 获取NavBar标题的颜色
#define NavBarTitleColor ([ZXTheme defaultTheme].zx_isDarkTheme ? ZXThemeDarkLevel2Color : [UIColor whiteColor])
#pragma mark 获取TableView背景色
#define TableViewBacColor ([ZXTheme defaultTheme].zx_isDarkTheme ? ZXThemeDarkLevel2Color : [UIColor whiteColor])
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
#define CollectionViewBacColor ([ZXTheme defaultTheme].zx_isDarkTheme ? ZXThemeDarkLevel1Color : [UIColor whiteColor])
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
//        tableViewTheme.backgroundColor = TableViewBacColor;
        tableViewTheme.viewForHeaderInSection = ^UIView * _Nonnull(UIView * _Nonnull headerView, NSUInteger section) {
            for (UIView *view in headerView.subviews) {
                if([view isKindOfClass:[UILabel class]] && view.tag != 30001 && view.tag != 30002){
                    ((UILabel *)view).textColor = TableViewHeaderViewLabelTextColor;
                }
            }
            return headerView;
        };
        tableViewTheme.viewForFooterInSection = ^UIView * _Nonnull(UIView * _Nonnull headerView, NSUInteger section) {
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
                if([view isKindOfClass:[UILabel class]] && view.tag != 15000 && view.tag != 15001 && view.tag != 15002 && view.tag != 15003 && view.tag != 15004 && view.tag != 15005 && view.tag != 15006 && view.tag != 15007 && view.tag != 15008) {
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
        if ([view isMemberOfClass:[SwitchHeaderView class]] || [view isMemberOfClass:[RecommendHeaderView class]]) {
            viewTheme.backgroundColor = ControllerBacViewColor;
        }
        return viewTheme;
    };
    //设置Button主题
    [ZXTheme defaultTheme].zx_buttonThemeBlock = ^ZXButtonTheme * _Nonnull(UIButton * _Nonnull button) {
        ZXButtonTheme *buttonTheme = [[ZXButtonTheme alloc]init];
        if (button.tag < 10000 && ![button isKindOfClass:[XZQHotTagButton class]]) {
            if([ZXTheme defaultTheme].zx_isDarkTheme) {
                [buttonTheme setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [buttonTheme setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            }else{
                [buttonTheme setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [buttonTheme setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
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

+ (UIImage *)image:(UIImage*)image setAlpha:(CGFloat)alpha {
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    CGContextSetAlpha(ctx, alpha);
    CGContextDrawImage(ctx, area, image.CGImage);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur {
     if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
     }
     int boxSize = (int)(blur * 40);
     boxSize = boxSize - (boxSize % 2) + 1;
     CGImageRef img = image.CGImage;
     vImage_Buffer inBuffer, outBuffer;
     vImage_Error error;
     void *pixelBuffer;
     //从CGImage中获取数据
     CGDataProviderRef inProvider = CGImageGetDataProvider(img);
     CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
     //设置从CGImage获取对象的属性
     inBuffer.width = CGImageGetWidth(img);
     inBuffer.height = CGImageGetHeight(img);
     inBuffer.rowBytes = CGImageGetBytesPerRow(img);
     inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
     pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
     if(pixelBuffer == NULL)
         NSLog(@"No pixelbuffer");
     outBuffer.data = pixelBuffer;
     outBuffer.width = CGImageGetWidth(img);
     outBuffer.height = CGImageGetHeight(img);
     outBuffer.rowBytes = CGImageGetBytesPerRow(img);
     error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
     if (error) {
           NSLog(@"error from convolution %ld", error);
     }
     CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
     CGContextRef ctx = CGBitmapContextCreate(outBuffer.data, outBuffer.width, outBuffer.height, 8, outBuffer.rowBytes, colorSpace, kCGImageAlphaNoneSkipLast);
     CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
     UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
     //clean up CGContextRelease(ctx);
     CGColorSpaceRelease(colorSpace);
     free(pixelBuffer);
     CFRelease(inBitmapData);
     CGColorSpaceRelease(colorSpace);
     CGImageRelease(imageRef);
     return returnImage;
}

+ (NSString *)base64Encode:(NSString *)string {
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSData *base64Data = [data base64EncodedDataWithOptions:0];
    NSString *baseString = [[NSString alloc]initWithData:base64Data encoding:NSUTF8StringEncoding];
    return baseString;
}

+ (NSString *)base64Decode:(NSString *)base64String {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:base64String options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSString *string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    return string;
}

+ (BOOL)isLocalWithUrlString:(NSString *)urlString {
    if ([urlString hasPrefix:@"http"]) {
        return NO;
    }
    return YES;
}

@end

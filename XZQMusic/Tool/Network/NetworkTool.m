//
//  NetworkTool.m
//  AudioAndVideo
//
//  Created by qhzc-iMac-02 on 2020/4/22.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "NetworkTool.h"
#import "NSError+XZQError.h"

@implementation NetworkTool

+ (AFHTTPSessionManager *)manager
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 30.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    // 声明上传的是json格式的参数，需要你和后台约定好，不然会出现后台无法获取到你上传的参数问题
    manager.requestSerializer = [AFHTTPRequestSerializer serializer]; // 上传普通格式
    //    manager.requestSerializer = [AFJSONRequestSerializer serializer]; // 上传JSON格式
    // 声明获取到的数据格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer]; // AFN不会解析,数据是data，需要自己解析
    //    manager.responseSerializer = [AFJSONResponseSerializer serializer]; // AFN会JSON解析返回的数据
    // 个人建议还是自己解析的比较好，有时接口返回的数据不合格会报3840错误，大致是AFN无法解析返回来的数据
    return manager;
}

+ (void)getUrl:(NSString *)url withParams:(NSDictionary *)params backInfoWhenErrorBlock:(void (^)(id obj, NSError *error))completeBlock
{
    // 包装参数
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionaryWithDictionary:params];
    // 可以先添加一些每个接口都需要的参数，例如版本号、平台信息等
    [paramsDic setValue:@"ios" forKey:@"platform"];
    //遍历获取所有的key和value
    NSMutableArray *strings = [NSMutableArray array];
    [paramsDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSString *objStr = [CommonUtils convert2JSONWithDictionary:obj];
            NSString *str = [NSString stringWithFormat:@"&%@=%@",key,objStr];
            [strings addObject:str];
        } else {
            NSString *str = [NSString stringWithFormat:@"&%@=%@",key,obj];
            [strings addObject:str];
        }
    }];
    // 最终的url
    NSString *getURL = [NSString stringWithFormat:@"%@?%@", url, [strings componentsJoinedByString:@""]];
    NSString *URL = [getURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    AFHTTPSessionManager *manager = [self manager];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html",@"application/x-javascript",@"application/octet-stream",nil];
    [manager GET:URL parameters:nil headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"jsonStr:%@", jsonStr);
        NSDictionary *obj = [NSDictionary dictionary];
        if ([jsonStr hasPrefix:@"callback("]) {
            jsonStr = [jsonStr substringFromIndex:9];
            jsonStr = [jsonStr substringToIndex:jsonStr.length-1];
            obj = [self dictionaryWithJsonString:jsonStr];
        } else {
            obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        }
        if (obj) {
            completeBlock(obj, nil);
        } else {
            completeBlock(nil, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSError *newError = [NSError returnErrorWithError:error];
        completeBlock(nil, newError);
    }];
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if (err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+ (void)getUrl:(NSString *)url withParams:(NSDictionary *)params backViewWhenErrorBlock:(void (^)(id obj, UIView *errorView))completeBlock
{
    // 包装参数
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionaryWithDictionary:params];
    // 可以先添加一些每个接口都需要的参数，例如版本号、平台信息等
    [paramsDic setValue:@"ios" forKey:@"platform"];
    //遍历获取所有的key和value
    NSMutableArray *strings = [NSMutableArray array];
    [paramsDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString *str = [NSString stringWithFormat:@"&%@=%@",key,obj];
        [strings addObject:str];
    }];
    // 最终的url
    NSString *getURL = [NSString stringWithFormat:@"%@?%@", url, [strings componentsJoinedByString:@""]];
    NSString *URL = [getURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    AFHTTPSessionManager *manager = [self manager];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html",@"application/x-javascript",@"application/octet-stream",nil];
    [manager GET:URL parameters:paramsDic headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *obj = [NSDictionary dictionary];
        if ([jsonStr hasPrefix:@"callback("]) {
            jsonStr = [jsonStr substringFromIndex:9];
            jsonStr = [jsonStr substringToIndex:jsonStr.length-1];
            obj = [self dictionaryWithJsonString:jsonStr];
        } else {
            obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        }
        if (obj) {
            completeBlock(obj, nil);
        } else {
            XZQErrorView *errorView = [[XZQErrorView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-SafeAreaTopHeight-SafeAreaBottomHeight) errorImageUrl:@"https://pic640.weishi.qq.com/879a31aac8a9404b8a8242104e2dcover.jpg" errorTip:@"未请求到数据" operateText:@"重新加载" errorOperateBlock:^{
                NSLog(@"重新加载");
            }];
            completeBlock(nil, errorView);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSError *newError = [NSError returnErrorWithError:error];
        XZQErrorView *errorView = [[XZQErrorView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-SafeAreaTopHeight-SafeAreaBottomHeight) errorImageUrl:@"https://pic640.weishi.qq.com/879a31aac8a9404b8a8242104e2dcover.jpg" errorTip:newError.localizedDescription operateText:@"重新加载" errorOperateBlock:^{
            NSLog(@"重新加载");
        }];
        completeBlock(nil, errorView);
    }];
}

+ (void)postUrl:(NSString *)url withParams:(NSDictionary *)params backInfoWhenErrorBlock:(void (^)(id obj, NSError *error))completeBlock
{
    // 包装参数
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionaryWithDictionary:params];
    // 可以先添加一些每个接口都需要的参数，例如版本号、平台信息等
//    [paramsDic setValue:@"ios" forKey:@"platform"];
    AFHTTPSessionManager *manager = [self manager];
    
    [manager.requestSerializer setValue:@"application/json, text/plain, */*" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setQueryStringSerializationWithStyle:AFHTTPRequestQueryStringStringifyStyle];
    
    [manager POST:url parameters:paramsDic headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"jsonStr:%@", jsonStr);
        if (responseObject) {
            NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            if (obj) {
                completeBlock(obj, nil);
            } else {
                completeBlock(nil, nil);
            }
        } else {
            completeBlock(@{@"msg":@"暂无数据"}, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@ - %@", url, error);
        completeBlock(@{@"msg":@"请求失败"}, nil);
    }];
}

@end

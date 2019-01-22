//
//  LYADsNetworkingTool.m
//  LYADs
//
//  Created by liyu on 2018/11/8.
//

#import "LYADsNetworkingTool.h"
#import "AFNetworking.h"

#define LYADs_HTTP_HOST_URL     @"https://www.baidu.com"

@interface AFHttpClient : AFHTTPSessionManager

+ (instancetype)sharedClient;

@end

@implementation AFHttpClient

+ (instancetype)sharedClient {
    static AFHttpClient *client = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        client = [[AFHttpClient alloc] initWithBaseURL:[NSURL URLWithString:LYADs_HTTP_HOST_URL] sessionConfiguration:configuration];
        // 接收参数类型
        client.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain", nil];
        // 设置超时时间,默认60
        client.requestSerializer.timeoutInterval = 15;
        // 安全策略
        client.securityPolicy = [AFSecurityPolicy defaultPolicy];
    });    
    return client;
}

@end

@implementation LYADsNetworkingTool

+ (void)getWithPath:(NSString *)path params:(NSDictionary *)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure {
    
    // 获取完整的url路径
    //NSString *url = [kBaseUrl stringByAppendingPathComponent:path];
    [[AFHttpClient sharedClient] GET:path parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

+ (void)postWithPath:(NSString *)path params:(NSDictionary *)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure {
    
    // 获取完整的url路径
    // NSString *url = [kBaseUrl stringByAppendingPathComponent:path];
    [[AFHttpClient sharedClient] POST:path parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

@end

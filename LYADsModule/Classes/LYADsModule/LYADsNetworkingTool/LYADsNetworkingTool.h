//
//  LYADsNetworkingTool.h
//  LYADs
//
//  Created by liyu on 2018/11/8.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^HttpSuccessBlock)(id json);
typedef void(^HttpFailureBlock)(NSError *error);

@interface LYADsNetworkingTool : NSObject

/**
 get网络请求
 @param path url地址
 @param params url参数 NSDictionary类型
 @param success 请求成功 返回NSDictionary或NSArray
 @param failure 请求失败 返回NSError
 */
+ (void)getWithPath:(NSString *)path
             params:(NSDictionary *)params
            success:(HttpSuccessBlock)success
            failure:(HttpFailureBlock)failure;

/**
 post网络请求 
 @param path url地址
 @param params url参数 NSDictionary类型
 @param success 请求成功 返回NSDictionary或NSArray
 @param failure 请求失败 返回NSError
 */
+ (void)postWithPath:(NSString *)path
              params:(NSDictionary *)params
             success:(HttpSuccessBlock)success
             failure:(HttpFailureBlock)failure;


@end


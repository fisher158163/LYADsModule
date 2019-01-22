//
//  LYADsModel.h
//  LLFullScreenAd
//
//  Created by liyu on 2018/11/8.
//

#import <Foundation/Foundation.h>

#define LYADsModelKey   @"LYADsModel"

@interface LYADsModel : NSObject<NSCopying, NSCoding>
@property(nonatomic, copy)NSString *title;      // 标题
@property(nonatomic, copy)NSString *path;       // 图片链接
@property(nonatomic, copy)NSString *pageURL;    // 跳转URL
@property(nonatomic, assign)NSInteger status;   // 状态：0 显示，非0 不显示
@end


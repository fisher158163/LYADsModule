//
//  LYADsManager.h
//  LYADs
//
//  Created by liyu on 2018/11/8.
//

#import <Foundation/Foundation.h>
#import "LYADsHeader.h"
#import "LYADsWebViewController.h"
#import "LYADsModel.h"

@interface LYADsManager : NSObject

@property (nonatomic, strong) LYADsModel *adsModel;

@property (nonatomic, strong) LYADsWebViewController *adsImageWebViewController;

+ (instancetype)shareInstance;

// 唤醒启动广告图
- (void)showLaunchADsImage;

@end



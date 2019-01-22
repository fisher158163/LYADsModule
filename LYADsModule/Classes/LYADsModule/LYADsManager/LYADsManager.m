//
//  LYADsManager.m
//  LYADs
//
//  Created by liyu on 2018/11/8.
//

#import "LYADsManager.h"
#import "LYADsNetworkingTool.h"
#import "LYADsLaunchView.h"
#import "LYADsWebViewController.h"

@interface LYADsManager ()
@property (nonatomic, copy) NSString *pageURL;
@end

@implementation LYADsManager

+ (instancetype)shareInstance {
    static LYADsManager *instanced = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!instanced) {
            instanced = [[LYADsManager alloc] init];
            instanced.pageURL = nil;
        }
    });
    return instanced;
}

#pragma mark - WebViewController init

- (LYADsWebViewController *)adsImageWebViewController {
    return [[LYADsWebViewController alloc] initWithLoadingURL:self.pageURL];
}

#pragma mark - Public

// 唤醒启动广告图
- (void)showLaunchADsImage {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey: LYADsModelKey];
    LYADsModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//    if (!model || model.path == nil || model.path.length == 0) {
//        // 加载本地数据
//        [self loadingLocalLaunchADsInfo];
//    }
//    else {
        [LYADsManager shareInstance].adsModel = model;
//    }
    
    // 显示启动广告
    [self loadingLaunchADsView];
    
    // 加载服务器数据
    [self loadingRemoteLaunchADsInfo];
}

#pragma mark - Private

// 添加广告图
- (void)loadingLaunchADsView {
    LYADsLaunchView *adView = [[LYADsLaunchView alloc] init];
    adView.duration = 5;
    adView.waitTime = 3;
    adView.skipType = LYADsSkipButtonTypeCircleAnimation;
    adView.adImageTapBlock = ^(NSString *aPageURL) {
        self.pageURL = aPageURL;
        NSLog(@"pageURL:%@", self.pageURL);
        // 发送点击广告通知，同时带上链接地址信息
        [[NSNotificationCenter defaultCenter] postNotificationName:LYADsLaunchImageTapedKey object:nil userInfo:nil];
    };
    [[UIApplication sharedApplication].keyWindow addSubview:adView];
    
    LYADsModel *model = [LYADsManager shareInstance].adsModel;
    if (model && model.path) {
        [adView reloadAdImageWithUrl:model.path]; // 加载广告图
    }
}

// 加载本地数据
- (void)loadingLocalLaunchADsInfo {
    LYADsModel *aADsModel = [[LYADsModel alloc] init];
    aADsModel.title = @"本地图片";
    aADsModel.path = @"https://ws4.sinaimg.cn/large/006tNc79gy1fzc66ezaqlj30ku112dhl.jpg";
    aADsModel.pageURL = @"https://www.mogujie.com";
    [LYADsManager shareInstance].adsModel = aADsModel;
    [self saveLocalData:aADsModel];
}

// 加载服务器数据
- (void)loadingRemoteLaunchADsInfo {
    NSDictionary *param = @{@"app_id": APP_CHANNEL_ID,
                            @"version": APP_VERSION,
                            @"channel_id": APP_CHANNEL_ID,
                            @"width": @(LYADsScreenWidth),
                            @"height": @(LYADsScreenHeight)
                            };
    [LYADsNetworkingTool getWithPath:LYADs_REQUEST_URL params:param success:^(id json) {
        NSInteger code = [[json objectForKey:@"state"] integerValue];
        NSArray *data = [json objectForKey:@"data"];
        if (code == 0 && data.count > 0) {
            for (NSDictionary *item in data) {
                if (item.count == 0) continue;
                
                NSInteger _aStatus = [[item objectForKey:@"status"] integerValue];
                if (_aStatus != 1) continue;
                
                LYADsModel *aADsModel = [[LYADsModel alloc] init];
                aADsModel.title = [item objectForKey:@"name"];
                aADsModel.pageURL = [item objectForKey:@"link"];
                aADsModel.path = [item objectForKey:@"img"];
                
                [self saveLocalData:aADsModel];
                break;
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"error = %@", error);
    }];
}

// 存储本地数据
- (void)saveLocalData:(LYADsModel *)aADsModel {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:[NSKeyedArchiver archivedDataWithRootObject:aADsModel] forKey:LYADsModelKey];
    [userDefault synchronize];
}

@end

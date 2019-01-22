//
//  LYADsHeader.h
//  LYADs
//
//  Created by liyu on 2018/11/8.
//

#ifndef LYADsHeader_h
#define LYADsHeader_h

#define LYADs_REQUEST_URL          @"https://hc01.bsrkm.com/api/banner/startup"

#define LYADsLaunchImageTapedKey   @"LYADsLaunchImageTapedKey"

// 设备宽高
#define LYADsScreenScale  [UIScreen mainScreen].scale
#define LYADsScreenWidth  (int)([UIScreen mainScreen].bounds.size.width * LYADsScreenScale)
#define LYADsScreenHeight (int)([UIScreen mainScreen].bounds.size.height * LYADsScreenScale)
// App渠道号
#define APP_CHANNEL_ID    [[[NSBundle mainBundle] infoDictionary] valueForKey:@"APP_CHANNEL_ID"]
// App版本
#define APP_VERSION       [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"]

#endif /* LYADsHeader_h */

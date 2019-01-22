//
//  LYADsLaunchView.h
//  LYADs
//
//  Created by liyu on 2018/11/8.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LYADsSkipButtonType) {
    LYADsSkipButtonTypeNormalTimeAndText = 0,      // 普通的倒计时+跳过
    LYADsSkipButtonTypeCircleAnimation,            // 圆形动画+跳过
    LYADsSkipButtonTypeNormalText,                 // 只有普通的跳过
    LYADsSkipButtonTypeNormalTime,                 // 只有普通的倒计时
    LYADsSkipButtonTypeNone                        // 无
};

typedef void(^adImageBlock)(NSString *aPageURL);   // 可以根据需要添加一些相应的参数

@interface LYADsLaunchView : UIImageView

// 广告图的显示时间（默认5秒）
@property (nonatomic, assign) NSUInteger duration;
// 获取数据前，启动图的等待时间（若不设置则不启动等待机制）
@property (nonatomic, assign) NSUInteger waitTime;
// 右上角按钮的样式（默认倒计时+跳过）
@property (nonatomic, assign) LYADsSkipButtonType skipType;
// 广告图点击事件回调
@property (nonatomic, copy) adImageBlock adImageTapBlock;
// 加载广告图
- (void)reloadAdImageWithUrl:(NSString *)urlStr;

@end

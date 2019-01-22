//
//  LYADsLaunchView.m
//  LYADs
//
//  Created by liyu on 2018/11/8.
//

#import "LYADsLaunchView.h"
#import "SDWebImageManager.h"
#import "LYADsManager.h"
#import "LYADsModel.h"

#define LYADsMainScreenWidth [UIScreen mainScreen].bounds.size.width

@interface LYADsLaunchView ()
@property (nonatomic, strong) UIButton *skipButton;         // 跳过按钮
@property (nonatomic, strong) dispatch_source_t timer;      // 显示计时器
@property (nonatomic, strong) dispatch_source_t timerWait;  // 等待计时器
@property (nonatomic, assign) BOOL flag;                    // 是否将要消失
@property (nonatomic, strong) UIView *timerView;
@property (nonatomic, weak) CAShapeLayer *viewLayer;
@property (nonatomic, assign) NSInteger remain;             // 剩余时间
@property (nonatomic, assign) NSInteger count;
@end

@implementation LYADsLaunchView

- (instancetype)init {
    if (self = [super init]) {
        [self configDefaultParameter];
    }
    return self;
}

- (UIButton *)skipButton {
    if (!_skipButton) {
        _skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _skipButton.frame = CGRectMake(LYADsMainScreenWidth - 70, 30, 60, 30);
        _skipButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        _skipButton.layer.cornerRadius = 15;
        _skipButton.layer.masksToBounds = YES;
        _skipButton.titleLabel.font = [UIFont systemFontOfSize:13.5];
        __weak LYADsLaunchView *weakSelf = self;
        [_skipButton addTarget:weakSelf action:@selector(skipAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _skipButton;
}

- (void)setDuration:(NSUInteger)duration {
    _duration = duration;
    if (duration < 3) {
        _duration = 3;
    }
}

- (void)setWaitTime:(NSUInteger)waitTime {
    _waitTime = waitTime;
    if (waitTime < 1) {
        _waitTime = 1;
    }
    // 启动等待计时器
    [self scheduledWaitTimer];
}

- (UIView *)timerView {
    if (!_timerView) {
        self.timerView = [[UIView alloc] initWithFrame:CGRectMake(LYADsMainScreenWidth - 62, 40, 40, 40)];
        CAShapeLayer *layer = [CAShapeLayer layer];
        // 填充颜色
        layer.fillColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4].CGColor;
        // 绘制颜色
        layer.strokeColor = [UIColor redColor].CGColor;
        layer.lineCap = kCALineCapRound;
        layer.lineJoin = kCALineJoinRound;
        layer.lineWidth = 2;
        layer.frame = self.bounds;
        layer.path = [self getCirclePath].CGPath;
        layer.strokeStart = 0;
        [_timerView.layer addSublayer:layer];
        self.viewLayer = layer;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(3, 3, 34, 34)];
        titleLabel.text = @"跳过";
        titleLabel.textColor = [UIColor whiteColor];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        titleLabel.font = [UIFont systemFontOfSize:14];
        [_timerView addSubview:titleLabel];
        _remain = _duration * 20;
        _count = 0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(skipAction)];
        [_timerView addGestureRecognizer:tap];
    }
    return _timerView;
}

// 配置默认参数
- (void)configDefaultParameter {
    self.flag = NO;
    self.duration = 5;
    self.skipType = LYADsSkipButtonTypeCircleAnimation;
    self.image = [self getLaunchImage];
    self.frame = [[UIScreen mainScreen] bounds];
}

// 获取启动图片
- (UIImage *)getLaunchImage {
    CGSize viewSize = [UIScreen mainScreen].bounds.size;
    // 横屏请设置成 @"Landscape"
    NSString *viewOrientation = @"Portrait";
    // 竖屏请设置成 @"Portrait"
    // NSString *viewOrientation = @"Landscape";
    UIImage *lauchImage = nil;
    NSArray *imagesDictionary = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary *dict in imagesDictionary) {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]]) {
            lauchImage = [UIImage imageNamed:dict[@"UILaunchImageName"]];
        }
    }
    return lauchImage;
}

// 绘制路径
- (UIBezierPath *)getCirclePath {
    return [UIBezierPath bezierPathWithArcCenter:CGPointMake(20, 20) radius:19 startAngle:-0.5*M_PI endAngle:1.5*M_PI clockwise:YES];
}

// 获取广告图
- (void)reloadAdImageWithUrl:(NSString *)urlStr {
    if (urlStr.length <= 0) {
        if (_timerWait) dispatch_source_cancel(_timerWait);
        [self removeFromSuperview];
        return;
    }
    NSURL *imageUrl = [NSURL URLWithString:urlStr];
    __weak typeof(self) weakSelf = self;
    UIImage *cacheImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:urlStr];
    if (cacheImage) {
        NSLog(@"cacheImage");
        [weakSelf adImageShowWithImage:cacheImage];
    } else {
        NSLog(@"noCacheImage");
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadImageWithURL:imageUrl options:SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (image && finished && error == nil) {                
                [weakSelf adImageShowWithImage:image];
                [[SDImageCache sharedImageCache] storeImage:image forKey:urlStr toDisk:YES];
            }
        }];
    }
}

// 显示广告图
- (void)adImageShowWithImage:(UIImage *)image {
    if (_flag) return;
    if (_timerWait) dispatch_source_cancel(_timerWait);
    self.image = image;
    self.userInteractionEnabled = YES;
    if (_skipType == LYADsSkipButtonTypeCircleAnimation) {
        [self addSubview:self.timerView];
        [self setCircleTimer];
    } else {
        [self addSubview:self.skipButton];
        [self scheduledTimer];
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:tap];
    CATransition *animation = [CATransition animation];
    animation.duration = 0.2; // 动画执行时间
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = kCATransitionFade;
    [self.layer addAnimation:animation forKey:@"animation"];
}

// 广告图显示倒计时
- (void)setCircleTimer {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 0.05 * NSEC_PER_SEC, 0);    
    dispatch_source_set_event_handler(_timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_count >= _remain) {
                dispatch_source_cancel(_timer);
                self.viewLayer.strokeStart = 1;
                [self dismiss];
            } else {
                self.viewLayer.strokeStart += 0.01;
                _count++;
            }
        });
    });
    dispatch_resume(_timer);
}

// 广告图显示倒计时
- (void)scheduledTimer {
    if (_timerWait) dispatch_source_cancel(_timerWait);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    // 每秒执行
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_duration <= 0) {
                dispatch_source_cancel(_timer);
                // 关闭界面
                [self dismiss];
            } else {
                [self showSkipBtnTitleTime:_duration];
                _duration--;
            }
        });
    });
    dispatch_resume(_timer);
}


// 广告图加载前等待计时器
- (void)scheduledWaitTimer {
    if (_timerWait) dispatch_source_cancel(_timerWait);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timerWait = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timerWait, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timerWait, ^{
        if (_waitTime <= 0) {
            _flag = YES;
            dispatch_source_cancel(_timerWait);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self dismiss];
            });
        } else {
            _waitTime--;
        }
    });
    dispatch_resume(_timerWait);
}

// 消失广告图
- (void)dismiss {
    NSLog(@"launchAdImage dismiss");
    [UIView animateWithDuration:0.5 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.transform = CGAffineTransformMakeScale(1.2, 1.2);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {        
        [self removeFromSuperview];
    }];
}

// 设置跳过按钮
- (void)showSkipBtnTitleTime:(NSInteger)timeLeave {
    switch (_skipType) {
        case LYADsSkipButtonTypeNormalTimeAndText:
            [self.skipButton setTitle:[NSString stringWithFormat:@"%ld 跳过", (long)timeLeave] forState:UIControlStateNormal];
            break;
        case LYADsSkipButtonTypeNormalText:
            [self.skipButton setTitle:@"跳过" forState:UIControlStateNormal];
            break;
        case LYADsSkipButtonTypeNormalTime:
            [self.skipButton setTitle:[NSString stringWithFormat:@"%ld S", (long)timeLeave] forState:UIControlStateNormal];
            break;
        case LYADsSkipButtonTypeNone:
            self.skipButton.hidden = YES;
            break;
        default:
            break;
    }
}

// 广告图点击相应方法
- (void)tapAction {
    if (_timer) dispatch_source_cancel(_timer);
    [self dismiss];
    // self.adImageTapBlock(@"https://www.mogujie.com");
    // NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:LYADsModelKey];
    // LYADsModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    LYADsModel *model = [LYADsManager shareInstance].adsModel;
    if (model && model.pageURL) {
        NSLog(@"pageURL:%@", model.pageURL);
        if (self.adImageTapBlock) {
            self.adImageTapBlock(model.pageURL);
        }
    }
}

// 跳过按钮响应方法
- (void)skipAction {
    if (_timer) dispatch_source_cancel(_timer);
    [self dismiss];
}

- (void)dealloc {
    NSLog(@"dealloc");
}

@end

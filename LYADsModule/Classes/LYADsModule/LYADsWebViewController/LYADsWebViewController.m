//
//  LYADsWebViewController.m
//  LYADs
//
//  Created by liyu on 2018/11/8.
//

#import "LYADsWebViewController.h"

@interface LYADsWebViewController ()<WKScriptMessageHandler,WKUIDelegate>

@property (nonatomic, strong) NSMutableArray *scriptMessageNames;

@end

@implementation LYADsWebViewController

// 加载URL
- (instancetype)initWithLoadingURL:(NSString *)loadingURL {
    if (self = [super init]) {
        self.loadingURL = loadingURL;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    [self initSuperMainView];
}

- (NSMutableArray *)scriptMessageNames {
    if (_scriptMessageNames == nil) {
        _scriptMessageNames = [NSMutableArray array];
    }
    return _scriptMessageNames;
}

// 初始化主界面
- (void)initSuperMainView {
    // 进度条
    CGFloat height = 0;
    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, height, self.view.frame.size.width, 1)];
    progressView.tintColor = [UIColor redColor];
    progressView.trackTintColor = [UIColor whiteColor];
    [self.view addSubview:progressView];
    self.progressView = progressView;
    
    WKWebViewConfiguration *config = [WKWebViewConfiguration new];
    // 初始化偏好设置属性：preferences
    config.preferences = [WKPreferences new];
    // The minimum font size in points default is 0;
    config.preferences.minimumFontSize = 10;
    // 是否支持JavaScript
    config.preferences.javaScriptEnabled = YES;
    // 不通过用户交互，是否可以打开窗口
    config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    // 网页中内嵌视频可以正常播放，默认不可以
    config.allowsInlineMediaPlayback = YES;
    
    CGFloat offset = 0;
    CGFloat safeArea = 0;
    WKWebView *wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, offset, self.view.frame.size.width, self.view.frame.size.height-offset-safeArea) configuration:config];
    wkWebView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    wkWebView.backgroundColor = [UIColor whiteColor];
    wkWebView.scrollView.bounces = YES;
    wkWebView.scrollView.showsVerticalScrollIndicator = NO;
    wkWebView.scrollView.showsHorizontalScrollIndicator = NO;
    wkWebView.UIDelegate = self;
    wkWebView.navigationDelegate = self;
    self.wkWebView = wkWebView;
    [self.view insertSubview:self.wkWebView belowSubview:progressView];
    [self.wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    [self.wkWebView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];

    [self loadURLRequest];
}

- (void)loadURLRequest {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.loadingURL] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
    [self.wkWebView loadRequest:request];
}

#pragma mark - WKNavigationDelegate

- ( void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"didStartProvisionalNavigation");
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
   // NSLog(@"message.name = %@", message.name);
}

// 如果不添加这个，那么wkwebview跳转不了AppStore
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSString *requestStr = [navigationAction.request.URL.absoluteString stringByRemovingPercentEncoding];
    NSLog(@"requestStr is :%@", requestStr);
    
    if ([webView.URL.absoluteString hasPrefix:@"https://itunes.apple.com"]) {
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
        decisionHandler(WKNavigationActionPolicyCancel);
    }    
    decisionHandler(WKNavigationActionPolicyAllow);
}

// 计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.wkWebView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            self.progressView.hidden = YES;
            [self.progressView setProgress:0 animated:NO];
        }else {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    } else if ([keyPath isEqualToString:@"title"]) {
        if (object == self.wkWebView) {
            self.title = self.wkWebView.title;
        } else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
}

- (void)dealloc {
    [self.wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.wkWebView removeObserver:self forKeyPath:@"title"];

    WKUserContentController *userContentCtrl = self.wkWebView.configuration.userContentController;
    for (NSString *scriptMessageName in self.scriptMessageNames) {
        [userContentCtrl removeScriptMessageHandlerForName:scriptMessageName];
    }
}

// 返回白色
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

// 设置状态栏隐藏
- (BOOL)prefersStatusBarHidden {
    return NO;
}

@end

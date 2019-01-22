//
//  LYADsWebViewController.h
//  LYADs
//
//  Created by liyu on 2018/11/8.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface LYADsWebViewController : UIViewController<WKNavigationDelegate, WKUIDelegate>

@property (strong, nonatomic) WKWebView *wkWebView;
@property (strong, nonatomic) UIProgressView *progressView;
@property (nonatomic, copy) NSString *loadingURL;  

// 加载URL
- (instancetype)initWithLoadingURL:(NSString *)loadingURL;

- (void)loadURLRequest;

@end


//
//  MYWebViewViewController.m
//  gmTestDemo
//
//  Created by lemonmgy on 2017/7/11.
//  Copyright © 2017年 lemonmgy. All rights reserved.
//

#import "MYWebViewViewController.h"
#import <WebKit/WebKit.h>
#import <AVFoundation/AVFoundation.h>

@interface MYWebViewViewController ()<WKUIDelegate, WKNavigationDelegate,WKScriptMessageHandler>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UITextField *textField;
@end

@implementation MYWebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"跳转" style:UIBarButtonItemStylePlain target:self action:@selector(goClick)];
    
 
    NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
    }];
    
//    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
//    WKUserContentController *usercontent = [[WKUserContentController alloc]init];
//    configuration.userContentController = usercontent;
    self.webView = [[WKWebView alloc] initWithFrame:self.view.frame];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    self.webView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.webView];
    
    WKUserScript *script = [[WKUserScript alloc] initWithSource:@"document.getElementById(\"button22\").innerHTML=\"My First JavaScript     Function\";" injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    [self.webView.configuration.userContentController addUserScript:script];
    
    
    //注入js事件 js调用原生方法
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"myrefreshData"];
    
    if (!self.urlString.length) {
        _urlString = @"http://localhost:8888/testhtml/mainPage.html?page=1&num=20";
    }
    NSMutableURLRequest *rq = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.urlString]];
//    rq.HTTPShouldHandleCookies = YES;
    [rq setValue:@"appVersion" forHTTPHeaderField:@"APPVERSION"];
    
    [self.webView loadRequest:rq];
}
- (void)goClick {
//    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",self.textField.text]]]];
//    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://localhost:8888/testhtml/mainPage.html"]]];
    [self.webView evaluateJavaScript:@"document.getElementById(\"button22\").innerHTML=\"My First JavaScript     Function\";" completionHandler:^(id data, NSError * _Nullable error) {
    
    }];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSLog(@"Action == %@",webView.URL);
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    NSLog(@"Response ===%@",webView.URL);
    decisionHandler(WKNavigationResponsePolicyAllow);
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"didStart ==== %@",webView.URL);
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"didReceiveServerRedirectForProvisionalNavigation");
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"didFailProvisionalNavigation");

}

- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
    
    NSLog(@"didCommit ===%@",webView.URL);

}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"didFinishNavigation");
    if (webView.canGoBack) {
        UIBarButtonItem *itemBack = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(leftBtnClick)];
        self.navigationItem.leftBarButtonItems= @[itemBack];
    }
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"didFailNavigation");

}

//- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
//
//    NSLog(@"didReceiveAuthenticationChallenge");
//
//}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView API_AVAILABLE(macosx(10.11), ios(9.0)) {
    NSLog(@"webViewWebContentProcessDidTerminate");

}

//js 调原生
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
//    myrefreshData
    NSLog(@"%@",message.name);
}


- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
    completionHandler();
}


- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    MYWebViewViewController *web = [MYWebViewViewController new];
    web.urlString = navigationAction.request.URL.absoluteString;
    [self.navigationController pushViewController:web animated:YES];
    return nil;
}










#pragma mark 左边的返回被点击了
- (void)leftBtnClick{
    if (self.webView.canGoBack) {
        [self back];
    }else{
        
    }
}

#pragma mark  关闭
- (void)back{
    [self.webView goBack];
}



- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"viewDidDisappear");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

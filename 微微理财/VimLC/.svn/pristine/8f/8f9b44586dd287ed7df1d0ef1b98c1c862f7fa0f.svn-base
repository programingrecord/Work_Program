//
//  TopupWebViewController.m
//  SmallCat
//
//  Created by HMH on 2017/6/26.
//  Copyright © 2017年 HM. All rights reserved.
//

#import "TopupWebViewController.h"
#import "ToUPSureViewController.h"
#import "TopUpResultViewController.h"

@interface TopupWebViewController ()<UIWebViewDelegate>

@property (nonatomic,strong) UIWebView *webview;

@end

@implementation TopupWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"卡密鉴权";
    self.webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kNavigationBarHeight-kStatusBarHeight)];
    self.webview.delegate = self;
    self.webview.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
    self.webview.detectsPhoneNumbers = YES;//自动检测网页上的电
    [self.view addSubview:self.webview];
    
    [self.webview loadHTMLString:self.urlString baseURL:nil];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    MyLog(@"%@",NSStringFromSelector(_cmd));
    
    //OC调用JS是基于协议拦截实现的 下面是相关操作
    NSString *absolutePath = request.URL.absoluteString;
    NSLog(@"absolutePath%@",absolutePath);

    NSString *scheme = @"rrcc://";
    if ([absolutePath hasPrefix:scheme]) {
        
        NSString *subPath = [absolutePath substringFromIndex:scheme.length];
        if ([subPath containsString:@"?"]) {//1个或多个参数
            if ([subPath containsString:@"&"]) {//多个参数
                NSArray *components = [subPath componentsSeparatedByString:@"?"];
                NSString *methodName = [components firstObject];
                methodName = [methodName stringByReplacingOccurrencesOfString:@"_" withString:@":"];
                SEL sel = NSSelectorFromString(methodName);
                
                NSString *parameter = [components lastObject];
                NSArray *params = [parameter componentsSeparatedByString:@"&"];
                
                if (params.count == 2) {
                    if ([self respondsToSelector:sel]) {
                        [self performSelector:sel withObject:[params firstObject] withObject:[params lastObject]];
                    }
                }
            } else {//1个参数
                NSArray *components = [subPath componentsSeparatedByString:@"?"];
                
                NSString *result = [components lastObject];
                if ([result isEqualToString:@"true"]) {
                    ToUPSureViewController *VC = [[ToUPSureViewController alloc] init];
                    VC.AmountStr = self.AmountStr;
                    VC.OrderIdStr = self.OrderIdStr;
                    [self.navigationController pushViewController:VC animated:YES];
                }else{
                    TopUpResultViewController *VC= [[TopUpResultViewController alloc] init];
                    VC.isSucess = NO;
                    VC.isAuth = YES;
                    [self.navigationController pushViewController:VC animated:YES];
                }
            }
        } else {//没有参数
            NSString *methodName = [subPath stringByReplacingOccurrencesOfString:@"_" withString:@":"];
            SEL sel = NSSelectorFromString(methodName);
            
            if ([self respondsToSelector:sel]) {
                [self performSelector:sel];
            }
        }
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [AddHudView removeProgressView:self.view];
}

- (void)BackViewController{
    [self.navigationController popViewControllerAnimated:YES];
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

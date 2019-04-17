//
//  WebViewController.m
//  WTJR
//
//  Created by H on 16/8/15.
//  Copyright © 2016年 HM. All rights reserved.
//

#import "WebViewController.h"
#import "WebviewProgressLine.h"
#import "InviteViewController.h"
#import "InviteListViewController.h"
#import "MSUTradeDetailController.h"

#import "MSUAesTools.h"

#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol JSObjDelegate <JSExport>
- (void) share:(NSString *)shareInfo;
@end

@interface WebViewController ()<UIWebViewDelegate,JSObjDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic,strong) WebviewProgressLine  *progressLine;
@property (nonatomic, strong) JSContext *jsContext;


@end

@implementation WebViewController

#pragma mark  - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(0, 0, kDeviceWidth, 0.5);
    lineView.backgroundColor = HEXCOLOR(0xdedede);
    [self.view addSubview:lineView];
    
    NSURL *url = [[NSURL alloc]initWithString:self.UrlString];
    self.webView.delegate = self;
    self.webView.scalesPageToFit = YES;
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    if (@available(iOS 11.0, *)) {
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    
    self.progressLine = [[WebviewProgressLine alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 2)];
    self.progressLine.lineColor = [UIColor colorWithHex:0xEE451F];
    [self.view addSubview:self.progressLine];
    if ([self.title isEqualToString:@"邀请好友"]) {
        UIButton *listButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [listButton setTitleColor:RGBA(255, 75, 5, 1) forState:UIControlStateNormal];
        [listButton setTitle:@"我的奖励" forState:UIControlStateNormal];
        listButton.titleLabel.font = TEXTFONT(14);
        listButton.frame = CGRectMake(0, 0, 60, 30);
        [listButton addTarget:self action:@selector(RightButtonClick) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:listButton];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
}


#pragma mark - 交互
- (void)RightButtonClick{
    InviteListViewController *VC= [[InviteListViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)LeftNavigationButtonClick:(UIButton *)leftbtn{
    if (self.webView.canGoBack == YES) {
        [self.webView goBack];
    } else{
        NSArray *viewcontrollers=self.navigationController.viewControllers;
        if (viewcontrollers.count>1) {
            if ([viewcontrollers objectAtIndex:viewcontrollers.count-1]==self) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        else{
            //present方式
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

#pragma mark - 代理
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"%@",NSStringFromSelector(_cmd));
    
    //OC调用JS是基于协议拦截实现的 下面是相关操作
    NSString *absolutePath = request.URL.absoluteString;
    NSLog(@"absolutePath--%@",absolutePath);
    
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
                
            } else {//1个参数
                NSArray *components = [subPath componentsSeparatedByString:@"?"];
                
                NSString *result = [components lastObject];
                if ([result isEqualToString:@"true"]) {
                   
                }else{
                }
            }
        } else {//没有参数
            NSString *methodName = [subPath stringByReplacingOccurrencesOfString:@"_" withString:@""];
            SEL sel = NSSelectorFromString(methodName);
            if ([self respondsToSelector:sel]) {
                [self performSelector:sel];
            }
        }
    }
    return YES;
}

- (void)jumpReferrer{
    InviteViewController *VC= [[InviteViewController alloc] init];
    [self.navigationController pushViewController: VC animated:YES];
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    [self.progressLine startLoadingAnimation];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.progressLine endLoadingAnimation];
    
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"registerData"];
    NSString *phoneStr = [dic objectForKey:@"UserName"];
    NSString *pwdStr = [dic objectForKey:@"PassWord"];
    NSString *isActicityStr = [dic objectForKey:@"isActivelog"];
    
    if(phoneStr.length == 0){
        phoneStr = @"";
    }
    if(pwdStr.length == 0){
        pwdStr = @"";
    }
    if(isActicityStr.length == 0){
        isActicityStr = @"";
    }
    
    pwdStr = [MSUAesTools msu_aes_encryt:pwdStr key:AESKey];

    NSString *str = [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"postStr('%@','%@','%@');",phoneStr,pwdStr,isActicityStr]];
    NSLog(@"JS返回值：%@",str);
    
    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.jsContext[@"WTK"] = self;
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self.progressLine endLoadingAnimation];
}

- (void)share:(NSString *)shareInfo;
{
    MyLog(@"====%@",shareInfo);
    if ([shareInfo isEqualToString:@"点击投资"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            AppDelegate *jj = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [jj loadMainView];
            [jj.mainVC setSelectedIndex:1];
        });
    } else if ([shareInfo containsString:@"新手标"]){
        dispatch_async(dispatch_get_main_queue(), ^{
            MSUTradeDetailController *VC = [[MSUTradeDetailController alloc] init];
//            VC.postDic = dic;
            VC.idStr = [NSString stringWithFormat:@"%@",[shareInfo substringFromIndex:3]];
            VC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:VC animated:YES];
        });
    } else if ([shareInfo containsString:@"立即领取"]){
        dispatch_async(dispatch_get_main_queue(), ^{
            AppDelegate *jj = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [jj loadMainView];
            [jj.mainVC setSelectedIndex:3];
        });
    }
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

//
//  MSUWebController.m
//  vvlc
//
//  Created by 007 on 2018/2/7.
//  Copyright © 2018年 HM. All rights reserved.
//

#import "MSUWebController.h"

#import <WebKit/WebKit.h>
#import "WebviewProgressLine.h"

#import "MSUPathTools.h"


@interface MSUWebController ()<WKNavigationDelegate,WKUIDelegate,UIScrollViewDelegate>

@property (nonatomic , strong) WKWebView *webView;
@property (nonatomic,strong) WebviewProgressLine  *progressLine;

@property (nonatomic , strong) UIScrollView *scrollView;

@property (nonatomic , strong) UIView *nodataView;

@end

@implementation MSUWebController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = self.titStr;
    self.view.backgroundColor = LineColor;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    _scrollView.backgroundColor  = LineColor;
    _scrollView.scrollEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:_scrollView];
    if (iOS11) {
        _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    self.webView = [[WKWebView alloc] init];
    if (is_iPhoneX) {
        self.webView.frame = CGRectMake(0, 1, kDeviceWidth, kDeviceHeight-44);
    } else{
        self.webView.frame = CGRectMake(0, 1, kDeviceWidth, kDeviceHeight-64);
    }
    _webView.navigationDelegate = self;
    [self.view addSubview:_webView];
    
    self.progressLine = [[WebviewProgressLine alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 2)];
    self.progressLine.lineColor = [UIColor colorWithHex:0xEE451F];
    [self.view addSubview:self.progressLine];
    
    [self loadRequestWithAFN];
    id traget = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:traget action:nil];
    [self.view addGestureRecognizer:pan];
}


- (void)loadRequestWithAFN{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:self.numStr forKey:@"code"];
    
    [[DataRequestServer getDataRequestServerData] request:@"Lunap2pAppConsultationCenterServlet" parameters:dic result:^(id result) {
        if ([result isKindOfClass:[NSString class]] &&  [result isEqualToString:@"44"]) {
            [AddHudView addProgressView:self.view message:@"网络错误，请稍后再试"];
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            self.nodataView.hidden = YES;

            int success = [[result objectForKey:@"success"]intValue];
            if ([[result objectForKey:@"errorlog"]isEqualToString:@"noLogin"]&& success==0)
            {
                
            }else if([[result objectForKey:@"errorlog"]isEqualToString:@"nofind"]&& success==0)
            {
                self.nodataView.hidden = NO;
            }
            else if([[result objectForKey:@"errorlog"]isEqualToString:@""]&& success==1)
            {
                [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:result[@"url"]]]];
            }else
            {
                [AddHudView addProgressView:self.view message:@"数据获取失败，请重新获取"];
            }
        }
    }];
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
//开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"开始加载网页");
    [self.progressLine startLoadingAnimation];

}

//加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"加载完成");
    [self.progressLine endLoadingAnimation];

}

//加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"加载失败");
    [self.progressLine endLoadingAnimation];
}

- (UIView *)nodataView{
    if (!_nodataView) {
        _nodataView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
        _nodataView.backgroundColor = WhiteColor;
        [self.view addSubview:_nodataView];
        
        UIImageView *imaView = [[UIImageView alloc] initWithFrame:CGRectMake(kDeviceWidth*0.5-50, (kDeviceHeight-64)*0.5-100, 100, 100)];
        imaView.image = [MSUPathTools showImageWithContentOfFileByName:@"Date_Empty"];
        [_nodataView addSubview:imaView];
        
        UILabel *attentionLab = [[UILabel alloc] initWithFrame:CGRectMake(0, imaView.bottom + 10, kDeviceWidth, 20)];
        attentionLab.text = @"暂无数据";
        attentionLab.font = [UIFont systemFontOfSize:13];
        attentionLab.textAlignment = NSTextAlignmentCenter;
        attentionLab.textColor = HEXCOLOR(0x333333);
        [_nodataView addSubview:attentionLab];
        
    }
    return _nodataView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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

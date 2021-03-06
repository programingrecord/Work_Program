//
//  FindViewController.m
//  项目开发
//
//  Created by 姜国军 on 14-5-28.
//  Copyright (c) 2014年 姜国军. All rights reserved.
//

#import "FindViewController.h"
#import "LoginViewController.h"
@interface FindViewController (){
    
     Boolean isMassage;
}

@property (nonatomic,strong) UIButton *Rightbutton;

@end

@implementation FindViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"找回密码";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIView *rightView=[[UIView alloc] init];
    rightView.frame = CGRectMake(_secretText.width-130, 2, 110, 40);
    _secretText.rightView=rightView;
    _secretText.rightViewMode = UITextFieldViewModeAlways;
    
    UIView *leftView=[[UIView alloc] init];
    leftView.frame = CGRectMake(0, 0, 10, 42);
    _secretText.leftView=leftView;
    _secretText.leftViewMode = UITextFieldViewModeAlways;

    
    _Rightbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    _Rightbutton.frame = CGRectMake(10, 5, 100, 30);
    [_Rightbutton setTitle:@"发送验证码" forState:UIControlStateNormal];
    _Rightbutton.titleLabel.font = TEXTFONT(12.0);
    [_Rightbutton setTitleColor:RGBA(228, 228, 228, 1) forState:UIControlStateNormal];
    [_Rightbutton setBackgroundColor:[UIColor clearColor]];
    [_Rightbutton addTarget:self action:@selector(VerifyButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:_Rightbutton];

    secondsCountDown = 60;//60秒倒计时
    [self VerifyButtonClick];
}

- (void)viewWillDisappear:(BOOL)animated{
    [countDownTimer invalidate];
    countDownTimer = nil;
}

#pragma mark - 获取短信验证码
- (void)VerifyButtonClick{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self beginTimer];

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"lunaP2pUserPasswordBean" forKey:@"bean"];
    [params setObject:_ccString forKey:@"c"];
    [params setObject:@"4" forKey:@"type"];
    [params setObject:@"vcodephone" forKey:@"hkey"];
    [params setObject:@"WeiMi" forKey:@"appIdenty"];
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary]
                                objectForKey:@"CFBundleShortVersionString"];
    [params setObject:currentVersion forKey:@"appVersion"];

    NSString *UrlString = [NSString stringWithFormat:@"%@luna_ajax.do", Base_url];
    
    AFHTTPSessionManager *manage = [AFHTTPSessionManager manager];
    manage.requestSerializer = [AFHTTPRequestSerializer serializer];
    manage.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manage.requestSerializer setValue:@"LUNA.APP.U.AGENT" forHTTPHeaderField:@"User-Agent"];
    
    [manage GET:UrlString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        MyLog(@"luna_ajax.do%@",result);
        
        if([[result objectForKey:@"success"]isEqualToString:@"true"] &&[[result objectForKey:@"errorlog"]isEqualToString:@""]){
            [AddHudView addProgressView:self.view message:@"短信验证码已发送，请注意查收"];

        }else if([[result objectForKey:@"errorlog"]isEqualToString:@"1"] && [[result objectForKey:@"success"]isEqualToString:@"false"]){
            [AddHudView addProgressView:self.view message:@"获取短信数量已达到单日短信发送上限"];
        }else{
            [AddHudView addProgressView:self.view message:@"获取激活码失败，您可以重新获取"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[DataRequestServer getDataRequestServerData] requestImportWithUrl:UrlString Error:error urlParams:params];

    }];
}

- (void)beginTimer{
    secondsCountDown =60;
    if (!countDownTimer) {
        countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFunction:) userInfo:nil repeats:YES];
    }else{
        [countDownTimer setFireDate:[NSDate distantPast]];
    }
}

-(void)timeFunction:(NSTimer *)timer{
    if (secondsCountDown == 0) {
        secondsCountDown = 60;
        [_Rightbutton setTitle:@"发送验证码" forState:UIControlStateNormal];
        _Rightbutton.enabled = YES;
        [countDownTimer invalidate];
        countDownTimer = nil;
    }else{
        secondsCountDown--;
        [_Rightbutton setTitle:[NSString stringWithFormat:@"%d秒后获取",secondsCountDown] forState:UIControlStateNormal];
        
        _Rightbutton.enabled = NO;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_secretText resignFirstResponder];
    return YES;
}

- (IBAction)activateButton:(id)sender {
    
     NSMutableDictionary *params1 = [[NSMutableDictionary alloc] init];
     [params1 setObject:_ccString forKey:@"c"];
     [params1 setObject:_secretText.text forKey:@"vcodePhone"];
    
    [[DataRequestServer getDataRequestServerData] request:@"LunaP2pAppMitCodeServlet" parameters:params1 result:^(id result) {
        if ([result isKindOfClass:[NSString class]] &&  [result isEqualToString:@"44"]) {
            [AddHudView addProgressView:self.view message:@"网络错误，请稍后再试"];
        }else{
            MyLog(@"url= %@",result);
            if ([result[@"errorlog"] isEqualToString:@""] && [[result objectForKey:@"success"]intValue] == 1) {
                [AddHudView addProgressView:self.view message:@"新密码已发送到您手机，请注意查收"];
            }else{
                [AddHudView addProgressView:self.view message:@"操作超时，请重新获取"];
            }
        }
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1001) {
       
    }
}



@end

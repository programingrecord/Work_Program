//
//  ForgetViewController.m
//  WTJR
//
//  Created by HM on 16/5/31.
//  Copyright © 2016年 HM. All rights reserved.
//

#import "ForgetViewController.h"
#import "CustomField.h"
#import "MSUResetPWDController.h"

@interface ForgetViewController ()<UITextFieldDelegate>{
    NSTimer                             *countDownTimer;
    int                                 secondsCountDown;
}


@property (weak, nonatomic) IBOutlet UITextField *PhonNum;
@property (weak, nonatomic) IBOutlet UITextField *VerifyNum;
@property (nonatomic,strong) UIButton *Rightbutton;
@property (nonatomic , copy) NSString *cString;

@end

@implementation ForgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"忘记密码";
    
    [self setUI];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyBoard:)];
    [self.view addGestureRecognizer:tapGesture];
    
}

- (void)setUI{
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(0, 0, 120, 54);
    bgView.backgroundColor = HEXCOLOR(0xffffff);
    
    UILabel *attentionLab = [[UILabel alloc] init];
    attentionLab.frame = CGRectMake(19, 0, 120, 54);
    attentionLab.text = @"手机号码";
    attentionLab.font = [UIFont systemFontOfSize:16];
    attentionLab.textColor = HEXCOLOR(0x454545);
    [bgView addSubview:attentionLab];
    
    self.PhonNum.leftViewMode = UITextFieldViewModeAlways;
    self.PhonNum.leftView = bgView;
    
    UIView *bg1View = [[UIView alloc] init];
    bg1View.frame = CGRectMake(0, 0, 120, 54);
    bg1View.backgroundColor = HEXCOLOR(0xffffff);
    
    UILabel *attentionLab1 = [[UILabel alloc] init];
    attentionLab1.frame = CGRectMake(19, 0, 120, 54);
    attentionLab1.text = @"验证码";
    attentionLab1.font = [UIFont systemFontOfSize:16];
    attentionLab1.textColor = HEXCOLOR(0x454545);
    [bg1View addSubview:attentionLab1];

    self.VerifyNum.leftViewMode = UITextFieldViewModeAlways;
    self.VerifyNum.leftView = bg1View;
    
    UIView *lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(18, 64, kDeviceWidth-36, 1);
    lineView.backgroundColor = LineColor;
    [self.view addSubview:lineView];

    _Rightbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    _Rightbutton.frame = CGRectMake(10, 5, 110, 30);
    [_Rightbutton setTitle:@"发送验证码" forState:UIControlStateNormal];
    _Rightbutton.titleLabel.font = TEXTFONT(14.0);
    [_Rightbutton setTitleColor:HEXCOLOR(0x5EA1FF) forState:UIControlStateNormal];
    [_Rightbutton setTitleColor:HEXCOLOR(0xdcdcdc) forState:UIControlStateDisabled];

    [_Rightbutton setBackgroundColor:[UIColor clearColor]];
    [_Rightbutton addTarget:self action:@selector(VerifyButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.VerifyNum.rightView=_Rightbutton;
    self.VerifyNum.rightViewMode = UITextFieldViewModeAlways;
    
    secondsCountDown = 60;//60秒倒计时
}


- (IBAction)nextButtonClick:(id)sender {
    [self KeyboardresignFirstResponder];
   
    if (![VerifyRegexTool checkTelNumber:_PhonNum.text]) {
        [AddHudView addProgressView:self.view message:@"请输入正确的手机号码"];
        return;
    }
    
    if (_VerifyNum.text.length == 0) {
        [AddHudView addProgressView:self.view message:@"请输入验证码"];
        return;
    }
    NSMutableDictionary *prams = [[NSMutableDictionary alloc] init];
    [prams setObject:_PhonNum.text forKey:@"username"];
    [prams setObject:_PhonNum.text forKey:@"userPhone"];
    [prams setObject:_VerifyNum.text forKey:@"vcodePhone"];

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [[DataRequestServer getDataRequestServerData] request:@"LunaP2pAppMitUserServlet" parameters:prams result:^(id result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([result isKindOfClass:[NSString class]] &&  [result isEqualToString:@"44"]) {
            [PAProgressView showInView:self.view  contentString:@"网络错误，请稍后再试"];
        }else{
            self.cString = [result objectForKey:@"c"];
            MyLog(@"LunaP2pAppMitUserServlet= %@",result);
            
            if ([[result objectForKey:@"success"] intValue] == 1 && [[result objectForKey:@"errorlog"] isEqualToString:@""]) {
                MSUResetPWDController *findVC = [[MSUResetPWDController alloc] init];
                findVC.phoneStr = _PhonNum.text;
                [self.navigationController pushViewController:findVC animated:YES];
            }
            if ([[result objectForKey:@"errorlog"] isEqual:@"idPhoneMismatch"])
            {
                [PAProgressView showInView:self.view  contentString:@"输入号码有误或手机号码不存在"];
                return;
            }
            if ([[result objectForKey:@"errorlog"] isEqualToString:@""] && [[result objectForKey:@"success"] intValue] ==0)
            {
                [PAProgressView showInView:self.view  contentString:@"验证错误"];
                return;
            }
        }
    }];
}

- (void)VerifyButtonClick{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self beginTimer];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:self.PhonNum.text forKey:@"phone"];
    [params setObject:@"5" forKey:@"type"];
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
            [PAProgressView showInView:self.view  contentString:@"短信验证码已发送，请注意查收"];

        }else if([[result objectForKey:@"errorlog"]isEqualToString:@"1"] && [[result objectForKey:@"success"]isEqualToString:@"false"]){
            [PAProgressView showInView:self.view  contentString:@"获取短信数量已达到单日短信发送上限"];

        }else{
            [PAProgressView showInView:self.view  contentString:@"获取激活码失败，您可以重新获取"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
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
    [self KeyboardresignFirstResponder];
    return YES;
}

- (void)resignKeyBoard:(UITapGestureRecognizer *)tap{
    [self KeyboardresignFirstResponder];
}

- (void)KeyboardresignFirstResponder{
    if ([_PhonNum isFirstResponder])//判断是否是第一响应
    {
        [_PhonNum resignFirstResponder];
    }
    
    if ([_VerifyNum isFirstResponder])//判断是否是第一响应
    {
        [_VerifyNum resignFirstResponder];
    }
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

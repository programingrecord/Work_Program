//
//  ForgotTradePassVC.m
//  WTJR
//
//  Created by H on 16/8/23.
//  Copyright © 2016年 HM. All rights reserved.
//

#import "ForgotTradePassVC.h"
#import "CustomField.h"
#import "LoginViewController.h"
#import "MSUSetTradePWDController.h"

@interface ForgotTradePassVC ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet CustomField *phonrNum;
@property (weak, nonatomic) IBOutlet CustomField *Verify;
@property (nonatomic,strong)    UIButton *Rightbutton;

@end

@implementation ForgotTradePassVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"忘记交易密码";
    [self setUI];
}

- (void)setUI{
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(0, 0, 36+8, 12);
    bgView.backgroundColor = HEXCOLOR(0xffffff);
    
    UIImageView *passleft = [[UIImageView alloc] init];
    passleft.image = [UIImage imageNamed:@"MSUpassword"];
    passleft.frame = CGRectMake(15, 0, 21, 12);
    passleft.contentMode = UIViewContentModeScaleAspectFit;
    [bgView addSubview:passleft];
    
    self.phonrNum.leftViewMode = UITextFieldViewModeAlways;
    self.phonrNum.leftView = bgView;
    _phonrNum.secureTextEntry = NO;
    [self.phonrNum addTarget:self action:@selector(UITextFieldChange:) forControlEvents:UIControlEventAllEditingEvents];

    UIView *bg1View = [[UIView alloc] init];
    bg1View.frame = CGRectMake(0, 0, 36+8, 15);
    bg1View.backgroundColor = HEXCOLOR(0xffffff);
    
    UIImageView *Verifyleft = [[UIImageView alloc] init];
    Verifyleft.image = [UIImage imageNamed:@"verification-code"];
    Verifyleft.frame = CGRectMake(15, 0, 21, 15);
    Verifyleft.contentMode = UIViewContentModeScaleAspectFit;
    [bg1View addSubview:Verifyleft];

    self.Verify.leftViewMode = UITextFieldViewModeAlways;
    self.Verify.leftView = bg1View;
    
    UIView *rightView=[[UIView alloc] init];
    rightView.frame = CGRectMake(0, 0, 110, 49);
    _Verify.rightView=rightView;
    _Verify.rightViewMode = UITextFieldViewModeAlways;
    self.Verify.keyboardType = UIKeyboardTypeNumberPad;

    self.Rightbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.Rightbutton.frame = CGRectMake(10, 10, 87, 29);
    _Rightbutton.layer.borderColor = HEXCOLOR(0xFB6337).CGColor;
    _Rightbutton.layer.borderWidth = 0.5;
    _Rightbutton.clipsToBounds = YES;
    _Rightbutton.layer.cornerRadius = 4;
    _Rightbutton.layer.shouldRasterize = YES;
    _Rightbutton.layer.rasterizationScale = [UIScreen mainScreen].scale;
    [self.Rightbutton setTitle:@"发送验证码" forState:UIControlStateNormal];
    self.Rightbutton.titleLabel.font = TEXTFONT(12.0);
    [self.Rightbutton setTitleColor:[UIColor colorWithHex:0xFB6337] forState:UIControlStateNormal];
    [self.Rightbutton setBackgroundColor:[UIColor clearColor]];
    [self.Rightbutton addTarget:self action:@selector(getVerifyButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:self.Rightbutton];
    
//    UIView *lineView = [[UIView alloc] init];
//    lineView.frame = CGRectMake(10, 10,1, 25);
//    lineView.backgroundColor = RGBA(229, 229, 229, 1);
//    [rightView addSubview:lineView];
    
    _phonrNum.delegate = self;
    _Verify.delegate = self;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyBoard:)];
    [self.view addGestureRecognizer:tapGesture];
    
    UILabel *introLab = [[UILabel alloc] init];
    introLab.frame = CGRectMake(0, kDeviceHeight-65*kDeviceHeightScale-64*kDeviceHeightScale, kDeviceWidth, 20*kDeviceHeightScale);
    introLab.text = @"如您长时间未收到验证码，可咨询微米客服";
    introLab.font = [UIFont systemFontOfSize:13];
    introLab.textAlignment = NSTextAlignmentCenter;
    introLab.textColor = HEXCOLOR(0xa4a4a4);
    [self.view addSubview:introLab];
    
    UILabel *phoneLab = [[UILabel alloc] init];
    phoneLab.frame = CGRectMake(0, introLab.bottom, kDeviceWidth, 20*kDeviceHeightScale);
    phoneLab.text = @"400-0571-115";
    phoneLab.font = [UIFont systemFontOfSize:13];
    phoneLab.textAlignment = NSTextAlignmentCenter;
    phoneLab.textColor = HEXCOLOR(0xa4a4a4);
    [self.view addSubview:phoneLab];
    
    UIButton *Vbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    Vbtn.frame = CGRectMake(0, kDeviceHeight-65*kDeviceHeightScale-64*kDeviceHeightScale, kDeviceWidth, 40*kDeviceHeightScale);
    [self.view addSubview:Vbtn];
    [Vbtn addTarget:self action:@selector(VbtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)VbtnClick:(UIButton *)sender{
    sender.enabled = NO;
    NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"tel://%@",@"400-0571-115"];
    //    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    
    NSURL *url = [NSURL URLWithString:str];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        if (iOS10) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                if (success) {
                    MyLog(@"hahah");
                    sender.enabled = YES;
                    
                } else{
                    sender.enabled = YES;
                }
            }];
        }else{
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

- (void)getVerifyButtonClick{
    [self KeyboardresignFirstResponder];
    
    __block int timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.Rightbutton setTitle:@"发送验证码" forState:UIControlStateNormal];
                self.Rightbutton.enabled = YES;
            });
        }else{
            NSString *starTime = [NSString stringWithFormat:@"%d秒后获取",timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.Rightbutton setTitle:starTime forState:UIControlStateNormal];
                self.Rightbutton.enabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"1" forKey:@"type"];
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
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        MyLog(@"luna_ajax.do%@",result);
        
        if([[result objectForKey:@"success"]isEqualToString:@"true"] &&[[result objectForKey:@"errorlog"]isEqualToString:@""]){
           [AddHudView addProgressView:self.view message:@"短信验证码已发送，请注意查收"];
        }else if([[result objectForKey:@"errorlog"]isEqualToString:@"1"] && [[result objectForKey:@"success"]isEqualToString:@"false"]){
            [AddHudView addProgressView:self.view message:@"获取短信数量已达到单日短信发送上限"];
            return;
        }else{
            [AddHudView addProgressView:self.view message:@"获取激活码失败，您可以重新获取"];
            return;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [AddHudView addProgressView:self.view message:@"网络错误，请稍后再试"];
        [[DataRequestServer getDataRequestServerData] requestImportWithUrl:UrlString Error:error urlParams:params];
    }];
}

- (IBAction)VerifyButtonClick:(id)sender {
    [self KeyboardresignFirstResponder];
    if (self.phonrNum.text.length==0) {
        [AddHudView addProgressView:self.view message:@"请输入登录密码"];
        return;
    }
    
    if (_Verify.text.length ==0) {
        [AddHudView addProgressView:self.view message:@"请输入验证码"];
        return;
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:_phonrNum.text forKey:@"password"];
    [params setObject:_Verify.text forKey:@"vcodePhone"];

    [[DataRequestServer getDataRequestServerData]request:@"LunaP2pAppNewResetTradePwdservlet" parameters:params result:^(id result) {
        if ([result isKindOfClass:[NSString class]] &&  [result isEqualToString:@"44"]) {
            [AddHudView addProgressView:self.view message:@"网络错误，请稍后再试"];
        }else{
            if ([[result objectForKey:@"success"]intValue]==0 &&[[result objectForKey:@"errorlog"]isEqualToString:@"noLogin"])
            {
                [self requestLogin];
            }else if ([[result objectForKey:@"success"]intValue]==1 &&[[result objectForKey:@"errorlog"]isEqualToString:@""])
            {
                [AddHudView addProgressView:self.view message:@"验证成功"];
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    MSUSetTradePWDController *set = [[MSUSetTradePWDController alloc] init];
                    set.signStr = @"account";
                    set.pwdType = MSUSetPwd;
                    set.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:set animated:YES];
                });
            }else if([[result objectForKey:@"errorlog"]isEqualToString:@"vcodePhoneFailed"]){
                [AddHudView addProgressView:self.view message:@"您输入的手机验证码有误"];

            }else{
                [AddHudView addProgressView:self.view message:@"重置失败,请稍后再试"];
            }
        }
    }];
}

- (void)requestLogin{
    [[DataRequestServer getDataRequestServerData] requestLoginresult:^(NSString *LoginState) {
        if ([LoginState isEqualToString:@"true"]) {
            
        }else{
            [AddHudView addProgressView:self.view message:@"登录失效，请重新登录"];
            double delayInSeconds = 1.0;
            __weak __block ForgotTradePassVC* BlockVC = self;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                LoginViewController *loginVc= [[LoginViewController alloc] init];
                loginVc.loginType = logintypeOutTime;
                loginVc.hidesBottomBarWhenPushed = YES;

                [BlockVC.navigationController pushViewController:loginVc animated:YES];
            });
        }
    }];
}

- (void)popViewController{
    [self .navigationController popViewControllerAnimated:YES];
}

#pragma mark - 键盘
- (void)resignKeyBoard:(UITapGestureRecognizer *)tap{
    [self KeyboardresignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self KeyboardresignFirstResponder];
    return YES;
}

- (void)KeyboardresignFirstResponder
{
    if ([_phonrNum isFirstResponder])//判断是否是第一响应
    {
        [_phonrNum resignFirstResponder];
    }
    
    if ([_Verify isFirstResponder])//判断是否是第一响应
    {
        [_Verify resignFirstResponder];
    }
}

- (void)UITextFieldChange:(UITextField *)sender{
//    if (self.phonrNum.text.length > 6 && [self.title isEqualToString:@"重置交易密码"]) {
//        self.phonrNum.text = [sender.text substringToIndex:6];;
//    }
//
//    if ([self.phonrNum.text isEqualToString:@"123456"] || [self.phonrNum.text isEqualToString:@"234567"] || [self.phonrNum.text isEqualToString:@"345678"] || [self.phonrNum.text isEqualToString:@"456789"] || [self.phonrNum.text isEqualToString:@"012345"] || [self.phonrNum.text isEqualToString:@"543210"] || [self.phonrNum.text isEqualToString:@"654321"] || [self.phonrNum.text isEqualToString:@"765432"] || [self.phonrNum.text isEqualToString:@"876543"] || [self.phonrNum.text isEqualToString:@"987654"]) {
//        [PAProgressView showInView:self.view contentString:@"交易密码不得为6位连续数字"];
//        self.phonrNum.text = @"";
//    } else if ([self.phonrNum.text isEqualToString:@"000000"] || [self.phonrNum.text isEqualToString:@"111111"] || [self.phonrNum.text isEqualToString:@"222222"] || [self.phonrNum.text isEqualToString:@"333333"] || [self.phonrNum.text isEqualToString:@"444444"] || [self.phonrNum.text isEqualToString:@"555555"] || [self.phonrNum.text isEqualToString:@"666666"] || [self.phonrNum.text isEqualToString:@"777777"] || [self.phonrNum.text isEqualToString:@"888888"] || [self.phonrNum.text isEqualToString:@"999999"]){
//
//        [PAProgressView showInView:self.view contentString:@"交易密码不得为6位重复数字"];
//        self.phonrNum.text = @"";
//    }
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

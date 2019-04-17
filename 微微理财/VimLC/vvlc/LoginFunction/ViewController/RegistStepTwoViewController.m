//
//  RegistStepTwoViewController.m
//  vvlc
//
//  Created by HM on 2017/7/26.
//  Copyright © 2017年 HM. All rights reserved.
//

#import "RegistStepTwoViewController.h"
#import "CustomField.h"
#import "LoginViewController.h"
#import <AdSupport/AdSupport.h>

#import "GesturePasswordController.h"

#import <UMAnalytics/MobClick.h>


@interface RegistStepTwoViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *TipstrLabel;
@property (weak, nonatomic) IBOutlet CustomField *PassWord;
@property (weak, nonatomic) IBOutlet CustomField *RelationPeople;
@property (weak, nonatomic) IBOutlet CustomField *PhoneVerify;

@property (nonatomic,strong) UIButton *VerifyRightButton;
@property (nonatomic,strong)    UIButton *PhoneRightbutton;

@property (weak, nonatomic) IBOutlet UIButton *inviteButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ButtonSpace;

@property (nonatomic , strong) CustomField *veriTF;
@property (nonatomic,strong)GesturePasswordController *gesturePassWord;

@end

@implementation RegistStepTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUIDetail];

}

- (void)setUIDetail{
    NSString * Str= [NSString stringWithFormat:@"已向手机%@发送短信请注意查收",self.PhoneStr];
    NSRange range1= [Str rangeOfString:self.PhoneStr];

    NSMutableAttributedString *Astring1 = [[NSMutableAttributedString alloc] initWithString:Str];
    [Astring1 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0xFB6337] range:range1];
    self.TipstrLabel.attributedText = Astring1;
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0x222222],NSFontAttributeName: [UIFont systemFontOfSize:18]}];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self createLeftNavigationItem:[UIImage imageNamed:@"nav_icon_back_nor"]];
    self.navigationItem.title = @"注册";
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    [self.view addGestureRecognizer:tap];
    
    self.veriTF = [[CustomField alloc] init];
    _veriTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入图片验证码" attributes:@{NSForegroundColorAttributeName: HEXCOLOR(0xc3c3c3)}];
    _veriTF.frame = CGRectMake(10*kDeviceWidthScale, 107, kDeviceWidth-20*kDeviceWidthScale, 55);
    _veriTF.font = [UIFont systemFontOfSize:16];
    _veriTF.textColor = HEXCOLOR(0x333333);
    [self.view addSubview:_veriTF];
    
    self.VerifyRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.VerifyRightButton.frame = CGRectMake(0, 0, 80, 36);
    [self.VerifyRightButton addTarget:self action:@selector(getImage) forControlEvents:UIControlEventTouchUpInside];
    [self.VerifyRightButton setAdjustsImageWhenHighlighted:NO];
    [self getImage];
    _veriTF.rightView=self.VerifyRightButton;
    _veriTF.rightViewMode = UITextFieldViewModeAlways;
    
    self.PhoneRightbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.PhoneRightbutton.frame = CGRectMake(10, 0, 100, 45);
    [self.PhoneRightbutton setTitle:@"发送验证码" forState:UIControlStateNormal];
    self.PhoneRightbutton.titleLabel.font = TEXTFONT(12.0);
    [self.PhoneRightbutton setTitleColor:[UIColor colorWithHex:0x5381ff] forState:UIControlStateNormal];
    [self.PhoneRightbutton setBackgroundColor:[UIColor clearColor]];
    [self.PhoneRightbutton addTarget:self action:@selector(getVerifyButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.PhoneVerify.rightView  = self.PhoneRightbutton;
    self.PhoneVerify.rightViewMode = UITextFieldViewModeAlways;

    [self beginCountbackwards:60];
}

- (void)beginCountbackwards:(int)timeNum{
    __block int time = timeNum;
    
    __block UIButton *verifybutton = self.PhoneRightbutton;
    verifybutton.enabled = NO;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(time<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [verifybutton setTitle:@"获取验证码" forState:UIControlStateNormal];
                verifybutton.enabled = YES;
                [verifybutton setTitleColor:[UIColor colorWithHex:0xF26059] forState:UIControlStateNormal];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                NSString *strTime = [NSString stringWithFormat:@"重新发送(%d)",time];
                [verifybutton setTitle:strTime forState:UIControlStateNormal];
                [verifybutton setTitleColor:[UIColor colorWithHex:0x999999] forState:UIControlStateNormal];
                verifybutton.enabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}

- (void)getVerifyButtonClick{
    [self beginCountbackwards:60];

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:self.PhoneStr forKey:@"phone"];
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
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"luna_ajax.do%@",result);
        
        if([[result objectForKey:@"success"]isEqualToString:@"true"] &&[[result objectForKey:@"errorlog"]isEqualToString:@""]){
            [AddHudView addProgressView:self.view message:@"短信验证码已发送，请注意查收"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
            });
        }else if ([[result objectForKey:@"errorlog"]isEqualToString:@"phoneIsExist"] &&[[result objectForKey:@"success"]isEqualToString:@"false"]) {
            
            [UIAlertTool showAlertView:self TitleString:@"该手机号已被注册" MessageString:nil CancelButtonString:@"去登录" OhterButtonString:@"联系客服" confirmBlock:^{
                NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"400-0571-115"];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            } cancleBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
            
        }else if ([[result objectForKey:@"errorlog"]isEqualToString:@"-88"] &&[[result objectForKey:@"success"]isEqualToString:@"false"]) {
            [UIAlertTool showAlertView:self TitleString:@"非法获取短信验证码" MessageString:nil CancelButtonString:@"取消" OhterButtonString:@"联系客服" confirmBlock:^{
                NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"400-0571-115"];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            } cancleBlock:^{
                
            }];
        }
        else if ([[result objectForKey:@"errorlog"]isEqualToString:@"1"] &&[[result objectForKey:@"success"]isEqualToString:@"false"]) {
            [UIAlertTool showAlertView:self TitleString:@"获取短信数量已达到单日短信发送上限" MessageString:nil CancelButtonString:@"取消" OhterButtonString:@"联系客服" confirmBlock:^{
                NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"400-0571-115"];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            } cancleBlock:^{
                
            }];
        }
        else if ([[result objectForKey:@"errorlog"]isEqualToString:@"2"] &&[[result objectForKey:@"success"]isEqualToString:@"false"]) {
            
        }else{
            [UIAlertTool showAlertView:self TitleString:@"获取短信验证码失败，您可以重新获取" MessageString:nil CancelButtonString:@"取消" OhterButtonString:@"重新获取" confirmBlock:^{
                [self getVerifyButtonClick];
            } cancleBlock:^{
                
            }];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[DataRequestServer getDataRequestServerData] requestImportWithUrl:UrlString Error:error urlParams:params];

    }];
}

- (void)getImage{
    [NetworkTools GetImageFromUrlString:VerifyImageUrl withParams:nil andResultBlock:^(UIImage *imageData) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.VerifyRightButton setImage:imageData forState:UIControlStateNormal];
        });
    } andfail:^{
        
    }];
}

- (IBAction)SureRegistButtonClick:(id)sender {
    [self checkTextFieldeRsponder];
    NSString *passWordStr = [self.PassWord.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (passWordStr.length ==0 || passWordStr.length<6
        || passWordStr.length>20) {
        [AddHudView addProgressView:self.view message:@"请您设置6-20位的密码"];
        return;
    }
    if ([_veriTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length==0){
        [AddHudView addProgressView:self.view message:@"请输入正确的图片验证码"];
        return;
    }
    if ([_PhoneVerify.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length==0){
        [AddHudView addProgressView:self.view message:@"请输入正确的短信验证码"];
        return;
    }
    
    NSString* phoneStr = [self.PhoneStr stringByReplacingOccurrencesOfString:@" " withString:@""];

    NSMutableDictionary *parms = [NSMutableDictionary dictionary];
    [parms setObject:phoneStr forKey:@"userPhone"];
    [parms setObject:self.PassWord.text forKey:@"originalPassowrd"];
    if ([self.RelationPeople.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length >0) {
        [parms setObject:self.RelationPeople.text forKey:@"referrerByInput"];
    }
    [parms setObject:self.PhoneVerify.text forKey:@"vcodePhone"];
    [parms setObject:@"7" forKey:@"appCode"];
    [parms setObject:_veriTF.text forKey:@"vcodeImage"];
    
    MyLog(@"-----%@",parms);

    NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    if (adId != nil && adId.length>0) {
        [parms setObject:adId forKey:@"idfa"];
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[DataRequestServer getDataRequestServerData] request:@"LunaP2pAppNewRegisterServlet" parameters:parms result:^(id result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([result isKindOfClass:[NSString class]] &&  [result isEqualToString:@"44"]) {
            [AddHudView addProgressView:self.view message:@"网络错误，请稍后再试"];
            
        }else{
            [self.view endEditing:YES];

            if ([[result objectForKey:@"errorlog"] isEqualToString:@""] && [[result objectForKey:@"success"]intValue] ==1) {
                
                NSDictionary *registerData = [NSDictionary dictionaryWithObjectsAndKeys:self.PhoneStr,@"UserName",self.PassWord.text,@"PassWord",@"true",@"isActivelog", nil];
                [[NSUserDefaults standardUserDefaults] setObject:registerData forKey:@"registerData"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [AddHudView addProgressView:self.view message:@"注册成功"];
                
                [MobClick profileSignInWithPUID:@"phoneStr"];

//                [MobClick event:@"register" label:@"注册成功"];
                [MobClick event:@"register" durations:2];
                
                _gesturePassWord = [[GesturePasswordController alloc] init];
                _gesturePassWord.gestureType = GestureSet;
                [[UIApplication sharedApplication].keyWindow addSubview:_gesturePassWord.view];
            }else
            {
                if ([[result objectForKey:@"errorlog"] isEqualToString:@"usernameExisted"]) {
                    [AddHudView addProgressView:self.view message:@"手机号码已经存在"];
                    
                }else if([[result objectForKey:@"errorlog"] isEqualToString:@"vcodeError"]){
                    [AddHudView addProgressView:self.view message:@"图片验证码错误"];
                }else if([[result objectForKey:@"errorlog"] isEqualToString:@"usernameIllegal"]){
                    [AddHudView addProgressView:self.view message:@"请您输入不含特殊字符的手机号码"];
                    
                }else if([[result objectForKey:@"errorlog"] isEqualToString:@"referrerError"]){
                    [AddHudView addProgressView:self.view message:@"请您输入正确的推荐人"];
                }
                else if([[result objectForKey:@"errorlog"] isEqualToString:@"vcodePhoneFailed"]){
                    [AddHudView addProgressView:self.view message:@"手机验证码错误"];
                }else{
                    [AddHudView addProgressView:self.view message:@"注册失败，您可以尝试重新操作"];
                }
            }
        }
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self checkTextFieldeRsponder];
    return YES;
}

- (void)tapClick{
    [self checkTextFieldeRsponder];
}

- (void)checkTextFieldeRsponder{
    if ([self.PhoneVerify isFirstResponder]) {
        [self.PhoneVerify resignFirstResponder];
    }
    if ([self.RelationPeople isFirstResponder]) {
        [self.RelationPeople resignFirstResponder];
    }
    
    if ([self.PassWord isFirstResponder]) {
        [self.PassWord resignFirstResponder];
    }
}

- (IBAction)InviteButtonClick:(id)sender {
    self.ButtonSpace.constant = 95;
    self.RelationPeople.hidden = NO;
    self.inviteButton.hidden = YES;
}


@end

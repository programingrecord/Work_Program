//
//  ToUPSureViewController.m
//  SmallCat
//
//  Created by H on 2017/6/15.
//  Copyright © 2017年 HM. All rights reserved.
//

#import "ToUPSureViewController.h"
#import "CustomField.h"
#import "CustomUIEdgeInsetLabel.h"
#import "TopUpResultViewController.h"
#import "LoginViewController.h"
#import "TopUpViewController.h"

@interface ToUPSureViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *OrderNumLable;
@property (weak, nonatomic) IBOutlet UILabel *TOUPMoneyLable;
@property (weak, nonatomic) IBOutlet UITextField *PhoneCodeField;
@property (weak, nonatomic) IBOutlet UIButton *SureButton;
@property (nonatomic,strong) UIButton *Rightbutton;

@end

@implementation ToUPSureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"充值";
    [AddHudView addProgressView:self.view message:@"短信验证码已发送，请注意查收"];
    [self createUI];
    [self timeCount];
}

- (void)createUI{
     UIView *leftView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 45)];
    _PhoneCodeField.leftView = leftView;
    _PhoneCodeField.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *rightView=[[UIView alloc] init];
    rightView.frame = CGRectMake(_PhoneCodeField.width-130, 2, 110, 45);
    _PhoneCodeField.rightView = rightView;
    _PhoneCodeField.rightViewMode = UITextFieldViewModeAlways;
    
    self.Rightbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.Rightbutton.frame = CGRectMake(10, 7, 100, 30);
    [self.Rightbutton setTitle:@"发送验证码" forState:UIControlStateNormal];
    self.Rightbutton.titleLabel.font = TEXTFONT(12.0);
    [self.Rightbutton setTitleColor:[UIColor colorWithHex:0xFB6337] forState:UIControlStateNormal];
    [self.Rightbutton setBackgroundColor:[UIColor clearColor]];
    [self.Rightbutton addTarget:self action:@selector(VerifyButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:self.Rightbutton];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(10, 15,1, 15);
    lineView.backgroundColor = RGBA(229, 229, 229, 1);
    [rightView addSubview:lineView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyBoard:)];
    [self.view addGestureRecognizer:tapGesture];

    self.TOUPMoneyLable.text = [NSString stringWithFormat:@"¥ %@",self.AmountStr];
    self.OrderNumLable.text = [NSString stringWithFormat:@"订单编号：%@",self.OrderIdStr];
}

- (IBAction)SureButtonclick:(id)sender {
    [self KeyboardresignFirstResponder];
    if (self.PhoneCodeField.text.length<3) {
        [AddHudView addProgressView:self.view message:@"请输入正确的短信验证码"];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:@"2" forKey:@"payConfigId"];
    [param setObject:self.OrderIdStr forKey:@"orderNo"];
    [param setObject:self.PhoneCodeField.text forKey:@"checkCode"];

    [[DataRequestServer getDataRequestServerData] request:@"LunaP2pAppOnlinePayServlet" parameters:param result:^(id result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([result isKindOfClass:[NSString class]] &&  [result isEqualToString:@"44"]) {
            [AddHudView addProgressView:self.view message:@"网络错误，请稍后再试"];
        }else if([[result objectForKey:@"success"]intValue]==0 && [[result objectForKey:@"errorlog"]isEqualToString:@"noLogin"]){
            [self requestLogin];
        }else if([[result objectForKey:@"success"]intValue]==1 && [[result objectForKey:@"errorlog"]isEqualToString:@""]){
            TopUpResultViewController *VC= [[TopUpResultViewController alloc] init];
            VC.isSucess = YES;
            VC.AmountStr = self.AmountStr;
            [self.navigationController pushViewController:VC animated:YES];
            [TalkingData trackEvent:@"资金充值" label:@"资金充值"];
        }else{
            if ([result objectForKey:@"errorlog"] && [[result objectForKey:@"errorlog"] isEqualToString:@"验证码错误"]) {
                [AddHudView addProgressView:self.view message:[result objectForKey:@"errorlog"]];
            }else{
                [AddHudView addProgressView:self.view message:[result objectForKey:@"errorlog"] != nil? [result objectForKey:@"errorlog"]:@"充值失败，请稍后再试"];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    TopUpResultViewController *VC= [[TopUpResultViewController alloc] init];
                    VC.isSucess = NO;
                    VC.isAuth = NO;
                    [self.navigationController pushViewController:VC animated:YES];
                });
            }
        }
    }];
}

- (void)VerifyButtonClick{
    [self timeCount];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:@"2" forKey:@"payConfigId"];
    [param setObject:self.OrderIdStr forKey:@"orderNo"];

    [[DataRequestServer getDataRequestServerData] request:@"LunaP2pAppOnlineSendSmsServlet" parameters:param result:^(id result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([result isKindOfClass:[NSString class]] &&  [result isEqualToString:@"44"]) {
            [AddHudView addProgressView:self.view message:@"网络错误，请稍后再试"];
        }else if([[result objectForKey:@"success"]intValue]==0 && [[result objectForKey:@"errorlog"]isEqualToString:@"noLogin"]){
            [self requestLogin];
        }else if([[result objectForKey:@"success"]intValue]==1 && [[result objectForKey:@"errorlog"]isEqualToString:@""]){
            [AddHudView addProgressView:self.view message:@"短信验证码已发送，请注意查收"];
        }
        else{
            [AddHudView addProgressView:self.view message:@"短信验证码发送失败，请稍后再试"];
        }
    }];
}

- (void)KeyboardresignFirstResponder
{
    if ([_PhoneCodeField isFirstResponder])//判断是否是第一响应
    {
        [_PhoneCodeField resignFirstResponder];
    }
}

- (void)requestLogin{
    [[DataRequestServer getDataRequestServerData] requestLoginresult:^(NSString *LoginState) {
        if ([LoginState isEqualToString:@"true"]) {
//            [self RequestUserInfo:NO];
        }else{
            [AddHudView addProgressView:self.view message:@"登录失效，请重新登录"];
            double delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                LoginViewController *loginVc= [[LoginViewController alloc] init];
                loginVc.loginType = logintypeOutTime;
                loginVc.hidesBottomBarWhenPushed = YES;

                [self.navigationController pushViewController:loginVc animated:YES];
            });
        }
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self KeyboardresignFirstResponder];
    return YES;
}

- (void)resignKeyBoard:(UITapGestureRecognizer *)tap{
    [self KeyboardresignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)timeCount{
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
}

- (void)BackViewController{
    NSArray *temArray = self.navigationController.viewControllers;
    for(UIViewController *temVC in temArray)
    {
        if ([temVC isKindOfClass:[TopUpViewController class]])
        {
            [self.navigationController popToViewController:temVC animated:YES];
            return;
        }
    }
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

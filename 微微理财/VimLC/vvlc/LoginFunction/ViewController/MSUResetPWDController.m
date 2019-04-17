//
//  MSUResetPWDController.m
//  ZMLC
//
//  Created by 007 on 2018/2/28.
//  Copyright © 2018年 HM. All rights reserved.
//

#import "MSUResetPWDController.h"
#import "LoginViewController.h"

#import "MSUCustomTF2.h"
#import "MSUPathTools.h"

@interface MSUResetPWDController ()<UITextFieldDelegate,UIGestureRecognizerDelegate>

@property (nonatomic , strong) UITextField *pwdTF;
@property (nonatomic , strong) UITextField *pwdAgainTF;


@end

@implementation MSUResetPWDController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"修改密码";
    self.view.backgroundColor = HEXCOLOR(0xE4E4E4);
    
    [self CreateCenterView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
    tap.delegate = self;
    tap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tap];
}

- (void)tapView:(UITapGestureRecognizer *)sender{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)CreateCenterView{
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(0, 13*kDeviceHeightScale, kDeviceWidth, 13*kDeviceHeightScale+55*2);
    bgView.backgroundColor = HEXCOLOR(0xffffff);
    [self.view addSubview:bgView];
    
    /// 手机输入框
    self.pwdTF = [[UITextField alloc] init];
    _pwdTF.frame = CGRectMake(17, 0, kDeviceWidth-34, 55);
    _pwdTF.font = [UIFont systemFontOfSize:16];
    NSDictionary *dic = @{NSForegroundColorAttributeName:HEXCOLOR(0xdcdcdc), NSFontAttributeName:[UIFont systemFontOfSize:16]};
    _pwdTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入您的密码" attributes:dic];
    _pwdTF.tintColor = titOrangeColor;
    _pwdTF.textColor = HEXCOLOR(0x333333);
    _pwdTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _pwdTF.delegate = self;
    _pwdTF.secureTextEntry = YES;
    [bgView addSubview:_pwdTF];
    
    UIButton *passWordRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    passWordRightButton.frame = CGRectMake(0, 0, 40, 55);
    passWordRightButton.selected = NO;
    [passWordRightButton addTarget:self action:@selector(passWordRightButtonclick:) forControlEvents:UIControlEventTouchUpInside];
    [passWordRightButton setImage:[UIImage imageNamed:@"login_pass_right"] forState:UIControlStateNormal];
    [passWordRightButton setImage:[UIImage imageNamed:@"login_pass_right_open"] forState:UIControlStateSelected];
    self.pwdTF.rightView=passWordRightButton;
    self.pwdTF.rightViewMode = UITextFieldViewModeAlways;
    
    UIView *line1View = [[UIView alloc] init];
    line1View.frame = CGRectMake(17, _pwdTF.bottom+5, kDeviceWidth-17, 0.5);
    line1View.backgroundColor = HEXCOLOR(0xededed);
    [bgView addSubview:line1View];
    
    /// 密码输入框
    self.pwdAgainTF = [[UITextField alloc] init];
    _pwdAgainTF.frame = CGRectMake(17,line1View.bottom , kDeviceWidth-34, 55);
    _pwdAgainTF.font = [UIFont systemFontOfSize:16];
    _pwdAgainTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请再次输入您的密码" attributes:dic];
    _pwdAgainTF.tintColor = titOrangeColor;
    _pwdAgainTF.textColor = HEXCOLOR(0x333333);
    //    _pwdTF.keyboardType = UIKeyboardTypeNumberPad;
    _pwdAgainTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _pwdAgainTF.delegate = self;
    _pwdAgainTF.secureTextEntry = YES;
    [bgView addSubview:_pwdAgainTF];

    UIButton *passWordRightButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    passWordRightButton1.frame = CGRectMake(0, 0, 40, 55);
    passWordRightButton1.selected = NO;
    [passWordRightButton1 addTarget:self action:@selector(passWordRightButton1click:) forControlEvents:UIControlEventTouchUpInside];
    [passWordRightButton1 setImage:[UIImage imageNamed:@"login_pass_right"] forState:UIControlStateNormal];
    [passWordRightButton1 setImage:[UIImage imageNamed:@"login_pass_right_open"] forState:UIControlStateSelected];
    self.pwdAgainTF.rightView=passWordRightButton1;
    self.pwdAgainTF.rightViewMode = UITextFieldViewModeAlways;

    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(22,_pwdAgainTF.bottom + 40*kDeviceHeightScale, kDeviceWidth-44, 45);
    sureBtn.backgroundColor = HEXCOLOR(0Xf54e4e);
    sureBtn.layer.cornerRadius = 45*0.5;
    sureBtn.clipsToBounds = YES;
    sureBtn.layer.shouldRasterize = YES;
    sureBtn.layer.rasterizationScale = [UIScreen mainScreen].scale;
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:sureBtn];
    [sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 点击
- (void)passWordRightButtonclick:(UIButton *)sender{
    sender.selected = !sender.selected;
    self.pwdTF.secureTextEntry = !sender.selected;
}

- (void)passWordRightButton1click:(UIButton *)sender{
    sender.selected = !sender.selected;
    self.pwdAgainTF.secureTextEntry = !sender.selected;
}

- (void)sureBtnClick:(UIButton *)sender{
    [self KeyboardresignFirstResponder];
    if (_pwdTF.text.length == 0) {
        [PAProgressView showInView:self.view  contentString:@"请输入密码"];
        return;
    }
    if (_pwdAgainTF.text.length == 0) {
        [PAProgressView showInView:self.view  contentString:@"请输入您的确认密码"];
        return;
    }
    
    if (![_pwdTF.text isEqualToString:_pwdAgainTF.text]) {
        [PAProgressView showInView:self.view  contentString:@"两次输入密码不相符"];
        return;
    }
    
    NSMutableDictionary *prams = [[NSMutableDictionary alloc] init];
    [prams setObject:self.phoneStr forKey:@"PhoneNumber"];
    [prams setObject:_pwdAgainTF.text forKey:@"NewPaswad"];

    [[DataRequestServer getDataRequestServerData] request:@"LunaP2pAppNewPaswadServlet" parameters:prams result:^(id result) {
        
        if ([result isKindOfClass:[NSString class]] &&  [result isEqualToString:@"44"]) {
            [PAProgressView showInView:self.view  contentString:@"网络错误，请稍后再试"];
        }else{
            NSString *value = [result objectForKey:@"errorlog"];
            int  success = [[result objectForKey:@"success"]intValue];
            if ([value isEqualToString:@""]&& success==1)
            {
                [PAProgressView showInView:self.view  contentString:@"重置密码成功"];

                for (UIViewController *vc in self.navigationController.viewControllers) {
                    if ([vc isKindOfClass:[LoginViewController class]]) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"phoneMsuStr" object:nil userInfo:@{@"phoneStr":self.phoneStr}];
                        [self.navigationController popToViewController:vc animated:YES];
                    }
                }
            }
            //登录失败的处理
            else
            {
                [PAProgressView showInView:self.view  contentString:@"验证失败"];
            }
        }
    }];
}

- (void)KeyboardresignFirstResponder
{
    if ([_pwdTF isFirstResponder])//判断是否是第一响应
    {
        [_pwdTF resignFirstResponder];
    }
    
    if ([_pwdAgainTF isFirstResponder])//判断是否是第一响应
    {
        [_pwdAgainTF resignFirstResponder];
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

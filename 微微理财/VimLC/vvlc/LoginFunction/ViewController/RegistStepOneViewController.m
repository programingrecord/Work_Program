//
//  RegistStepOneViewController.m
//  vvlc
//
//  Created by HM on 2017/7/26.
//  Copyright © 2017年 HM. All rights reserved.
//

#import "RegistStepOneViewController.h"
#import "CustomField.h"
#import "RegistStepTwoViewController.h"
#import "WebViewController.h"
#import "ForgetViewController.h"

@interface RegistStepOneViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *NextButton;
@property (weak, nonatomic) IBOutlet CustomField *phoneTextField;
@property (weak, nonatomic) IBOutlet UILabel *WarmLabel;

@property (nonatomic,strong) NSString       *previousTextFieldContent;
@property (nonatomic,strong) UITextRange    *previousSelection;

@end


@implementation RegistStepOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUIDetail];
    [self.phoneTextField becomeFirstResponder];
    self.phoneTextField.inputAccessoryView = [self addToolbar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 创建视图
- (void)setUIDetail{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0x222222],NSFontAttributeName: [UIFont systemFontOfSize:18]}];
    
    self.NextButton.enabled = NO;
    self.NextButton.backgroundColor = [UIColor colorWithHex:0xFB6337 alpha:0.5];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self createLeftNavigationItem:[UIImage imageNamed:@"nav_icon_back_nor"]];
    self.navigationItem.title = @"注册";
    [_phoneTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    [self.view addGestureRecognizer:tap];
    
    UIView *View = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 85, self.phoneTextField.height)];
    self.phoneTextField.leftView=View;
    self.phoneTextField.leftViewMode = UITextFieldViewModeAlways;
    self.phoneTextField.tintColor = titOrangeColor;
    
    UILabel *lable1 =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 25,View.height)];
    lable1.textColor = [UIColor colorWithHex:0xDCDCDC];
    lable1.font = TEXTFONT(17);
    lable1.text = @"CN";
    [View addSubview:lable1];
    
    UILabel *lable2 =[[UILabel alloc] initWithFrame:CGRectMake(lable1.right+5, 0, 40,View.height)];
    lable2.textAlignment = NSTextAlignmentCenter;
    lable2.textColor = [UIColor colorWithHex:0x4A4A4A];
    lable2.font = TEXTFONT(15);
    lable2.text = @"＋86";
    [View addSubview:lable2];
}

- (UIToolbar *)addToolbar {
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 40)];
    toolbar.tintColor = [UIColor colorWithHex:0x4A90E2];
    toolbar.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *flbSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"完成",nil) style:UIBarButtonItemStylePlain target:self action:@selector(textFieldDone)];
    toolbar.items = @[flbSpace,doneItem];
    return toolbar;
}

- (void)textFieldDone{
    [self.view endEditing:YES];
}

#pragma mark - 代理
- (void)textFieldDidChange:(UITextField *)filed{
    if (filed == self.phoneTextField) {
        if (filed.text.length > 13) {
            filed.text = [filed.text substringToIndex:13];
        }
        NSUInteger targetCursorPosition = [filed offsetFromPosition:filed.beginningOfDocument toPosition:filed.selectedTextRange.start];
        
        NSString* nStr = [filed.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString* preTxt = [self.previousTextFieldContent stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        char editFlag = 0;// 正在执行删除操作时为0，否则为1
        if (nStr.length <= preTxt.length) {
            editFlag = 0;
        }else{
            editFlag = 1;
        }
        
        NSString* spaceStr = @" ";
        NSMutableString *mStrTemp = [NSMutableString string];
        
        int spaceCount = 0;
        if (nStr.length < 3 && nStr.length > -1) {
            spaceCount = 0;
        }else if (nStr.length < 7&& nStr.length > 2){
            spaceCount = 1;
        }else if (nStr.length < 12&& nStr.length > 6){
            spaceCount = 2;
        }
        for (int i = 0; i < spaceCount; i++){
            if (i == 0) {
                [mStrTemp appendFormat:@"%@%@", [nStr substringWithRange:NSMakeRange(0, 3)],spaceStr];
            }else if (i == 1){
                [mStrTemp appendFormat:@"%@%@", [nStr substringWithRange:NSMakeRange(3, 4)], spaceStr];
            }else if (i == 2){
                [mStrTemp appendFormat:@"%@%@", [nStr substringWithRange:NSMakeRange(7, 4)], spaceStr];
            }
        }
        
        if (nStr.length == 11){
            [mStrTemp appendFormat:@"%@%@", [nStr substringWithRange:NSMakeRange(7, 4)], spaceStr];
        }
        
        if (nStr.length < 4) {
            [mStrTemp appendString:[nStr substringWithRange:NSMakeRange(nStr.length - nStr.length % 3, nStr.length % 3)]];
        }else if(nStr.length > 3 && nStr.length <12) {
            NSString *str = [nStr substringFromIndex:3];
            [mStrTemp appendString:[str substringWithRange:NSMakeRange(str.length - str.length % 4, str.length % 4)]];
            if (nStr.length == 11) {
                [mStrTemp deleteCharactersInRange:NSMakeRange(13, 1)];
            }
        }
        filed.text = mStrTemp;
        NSUInteger curTargetCursorPosition = targetCursorPosition;// 当前光标的偏移位置
        if (editFlag == 0){
            //删除
            if (targetCursorPosition == 9 || targetCursorPosition == 4){
                curTargetCursorPosition = targetCursorPosition - 1;
            }
        }
        else {
            //添加
            if (nStr.length == 8 || nStr.length == 4){
                curTargetCursorPosition = targetCursorPosition + 1;
            }
        }
        
        UITextPosition *targetPosition = [filed positionFromPosition:filed.beginningOfDocument offset:curTargetCursorPosition];
        [filed setSelectedTextRange:[filed textRangeFromPosition:targetPosition toPosition :targetPosition]];
    }
    if (self.phoneTextField.text.length ==13) {
        self.NextButton.enabled = YES;
        self.NextButton.backgroundColor = [UIColor colorWithHex:0xFB6337 alpha:1];
    }else{
        self.NextButton.enabled = NO;
        self.NextButton.backgroundColor = [UIColor colorWithHex:0xFB6337 alpha:0.5];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self checkTextFieldeRsponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.WarmLabel.hidden = YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == self.phoneTextField) {
        self.previousTextFieldContent = textField.text;
        self.previousSelection = textField.selectedTextRange;
    }
    return YES;
}

#pragma mark - 点击事件
- (void)tapClick{
    [self checkTextFieldeRsponder];
}

- (void)checkTextFieldeRsponder{
    if ([self.phoneTextField isFirstResponder]) {
        [self.phoneTextField resignFirstResponder];
    }
}

- (IBAction)AgreeMentButtonClick:(id)sender {
    WebViewController *webVC = [[WebViewController alloc] init];
    webVC.UrlString =@"http://www.vimzx.com/reg_agreement.htm";
    webVC.title = @"微米服务协议";
    [self.navigationController pushViewController:webVC animated:YES];
}

- (IBAction)nextstepClick:(id)sender {
    [self checkTextFieldeRsponder];
    
    NSString* phoneStr = [self.phoneTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];

    if (phoneStr.length == 0) {
        [PAProgressView showInView:self.view  contentString:@"请输入手机号码"];
        return;
    }
    if (![VerifyRegexTool checkTelNumber:phoneStr]) {
        self.WarmLabel.hidden = NO;
        self.WarmLabel.text = @"请输入正确的手机号";
        return;
    }
    self.WarmLabel.hidden = YES;
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:phoneStr forKey:@"phone"];
    [params setObject:@"5" forKey:@"type"];
    [params setObject:@"checkphone" forKey:@"hkey"];
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
            [self getVerifyButtonClick:phoneStr];
        }else if ([[result objectForKey:@"errorlog"]isEqualToString:@"phoneIsExist"] &&[[result objectForKey:@"success"]isEqualToString:@"false"]) {
            self.WarmLabel.hidden = NO;
            self.WarmLabel.text = @"";
            
            [UIAlertTool showAlertView:self TitleString:@"该手机号已注册，是否直接登录" MessageString:nil CancelButtonString:@"取消" OhterButtonString:@"登录" confirmBlock:^{
                if (self.RegistBlock) {
                    self.RegistBlock(self.phoneTextField.text);
                }
                [self.navigationController popViewControllerAnimated:YES];
            } cancleBlock:^{
                
            }];            
        }else if ([[result objectForKey:@"errorlog"]isEqualToString:@"-88"] &&[[result objectForKey:@"success"]isEqualToString:@"false"]) {
            self.WarmLabel.hidden = NO;
            self.WarmLabel.text = @"";
            [UIAlertTool showAlertView:self TitleString:@"非法获取短信验证码" MessageString:nil CancelButtonString:@"取消" OhterButtonString:@"联系客服" confirmBlock:^{
                NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"400-0571-115"];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            } cancleBlock:^{
                
            }];
        }else if ([[result objectForKey:@"errorlog"]isEqualToString:@"1"] &&[[result objectForKey:@"success"]isEqualToString:@"false"]) {
            self.WarmLabel.hidden = NO;
            self.WarmLabel.text = @"";

            [UIAlertTool showAlertView:self TitleString:@"获取短信数量已达到单日短信发送上限" MessageString:nil CancelButtonString:@"取消" OhterButtonString:@"联系客服" confirmBlock:^{
                NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"400-0571-115"];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            } cancleBlock:^{
                
            }];
        }else if ([[result objectForKey:@"errorlog"]isEqualToString:@"2"] &&[[result objectForKey:@"success"]isEqualToString:@"false"]) {
            self.WarmLabel.hidden = NO;
            self.WarmLabel.text = @"系统错误，请稍后重试";
        }else{
            self.WarmLabel.hidden = NO;
            self.WarmLabel.text = @"";
            [UIAlertTool showAlertView:self TitleString:@"获取短信验证码失败，您可以重新获取" MessageString:nil CancelButtonString:@"取消" OhterButtonString:@"重新获取" confirmBlock:^{
                [self nextstepClick:sender];
            } cancleBlock:^{
                
            }];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[DataRequestServer getDataRequestServerData] requestImportWithUrl:UrlString Error:error urlParams:params];

        [UIAlertTool showAlertView:self TitleString:@"获取短信验证码失败，您可以重新获取" MessageString:nil CancelButtonString:@"取消" OhterButtonString:@"重新获取" confirmBlock:^{
            [self nextstepClick:sender];
        } cancleBlock:^{
            
        }];
    }];
}

- (void)getVerifyButtonClick:(NSString *)phone{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:phone forKey:@"phone"];
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
        MyLog(@"luna_ajax.do%@",result);
        
        if([[result objectForKey:@"success"]isEqualToString:@"true"] &&[[result objectForKey:@"errorlog"]isEqualToString:@""]){
            [AddHudView addProgressView:self.view message:@"短信验证码已发送，请注意查收"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                RegistStepTwoViewController *VC = [[RegistStepTwoViewController alloc] init];
                VC.PhoneStr = phone;
                [self.navigationController pushViewController:VC animated:YES];
            });
        }else if ([[result objectForKey:@"errorlog"]isEqualToString:@"phoneIsExist"] &&[[result objectForKey:@"success"]isEqualToString:@"false"]) {
            [UIAlertTool showAlertView:self TitleString:@"该手机号已被注册" MessageString:nil CancelButtonString:@"去登录" OhterButtonString:@"联系客服" confirmBlock:^{
                NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"400-9650-076"];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            } cancleBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }else if ([[result objectForKey:@"errorlog"]isEqualToString:@"-88"] &&[[result objectForKey:@"success"]isEqualToString:@"false"]) {
            [UIAlertTool showAlertView:self TitleString:@"非法获取短信验证码" MessageString:nil CancelButtonString:@"取消" OhterButtonString:@"联系客服" confirmBlock:^{
                NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"400-9650-076"];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            } cancleBlock:^{
                
            }];
        }
        else if ([[result objectForKey:@"errorlog"]isEqualToString:@"1"] &&[[result objectForKey:@"success"]isEqualToString:@"false"]) {
            [UIAlertTool showAlertView:self TitleString:@"获取短信数量已达到单日短信发送上限" MessageString:nil CancelButtonString:@"取消" OhterButtonString:@"联系客服" confirmBlock:^{
                NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"400-9650-076"];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            } cancleBlock:^{
                
            }];
        }
        else if ([[result objectForKey:@"errorlog"]isEqualToString:@"2"] &&[[result objectForKey:@"success"]isEqualToString:@"false"]) {
            
        }else{
            [UIAlertTool showAlertView:self TitleString:@"获取短信验证码失败，您可以重新获取" MessageString:nil CancelButtonString:@"取消" OhterButtonString:@"重新获取" confirmBlock:^{
                [self getVerifyButtonClick:phone];
            } cancleBlock:^{
                
            }];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[DataRequestServer getDataRequestServerData] requestImportWithUrl:UrlString Error:error urlParams:params];

    }];
    
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

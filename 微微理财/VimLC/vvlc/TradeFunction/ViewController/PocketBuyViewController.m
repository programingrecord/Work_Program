//
//  PocketBuyViewController.m
//  SmallCat
//
//  Created by H on 2017/6/5.
//  Copyright © 2017年 HM. All rights reserved.
//

#import "PocketBuyViewController.h"
#import "MSUTopUpController.h"
#import "LockNameViewController.h"
#import "AddCardViewController.h"
#import "WebViewController.h"
#import "MSUTradeCompleteController.h"
#import "LoginViewController.h"
#import "MSUSetTradePWDController.h"

#import "MSUPwdView.h"
#import "MSUShadowView.h"
#import "UnderLineField.h"


@interface PocketBuyViewController ()<UITextFieldDelegate,UIAlertViewDelegate,MSUTextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *AmountText;
@property (weak, nonatomic) IBOutlet UILabel *CanuserLable;
@property (weak, nonatomic) IBOutlet UILabel *RateLabel;

@property (weak, nonatomic) IBOutlet UIButton *SureButton;
@property (nonatomic,strong) NSString *availableAmount;
@property (nonatomic,strong) NSString *canBidMinAmount;
@property (weak, nonatomic) IBOutlet UIButton *AgreeMentButton;

@property (nonatomic , strong) MSUShadowView *pwdShadowView;
@property (nonatomic , strong) MSUPwdView *pwdView;
@property (nonatomic , copy) NSString *pwdStr;
@property (nonatomic , assign) BOOL isShowP;

@end

@implementation PocketBuyViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getOneDetailBuy];
    
    //键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [self registNSNotification];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    //    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)registNSNotification{
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    //    [self getBankList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"微微宝购买";
    

    self.RateLabel.font = [UIFont fontWithName:@"DINAlternate-Bold" size:31];

    self.RateLabel.text = [NSString stringWithFormat:@"%@",self.rate];
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20,self.AmountText.height)];
    lable.text = @"¥";
    lable.font = TEXTFONT(24);
    lable.textColor = [UIColor colorWithHex:0x4a4a4a];
    lable.textAlignment = NSTextAlignmentCenter;
    self.AmountText.leftView = lable;
    self.AmountText.leftViewMode = UITextFieldViewModeAlways;
    self.AmountText.inputAccessoryView = [self addToolbar];
    [self.AmountText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.AmountText.font = [UIFont fontWithName:@"DINAlternate-Bold" size:24];
    _AmountText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"100起投" attributes:@{NSForegroundColorAttributeName: HEXCOLOR(0xCFCFCF),NSFontAttributeName:[UIFont systemFontOfSize:24]}];

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyBoard:)];
    [self.view addGestureRecognizer:tapGesture];
}

#pragma mark - 数据请求
- (void)getOneDetailBuy{

    self.availableAmount =[[NSString stringWithFormat:@"%@",@"2000.43"] stringByReplacingOccurrencesOfString:@"," withString:@""];
    self.canBidMinAmount =[NSString stringWithFormat:@"%@",@"2321.21"];
    
    NSString *Userstring =[NSString stringWithFormat:@"可用余额：%@元", self.availableAmount];
    NSMutableAttributedString *UserstringAtt = [self setAttriButedString:Userstring font:TEXTFONT(14) color:[UIColor colorWithHex:0x4A4A4A] searchString:self.availableAmount font:[UIFont fontWithName:@"DINAlternate-Bold" size:14] color:[UIColor colorWithHex:0xFF6339]];
    _CanuserLable.attributedText = UserstringAtt;
}

- (NSMutableAttributedString *)setAttriButedString:(NSString *)string font:(UIFont *)font color:(UIColor *)color searchString:(NSString *)searchString font:(UIFont *)searchfont color:(UIColor *)searchcolor {
    NSRange range = NSMakeRange(0,string.length);
    
    NSRange range1= [string rangeOfString:searchString];
    
    NSMutableAttributedString *Astring = [[NSMutableAttributedString alloc] initWithString:string];
    [Astring addAttribute:NSFontAttributeName value:font  range:range];
    [Astring addAttribute:NSForegroundColorAttributeName value:color range:range1];
    
    [Astring addAttribute:NSFontAttributeName value:searchfont range:range1];
    [Astring addAttribute:NSForegroundColorAttributeName value:searchcolor range:range1];
    return Astring;
}

- (void)requestLogin{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *NSdic = [defaults objectForKey:@"registerData"];
    NSString *username = [NSdic objectForKey:@"UserName"];
    NSString *password = [NSdic objectForKey:@"PassWord"];
    
    NSMutableDictionary *parms = [[NSMutableDictionary alloc] init];//登录保存的字典
    if (username == nil || password == nil) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [CoreArchive removeNSUserDefaults];
        LoginViewController *loginVc= [[LoginViewController alloc] init];
        loginVc.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:loginVc animated:YES];
        return;
    }
    
    [parms setObject:username forKey:@"username"];
    [parms setObject:password forKey:@"password"];
    
    [[DataRequestServer getDataRequestServerData]requestLoginparameters:parms result:^(id result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([result isKindOfClass:[NSString class]]) {
            [AddHudView addProgressView:self.view message:@"网络错误，请稍后再试"];        }else{
                
                NSString *value = [result objectForKey:@"errorlog"];
                int  isNeedToActive =[[result objectForKey:@"isNeedToActivated"]intValue];
                int  success = [[result objectForKey:@"success"]intValue];
                if ([value isEqualToString:@""] && success ==1) {
                    if (isNeedToActive == 1)
                    {
                        [CoreArchive removeNSUserDefaults];
                        LoginViewController *loginVc= [[LoginViewController alloc] init];
                        loginVc.loginType=logintypePush;
                        loginVc.hidesBottomBarWhenPushed = YES;
                        
                        [self.navigationController pushViewController:loginVc animated:YES];
                    }
                    else{
                        [self getOneDetailBuy];
                    }
                }else{
                    [CoreArchive removeNSUserDefaults];
                    
                    LoginViewController *loginVc= [[LoginViewController alloc] init];
                    loginVc.loginType=logintypeHome;
                    loginVc.hidesBottomBarWhenPushed = YES;
                    
                    [self.navigationController pushViewController:loginVc animated:YES];
                }
            }
    }];
}

#pragma mark - 初始化
- (MSUShadowView *)pwdShadowView{
    if (!_pwdShadowView) {
        _pwdShadowView = [[MSUShadowView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
        _pwdShadowView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [MSUMainWindow addSubview:_pwdShadowView];
    }
    return _pwdShadowView;
}

- (MSUPwdView *)pwdView{
    if (!_pwdView) {
        _pwdView = [[MSUPwdView alloc] initWithFrame:CGRectMake(0, kDeviceHeight-137*kDeviceHeightScale, kDeviceWidth, 137*kDeviceHeightScale)];
        [self.pwdShadowView addSubview:_pwdView];
        _pwdView.pwdTF.delegate = self;
        [_pwdView.pwdTF addTarget:self action:@selector(textFieldMSUDidChange:) forControlEvents:UIControlEventEditingChanged];
        [_pwdView.closeBtn addTarget:self action:@selector(closePWDBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pwdView;
}

#pragma mark - 点击事件
- (IBAction)AllButtonClick:(id)sender {
    [self KeyboardresignFirstResponder];
    self.AmountText.text = [self.availableAmount stringByReplacingOccurrencesOfString:@"," withString:@""];
}

- (IBAction)agrenMentButtonclick:(id)sender {
    self.AgreeMentButton.selected = !self.AgreeMentButton.selected;
}

- (IBAction)BuyButtonClick:(id)sender {
    [self KeyboardresignFirstResponder];
    
    if (!self.AgreeMentButton.selected) {
        [AddHudView addProgressView:self.view message:@"同意《微米在线服务协议》"];
        return;
    }
    
    UIButton *button = (UIButton *)sender;
    if ([button.titleLabel.text isEqualToString:@"余额不足，去充值"]) {
        if (![CoreArchive isLockedBank]) {
            [UIAlertTool showAlertView:self TitleString:@"温馨提示" MessageString:@"未添加银行卡，请前往添加" CancelButtonString:@"取消" OhterButtonString:@"添加" confirmBlock:^{
//                AddCardViewController *AddCardVC =[[AddCardViewController alloc] init];
//                [self.navigationController pushViewController:AddCardVC animated:YES];
                MSUTopUpController *TopUpVC = [[MSUTopUpController alloc] init];
                TopUpVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:TopUpVC animated:YES];
            } cancleBlock:^{
                
            }];
        }else{
            MSUTopUpController *TopUpVC = [[MSUTopUpController alloc] init];
            TopUpVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:TopUpVC animated:YES];
        }
        return;
    }
    
    if (![self isValidateFloat:_AmountText.text] && ![self isValidateInt:_AmountText.text]) {
        [AddHudView addProgressView:self.view message:@"请您输入正确格式的存入金额"];
        return;
    }
    
    if (_AmountText.text.length == 0) {
        [AddHudView addProgressView:self.view message:@"存入金额不能为空"];
        return;
    }
    
    NSNumber *a=[NSNumber numberWithFloat:self.AmountText.text.floatValue];
    NSNumber *b=[NSNumber numberWithFloat:self.availableAmount.floatValue];
    NSNumber *c=[NSNumber numberWithFloat:self.canBidMinAmount.floatValue];

    if ([b compare:a]==NSOrderedAscending)
    {
        if (![CoreArchive isLockedBank]) {
            [UIAlertTool showAlertView:self TitleString:@"温馨提示" MessageString:@"输入的金额小于可用余额，还未添加银行卡，请前往添加充值" CancelButtonString:@"取消" OhterButtonString:@"添加" confirmBlock:^{
//                AddCardViewController *AddCardVC =[[AddCardViewController alloc] init];
//                [self.navigationController pushViewController:AddCardVC animated:YES];
                MSUTopUpController *TopUpVC = [[MSUTopUpController alloc] init];
                TopUpVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:TopUpVC animated:YES];
            } cancleBlock:^{
                
            }];
        }else{
            [UIAlertTool showAlertView:self TitleString:@"温馨提示" MessageString:@"输入的金额小于可用余额，请充值" CancelButtonString:@"取消" OhterButtonString:@"充值" confirmBlock:^{
                MSUTopUpController *TopUpVC = [[MSUTopUpController alloc] init];
                TopUpVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:TopUpVC animated:YES];
            } cancleBlock:^{
                
            }];
        }
        return;
    }
    
    if ([a compare:c]==NSOrderedAscending)
    {
        if (![CoreArchive isLockedBank]) {
            [UIAlertTool showAlertView:self TitleString:@"温馨提示" MessageString:@"输入的金额小于最小存入金额，还未添加银行卡，请前往添加充值" CancelButtonString:@"取消" OhterButtonString:@"添加" confirmBlock:^{
//                AddCardViewController *AddCardVC =[[AddCardViewController alloc] init];
//                [self.navigationController pushViewController:AddCardVC animated:YES];
                MSUTopUpController *TopUpVC = [[MSUTopUpController alloc] init];
                TopUpVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:TopUpVC animated:YES];
            } cancleBlock:^{
                
            }];
        }else{
            [UIAlertTool showAlertView:self TitleString:@"温馨提示" MessageString:@"输入的金额小于最小存入金额，请前往充值" CancelButtonString:@"取消" OhterButtonString:@"充值" confirmBlock:^{
                MSUTopUpController *TopUpVC = [[MSUTopUpController alloc] init];
                TopUpVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:TopUpVC animated:YES];
            } cancleBlock:^{
                
            }];
        }
        return;
    }
    
    if ([CoreArchive isSetTradePass]) {
        self.isShowP = YES;
        [UIView animateWithDuration:0.25 animations:^{
            self.pwdShadowView.hidden = NO;
            self.pwdView.hidden = NO;
            [self.pwdView.pwdTF becomeFirstResponder];
        }];
    } else {
        MSUSetTradePWDController *set = [[MSUSetTradePWDController alloc] init];
        set.signStr = @"pocket";
        set.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:set animated:YES];
    }
}

- (void)requestBuy{
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:self.AmountText.text forKey:@"joinAmount"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[DataRequestServer getDataRequestServerData] request:@"LunaP2pAppBidCurrentBorrowServlet" parameters:paramDic result:^(id result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([result isKindOfClass:[NSString class]] &&  [result isEqualToString:@"44"]) {
            [AddHudView addProgressView:self.view message:@"网络错误，请稍后再试"];
        }else{
            int t = [[result objectForKey:@"success"] intValue];
            if ([[result objectForKey:@"errorlog"]isEqualToString:@"noLogin"]&& t==0){//要加上未登录的判断
                [self requestLogin:logintypeOutTime];
                
            }else if ([[result objectForKey:@"errorlog"]isEqualToString:@""]&& t==1){
                [AddHudView addProgressView:self.view message:@"恭喜你，购买成功"];
                
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                NSDictionary *NSdic = [userDefaults objectForKey:@"registerData"];
                NSString *username = [NSdic objectForKey:@"UserName"];
                [TalkingData trackEvent:@"微微宝" label:@"购买成功" parameters:@{@"购买用户":username,@"购买金额":self.AmountText.text}];
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        MSUTradeCompleteController   *resultVC= [[MSUTradeCompleteController alloc] init];
                        [self.navigationController pushViewController:resultVC animated:YES];
                    });
                });
            }else{
                [AddHudView addProgressView:self.view message:@"很遗憾，购买失败"];
            }
        }
    }];
}

-(BOOL)isValidateFloat:(NSString *)phoneStr {
    NSString *phoneRegex = @"^(?:[1-9][0-9]*\\.[0-9]+|0\\.(?!0+$)[0-9]+)$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:phoneStr];
}

-(BOOL)isValidateInt:(NSString *)phoneStr {
    NSString *phoneRegex = @"^[1-9][0-9]*$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:phoneStr];
}

- (void)popViewController{
    if (self.presentingViewController != nil) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (alertView.tag) {
        case 1000:
        {
            [self popViewController];
        }
        break;
        
        case 1001:
        {
            if (buttonIndex==1) {
                LockNameViewController *LockName =[[LockNameViewController alloc] init];
                [self.navigationController pushViewController:LockName animated:YES];
            }
        }
        break;
        case 1002:
        {
//            if (buttonIndex==1) {
//                RealViewController *RealNameVC =[[RealViewController alloc] init];
//                [self.navigationController pushViewController:RealNameVC animated:YES];
//            }
        }
        break;
        case 1003:
        {
            if (buttonIndex==1) {
                AddCardViewController *AddCardVC =[[AddCardViewController alloc] init];
                [self.navigationController pushViewController:AddCardVC animated:YES];
            }
        }
        break;
        
        default:
        break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)AgreeButtonclick:(id)sender {
    WebViewController *webVC = [[WebViewController alloc] init];
    webVC.UrlString =@"http://www.vimzx.com/wap/current_sample.htm";
    webVC.title = @"微米服务协议";
    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark - textField
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

- (void)textFieldDidChange:(UITextField *)filed{
    if (filed.text.length>0) {
        NSNumber *a=[NSNumber numberWithFloat:filed.text.floatValue];
        NSNumber *b=[NSNumber numberWithFloat:self.availableAmount.floatValue];
        if ([b compare:a]==NSOrderedAscending){
            [self.SureButton setTitle:@"余额不足，去充值" forState:UIControlStateNormal];
        }else{
            [self.SureButton setTitle:@"确认存入" forState:UIControlStateNormal];
        }
    }else{
        [self.SureButton setTitle:@"确认存入" forState:UIControlStateNormal];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL isHaveDian;
    if ([textField.text rangeOfString:@"."].location == NSNotFound)
    {
        isHaveDian = NO;
    }else{
        isHaveDian = YES;
    }
    if ([string length] > 0)
    {
        unichar single = [string characterAtIndex:0];//当前输入的字符
        if ((single >= '0' && single <= '9') || single == '.')//数据格式正确
        {
            //首字母不能为0和小数点
            if([textField.text length] == 0 )
            {
                if(single == '.')
                {
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
                
                if (single == '0')
                {
                    if ([textField isKindOfClass:[UnderLineField class]]) {
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                }
            }
            //输入的字符是否是小数点
            if (single == '.')
            {
                if(!isHaveDian)//text中还没有小数点
                {
                    isHaveDian = YES;
                    return YES;
                }else{
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }else{
                if (isHaveDian) {//存在小数点
                    //判断小数点的位数
                    NSRange ran = [textField.text rangeOfString:@"."];
                    if (range.location - ran.location <= 2) {
                        return YES;
                    }else{
                        return NO;
                    }
                }else{
                    return YES;
                }
            }
        }else{//输入的数据格式不正确
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    else
    {
        return YES;
    }
}

- (void)resignKeyBoard:(UITapGestureRecognizer *)tap{
    [self KeyboardresignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self KeyboardresignFirstResponder];
    return YES;
}

- (void)KeyboardresignFirstResponder
{
    if ([_AmountText isFirstResponder])//判断是否是第一响应
    {
        [_AmountText resignFirstResponder];
    }
}

#pragma mark - 交易密码相关
- (void)closePWDBtnClick:(UIButton *)sender{
    [UIView animateWithDuration:0.25 animations:^{
        self.pwdShadowView.hidden = YES;
        //        [_pwdView.pwdTF resignFirstResponder];
        [self.pwdShadowView endEditing:YES];
    }];
}

- (void)clearTradePWD{
    self.pwdStr = @"";
    _pwdView.pwdTF.text = @"";
    for (UILabel *lab in self.pwdView.pwdArr) {
        lab.text = @"";
    }
}

- (void)textFieldMSUDidChange:(UITextField *)textField{
    if (textField == self.pwdView.pwdTF) {
        if (textField.text.length > 0 && textField.text.length < 7) {
            UILabel *label = self.pwdView.pwdArr[textField.text.length-1];
            label.text = @"●";
            self.pwdStr = textField.text;
            if (self.pwdStr.length == 6) {
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                //  确认交易密码
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setObject:self.pwdStr forKey:@"TranscationPas"];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [[DataRequestServer getDataRequestServerData] request:@"LunaP2pAppVerifyTranPwdServlet" parameters:dic result:^(id result) {
                        if ([result isKindOfClass:[NSString class]] &&  [result isEqualToString:@"44"]) {
                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                            [self clearTradePWD];
                            [self closePWDBtnClick:nil];
                            [PAProgressView showInView:MSUMainWindow contentString:@"网络错误，请稍后再试"];
                        }else{
                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                            
                            int t = [[result objectForKey:@"success"] intValue];
                            if ([[result objectForKey:@"errorlog"]isEqualToString:@"noLogin"]&& t==0){//要加上未登录的判断
                                [self requestLogin];
                            }else if ([[result objectForKey:@"errorlog"]isEqualToString:@""]&& t==1){
                                [self clearTradePWD];
                                [self closePWDBtnClick:nil];
                                [self requestBuy];
                            }else{
                                [self clearTradePWD];
                                //                                [self closePWDBtnClick:nil];
                                [PAProgressView showInView:MSUMainWindow contentString:@"支付密码错误，请重新输入"];
                            }
                        }
                    }];
                });
            }
        }
    }
}

- (void)KeyboardWillChangeFrame:(NSNotification *)note{
    if (self.isShowP) {
        CGRect keyboard = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGFloat trans = keyboard.origin.y - kDeviceHeight;
        //    NSLog(@"zhizhzihizhi---%f,%f",keyboard.origin.y,trans);
        // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
        double duration = [[note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
        [UIView animateWithDuration:duration animations:^{
            self.pwdView.transform = CGAffineTransformMakeTranslation(0, trans);
        }];
    }
}

///键盘消失事件
- (void) keyboardWillHide:(NSNotification *)notify {
    // 键盘动画时间
    //    if ([_VerifyText isFirstResponder]){
    //        double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //        NSLog(@"%@",NSStringFromCGRect(self.view.frame));
    //
    //        //视图下沉恢复原状
    //        [UIView animateWithDuration:duration animations:^{
    //            self.view.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height);
    //        }];
    //    }
}

- (void)deleteBtnClick:(UITextField *)textField{
    if (textField == self.pwdView.pwdTF) {
        NSLog(@"text  -- %@",textField.text);
        if ((textField.text.length > 0 && textField.text.length < 6)|| textField.text.length == 0) {
            UILabel *label = self.pwdView.pwdArr[textField.text.length];
            label.text = @"";
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

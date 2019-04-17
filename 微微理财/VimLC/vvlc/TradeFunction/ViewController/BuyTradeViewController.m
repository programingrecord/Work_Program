//
//  BuyTradeViewController.m
//  WTJR
//
//  Created by H on 16/6/14.
//  Copyright © 2016年 HM. All rights reserved.
//

#import "BuyTradeViewController.h"
#import "LoginViewController.h"
#import "MSUTopUpController.h"
#import "LockNameViewController.h"
#import "RealViewController.h"
#import "AddCardViewController.h"
#import "PasswordModifyVC.h"
#import "WebViewController.h"
#import "MSUTradeCompleteController.h"
#import "MSUSetTradePWDController.h"
#import "MSUProtocalController.h"

#import "MSUBuyCenterView.h"
#import "MSUBuyJuanView.h"
#import "MSUShadowInView.h"
#import "MSUShadowView.h"
#import "MSUStringTools.h"
#import "MSUPwdView.h"
#import "UnderLineField.h"

@interface BuyTradeViewController ()<UITextFieldDelegate,MSUBuyJuanViewDelegate,MSUTextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *AmountText;
@property (weak, nonatomic) IBOutlet UILabel *CanuserLable;
@property (nonatomic,assign) NSInteger hasPassWord;
@property (nonatomic,strong) UIView *alphaView;
@property (nonatomic,strong) UITextField *topTX;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) NSMutableDictionary *paramDic;
@property (weak, nonatomic) IBOutlet UILabel *LeftAmountLable;
@property (weak, nonatomic) IBOutlet UILabel *RateLabel;
@property (weak, nonatomic) IBOutlet UILabel *DateLabel;
@property (weak, nonatomic) IBOutlet UIButton *AgreeMentButton;
@property (nonatomic,strong) NSString *availableAmount;
@property (weak, nonatomic) IBOutlet UIButton *SureButton;
@property (weak, nonatomic) IBOutlet UIButton *protocalBtn;

@property (nonatomic , strong) MSUShadowInView *shadowView;
@property (nonatomic , strong) MSUBuyJuanView *seleJuanView;

@property (nonatomic , strong) MSUBuyCenterView *buyCenView;

@property (nonatomic , assign) double shouyi;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomH;

@property (nonatomic , strong) NSMutableArray *quanArr;
@property (nonatomic , strong) NSMutableArray *cuponArr;
@property (nonatomic , copy) NSString *moneyStr;
@property (nonatomic , copy) NSString *quanID;
@property (nonatomic , copy) NSString *quanType;
@property (nonatomic , copy) NSString *leftStr;

@property (nonatomic , strong) MSUShadowView *pwdShadowView;
@property (nonatomic , strong) MSUPwdView *pwdView;
@property (nonatomic , copy) NSString *pwdStr;
@property (nonatomic , assign) BOOL isShowP;
@property (nonatomic , copy) NSString *incomStr;
@property (nonatomic , copy) NSString *protocalStr;
@property (nonatomic , strong) NSDictionary *finalDic;
@property (nonatomic , strong) UIButton *jieXieBtn;

@end

@implementation BuyTradeViewController

#pragma mark - UI
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getOneDetailInfo];
    self.isShowP = NO;
    //键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [self registNSNotification];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)registNSNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"购买";
    
    self.DateLabel.text = [NSString stringWithFormat:@"投资期限：%@",@"7天"];

    NSString *str1 = @"4.3%";
    NSString *str2 = @"";
    CGFloat count1 = [[str1 substringWithRange:NSMakeRange(0, str1.length-1)] doubleValue];
    CGFloat count2 = 0.0;
    if (str2.length > 0) {
        count2 = [[str2 substringWithRange:NSMakeRange(0, str2.length-1)] doubleValue];
    }
    self.shouyi = count1+count2;

    NSString *rateString =[NSString stringWithFormat:@"%.2f%%",count1+count2];
    NSRange range1= [rateString rangeOfString:@"4.3"];
    NSMutableAttributedString *rateAstring = [[NSMutableAttributedString alloc] initWithString:rateString];
    [rateAstring addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, rateString.length)];
    [rateAstring addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:31] range:NSMakeRange(0, range1.length-1)];
    [rateAstring addAttribute:NSForegroundColorAttributeName value:titOrangeColor range:range1];
    self.RateLabel.attributedText = rateAstring;
    self.RateLabel.font = [UIFont fontWithName:@"DINAlternate-Bold" size:31];

    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20,self.AmountText.height)];
    lable.text = @"¥";
    lable.font = TEXTFONT(24);
    lable.textColor = [UIColor colorWithHex:0x4a4a4a];
    lable.textAlignment = NSTextAlignmentCenter;
    self.AmountText.leftView = lable;
    self.AmountText.leftViewMode = UITextFieldViewModeAlways;
    [self.AmountText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.AmountText.inputAccessoryView = [self addToolbar];
    self.AmountText.font = [UIFont fontWithName:@"DINAlternate-Bold" size:24];
    _AmountText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"50起投，50的整数倍投资" attributes:@{NSForegroundColorAttributeName: HEXCOLOR(0xCFCFCF),NSFontAttributeName:[UIFont systemFontOfSize:24]}];

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyBoard:)];
    [self.view addGestureRecognizer:tapGesture];

    self.buyCenView = [[MSUBuyCenterView alloc] init];
    if (is_iPhoneX) {
        _buyCenView.frame = CGRectMake(0, 240, kDeviceWidth, 150*kDeviceHeightScale);
        self.bottomH.constant = 140+60;
    } else{
        if ([UIScreen mainScreen].bounds.size.width == 375.f) {
            _buyCenView.frame = CGRectMake(0, 240*kDeviceHeightScale, kDeviceWidth, 150*kDeviceHeightScale);
            self.bottomH.constant = 120+50;
            
        } else if ([UIScreen mainScreen].bounds.size.width >= 414.f) {
            _buyCenView.frame = CGRectMake(0, 220*kDeviceHeightScale, kDeviceWidth, 150*kDeviceHeightScale);
            self.bottomH.constant = 140+50;
        } else if ([UIScreen mainScreen].bounds.size.width == 320.f){
            _buyCenView.frame = CGRectMake(0, 240, kDeviceWidth, 150*kDeviceHeightScale);
            self.bottomH.constant = 100+50;
        }
    }
    
    self.jieXieBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (is_iPhoneX) {
        _jieXieBtn.frame = CGRectMake(_protocalBtn.right,_buyCenView.bottom +8, 100, 30);
    } else{
        _jieXieBtn.frame = CGRectMake(_protocalBtn.right,_buyCenView.bottom +10, 100, 30);
    }
    [_jieXieBtn setTitle:@"、《借款协议》" forState:UIControlStateNormal];
    [_jieXieBtn setTitleColor:HEXCOLOR(0x75A6D2) forState:UIControlStateNormal];
    _jieXieBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:_jieXieBtn];
    [_jieXieBtn addTarget:self action:@selector(jieXieBtnClick:) forControlEvents:UIControlEventTouchUpInside];
   
    _buyCenView.backgroundColor = WhiteColor;
    [self.view addSubview:_buyCenView];
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

- (UIView *)addPassWordView{
    UIView *WhiteView = [[UIView alloc] init];
    WhiteView.center = CGPointMake(_alphaView.center.x, _alphaView.center.y-60);
    WhiteView.bounds = CGRectMake(0, 0, _alphaView.width-80, 200);
    WhiteView.backgroundColor = [UIColor whiteColor];
    [_alphaView addSubview:WhiteView];
    
    UIButton *CancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CancelButton.layer.cornerRadius = 5;
    CancelButton.layer.borderColor = RGBA(237, 128, 17, 1).CGColor;
    CancelButton.frame = CGRectMake(WhiteView.width-30, 10,16, 16);
    [CancelButton setBackgroundImage:[UIImage imageNamed:@"icon-close"] forState:UIControlStateNormal];
    [CancelButton addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [WhiteView addSubview:CancelButton];
    
    UILabel *titleLable = [[UILabel alloc] init];
    titleLable.frame = CGRectMake(20,10, WhiteView.width-40, 30);
    titleLable.text = @"请输入投标密码";
    titleLable.font = [UIFont systemFontOfSize:18.0];
    titleLable.textColor = RGBA(51, 51, 51, 1);
    titleLable.textAlignment = NSTextAlignmentCenter;
    [WhiteView addSubview:titleLable];
    
    _topTX = [[UITextField alloc] init ];
    _topTX.frame = CGRectMake(20, titleLable.bottom +15, WhiteView.width-40, 45);
    _topTX.borderStyle = UITextBorderStyleRoundedRect;
    _topTX.secureTextEntry = YES;
    _topTX.placeholder = @"请输入投标密码";
    _topTX.delegate = self;
    _topTX.clearButtonMode = UITextFieldViewModeWhileEditing;
    _topTX.clearsOnBeginEditing = YES;
    [WhiteView addSubview:_topTX];
    [_topTX becomeFirstResponder];
    
    UIButton *SureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    SureButton.layer.cornerRadius = 5;
    SureButton.layer.borderColor = RGBA(237, 128, 17, 1).CGColor;
    SureButton.frame = CGRectMake(20, _topTX.bottom + 20,WhiteView.width-40, 40);
    [SureButton setTitle:@"确 认" forState:UIControlStateNormal];
    [SureButton setBackgroundColor:RGBA(255, 127, 39, 1)];
    [SureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [SureButton addTarget:self action:@selector(addpassword) forControlEvents:UIControlEventTouchUpInside];
    [WhiteView addSubview:SureButton];
    
    return WhiteView;
}

#pragma mark - 请求数据
- (void)getOneDetailInfo{
  
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
                    [self getOneDetailInfo];
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

- (void)requestBuy{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[DataRequestServer getDataRequestServerData] request:@"LunaP2pAppBiddingServlet" parameters:_paramDic result:^(id result) {
        if ([result isKindOfClass:[NSString class]] &&  [result isEqualToString:@"44"]) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [AddHudView addProgressView:self.view message:@"网络错误，请稍后再试"];
        }else{
            int t = [[result objectForKey:@"success"] intValue];
            if ([[result objectForKey:@"errorlog"]isEqualToString:@"noLogin"]&& t==0){//要加上未登录的判断
                [self requestLogin];
            }else if ([[result objectForKey:@"errorlog"]isEqualToString:@""]&& t==1){
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                NSDictionary *NSdic = [userDefaults objectForKey:@"registerData"];
                NSString *username = [NSdic objectForKey:@"UserName"];
                [TalkingData trackEvent:@"投标" label:@"投资成功" parameters:@{@"投资用户":username,@"投资金额":_AmountText.text}];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    MSUTradeCompleteController   *resultVC= [[MSUTradeCompleteController alloc] init];
                    [self.navigationController pushViewController:resultVC animated:YES];
                });
            }else if ([[result objectForKey:@"errorlog"]isEqualToString:@"bidAmountLessThanZero"]&& t==0){
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                [AddHudView addProgressView:self.view message:@"投标金额小于最小投标"];
            }else if ([[result objectForKey:@"errorlog"]isEqualToString:@"bidAmountLargerThanAmountLeft"]&& t==0){
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [AddHudView addProgressView:self.view message:@"投标金额大于最大投标"];
            }else if ([[result objectForKey:@"errorlog"]isEqualToString:@"badBidPassword"]&& t==0){
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [AddHudView addProgressView:self.view message:@"投标密码错误"];
            }else if ([[result objectForKey:@"errorlog"]isEqualToString:@"lessThanMinBidAmount"]&& t==0){
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [AddHudView addProgressView:self.view message:@"投标金额小于最小投标"];
            }else if ([[result objectForKey:@"errorlog"]isEqualToString:@"largerThanAvailableAmount"]&& t==0){
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if (![CoreArchive isLockedBank]) {
                    [UIAlertTool showAlertView:self TitleString:@"温馨提示" MessageString:@"未添加银行卡，请前往添加" CancelButtonString:@"取消" OhterButtonString:@"添加" confirmBlock:^{
//                        AddCardViewController *AddCardVC =[[AddCardViewController alloc] init];
//                        [self.navigationController pushViewController:AddCardVC animated:YES];
                        MSUTopUpController *TopUpVC = [[MSUTopUpController alloc] init];
                        TopUpVC.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:TopUpVC animated:YES];
                    } cancleBlock:^{
                        
                    }];
                }else{
                    [UIAlertTool showAlertView:self TitleString:@"温馨提示" MessageString:@"账户余额不足，请充值" CancelButtonString:@"取消" OhterButtonString:@"充值" confirmBlock:^{
                        MSUTopUpController *TopUpVC = [[MSUTopUpController alloc] init];
                        TopUpVC.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:TopUpVC animated:YES];
                    } cancleBlock:^{
                        
                    }];
                }
            }else if ([[result objectForKey:@"errorlog"]isEqualToString:@"cannotBidItself"]&& t==0){
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [AddHudView addProgressView:self.view message:@"不能给自己借款投标"];
            }else if ([[result objectForKey:@"errorlog"]isEqualToString:@"cantNwBorrow"]&& t==0){
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [AddHudView addProgressView:self.view message:@"新手标只能投资一次，您已经投资过"];
            }
            else{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [AddHudView addProgressView:self.view message:@"获取数据失败，请重新获取"];
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


#pragma mark - 点击事件
- (IBAction)AgreeMentButtonClick:(id)sender {
    self.AgreeMentButton.selected = !self.AgreeMentButton.selected;
}

- (IBAction)BuyClick:(id)sender {
    [self textFieldDone];
    
    if (!self.AgreeMentButton.selected) {
        [AddHudView addProgressView:self.view message:@"同意《微米在线服务协议》"];
        return;
    }
    [self.view endEditing:YES];
    UIButton *button = (UIButton *)sender;
    if ([button.titleLabel.text isEqualToString:@"余额不足，去充值"]) {
        if (![CoreArchive isLockedBank]) {
            [UIAlertTool showAlertView:self TitleString:@"温馨提示" MessageString:@"未添加银行卡，请前往添加" CancelButtonString:@"取消" OhterButtonString:@"添加" confirmBlock:^{
//                AddCardViewController *AddCardVC =[[AddCardViewController alloc] init];
//                [self.navigationController pushViewController:AddCardVC animated:YES];
                MSUTopUpController *TopUpVC = [[MSUTopUpController alloc] init];
                TopUpVC.hidesBottomBarWhenPushed =  YES;
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
        [AddHudView addProgressView:self.view message:@"请您填写正确格式的投标金额"];
        return;
    }
    
    if (_AmountText.text.length == 0) {
        [AddHudView addProgressView:self.view message:@"投标金额不能为空"];
        return;
    }
    
    if (_AmountText.text.integerValue < 50) {
        [AddHudView addProgressView:self.view message:@"投标金额不能低于50元"];
        return;
    }

    _paramDic = [[NSMutableDictionary alloc] init];
    [_paramDic setObject:_AmountText.text forKey:@"bidAmount"];
    [_paramDic setObject:@"34234252" forKey:@"brid"];
    if ([MSUStringTools isBlankString:self.quanID]) {
        self.quanID = [NSString stringWithFormat:@"%@",@""];
    }
    if ([MSUStringTools isBlankString:self.quanType]) {
        self.quanType = [NSString stringWithFormat:@"%@",@""];
    }
    [_paramDic setObject:self.quanID forKey:@"RedPackedId"];
    [_paramDic setObject:self.quanType forKey:@"type"];

    if (_hasPassWord == 1) {
        if (!_alphaView) {
            _alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
            _alphaView.backgroundColor = [RGBA(62, 62, 62, 1) colorWithAlphaComponent:0.6];
            [self.view addSubview:_alphaView];
        }
        for (UIView *views in _alphaView.subviews) {
            [views removeFromSuperview];
        }
        [_alphaView addSubview:[self addPassWordView]];
    }else{
        if ([CoreArchive isSetTradePass]) {
            self.isShowP = YES;
            [UIView animateWithDuration:0.25 animations:^{
                self.pwdShadowView.hidden = NO;
                self.pwdView.hidden = NO;
                [self.pwdView.pwdTF becomeFirstResponder];
            }];
        } else {
            MSUSetTradePWDController *set = [[MSUSetTradePWDController alloc] init];
            set.signStr = @"dingqi";
            set.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:set animated:YES];
        }
    }
}

- (void)addpassword{
    if (_topTX.text.length>0) {
        [_paramDic setObject:_topTX.text forKey:@"bidPassword"];
    }
    [_paramDic setObject:_topTX.text forKey:@"bidPassword"];
    [self requestBuy];
    [_alphaView removeFromSuperview];
    _alphaView = nil;
}

- (void)forgotPassWord{
    [_alphaView removeFromSuperview];
    _alphaView = nil;
    
    PasswordModifyVC  *passWordVC = [[PasswordModifyVC alloc] init];
    [self.navigationController pushViewController:passWordVC animated:YES];
    passWordVC.title=@"修改交易密码";
}

- (void)cancelClick{
    [_alphaView removeFromSuperview];
    _alphaView = nil;
}

- (IBAction)RechargeButtonClick:(id)sender {
    [self KeyboardresignFirstResponder];
    NSString *availStr = [self.availableAmount stringByReplacingOccurrencesOfString:@"," withString:@""];
    NSString *allStr;
    if (availStr.floatValue > _leftStr.floatValue) {
        allStr = _leftStr;
    } else {
        allStr = availStr;
    }
    self.AmountText.text = allStr;
    
    [self fiterCuponWithDataStr:@"0" dataDic:nil];

    _buyCenView.bottomLab.text = [NSString stringWithFormat:@"%@元",self.AmountText.text];
    
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
            if (buttonIndex==1) {
                RealViewController *RealNameVC =[[RealViewController alloc] init];
                [self.navigationController pushViewController:RealNameVC animated:YES];
            }
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

- (void)popViewController{
    if (self.presentingViewController != nil) {
        [self dismissViewControllerAnimated:YES completion:NULL];
        
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)AgreeButtonclick:(id)sender {
    WebViewController *webVC = [[WebViewController alloc] init];
    webVC.UrlString =@"http://www.vimzx.com/wap/current_sample.htm";
    webVC.title = @"微米服务协议";
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)topBtnClick:(UIButton *)sender{
    //待定
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [defaults objectForKey:@"registerData"];
    if ([dic objectForKey:@"UserName"]&&[dic objectForKey:@"PassWord"] ) {
        self.shadowView.hidden = NO;
        self.seleJuanView.hidden = NO;
        self.seleJuanView.priceNum = self.AmountText.text.integerValue;
        if (self.AmountText.text.length > 0) {
            self.seleJuanView.dataArr = [self.quanArr mutableCopy];
        } else{
            self.seleJuanView.dataArr = [self.cuponArr mutableCopy];
        }
    } else{
        [self requestLogin];
    }
    
//    NSString *amoStr = [_moneyStr stringByReplacingOccurrencesOfString:@"," withString:@""];
//    if (self.AmountText.text.integerValue >= 2000 && amoStr.integerValue >= 2000) {
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        NSDictionary *dic = [defaults objectForKey:@"registerData"];
//        if ([dic objectForKey:@"UserName"]&&[dic objectForKey:@"PassWord"] ) {
//            self.shadowView.hidden = NO;
//            self.seleJuanView.hidden = NO;
//            self.seleJuanView.priceNum = self.AmountText.text.integerValue;
//            self.seleJuanView.dataArr = [self.quanArr mutableCopy];
//        } else{
//            [self requestLogin];
//        }
//    } else{
//        [AddHudView addProgressView:self.view message:@"存入金额和可用余额需大于2000方可查看"];
//    }
}

- (void)noUseABtnClick:(UIButton *)sender{
    self.shadowView.hidden = YES;
    _buyCenView.topLab.textColor = titOrangeColor;
    if (self.AmountText.text.length > 0) {
        _buyCenView.topLab.text = [NSString stringWithFormat:@"您有%ld张优惠券",self.quanArr.count];
    } else {
        _buyCenView.topLab.text = [NSString stringWithFormat:@"您有%ld张优惠券",self.cuponArr.count];
    }
    self.quanID = [NSString stringWithFormat:@"%@",@""];
    self.quanType = [NSString stringWithFormat:@"%@",@""];
    self.incomStr = [NSString stringWithFormat:@"%@",@""];
    self.finalDic = [NSDictionary dictionary];
    NSString *timeStr = @"7天";
    NSString *str = [timeStr substringWithRange:NSMakeRange(timeStr.length-1,1)];
    if ([str isEqualToString:@"天"]) {
        NSString *day = [timeStr substringWithRange:NSMakeRange(0, timeStr.length-1)];
        NSInteger dayCount = [day integerValue];
        if ([MSUStringTools isBlankString:self.incomStr]) {
//            _buyCenView.centerLab.text = [NSString stringWithFormat:@"%.2f元",dayCount/360.00*self.shouyi/100.00*[self.AmountText.text doubleValue]];
            _buyCenView.centerLab.text = [NSString stringWithFormat:@"%@元",[MSUStringTools keepTheDecimalPointWithStr:[NSNumber numberWithDouble:dayCount/360.00*self.shouyi/100.00*[self.AmountText.text doubleValue]].stringValue withRoundingMode:NSRoundPlain]];


        } else {
//            _buyCenView.centerLab.text = [NSString stringWithFormat:@"%.2f+%@",dayCount/360.00*self.shouyi/100.00*[self.AmountText.text doubleValue],self.incomStr];
            _buyCenView.centerLab.text = [NSString stringWithFormat:@"%@+%@",[MSUStringTools keepTheDecimalPointWithStr:[NSNumber numberWithDouble:dayCount/360.00*self.shouyi/100.00*[self.AmountText.text doubleValue]].stringValue withRoundingMode:NSRoundPlain],self.incomStr];

        }
    } else if ([str isEqualToString:@"月"]){
        NSString *month = [timeStr substringWithRange:NSMakeRange(0, timeStr.length-1)];
        NSInteger monthCount = [month integerValue];
        if ([MSUStringTools isBlankString:self.incomStr]) {
//            _buyCenView.centerLab.text = [NSString stringWithFormat:@"%.2f元",monthCount*self.shouyi/12.00/100.00*[self.AmountText.text doubleValue]];
//            _buyCenView.centerLab.text = [NSString stringWithFormat:@"%@元",[MSUStringTools keepTheDecimalPointWithStr:[NSNumber numberWithDouble:[NSString stringWithFormat:@"%.2f",self.shouyi/12.00/100.00*[self.AmountText.text doubleValue]].doubleValue*monthCount].stringValue withRoundingMode:NSRoundPlain]];
            _buyCenView.centerLab.text = [NSString stringWithFormat:@"%.2f元",[MSUStringTools keepTheDecimalPointWithStr:[NSNumber numberWithDouble:self.shouyi/12.00/100.00*[self.AmountText.text doubleValue]].stringValue withRoundingMode:NSRoundPlain].doubleValue*monthCount];


        } else {
//            _buyCenView.centerLab.text = [NSString stringWithFormat:@"%.2f+%@",monthCount*self.shouyi/12.00/100.00*[self.AmountText.text doubleValue],self.incomStr];
//            _buyCenView.centerLab.text = [NSString stringWithFormat:@"%@+%@",[MSUStringTools keepTheDecimalPointWithStr:[NSNumber numberWithDouble:[NSString stringWithFormat:@"%.2f",self.shouyi/12.00/100.00*[self.AmountText.text doubleValue]].doubleValue*monthCount].stringValue withRoundingMode:NSRoundPlain],self.incomStr];
            _buyCenView.centerLab.text = [NSString stringWithFormat:@"%.2f+%@",[MSUStringTools keepTheDecimalPointWithStr:[NSNumber numberWithDouble:self.shouyi/12.00/100.00*[self.AmountText.text doubleValue]].stringValue withRoundingMode:NSRoundPlain].doubleValue*monthCount,self.incomStr];

            
        }
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

- (void)clearTradePWD{
    self.pwdStr = @"";
    _pwdView.pwdTF.text = @"";
    for (UILabel *lab in self.pwdView.pwdArr) {
        lab.text = @"";
    }
}

- (void)closePWDBtnClick:(UIButton *)sender{
    [UIView animateWithDuration:0.25 animations:^{
        self.pwdShadowView.hidden = YES;
//        [_pwdView.pwdTF resignFirstResponder];
        [self.pwdShadowView endEditing:YES];
        
    }];
}

- (void)jieXieBtnClick:(UIButton *)sender{
    if (self.protocalStr.length == 0) {
        [PAProgressView showInView:self.view  contentString:@"无借款协议"];
    } else {
        WebViewController *webVC = [[WebViewController alloc] init];
        webVC.title = @"借款协议";
        webVC.hidesBottomBarWhenPushed = YES;
        webVC.UrlString = self.protocalStr;
        [self.navigationController pushViewController:webVC animated:YES];
//        MSUProtocalController *po = [[MSUProtocalController alloc] init];
//        po.dataArr = self.protocalArr;
//        po.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:po animated:YES];
    }
}

#pragma mark - 初始化
- (MSUShadowInView *)shadowView{
    if (!_shadowView) {
        _shadowView = [[MSUShadowInView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
        _shadowView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [MSUMainWindow addSubview:_shadowView];
        _shadowView.hidden = YES;
    }
    return _shadowView;
}

- (MSUBuyJuanView *)seleJuanView{
    if (!_seleJuanView) {
        _seleJuanView = [[MSUBuyJuanView alloc] initWithFrame:CGRectMake(0, kDeviceHeight-362*kDeviceHeightScale, kDeviceWidth, 362*kDeviceHeightScale)];
        _seleJuanView.backgroundColor = BGWhiteColor;
        [_seleJuanView.noUseABtn addTarget:self action:@selector(noUseABtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.shadowView addSubview:_seleJuanView];
        _seleJuanView.delegate = self;
    }
    return _seleJuanView;
}

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

#pragma mark - UITextField
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
    self.AmountText.text = [NSString stringWithFormat:@"%ld",self.AmountText.text.integerValue/50*50];
    [self fiterCuponWithDataStr:@"1" dataDic:self.finalDic];
    _buyCenView.bottomLab.text = [NSString stringWithFormat:@"%@元",_AmountText.text];
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
        
        [self fiterCuponWithDataStr:@"0" dataDic:nil];
        
       
        _buyCenView.bottomLab.text = [NSString stringWithFormat:@"%@元",filed.text];
        
    }else{
        _buyCenView.topLab.textColor = titOrangeColor;
        _buyCenView.topLab.text = [NSString stringWithFormat:@"您有%ld张优惠券",self.cuponArr.count];
        [self.SureButton setTitle:@"确认存入" forState:UIControlStateNormal];
        _buyCenView.bottomLab.text = @"0元";
        _buyCenView.centerLab.text = @"0元";
    }
}


- (void)cellDidSelectWithDic:(NSDictionary *)dataDic{
    self.shadowView.hidden = YES;
    //    [self changeBuyCenterViewUIWithDic:dataDic];
    [self fiterCuponWithDataStr:@"1" dataDic:dataDic];
}

/* 筛选红包  */
- (void)fiterCuponWithDataStr:(NSString *)dataStr dataDic:(NSDictionary *)dataDic{
    if ([dataStr isEqualToString:@"0"]) {
        // 筛选符合条件红包
        self.quanArr = [NSMutableArray array];
        NSMutableArray *cuponArr = [self.cuponArr mutableCopy];
        for (NSInteger i = 0; i < cuponArr.count; i++) {
            NSDictionary  *dic = cuponArr[i];
            // 红包金额
            NSString *priStr = [NSString stringWithFormat:@"%@",dic[@"useRule"]];
            NSString *str1;
            if ([priStr containsString:@"."]) {
                str1 = [priStr substringToIndex:[priStr rangeOfString:@"."].location];
            }  else{
                str1 = priStr;
            }
            NSString *aaaStr;
            if (str1.length > 0) {
                aaaStr = [str1 substringFromIndex:[str1 rangeOfString:@"满"].location+1];
            } else{
                aaaStr = str1;
            }

            if (aaaStr.integerValue <= self.AmountText.text.integerValue) {
                //            [cuponArr removeObject:dic];
                [self.quanArr addObject:dic];
            }
        }
        
        if (self.quanArr.count == 0) {
            _buyCenView.topLab.textColor = titQianColor;
            _buyCenView.topLab.text = [NSString stringWithFormat:@"暂无可用的优惠券"];
            [self changeBuyCenterViewUIWithDic:nil];
        } else{
            NSDictionary *dic = self.quanArr[0];
            NSString *strs = [[NSString stringWithFormat:@"%@",dic[@"price"]] substringFromIndex:1];
            double cuponIncom = strs.doubleValue;
            
            double jiaxiIncome = 0.00;
            NSDictionary *jiaxiDict = [NSDictionary dictionary];
            for (NSInteger i = 0; i<self.quanArr.count; i++) {
                NSDictionary *dict = self.quanArr[i];
                NSString *jiaxi = [NSString stringWithFormat:@"%@",dict[@"couponType"]];
                NSString *priStr = [[NSString stringWithFormat:@"%@",dict[@"price"]] substringToIndex:[NSString stringWithFormat:@"%@",dict[@"price"]].length-1];
                double price = priStr.doubleValue;
                
                if ([jiaxi containsString:@"0"]) {
                    jiaxiDict = dict;
                    NSString *timeStr = @"七天";
                    NSString *str = [timeStr substringWithRange:NSMakeRange(timeStr.length-1,1)];
                    if ([str isEqualToString:@"天"]) {
                        NSString *day = [timeStr substringWithRange:NSMakeRange(0, timeStr.length-1)];
                        NSInteger dayCount = [day integerValue];
                        jiaxiIncome = dayCount/360.00*price/100.00*[self.AmountText.text doubleValue];
                    } else if ([str isEqualToString:@"月"]){
                        NSString *month = [timeStr substringWithRange:NSMakeRange(0, timeStr.length-1)];
                        NSInteger monthCount = [month integerValue];
//                        jiaxiIncome = [NSString stringWithFormat:@"%.2f",price/12.00/100.00*[self.AmountText.text doubleValue]].doubleValue*monthCount;
                        jiaxiIncome = [MSUStringTools keepTheDecimalPointWithStr:[NSNumber numberWithDouble:price/12.00/100.00*[self.AmountText.text doubleValue]].stringValue withRoundingMode:NSRoundPlain].doubleValue*monthCount;
                    }
                    break;
                }
            }
            
            if (cuponIncom <= jiaxiIncome) {
//                self.incomStr = [NSString stringWithFormat:@"%0.2f(加息)",jiaxiIncome];
                self.incomStr = [NSString stringWithFormat:@"%@(加息)",[MSUStringTools keepTheDecimalPointWithStr:[NSNumber numberWithDouble:jiaxiIncome].stringValue withRoundingMode:NSRoundPlain]];

                self.finalDic = jiaxiDict;
                [self changeBuyCenterViewUIWithDic:jiaxiDict];
            } else {
                self.incomStr = [NSString stringWithFormat:@"%0.2f(返现红包)",cuponIncom];
//                self.incomStr = [NSString stringWithFormat:@"%@(返现红包)",[MSUStringTools keepTheDecimalPointWithStr:[NSNumber numberWithDouble:cuponIncom].stringValue withRoundingMode:NSRoundPlain]];

                self.finalDic = dic;
                [self changeBuyCenterViewUIWithDic:dic];
            }
        }
    } else {
        if (dataDic.allKeys.count > 0) {
            NSString *quanType = [NSString stringWithFormat:@"%@",dataDic[@"couponType"]];
            if ([quanType containsString:@"1"]) {
                self.incomStr = [NSString stringWithFormat:@"%@(返现红包)",[[NSString stringWithFormat:@"%@",dataDic[@"price"]] substringFromIndex:1]];
            } else if ([quanType containsString:@"0"]){
                
                NSString *priStr = [[NSString stringWithFormat:@"%@",dataDic[@"price"]] substringToIndex:[NSString stringWithFormat:@"%@",dataDic[@"price"]].length-1];
                double price = priStr.doubleValue;
                
                NSString *timeStr = @"7天";
                NSString *str = [timeStr substringWithRange:NSMakeRange(timeStr.length-1,1)];
                if ([str isEqualToString:@"天"]) {
                    NSString *day = [timeStr substringWithRange:NSMakeRange(0, timeStr.length-1)];
                    NSInteger dayCount = [day integerValue];
                    //                self.incomStr = [NSString stringWithFormat:@"%0.2f(加息)",dayCount/360.00*price/100.00*[self.AmountText.text doubleValue]];
                    self.incomStr = [NSString stringWithFormat:@"%@(加息)",[MSUStringTools keepTheDecimalPointWithStr:[NSNumber numberWithDouble:dayCount/360.00*price/100.00*[self.AmountText.text doubleValue]].stringValue withRoundingMode:NSRoundPlain]];
                    
                } else if ([str isEqualToString:@"月"]){
                    NSString *month = [timeStr substringWithRange:NSMakeRange(0, timeStr.length-1)];
                    NSInteger monthCount = [month integerValue];
                    //                self.incomStr = [NSString stringWithFormat:@"%0.2f(加息)",monthCount*price/12.00/100.00*[self.AmountText.text doubleValue]];
//                    self.incomStr = [NSString stringWithFormat:@"%@(加息)",[MSUStringTools keepTheDecimalPointWithStr:[NSNumber numberWithDouble:[NSString stringWithFormat:@"%.2f",price/12.00/100.00*[self.AmountText.text doubleValue]].doubleValue*monthCount].stringValue withRoundingMode:NSRoundPlain]];
                    self.incomStr = [NSString stringWithFormat:@"%.2f(加息)",[MSUStringTools keepTheDecimalPointWithStr:[NSNumber numberWithDouble:price/12.00/100.00*[self.AmountText.text doubleValue]].stringValue withRoundingMode:NSRoundPlain].doubleValue*monthCount];
                    
                }
            }else {
                
            }
            
            self.finalDic = dataDic;
            [self changeBuyCenterViewUIWithDic:dataDic];
        } else {
            [self changeBuyCenterViewUIWithDic:nil];
        }
    }
}

- (void)changeBuyCenterViewUIWithDic:(NSDictionary *)dataDic{
    if (dataDic.allKeys.count > 0) {
        self.quanID = [NSString stringWithFormat:@"%@",dataDic[@"couponId"]];
        
        NSString *quanType = [NSString stringWithFormat:@"%@",dataDic[@"couponType"]];
        NSString *quanName;
        if ([quanType containsString:@"1"]) {
            self.quanType = @"1";// 红包对应@“1”
            quanName = [NSString stringWithFormat:@"%@",@"返现红包"];
            
        } else if ([quanType containsString:@"0"]){
            self.quanType = @"2";
            quanName = [NSString stringWithFormat:@"%@",@"加息券"];
        }else {
            self.quanType = @"";
            quanName = [NSString stringWithFormat:@"%@",@"理财券"];
        }
        NSString *str1 = [NSString stringWithFormat:@"%@",dataDic[@"price"]];
        NSString *finaStr;
        if ([str1 containsString:@"."]) {
            finaStr = [str1 substringToIndex:[str1 rangeOfString:@"."].location];
        }  else{
            finaStr = str1;
        }
        
        if (self.quanArr.count == 0) {
            _buyCenView.topLab.textColor = titQianColor;
            _buyCenView.topLab.text = [NSString stringWithFormat:@"暂无可用的优惠券"];
        } else{
            _buyCenView.topLab.textColor = titQianColor;
            _buyCenView.topLab.attributedText = [MSUStringTools makeKeyWordAttributedWithSubText:str1 inOrigiText:[NSString stringWithFormat:@"您已选择%@%@",str1,quanName] font:14 color:titOrangeColor];
            _buyCenView.topBtn.enabled = YES;
        }
    }

    NSString *timeStr = @"7天";
    NSString *str = [timeStr substringWithRange:NSMakeRange(timeStr.length-1,1)];
    if ([str isEqualToString:@"天"]) {
        NSString *day = [timeStr substringWithRange:NSMakeRange(0, timeStr.length-1)];
        NSInteger dayCount = [day integerValue];
        if ([MSUStringTools isBlankString:self.incomStr]) {
//            _buyCenView.centerLab.text = [NSString stringWithFormat:@"%.2f元",dayCount/360.00*self.shouyi/100.00*[self.AmountText.text doubleValue]];
            _buyCenView.centerLab.text = [NSString stringWithFormat:@"%@元",[MSUStringTools keepTheDecimalPointWithStr:[NSNumber numberWithDouble:dayCount/360.00*self.shouyi/100.00*[self.AmountText.text doubleValue]].stringValue withRoundingMode:NSRoundPlain]];

        } else {
//            _buyCenView.centerLab.text = [NSString stringWithFormat:@"%.2f+%@",dayCount/360.00*self.shouyi/100.00*[self.AmountText.text doubleValue],self.incomStr];
            _buyCenView.centerLab.text = [NSString stringWithFormat:@"%@+%@",[MSUStringTools keepTheDecimalPointWithStr:[NSNumber numberWithDouble:dayCount/360.00*self.shouyi/100.00*[self.AmountText.text doubleValue]].stringValue withRoundingMode:NSRoundPlain],self.incomStr];
        }
    } else if ([str isEqualToString:@"月"]){
        NSString *month = [timeStr substringWithRange:NSMakeRange(0, timeStr.length-1)];
        NSInteger monthCount = [month integerValue];
        ;
        if ([MSUStringTools isBlankString:self.incomStr]) {
//            _buyCenView.centerLab.text = [NSString stringWithFormat:@"%.2f元",monthCount*self.shouyi/12.00/100.00*[self.AmountText.text doubleValue]];
//            _buyCenView.centerLab.text = [NSString stringWithFormat:@"%@元",[MSUStringTools keepTheDecimalPointWithStr:[NSNumber numberWithDouble:[NSString stringWithFormat:@"%.2f",self.shouyi/12.00/100.00*[self.AmountText.text doubleValue]].doubleValue*monthCount].stringValue withRoundingMode:NSRoundPlain]];
            _buyCenView.centerLab.text = [NSString stringWithFormat:@"%.2f元",[MSUStringTools keepTheDecimalPointWithStr:[NSNumber numberWithDouble:self.shouyi/12.00/100.00*[self.AmountText.text doubleValue]].stringValue withRoundingMode:NSRoundPlain].doubleValue*monthCount];


        } else {
//            _buyCenView.centerLab.text = [NSString stringWithFormat:@"%.2f+%@",monthCount*self.shouyi/12.00/100.00*[self.AmountText.text doubleValue],self.incomStr];
//            _buyCenView.centerLab.text = [NSString stringWithFormat:@"%@+%@",[MSUStringTools keepTheDecimalPointWithStr:[NSNumber numberWithDouble:[NSString stringWithFormat:@"%.2f",self.shouyi/12.00/100.00*[self.AmountText.text doubleValue]].doubleValue*monthCount].stringValue withRoundingMode:NSRoundPlain],self.incomStr];
           _buyCenView.centerLab.text = [NSString stringWithFormat:@"%.2f+%@",[MSUStringTools keepTheDecimalPointWithStr:[NSNumber numberWithDouble:self.shouyi/12.00/100.00*[self.AmountText.text doubleValue]].stringValue withRoundingMode:NSRoundPlain].doubleValue*monthCount,self.incomStr];

        }
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
    self.AmountText.text = [NSString stringWithFormat:@"%ld",self.AmountText.text.integerValue/50*50];
    [self fiterCuponWithDataStr:@"1" dataDic:self.finalDic];
    _buyCenView.bottomLab.text = [NSString stringWithFormat:@"%@元",_AmountText.text];
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


//键盘通知改变方法
//- (void)keyboardWillShow:(NSNotification *)note{
//    if (_hasPassWord == 0 && self.isShowP) {
//        CGRect keyboard = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//        CGFloat trans = keyboard.origin.y - kDeviceHeight;
//        //    NSLog(@"zhizhzihizhi---%f,%f",keyboard.origin.y,trans);
//        // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
//        double duration = [[note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//
//        [UIView animateWithDuration:duration animations:^{
////            self.pwdView.transform = CGAffineTransformMakeTranslation(0, trans);
//            self.pwdView.frame = CGRectMake(0, kDeviceHeight-137*kDeviceHeightScale+trans, kDeviceWidth, 137*kDeviceHeightScale);
//        }];
//    }
//}

- (void)KeyboardWillChangeFrame:(NSNotification *)note{
    if (_hasPassWord == 0 && self.isShowP) {
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
        if ((textField.text.length > 0 && textField.text.length < 7)|| textField.text.length == 0) {
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

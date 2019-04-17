//
//  TopUpViewController.m
//  WTJR
//
//  Created by H on 16/6/6.
//  Copyright © 2016年 HM. All rights reserved.
//

#import "TopUpViewController.h"
#import "UIImageView+WebCache.h"
#import <Security/Security.h>
#import "LoginViewController.h"
#import "ToUPSureViewController.h"
#import "TopupWebViewController.h"
#import "LLPaySdk.h"
#import "TopUpResultViewController.h"
#import "BankLimitViewController.h"
#import "TradeRecordViewController.h"
#import <FUMobilePay/FUMobilePay.h>
#import "MSUTopUpFailController.h"
#import "BankPayViewController.h"

#import "MSUStringTools.h"
#import "MSUPathTools.h"

#import "BankLimitModel.h"

@interface TopUpViewController ()<LLPaySdkDelegate>


@property (weak, nonatomic) IBOutlet UILabel *canUselabel;
@property (weak, nonatomic) IBOutlet UITextField *moneyText;
@property (weak, nonatomic) IBOutlet UIView *BankBackImage;
@property (weak, nonatomic) IBOutlet UILabel *bankName;
@property (weak, nonatomic) IBOutlet UILabel *bankID;
@property (weak, nonatomic) IBOutlet UIImageView *bankImage;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (nonatomic,strong) NSString *textorture;
@property (nonatomic,strong) NSString *OrderIdStr;
@property (weak, nonatomic) IBOutlet UIButton *PayTypeRBButton;
@property (weak, nonatomic) IBOutlet UIButton *PayTypeLLButton;
@property (weak, nonatomic) IBOutlet UIButton *LimitButton;
@property (weak, nonatomic) IBOutlet UITextView *phoneTV;
@property (weak, nonatomic) IBOutlet UIView *inputView;
@property (nonatomic , strong) NSTimer *clickTimer;

@property (nonatomic , strong) NSMutableArray *limitArr;

@end

@implementation TopUpViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationItemTitleView];
    self.title = @"充值";
    
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(0, self.inputView.bottom, kDeviceWidth, 160);
    bgView.backgroundColor = HEXCOLOR(0xffffff);
    [self.view insertSubview:bgView atIndex:0];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(10, 0, kDeviceWidth-20, 1);
    lineView.backgroundColor = LineColor;
    [bgView addSubview:lineView];
    
    UIImageView *imaView = [[UIImageView alloc] initWithFrame:CGRectMake(17, 130, 16, 16)];
    imaView.image = [MSUPathTools showImageWithContentOfFileByName:@"tx"];
    [bgView addSubview:imaView];
    
    UILabel *attentionLab = [[UILabel alloc] init];
    attentionLab.frame = CGRectMake(imaView.right + 5, 130, kDeviceWidth-40, 18);
    attentionLab.text = @"大额充值可登陆官网 www.vimzx.com 进行操作";
    attentionLab.font = [UIFont systemFontOfSize:13];
    attentionLab.textColor = HEXCOLOR(0x6aacfc);
    [bgView addSubview:attentionLab];

    self.type = TopUpType_LianLian;
    self.PayTypeRBButton.layer.cornerRadius = 5;
    self.PayTypeLLButton.layer.cornerRadius = 5;
    [self.PayTypeLLButton setImage:[MSUPathTools showImageWithContentOfFileByName:@"lianlian"] forState:UIControlStateNormal];
    [self.PayTypeRBButton setImage:[MSUPathTools showImageWithContentOfFileByName:@"fuyou"] forState:UIControlStateNormal];
    self.PayTypeLLButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.PayTypeRBButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _PayTypeLLButton.imageEdgeInsets = UIEdgeInsetsMake(12.5, 17, 12.5, 17);
    _PayTypeRBButton.imageEdgeInsets = UIEdgeInsetsMake(12.5, 17, 12.5, 17);
    _PayTypeLLButton.adjustsImageWhenHighlighted = NO;
    _PayTypeRBButton.adjustsImageWhenHighlighted = NO;
    self.moneyText.borderStyle = UITextBorderStyleNone;
    

    
    [self.moneyText setValue:TEXTFONT(16) forKeyPath:@"_placeholderLabel.font"];
    self.moneyText.contentVerticalAlignment =UIControlContentVerticalAlignmentCenter;
    
    if (self.type == TopUpType_FuYou) {
        self.PayTypeLLButton.selected = NO;
        self.PayTypeRBButton.selected = YES;
        self.PayTypeLLButton.layer.borderColor = RGBA(228, 228, 228, 1).CGColor;
        self.PayTypeLLButton.layer.borderWidth = 0.5;
        self.PayTypeRBButton.layer.borderColor = HEXCOLOR(0xf54e4e).CGColor;
        self.PayTypeRBButton.layer.borderWidth = 0.5;
    }else{
        self.PayTypeRBButton.selected = NO;
        self.PayTypeLLButton.selected = YES;
        self.PayTypeRBButton.layer.borderColor = RGBA(228, 228, 228, 1).CGColor;
        self.PayTypeRBButton.layer.borderWidth = 0.5;
        self.PayTypeLLButton.layer.borderColor = HEXCOLOR(0xf54e4e).CGColor;
        self.PayTypeLLButton.layer.borderWidth = 0.5;
    }
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    [self.view addGestureRecognizer:tapGesture];
    
    self.textorture = @"0";

    UIView *space1 =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, self.moneyText.height)];
    self.moneyText.leftView = space1;
    self.moneyText.leftViewMode = UITextFieldViewModeAlways;
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30,self.moneyText.height)];
    lable.text = @"¥";
    lable.font = TEXTFONT(36);
    lable.textColor = [UIColor colorWithHex:0x222222];
    lable.textAlignment = NSTextAlignmentLeft;
    [space1 addSubview:lable];
    
    [self requestBankInfo];
    [self requestBankLimitData];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *NSdic = [defaults objectForKey:@"userInfoDetial"];
    NSString *canUseStr = [NSString stringWithFormat:@"当前可用余额%@元",[NSdic objectForKey:@"availableAmount"]];
    self.canUselabel.attributedText = [MSUStringTools makeKeyWordAttributedWithSubText:[NSdic objectForKey:@"availableAmount"] inOrigiText:canUseStr font:14 color:HEXCOLOR(0xfb6337)];
    self.moneyText.inputAccessoryView = [self addToolbar];
    
    UIButton *tapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tapBtn.frame = CGRectMake(self.phoneTV.left, self.phoneTV.bottom-40, self.phoneTV.width, 40);
    [self.view addSubview:tapBtn];
    [tapBtn addTarget:self action:@selector(tapBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *str = @"400-0571-115";
    self.phoneTV.attributedText = [MSUStringTools makeLineSpaceAndAttributedWithSubText:str inOrigiText:self.phoneTV.text font:13 color:titOrangeColor space:5];
    [self.phoneTV sizeToFit];
}

- (void)addNavigationItemTitleView{
    UIButton *listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [listButton setTitleColor:[UIColor colorWithHex:0x666666] forState:UIControlStateNormal];
    [listButton setTitle:@"充值记录" forState:UIControlStateNormal];
    listButton.titleLabel.font = TEXTFONT(14);
    listButton.frame = CGRectMake(0, 0, 60, 30);
    [listButton addTarget:self action:@selector(listButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:listButton];
    self.navigationItem.rightBarButtonItem = rightItem;
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

#pragma mark - 点击事件
- (void)tapBtnClick:(UIButton *)sender{
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

- (void)textFieldDone{
    [self.view endEditing:YES];
}

- (void)listButtonClick{
    TradeRecordViewController *VC= [[TradeRecordViewController alloc] init];
    VC.TrandeFromType = TrandeRecordFromType_TOPUP;
    VC.TrandeType = TrandeRecordTypeRecharge;
    [self.navigationController pushViewController:VC animated:YES];
}

- (IBAction)payTypeRBButtonclick:(id)sender {
    self.type = TopUpType_FuYou;
    self.LimitButton.hidden = YES;
    self.PayTypeLLButton.selected = NO;
    self.PayTypeRBButton.selected = YES;
    self.PayTypeLLButton.layer.borderColor = RGBA(228, 228, 228, 1).CGColor;
    self.PayTypeLLButton.layer.borderWidth = 0.5;
    self.PayTypeRBButton.layer.borderColor = HEXCOLOR(0xf54e4e).CGColor;
    self.PayTypeRBButton.layer.borderWidth = 0.5;
}

- (IBAction)payTypeLLButtonclick:(id)sender {
    self.LimitButton.hidden = NO;
    self.type = TopUpType_LianLian;
    self.PayTypeRBButton.selected = NO;
    self.PayTypeLLButton.selected = YES;
    self.PayTypeRBButton.layer.borderColor = RGBA(228, 228, 228, 1).CGColor;
    self.PayTypeRBButton.layer.borderWidth = 0.5;
    self.PayTypeLLButton.layer.borderColor = HEXCOLOR(0xf54e4e).CGColor;
    self.PayTypeLLButton.layer.borderWidth = 0.5;
}

- (void)requestBankLimitData{
    [[DataRequestServer getDataRequestServerData] request:@"LunaP2pAppBankLimitServlet" parameters:nil result:^(id result) {
        if ([result isKindOfClass:[NSString class]] &&  [result isEqualToString:@"44"]) {
            [AddHudView addProgressView:self.view message:@"获取银行卡限额失败，请重新刷新"];
        }else if ([[result objectForKey:@"success"]intValue]==1 && [[result objectForKey:@"errorlog"]isEqualToString:@""]){
            
            if (self.limitArr.count>0) {
                [self.limitArr removeAllObjects];
            } else{
                self.limitArr = [NSMutableArray array];
            }
            NSArray *arr =[result objectForKey:@"items"];
            for (NSDictionary *dic in arr) {
                BankLimitModel *model = [[BankLimitModel alloc] initWithContent:dic];
                [self.limitArr addObject:model];
            }
        }else{
            [AddHudView addProgressView:self.view message:@"获取银行卡限额信息失败，请重新刷新"];
        }
    }];
}


- (void)requestBankInfo{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [[DataRequestServer getDataRequestServerData] request:@"LunaP2pAppBankServlet" parameters:nil result:^(id result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([result isKindOfClass:[NSString class]] &&  [result isEqualToString:@"44"]) {
            [AddHudView addProgressView:self.view message:@"获取银行卡信息失败，请重新操作"];
        }else if([[result objectForKey:@"success"]intValue]==1 && [[result objectForKey:@"errorlog"]isEqualToString:@""]){
    
            NSArray *DataArr= [result objectForKey:@"items"];
            if (DataArr && DataArr.count>0) {
                NSDictionary *dic= [DataArr objectAtIndex:0];
                self.bankID.text = [NSString stringWithFormat:@"尾号%@",[dic objectForKey:@"accountNumber"]];
                self.bankName.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"bankType"]];
                [self.bankImage sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"bankIcon"]] placeholderImage:[UIImage imageNamed:@"image_empty"]];
            }
        }else{
            [AddHudView addProgressView:self.view message:@"获取银行卡信息失败，请重新操作"];
        }
    }];
}

- (IBAction)orderSure:(id)sender {
    [self KeyboardresignFirstResponder];
    
    NSNumber *a=[NSNumber numberWithFloat:self.moneyText.text.floatValue];
    NSNumber *b=[NSNumber numberWithFloat:50];

    if (self.moneyText.text == nil ||self.moneyText.text.length == 0) {
        [AddHudView addProgressView:self.view message:@"充值金额不得为空"];
        return;
    }
    if ([a compare:b]==NSOrderedAscending){
        [AddHudView addProgressView:self.view message:@"请输入正确的充值金额,最低充值金额50元"];
        return;
    }
    
    if (self.type == TopUpType_FuYou) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setObject:@"8" forKey:@"payConfigId"];
        [param setObject:[NSString stringWithFormat:@"%.02f",[self.moneyText.text floatValue]] forKey:@"rechargeAmount"];
        
        [[DataRequestServer getDataRequestServerData] request:@"FuyouSdkPayServlet" parameters:param result:^(id result) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            if ([result isKindOfClass:[NSString class]] &&  [result isEqualToString:@"44"]) {
                [AddHudView addProgressView:self.view message:@"网络错误，请稍后再试"];
            }else if([[result objectForKey:@"success"]intValue]==0 && [[result objectForKey:@"errorlog"]isEqualToString:@"noLogin"]){
                [self requestLogin];
            }else if([[result objectForKey:@"success"]intValue]==1 && [[result objectForKey:@"errorlog"]isEqualToString:@""]){
                
                NSMutableDictionary *Dic = [[NSMutableDictionary alloc] initWithDictionary:result];
                BOOL test = [[Dic objectForKey:@"TEST"] boolValue];
                NSNumber * testNumber = [NSNumber numberWithBool:test];
                [Dic setObject:testNumber forKey:@"TEST"];
                [Dic removeObjectForKey:@"errorlog"];
                [Dic removeObjectForKey:@"success"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    FUMobilePay * pay = [FUMobilePay shareInstance];
                    if([pay respondsToSelector:@selector(mobilePay:delegate:)])
                        [pay performSelector:@selector(mobilePay:delegate:) withObject:Dic withObject:self];
                });
            }
            else{
                [AddHudView addProgressView:self.view message:@"提交充值失败，请重新操作"];
            }
        }];
    }else{

        for (BankLimitModel *model in self.limitArr) {
            if ([self.bankName.text isEqualToString:model.bankName]) {
                if (self.moneyText.text.floatValue < (model.singleAmt.floatValue*10000)) {//(model.singleAmt.floatValue*10000
                    MyLog(@"=====没超过限额");
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
                    [param setObject:@"5" forKey:@"payConfigId"];
                    [param setObject:[NSString stringWithFormat:@"%.02f",[self.moneyText.text floatValue]] forKey:@"rechargeAmount"];
                    
                    [[DataRequestServer getDataRequestServerData] request:@"LianLianSdkPayServlet" parameters:param result:^(id result) {
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        
                        if ([result isKindOfClass:[NSString class]] &&  [result isEqualToString:@"44"]) {
                            [AddHudView addProgressView:self.view message:@"网络错误，请稍后再试"];
                        }else if([[result objectForKey:@"success"]intValue]==0 && [[result objectForKey:@"errorlog"]isEqualToString:@"noLogin"]){
                            [self requestLogin];
                        }else if([[result objectForKey:@"success"]intValue]==1 && [[result objectForKey:@"errorlog"]isEqualToString:@""]){
                            // 进行签名
                            NSMutableDictionary *signedOrder = [result mutableCopy];
                            
                            if ([signedOrder objectForKey:@"success"]) {
                                [signedOrder removeObjectForKey:@"success"];
                            }
                            if ([signedOrder objectForKey:@"errorlog"]) {
                                [signedOrder removeObjectForKey:@"errorlog"];
                            }
                            
                            NSArray *risk_itemArr = [signedOrder objectForKey:@"risk_item_ios"];
                            for (NSString *key in signedOrder.allKeys) {
                                NSString *String = [NSString stringWithFormat:@"%@",[signedOrder objectForKey:key]];
                                if (String != NULL && String.length>0) {
                                    [signedOrder setObject:String forKey:key];
                                }else{
                                    [signedOrder removeObjectForKey:key];
                                }
                            }
                            
                            NSMutableString *mutStr = [[NSMutableString alloc] init];
                            
                            for (NSInteger i = 0; i<risk_itemArr.count; i++) {
                                NSDictionary *Dic = [risk_itemArr objectAtIndex:i];
                                if (Dic &&i == 0) {
                                    for (NSString *key in Dic) {
                                        [mutStr appendString:[NSString stringWithFormat:@"{\"%@\":\"%@\",",key,[NSString stringWithFormat:@"%@",[Dic objectForKey:key]]]];
                                    }
                                }else if (i == risk_itemArr.count-1){
                                    for (NSString *key in Dic) {
                                        [mutStr appendString:[NSString stringWithFormat:@"\"%@\":\"%@\"}",key,[NSString stringWithFormat:@"%@",[Dic objectForKey:key]]]];
                                    }
                                }else{
                                    for (NSString *key in Dic) {
                                        [mutStr appendString:[NSString stringWithFormat:@"\"%@\":\"%@\",",key,[NSString stringWithFormat:@"%@",[Dic objectForKey:key]]]];
                                    }
                                }
                            }
                            [signedOrder removeObjectForKey:@"risk_item_ios"];
                            [signedOrder setObject:mutStr forKey:@"risk_item"];
                            [LLPaySdk sharedSdk].sdkDelegate = self;
                            //接入什么产品就传什么LLPayType
                            [[LLPaySdk sharedSdk] presentLLPaySDKInViewController:self
                                                                      withPayType:LLPayTypeVerify
                                                                    andTraderInfo:signedOrder];
                        }
                        else{
                            [AddHudView addProgressView:self.view message:@"提交充值失败，请重新操作"];
                        }
                    }];
                    MyLog(@"连连支付");
                } else{
                    MyLog(@"=====超过限额");
                    BankPayViewController *vc = [[BankPayViewController alloc] init];
                    vc.moneyText = self.moneyText.text;
                    vc.bankName = self.bankName.text;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                
            }
        }

        
       
    }
}

-(void) payCallBack:(BOOL) success responseParams:(NSDictionary*) responseParams{
    if (success) {
        TopUpResultViewController *VC= [[TopUpResultViewController alloc] init];
        VC.isSucess = YES;
        [TalkingData trackEvent:@"资金充值" label:@"资金充值"];
        VC.AmountStr = self.moneyText.text;
        [self.navigationController pushViewController:VC animated:YES];
    }else{
//        [AddHudView addProgressView:self.view message:[responseParams objectForKey:@"RESPONSEMSG"]];
        MSUTopUpFailController *fail = [[MSUTopUpFailController alloc] init];
        fail.AmountStr = self.moneyText.text;
        fail.failCode = [NSString stringWithFormat:@"%@",[responseParams objectForKey:@"RESPONSECODE"]];
        fail.orderNum = [NSString stringWithFormat:@"%@",[responseParams objectForKey:@"ORDERID"]];
        fail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:fail animated:YES];
    }
}

- (void)postDatacertificateUrl:(NSString *)certificateUrl merchant_id:(NSString *)merchant_id encryptkey:(NSString *) encryptkey  data:(NSString *)data{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:data forKey:@"data"];
    [param setObject:encryptkey forKey:@"encryptkey"];
    [param setObject:merchant_id forKey:@"merchant_id"];

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 60;
    
    [manager POST:certificateUrl parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        NSString *result = [[NSString alloc] initWithData:responseObject  encoding:NSUTF8StringEncoding];
        if (result) {
            TopupWebViewController *webView = [[TopupWebViewController alloc] init];
            webView.AmountStr = [NSString stringWithFormat:@"%.02f",[self.moneyText.text floatValue]];
            webView.OrderIdStr = self.OrderIdStr;
            webView.urlString = result;
            [self.navigationController pushViewController:webView animated:YES];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [[DataRequestServer getDataRequestServerData] requestImportWithUrl:certificateUrl Error:error urlParams:param];

    }];
}

- (void)requestLogin{
    [[DataRequestServer getDataRequestServerData] requestLoginresult:^(NSString *LoginState) {
        if ([LoginState isEqualToString:@"true"]) {
        
        }else{
            [AddHudView addProgressView:self.view message:@"登录失效，请重新登录"];
            double delayInSeconds = 1.0;
            __weak __block TopUpViewController* BlockVC = self;
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

-(void)callBack:(NSString*)params
{
    NSLog(@"返回的参数是：%@",params);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"支付结果:%@",params] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
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
    if ([self.moneyText isFirstResponder])//判断是否是第一响应
    {
        [self.moneyText resignFirstResponder];
    }
}

- (void)tapClick{
    [self KeyboardresignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)BackViewController{
    [self KeyboardresignFirstResponder];
    NSArray *viewcontrollers=self.navigationController.viewControllers;
    if (viewcontrollers.count>1) {
        if ([viewcontrollers objectAtIndex:viewcontrollers.count-1]==self) {
            //push方式
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else{
        //present方式
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)BankLimitButtonClick:(id)sender {
    BankLimitViewController *VC= [[BankLimitViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma - mark 支付结果 LLPaySdkDelegate
// 订单支付结果返回，主要是异常和成功的不同状态
// TODO: 开发人员需要根据实际业务调整逻辑
- (void)paymentEnd:(LLPayResult)resultCode withResultDic:(NSDictionary *)dic {
    NSString *msg = @"异常";
    switch (resultCode) {
        case kLLPayResultSuccess: {
            TopUpResultViewController *VC= [[TopUpResultViewController alloc] init];
            VC.isSucess = YES;
            VC.AmountStr = self.moneyText.text;
            [self.navigationController pushViewController:VC animated:YES];
            [TalkingData trackEvent:@"资金充值" label:@"资金充值"];
        } break;
        case kLLPayResultFail: {
            msg = @"充值失败";
        } break;
        case kLLPayResultCancel: {
            msg = @"取消充值";
        } break;
        case kLLPayResultInitError: {
            msg = @"sdk初始化异常";
        } break;
        case kLLPayResultInitParamError: {
            msg = dic[@"ret_msg"];
        } break;
        default:
            break;
    }
//    [AddHudView addProgressView:self.view message:msg];
    [PAProgressView showInView:self.view  contentString:msg];
    
    if ([msg isEqualToString:@"取消充值"]) {
        [self BackViewController];
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
            if([textField.text length] == 0)
            {
                if(single == '.')
                {
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            
                if (single == '0')
                {
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

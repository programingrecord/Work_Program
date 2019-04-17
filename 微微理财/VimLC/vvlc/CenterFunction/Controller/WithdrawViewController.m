//
//  WithdrawViewController.m
//  WTJR
//
//  Created by H on 16/6/6.
//  Copyright © 2016年 HM. All rights reserved.
//

#import "WithdrawViewController.h"
#import "UIImageView+WebCache.h"
#import "PasswordModifyVC.h"
#import "LoginViewController.h"
#import "WithDrawNotiViewController.h"
#import "TradeRecordViewController.h"
#import "PopWhiteView.h"
#import "MSUCustomTF1.h"
#import "MSUTextField.h"
#import "MSUStringTools.h"
#import "MSUShadowView.h"

@interface WithdrawViewController ()<UITextFieldDelegate,MSUTextFieldDelegate>
@property (weak, nonatomic) IBOutlet MSUCustomTF1 *MoneyText;
@property (weak, nonatomic) IBOutlet UILabel *CardName;
@property (weak, nonatomic) IBOutlet UILabel *CardNum;
@property (weak, nonatomic) IBOutlet UIImageView *CardImage;

@property (nonatomic,strong) UIView *alphaView;
@property (nonatomic,strong) MSUTextField *topTX;
@property (nonatomic , strong) NSMutableArray *pwdBtnArr;
@property (nonatomic , copy) NSString *pwdStr;

@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) NSMutableDictionary *Params;

@property (nonatomic,strong) NSString *CardNumString;

@property (nonatomic,strong) PopWhiteView *popView;

@property (nonatomic,strong) NSString *canWithdrawAmount;

@property (nonatomic , strong) UILabel *chargeLab;

@property (nonatomic , strong) MSUShadowView *shadowView;
@property (nonatomic , strong) UIView *podView;
@property (nonatomic , strong) UILabel *podLab;

@end

@implementation WithdrawViewController

- (void)viewWillAppear:(BOOL)animated{
    self.Params = [[NSMutableDictionary alloc] init];
    [self requestBankInfo];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationItemTitleView];
    self.title = @"提  现";
    
    if (iOS11) {
        self.MoneyText.tfType = MSUNone30;
    } else{
        self.MoneyText.tfType = MSUTypeRightDown;
    }
    self.MoneyText.borderStyle = UITextBorderStyleNone;
    [self.MoneyText setValue:TEXTFONT(16) forKeyPath:@"_placeholderLabel.font"];
    self.MoneyText.contentVerticalAlignment =UIControlContentVerticalAlignmentCenter;
    self.MoneyText.inputAccessoryView = [self addToolbar];
    
    UIView *space1 =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, self.MoneyText.height)];
    self.MoneyText.leftView = space1;
    self.MoneyText.leftViewMode = UITextFieldViewModeAlways;
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20,self.MoneyText.height)];
    lable.text = @"¥";
    lable.font = TEXTFONT(20);
    lable.textColor = [UIColor colorWithHex:0x222222];
    lable.textAlignment = NSTextAlignmentLeft;
    [space1 addSubview:lable];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(0, 172, kDeviceWidth, 0.5);
    lineView.backgroundColor = HEXCOLOR(0xe8e8e8);
    [self.view addSubview:lineView];
    
    UILabel *attentionLab = [[UILabel alloc] init];
    attentionLab.frame = CGRectMake(15, lineView.bottom + 12.5, 50, 35);
    attentionLab.backgroundColor = HEXCOLOR(0xffffff);
    attentionLab.text = @"手续费";
    attentionLab.font = [UIFont systemFontOfSize:16];
    attentionLab.textColor = HEXCOLOR(0x2a2a2a);
    [self.view addSubview:attentionLab];
    
    self.chargeLab = [[UILabel alloc] init];
    _chargeLab.frame = CGRectMake(kDeviceWidth*0.5-15, lineView.bottom + 12.5, kDeviceWidth*0.5, 35);
    _chargeLab.backgroundColor = HEXCOLOR(0xffffff);
    _chargeLab.textAlignment = NSTextAlignmentRight;
    _chargeLab.text = @"--元";
    _chargeLab.font = [UIFont systemFontOfSize:14];
    _chargeLab.textColor = HEXCOLOR(0x939393);
    [self.view addSubview:_chargeLab];

    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyBoard:)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)addNavigationItemTitleView{
    UIButton *listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [listButton setTitleColor:[UIColor colorWithHex:0x666666] forState:UIControlStateNormal];
    [listButton setTitle:@"提现记录" forState:UIControlStateNormal];
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

- (void)requestBankInfo{
    [[DataRequestServer getDataRequestServerData] request:@"LunaP2pAppBankServlet" parameters:nil result:^(id result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([result isKindOfClass:[NSString class]] &&  [result isEqualToString:@"44"]) {
            [AddHudView addProgressView:self.view message:@"网络错误，请稍后再试"];
        }else if([[result objectForKey:@"success"]intValue]==1 && [[result objectForKey:@"errorlog"]isEqualToString:@""]){
            
            self.canWithdrawAmount = [NSString stringWithFormat:@"%@",[result objectForKey:@"canWithdrawAmount"]];
            self.MoneyText.placeholder = [NSString stringWithFormat:@"可提现%@元",self.canWithdrawAmount];
            
            NSArray *DataArr= [result objectForKey:@"items"];
            NSDictionary *dic= [DataArr objectAtIndex:0];
            self.CardNum.text = [NSString stringWithFormat:@"**** **** **** %@",[dic objectForKey:@"accountNumber"]];
            self.CardName.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"bankType"]];
            [self.Params setObject:[dic objectForKey:@"bankId"] forKey:@"withdrawBankId"];
            [self.CardImage sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"bankIcon"]] placeholderImage:[UIImage imageNamed:@"image_empty"]];
            self.CardNumString = [NSString stringWithFormat:@"%@",[dic objectForKey:@"accountNumber"]];
            
            NSString *chargeMoney = [NSString stringWithFormat:@"%@",result[@"chargeMoney"]];
            if ([chargeMoney isEqualToString:@"0"]) {
                self.chargeLab.text = [NSString stringWithFormat:@"%@",@"免费"];
            } else{
                self.chargeLab.text = [NSString stringWithFormat:@"%@元",chargeMoney];
            }
        }else{
            [AddHudView addProgressView:self.view message:@"绑定失败，请重新操作"];
        }
    }];
}

- (UIView *)SureWithDrawView{
    UIView *WhiteView = [[UIView alloc] init];
    WhiteView.center = _alphaView.center;
    WhiteView.bounds = CGRectMake(0, 0, _alphaView.width-60, _alphaView.width);
    WhiteView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLable = [[UILabel alloc] init];
    titleLable.frame = CGRectMake(20,5, WhiteView.width-40, 30);
    titleLable.text = @"确认提现信息";
    titleLable.font = [UIFont systemFontOfSize:16.0];
    titleLable.textColor = RGBA(51, 51, 51, 1);
    titleLable.textAlignment = NSTextAlignmentCenter;
    [WhiteView addSubview:titleLable];
    
    UILabel *MoneyLable = [[UILabel alloc] init];
    MoneyLable.frame = CGRectMake(20,titleLable.bottom+10, WhiteView.width-40, 30);
    MoneyLable.text = [NSString stringWithFormat:@"提现金额（元）：%@",_MoneyText.text];
    MoneyLable.font = [UIFont systemFontOfSize:15.0];
    MoneyLable.textColor = RGBA(51, 51, 51, 1);
    MoneyLable.textAlignment = NSTextAlignmentLeft;
    [WhiteView addSubview:MoneyLable];
    
    UILabel *CommissionLable = [[UILabel alloc] init];
    CommissionLable.frame = CGRectMake(20,MoneyLable.bottom, WhiteView.width-40, 30);
    //    CommissionLable.text = [NSString stringWithFormat:@"提现手续费(元)：%@",_MoneyText.text];
    CommissionLable.font = [UIFont systemFontOfSize:15.0];
    CommissionLable.textColor = RGBA(51, 51, 51, 1);
    CommissionLable.textAlignment = NSTextAlignmentLeft;
    [WhiteView addSubview:CommissionLable];
    
    UILabel *CardInfo = [[UILabel alloc] init];
    CardInfo.frame = CGRectMake(20,CommissionLable.bottom+10, WhiteView.width-40, 30);
    CardInfo.text = [NSString stringWithFormat:@"所属银行：%@",self.CardName.text];
    CardInfo.font = [UIFont systemFontOfSize:15.0];
    CardInfo.textColor = RGBA(51, 51, 51, 1);
    CardInfo.textAlignment = NSTextAlignmentLeft;
    [WhiteView addSubview:CardInfo];
    
    UILabel *CardNum = [[UILabel alloc] init];
    CardNum.frame = CGRectMake(20,CardInfo.bottom, WhiteView.width-40, 30);
    CardNum.text = [NSString stringWithFormat:@"储蓄卡号：%@",self.CardNum.text];
    CardNum.font = [UIFont systemFontOfSize:15.0];
    CardNum.textColor = RGBA(51, 51, 51, 1);
    CardNum.textAlignment = NSTextAlignmentLeft;
    [WhiteView addSubview:CardNum];
    
    UILabel *AlertLable = [[UILabel alloc] init];
    AlertLable.frame = CGRectMake(20,CardNum.bottom+10, WhiteView.width-40, 50);
    AlertLable.text = [NSString stringWithFormat:@"预计1-2个工作日到账。为了顺利提现，请确认你的银行卡信息无误。"];
    AlertLable.numberOfLines = 0;
    AlertLable.font = [UIFont systemFontOfSize:13.0];
    AlertLable.textColor = RGBA(194, 194, 194, 1);
    AlertLable.textAlignment = NSTextAlignmentLeft;
    [WhiteView addSubview:AlertLable];
    
    UIButton *BackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    BackButton.layer.borderWidth = 0.5;
    BackButton.layer.cornerRadius = 3.0;
    BackButton.tag = 100;
    BackButton.layer.borderColor = [UIColor colorWithHex:0xFB6337].CGColor;
    BackButton.frame = CGRectMake(20, AlertLable.bottom +10, WhiteView.width/2-30, 42);
    [BackButton setTitle:@"返回修改" forState:UIControlStateNormal];
    [BackButton setTitleColor:[UIColor colorWithHex:0xFB6337] forState:UIControlStateNormal];
    [BackButton addTarget:self action:@selector(BackOrSure:) forControlEvents:UIControlEventTouchUpInside];
    [WhiteView addSubview:BackButton];
    
    UIButton *SureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    SureButton.layer.cornerRadius = 3.0;
    SureButton.frame = CGRectMake(WhiteView.width/2+10, AlertLable.bottom +10, WhiteView.width/2-30, 42);
    [SureButton setTitle:@"确  认" forState:UIControlStateNormal];
    SureButton.tag = 101;
    [SureButton addTarget:self action:@selector(BackOrSure:) forControlEvents:UIControlEventTouchUpInside];
    
    [SureButton setBackgroundColor:[UIColor colorWithHex:0xFB6337]];
    [SureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [WhiteView addSubview:SureButton];
    WhiteView.bounds = CGRectMake(0, 0, _alphaView.width-60, SureButton.bottom +20);
    return WhiteView;
}

- (UIView *)addPassWordView{
    UIView *WhiteView = [[UIView alloc] init];
    WhiteView.center = CGPointMake(_alphaView.center.x, _alphaView.center.y-100);
    WhiteView.bounds = CGRectMake(0, 0, _alphaView.width-60, 240);
    WhiteView.backgroundColor = [UIColor whiteColor];
    WhiteView.layer.cornerRadius = 12;
    [_alphaView addSubview:WhiteView];
    
    UIButton *CancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CancelButton.layer.cornerRadius = 5;
    CancelButton.layer.borderColor = RGBA(237, 128, 17, 1).CGColor;
    CancelButton.frame = CGRectMake(WhiteView.width-30, 10,16, 16);
    [CancelButton setBackgroundImage:[UIImage imageNamed:@"icon-close"] forState:UIControlStateNormal];
    [CancelButton addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [WhiteView addSubview:CancelButton];
    
    UILabel *titleLable = [[UILabel alloc] init];
    titleLable.frame = CGRectMake(20,25, WhiteView.width-40, 25);
    titleLable.text = @"输入交易密码";
    titleLable.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18];
    titleLable.textColor = RGBA(0, 0, 0, 1);
    titleLable.textAlignment = NSTextAlignmentCenter;
    [WhiteView addSubview:titleLable];
    
//    _topTX = [[UITextField alloc] init ];
//    _topTX.frame = CGRectMake(24, titleLable.bottom +24, WhiteView.width-48, 49);
//    _topTX.borderStyle = UITextBorderStyleRoundedRect;
//    _topTX.secureTextEntry = YES;
//    _topTX.placeholder = @"请输入交易密码";
//    _topTX.delegate = self;
//    _topTX.clearButtonMode = UITextFieldViewModeWhileEditing;
//    _topTX.clearsOnBeginEditing = YES;
//    [WhiteView addSubview:_topTX];
//    [_topTX becomeFirstResponder];
    
    
    self.topTX = [[MSUTextField alloc] init];
    //    _pwdTF.backgroundColor  = [UIColor clearColor];
    _topTX.frame = CGRectMake(24, titleLable.bottom +24, WhiteView.width-48, 42);
    _topTX.textColor = HEXCOLOR(0xf4f4f4);
    _topTX.keyboardType = UIKeyboardTypeNumberPad;
    _topTX.delegate = self;
    [WhiteView addSubview:_topTX];
    [_topTX addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_topTX becomeFirstResponder];
    
    //    MSUTextField *msu = [[MSUTextField alloc] init];
    //    msu.delegate = self;
    
    UIView *fuView = [[UIView alloc] init];
    fuView.frame = CGRectMake(24, titleLable.bottom +24, 242, 42);
    fuView.backgroundColor = HEXCOLOR(0xffffff);
    [WhiteView addSubview:fuView];
    fuView.layer.borderWidth = 1;
    fuView.layer.borderColor = HEXCOLOR(0x979797).CGColor;
    
    CGFloat wid = 40;
    for (NSInteger i = 0; i < 6; i++) {
        UILabel *pwdLab = [[UILabel alloc] init];
        pwdLab.frame = CGRectMake(wid*i, 0, wid, wid);
        pwdLab.textAlignment = NSTextAlignmentCenter;
        pwdLab.backgroundColor = HEXCOLOR(0xffffff);
        //            pwdLab.layer.borderWidth = 1;
        //            pwdLab.layer.borderColor = HEXCOLOR(0x979797).CGColor;
        pwdLab.textColor = HEXCOLOR(0x333333);
        pwdLab.font = [UIFont systemFontOfSize:14];
        [fuView addSubview:pwdLab];
        [self.pwdBtnArr addObject:pwdLab];
    }
    
    for (NSInteger i = 0; i < 5; i++) {
        UIView *lineView = [[UIView alloc] init];
        lineView.frame = CGRectMake(40+40*i, 0, 1, 42);
        lineView.backgroundColor = HEXCOLOR(0x979797);
        [fuView addSubview:lineView];
    }
    
    UILabel *TipLable = [[UILabel alloc] init];
    TipLable.frame = CGRectMake(24,_topTX.bottom+4, WhiteView.width-24, 18);
    TipLable.text = @"注: 默认交易密码为登录密码！";
    TipLable.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    TipLable.textColor = [UIColor colorWithHex:0xF1775D];
    [WhiteView addSubview:TipLable];
    
    UIButton *SureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    SureButton.layer.cornerRadius = 5;
    SureButton.frame = CGRectMake(20, TipLable.bottom + 15,WhiteView.width-40, 40);
    [SureButton setTitle:@"确 认" forState:UIControlStateNormal];
    [SureButton setBackgroundColor:[UIColor colorWithHex:0xFB6337]];
    [SureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [SureButton addTarget:self action:@selector(reSureBuy) forControlEvents:UIControlEventTouchUpInside];
    [WhiteView addSubview:SureButton];
    
    UIButton *BackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    BackButton.layer.borderColor = RGBA(237, 128, 17, 1).CGColor;
    BackButton.frame = CGRectMake(WhiteView.width-100, SureButton.bottom +2,100, 30);
    BackButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [BackButton setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [BackButton setTitleColor:[UIColor colorWithHex:0xFB6337] forState:UIControlStateNormal];
    [BackButton addTarget:self action:@selector(forgotPassWord) forControlEvents:UIControlEventTouchUpInside];
    [WhiteView addSubview:BackButton];
    return WhiteView;
}

- (NSMutableArray *)pwdBtnArr{
    if (!_pwdBtnArr) {
        self.pwdBtnArr = [NSMutableArray array];
    }
    return _pwdBtnArr;
}

- (MSUShadowView *)shadowView{
    if (!_shadowView) {
        self.shadowView = [[MSUShadowView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
        _shadowView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [MSUMainWindow addSubview:_shadowView];
        _shadowView.hidden = YES;
    }
    return _shadowView;
}

- (UIView *)podView{
    if (!_podView) {
        _podView = [[UIView alloc] initWithFrame:CGRectMake(28, kDeviceHeight*0.5-88*kDeviceHeightScale, kDeviceWidth-56, 176*kDeviceHeightScale)];
        _podView.backgroundColor = WhiteColor;
        _podView.clipsToBounds = YES;
        _podView.layer.cornerRadius = 4;
        _podView.layer.shouldRasterize = YES;
        _podView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        [self.shadowView addSubview:_podView];
        
        UILabel *attentionLab = [[UILabel alloc] init];
        attentionLab.frame = CGRectMake(40, 24*kDeviceHeightScale, kDeviceWidth-56-80, 22.5*kDeviceHeightScale);
        attentionLab.backgroundColor = HEXCOLOR(0xffffff);
        attentionLab.text = @"提示";
        attentionLab.font = [UIFont systemFontOfSize:16];
        attentionLab.textAlignment = NSTextAlignmentCenter;
        attentionLab.textColor = HEXCOLOR(0x757575);
        [_podView addSubview:attentionLab];

        self.podLab = [[UILabel alloc] init];
        _podLab.frame = CGRectMake(40,attentionLab.bottom + 18*kDeviceHeightScale, kDeviceWidth-56-80, 18.5*kDeviceHeightScale);
        _podLab.backgroundColor = HEXCOLOR(0xffffff);
        _podLab.text = @"--";
        _podLab.font = [UIFont systemFontOfSize:13];
        _podLab.textAlignment = NSTextAlignmentCenter;
        _podLab.numberOfLines = 0;
        _podLab.textColor = HEXCOLOR(0x1f2425);
        [_podView addSubview:_podLab];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.frame = CGRectMake(0, 109*kDeviceHeightScale, kDeviceWidth-56, 0.5);
        lineView.backgroundColor = HEXCOLOR(0xe4e4e4);
        [_podView addSubview:lineView];
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(0, lineView.bottom, (kDeviceWidth-56)*0.5, 67*kDeviceHeightScale);
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:HEXCOLOR(0x1f2425) forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_podView addSubview:cancelBtn];
        [cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sureBtn.frame = CGRectMake(cancelBtn.right, lineView.bottom, (kDeviceWidth-56)*0.5, 67*kDeviceHeightScale);
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [sureBtn setTitleColor:HEXCOLOR(0xff6339) forState:UIControlStateNormal];
        sureBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_podView addSubview:sureBtn];
        [sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *line1View = [[UIView alloc] init];
        line1View.frame = CGRectMake((kDeviceWidth-56)*0.5-0.25, lineView.bottom,0.5, 67*kDeviceHeightScale);
        line1View.backgroundColor = HEXCOLOR(0xe4e4e4);
        [_podView addSubview:line1View];
        
    }
    return _podView;
}
#pragma mark - button
- (void)listButtonClick{
    TradeRecordViewController *VC= [[TradeRecordViewController alloc] init];
    VC.TrandeFromType = TrandeRecordFromType_WITHDRAW;
    VC.TrandeType = TrandeRecordTypeBidAward;
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)cancelBtnClick:(UIButton *)sender{
    self.shadowView.hidden = YES;
}

- (void)sureBtnClick:(UIButton *)sender{
    self.shadowView.hidden = YES;
    if (!self.alphaView) {
        self.alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
        self.alphaView.backgroundColor = [RGBA(62, 62, 62, 1) colorWithAlphaComponent:0.6];
        [self.view addSubview:self.alphaView];
    }
    for (UIView *views in self.alphaView.subviews) {
        [views removeFromSuperview];
    }
    [self.alphaView addSubview:[self SureWithDrawView]];
    [self.Params setObject:self.MoneyText.text forKey:@"withdrawAmount"];
//    self.popView = [[PopWhiteView alloc] initWithFrame:CGRectZero];
//    [self.popView show];
//    __weak typeof(self) weakSelf = self;
//    self.popView.ButtonBlock = ^(NSString *phoneCode) {
//        if (!weakSelf.alphaView) {
//            weakSelf.alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, weakSelf.view.width, weakSelf.view.height)];
//            weakSelf.alphaView.backgroundColor = [RGBA(62, 62, 62, 1) colorWithAlphaComponent:0.6];
//            [weakSelf.view addSubview:weakSelf.alphaView];
//        }
//        for (UIView *views in weakSelf.alphaView.subviews) {
//            [views removeFromSuperview];
//        }
//        [weakSelf.alphaView addSubview:[weakSelf SureWithDrawView]];
//        [weakSelf.Params setObject:weakSelf.MoneyText.text forKey:@"withdrawAmount"];
//        [weakSelf.Params setObject:phoneCode forKey:@"vcodePhone"];
//    };
}

- (IBAction)WithDrawButtonClick:(id)sender {
    [self.view endEditing:YES];

    NSNumber *a=[NSNumber numberWithFloat:self.MoneyText.text.floatValue];
    NSNumber *b=[NSNumber numberWithFloat:self.canWithdrawAmount.floatValue];

    if (self.MoneyText.text == nil ||self.MoneyText.text.length == 0) {
        [AddHudView addProgressView:self.view message:@"提现金额不得为空"];
        return;
    }
    if ([b compare:a]==NSOrderedAscending){
        [AddHudView addProgressView:self.view message:@"超出账户可提现金额"];
        return;
    }
    if (self.MoneyText.text.floatValue<100) {
        [AddHudView addProgressView:self.view message:@"最低提现金额为100元"];
        return;
    }
    if (self.MoneyText.text.floatValue>50000) {
        [AddHudView addProgressView:self.view message:@"最高可提现50000元"];
        return;
    }
    
    self.shadowView.hidden = NO;
    self.podView.hidden = NO;
    _podLab.text = [NSString stringWithFormat:@"您本次提现%@元",self.MoneyText.text];
}

- (void)BackOrSure:(UIButton *)sender{
    if (sender.tag ==100) {
        [_alphaView removeFromSuperview];
        _alphaView = nil;
    }else if(sender.tag ==101){
        if (!_alphaView) {
            _alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
            _alphaView.backgroundColor = [RGBA(62, 62, 62, 1) colorWithAlphaComponent:0.6];
            [self.view addSubview:_alphaView];
        }
        for (UIView *views in _alphaView.subviews) {
            [views removeFromSuperview];
        }
        [_alphaView addSubview:[self addPassWordView]];
    }
}

-(void)cancelClick{
    [_alphaView removeFromSuperview];
    _alphaView = nil;
}

- (void)textFieldDidChange:(UITextField *)textField{
    if (textField == self.topTX) {
        if (textField.text.length > 0 && textField.text.length < 7) {
            UILabel *label = self.pwdBtnArr[textField.text.length-1];
            if (self.pwdStr.length > textField.text.length) {
                label.text = @"●";
            } else {
                label.text = [textField.text substringWithRange:NSMakeRange(textField.text.length-1, 1)];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    label.text = @"●";
                });
            }
            self.pwdStr = textField.text;
        }
    }
}

- (void)deleteBtnClick:(UITextField *)textField{
    if (textField == self.topTX) {
        NSLog(@"text  -- %@",textField.text);
        if ((textField.text.length > 0 && textField.text.length < 6)|| textField.text.length == 0) {
            UILabel *label = self.pwdBtnArr[textField.text.length];
            label.text = @"";
            self.pwdStr = textField.text;
        }
    }
}

- (void)clearTradePWD{
    self.pwdStr = @"";
    _topTX.text = @"";
    for (UILabel *lab in self.pwdBtnArr) {
        lab.text = @"";
    }
}

- (void)reSureBuy{
    
    if (self.pwdStr.length>0) {
        [self.Params setObject:_topTX.text forKey:@"safePassowrd"];
        [[DataRequestServer getDataRequestServerData] request:@"LunaP2pAppDrawingServlet" parameters:self.Params result:^(id result) {
            if ([result isKindOfClass:[NSString class]] &&  [result isEqualToString:@"44"]) {
                [AddHudView addProgressView:self.view message:@"网络错误，请稍后再试"];
            }else if([[result objectForKey:@"success"]intValue]==0 && [[result objectForKey:@"errorlog"]isEqualToString:@"noLogin"]){
                [self requestLogin];
            }else if([[result objectForKey:@"success"]intValue]==0 && [[result objectForKey:@"errorlog"]isEqualToString:@"safePassowrdIncorrect"]){
                [PAProgressView showInView:self.view  contentString:@"您输入的交易密码有误"];
                [self clearTradePWD];
//                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"an'quan" message:@"您输入的交易密码有误" preferredStyle:UIAlertControllerStyleAlert];
//                // 添加按钮
//                __weak typeof(alert) weakAlert = alert;
//                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
//                    NSLog(@"点击了确定按钮--%@-%@", [weakAlert.textFields.firstObject text], [weakAlert.textFields.lastObject text]);
//                }]];
//                [self presentViewController:alert animated:YES completion:nil];
            }else if([[result objectForKey:@"success"]intValue]==0 && [[result objectForKey:@"errorlog"]isEqualToString:@"withdrawAmountTooSmall"]){
                [PAProgressView showInView:self.view  contentString:@"提现金额必须大于或等于100"];
            }else if([[result objectForKey:@"success"]intValue]==0 && [[result objectForKey:@"errorlog"]isEqualToString:@"withdrawAmountTooLarge"]){
                [PAProgressView showInView:self.view  contentString:@"提现金额必须小于或等于50000"];
            }else if([[result objectForKey:@"success"]intValue]==0 && [[result objectForKey:@"errorlog"]isEqualToString:@"withdrawBankError"]){
                [PAProgressView showInView:self.view  contentString:@"不正确的提现账户"];
            }else if([[result objectForKey:@"success"]intValue]==0 && [[result objectForKey:@"errorlog"]isEqualToString:@"withdrawAmountError"]){
                [PAProgressView showInView:self.view  contentString:@"超出账户可提现金额"];
            }else if([[result objectForKey:@"success"]intValue]==0 && [[result objectForKey:@"errorlog"]isEqualToString:@"vcodePhoneFailed"]){
                [PAProgressView showInView:self.view  contentString:@"您输入的手机验证码有误"];
            }else if([[result objectForKey:@"success"]intValue]==1 && [[result objectForKey:@"errorlog"]isEqualToString:@""]){
                [self.view endEditing:YES];
                [_alphaView removeFromSuperview];
                _alphaView = nil;
                WithDrawNotiViewController *WithDrawNotiVC = [[WithDrawNotiViewController alloc] init];
                WithDrawNotiVC.withDrawMoney = self.MoneyText.text;
                WithDrawNotiVC.cardName = self.CardName.text;
                WithDrawNotiVC.cardNumber = self.CardNumString;
                [self.navigationController pushViewController:WithDrawNotiVC animated:YES];
            }
            else{
                [PAProgressView showInView:self.view  contentString:@"提现失败，请重新操作"];
            }
        }];
//        [_alphaView removeFromSuperview];
//        _alphaView = nil;
    }
}

- (void)forgotPassWord{
    [_alphaView removeFromSuperview];
    _alphaView = nil;
    PasswordModifyVC  *passWordVC = [[PasswordModifyVC alloc] init];
    [self.navigationController pushViewController:passWordVC animated:YES];
    passWordVC.title=@"修改交易密码";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)resignKeyBoard:(UITapGestureRecognizer *)tap{
    [self KeyboardresignFirstResponder];
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    return YES;
}

- (void)textFieldDone{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self KeyboardresignFirstResponder];
    return YES;
}

- (void)KeyboardresignFirstResponder
{
    if ([_MoneyText isFirstResponder])//判断是否是第一响应
    {
        [_MoneyText resignFirstResponder];
    }
//    if ([_VerifyNumText isFirstResponder])//判断是否是第一响应
//    {
//        [_VerifyNumText resignFirstResponder];
//    }
}

- (void)UITextFieldChange:(UITextField *)sender{
//    if (self.MoneyText.text.length>0 && self.VerifyNumText.text.length >0 &&self.MoneyText.text.integerValue >0) {
//
//        [self.WithdrawButton setBackgroundColor:[UIColor colorWithHex:0xFB6337]];
//        self.WithdrawButton.enabled = YES;
//    }else{
//        [self.WithdrawButton setBackgroundColor:RGBA(228, 228, 228, 1)];
//        self.WithdrawButton.enabled = NO;
//    }
}

//- (void)textFieldDidEndEditing:(UITextField *)textField{
//    if (textField == self.MoneyText) {
//        if (textField.text.floatValue>=100) {
//
//            NSMutableDictionary *paramDic= [[NSMutableDictionary alloc] init];
//            [paramDic setObject:self.MoneyText.text forKey:@"withdrawAmount"];
//            [[DataRequestServer getDataRequestServerData] request:@"LunaP2pAppWithdrawFeeServlet" parameters:paramDic result:^(id result) {
//
//                if ([result isKindOfClass:[NSString class]] &&  [result isEqualToString:@"44"]) {
//
//                    [AddHudView addProgressView:self.view message:@"网络错误，请稍后再试"];
//                }else if([[result objectForKey:@"success"]intValue]==1 && [[result objectForKey:@"errorlog"]isEqualToString:@""]){
//                    self.feeText = [NSString stringWithFormat:@"%@",[result objectForKey:@"fee"]];\
//                    NSString *string = [NSString stringWithFormat:@"本次提现手续费%@元",self.feeText];
//                    NSRange range= [string rangeOfString:self.feeText];
//
//                    NSMutableAttributedString *Astring = [[NSMutableAttributedString alloc] initWithString:string];
//                    [Astring addAttribute:NSForegroundColorAttributeName value: [UIColor colorWithHex:0xFB6337] range:range];
//                    self.CommissionLabel.attributedText = Astring;
//                }else if([[result objectForKey:@"success"]intValue]==0 && [[result objectForKey:@"errorlog"]isEqualToString:@"withdrawAmountError"]){
//                    [AddHudView addProgressView:self.view message:@"输入的提现金额错误"];
//                }
//                else{
//                    [AddHudView addProgressView:self.view message:@"获取手续费失败，请重新获取"];
//                }
//
//            }];
//
//        }else{
//            [AddHudView addProgressView:self.view message:@"提现金额需要大于100元"];
//        }
//    }
//}

- (void)requestLogin{
    [[DataRequestServer getDataRequestServerData] requestLoginresult:^(NSString *LoginState) {
        if ([LoginState isEqualToString:@"true"]) {
        
        }else{
            [AddHudView addProgressView:self.view message:@"登录失效，请重新登录"];
            double delayInSeconds = 1.0;
            __weak __block WithdrawViewController* BlockVC = self;
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.MoneyText) {
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
    }else{
        return YES;
    }
}

@end

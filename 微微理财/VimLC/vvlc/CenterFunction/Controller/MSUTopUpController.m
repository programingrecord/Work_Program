//
//  MSUTopUpController.m
//  vvlc
//
//  Created by 007 on 2018/4/19.
//  Copyright © 2018年 HM. All rights reserved.
//

#import "MSUTopUpController.h"
#import "TradeRecordViewController.h"
#import "BankLimitViewController.h"
#import "LoginViewController.h"
#import "MSUTopUpFailController.h"
#import "BankPayViewController.h"
#import "TopUpResultViewController.h"
#import "TopupWebViewController.h"

#import "MSUStringTools.h"
#import "MSUPathTools.h"
#import "BankLimitModel.h"
#import "MSUCustomTF1.h"

#import "MSUChargeTableCell.h"

#import "LLPaySdk.h"
#import <FUMobilePay/FUMobilePay.h>
#import <Security/Security.h>
#import "UIImageView+WebCache.h"


@interface MSUTopUpController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,LLPaySdkDelegate>

@property (nonatomic , strong) UILabel *canUseLab;
@property (nonatomic , strong) MSUCustomTF1 *moneyTF;

@property (nonatomic , copy) NSString *bankNum;
@property (nonatomic , copy) NSString *bankImaStr;
@property (nonatomic , copy) NSString *bankName;

@property (nonatomic , strong) NSMutableArray *limitArr;

@property (nonatomic , strong) UIView *bankView;
@property (nonatomic , strong) UITableView *tableView;

@property (nonatomic , copy) NSString *isSetPWD;

@property (nonatomic , copy) NSString *selectStr;
@property (nonatomic , copy) NSString *singleLLStr;

@property (nonatomic , strong) UIView *chargeView;

@end

@implementation MSUTopUpController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
//    self.view = nil;
    if (self.view == nil) {
        [self requestBankInfo];
        [self createCenterView];
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.view = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addNavigationItemTitleView];
    self.title = @"充值";
    self.view.backgroundColor = HEXCOLOR(0xF0F0F0);

    [self requestBankInfo];
    [self requestBankLimitData];
    [self createCenterView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)createCenterView{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *NSdic = [defaults objectForKey:@"userInfoDetial"];
    NSString *canUseStr = [NSString stringWithFormat:@"当前可用余额%@元",[NSdic objectForKey:@"availableAmount"]];
    self.canUseLab = [[UILabel alloc] init];
    _canUseLab.frame = CGRectMake(12, 0, kDeviceWidth-24, 32*kDeviceHeightScale);
    _canUseLab.font = [UIFont systemFontOfSize:13];
    _canUseLab.textColor = HEXCOLOR(0x959595);
    _canUseLab.attributedText = [MSUStringTools makeKeyWordAttributedWithSubText:[NSdic objectForKey:@"availableAmount"] inOrigiText:canUseStr font:14 color:HEXCOLOR(0xfb6337)];
    [self.view addSubview:_canUseLab];
    
    self.chargeView = [[UIView alloc] init];
    _chargeView.frame = CGRectMake(0, _canUseLab.bottom, kDeviceWidth, 84*kDeviceHeightScale);
    _chargeView.backgroundColor = HEXCOLOR(0xffffff);
    [self.view addSubview:_chargeView];
    
    UILabel *chargeLab = [[UILabel alloc] init];
    chargeLab.frame = CGRectMake(12, 12*kDeviceHeightScale, kDeviceWidth-24, 20*kDeviceHeightScale);
    chargeLab.text = @"充值金额（元）";
    chargeLab.font = [UIFont systemFontOfSize:14];
    chargeLab.textColor = HEXCOLOR(0x4A4A4A);
    [_chargeView addSubview:chargeLab];
    
    self.moneyTF = [[MSUCustomTF1 alloc] init];
    _moneyTF.font = [UIFont systemFontOfSize:24];
    if (iOS11) {
        _moneyTF.tfType = MSUNone20;
    } else{
        _moneyTF.tfType = MSUTypeRight;
    }
    _moneyTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"100元起充" attributes:@{NSForegroundColorAttributeName: HEXCOLOR(0xCFCFCF),NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    _moneyTF.frame = CGRectMake(12, chargeLab.bottom + 12*kDeviceHeightScale, kDeviceWidth-24, 28*kDeviceHeightScale);
    _moneyTF.textColor = HEXCOLOR(0x333333);
    //        _shopTF = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 30)];
    //        _shopTF = UITextFieldViewModeAlways;
    _moneyTF.keyboardType = UIKeyboardTypeNumberPad;
    _moneyTF.delegate = self;
    [_chargeView addSubview:_moneyTF];
    
    UILabel *symbolLab = [[UILabel alloc] init];
    symbolLab.frame = CGRectMake(0, 0, 20, 28*kDeviceHeightScale);
    symbolLab.text = @"¥";
    symbolLab.font = [UIFont systemFontOfSize:24];
    symbolLab.textColor = HEXCOLOR(0x4A4A4A);
    _moneyTF.leftView = symbolLab;
    _moneyTF.leftViewMode = UITextFieldViewModeAlways;
    
    _moneyTF.inputAccessoryView = [self addToolbar];
    
    self.bankView = [[UIView alloc] init];
    _bankView.backgroundColor = HEXCOLOR(0xffffff);
    [self.view addSubview:_bankView];
    
    if (![CoreArchive isLockedBank]) {
        _bankView.frame = CGRectMake(0, _chargeView.bottom + 12*kDeviceHeightScale, kDeviceWidth, 49*kDeviceHeightScale);
        
        UILabel *bankLab = [[UILabel alloc] init];
        bankLab.frame = CGRectMake(12, 0, kDeviceWidth-24, 49*kDeviceHeightScale);
        bankLab.text = @"请选择银行";
        bankLab.font = [UIFont systemFontOfSize:16];
        bankLab.textColor = HEXCOLOR(0x454545);
        [_bankView addSubview:bankLab];
        
        UIImageView *imaView = [[UIImageView alloc] initWithFrame:CGRectMake(kDeviceWidth-16-14*kDeviceHeightScale, 17, 14*kDeviceHeightScale, 14*kDeviceHeightScale)];
        imaView.image = [MSUPathTools showImageWithContentOfFileByName:@"icon_arrow_right"];
        imaView.contentMode = UIViewContentModeScaleAspectFit;
        [_bankView addSubview:imaView];
        
        UIButton *noBankBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        noBankBtn.frame = CGRectMake(12, 0, kDeviceWidth-24, 49*kDeviceHeightScale);
        [_bankView addSubview:noBankBtn];
        [noBankBtn addTarget:self action:@selector(noBankBtnClick) forControlEvents:UIControlEventTouchUpInside];
    } else{
        if ([_ishasfuyoupay isEqualToString:@"1"]) {
            _bankView.frame = CGRectMake(0, _chargeView.bottom + 12*kDeviceHeightScale, kDeviceWidth, 62*kDeviceHeightScale);
        } else {
            _bankView.frame = CGRectMake(0, _chargeView.bottom + 12*kDeviceHeightScale, kDeviceWidth, 124*kDeviceHeightScale);
        }
        self.tableView.hidden = NO;
        [_bankView addSubview:self.tableView];
    }
    
    UIImageView *imaView = [[UIImageView alloc] initWithFrame:CGRectMake(17, _bankView.bottom + 8, 16*kDeviceHeightScale, 16*kDeviceHeightScale)];
    imaView.image = [MSUPathTools showImageWithContentOfFileByName:@"tx"];
    [self.view addSubview:imaView];
    
    UILabel *attentionLab = [[UILabel alloc] init];
    attentionLab.frame = CGRectMake(imaView.right + 5, imaView.top, kDeviceWidth-40, 19*kDeviceHeightScale);
    attentionLab.text = @"大额充值可登陆官网 www.vimzx.com 进行操作";
    attentionLab.font = [UIFont systemFontOfSize:13];
    attentionLab.textColor = HEXCOLOR(0x6aacfc);
    [self.view addSubview:attentionLab];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(17, attentionLab.bottom + 30*kDeviceHeightScale, kDeviceWidth-34, 44*kDeviceHeightScale);
    sureBtn.backgroundColor = HEXCOLOR(0xFB6337);
    sureBtn.layer.cornerRadius = 4;
    sureBtn.clipsToBounds = YES;
    sureBtn.layer.shouldRasterize = YES;
    sureBtn.layer.rasterizationScale = [UIScreen mainScreen].scale;
    [sureBtn setTitle:@"确认充值" forState:UIControlStateNormal];
    [sureBtn setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:sureBtn];
    [sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];

    UILabel *titLab = [[UILabel alloc] init];
    titLab.frame = CGRectMake(25, sureBtn.bottom + 21*kDeviceHeightScale, kDeviceWidth-50, 20);
    titLab.text = @"充值须知:";
    titLab.font = [UIFont systemFontOfSize:14];
    titLab.textColor = HEXCOLOR(0x818181);
    [self.view addSubview:titLab];
    
    NSString *str = @"1、用户在本站充值、提现必须使用一张银行借记卡，并且实名认证必须和银行的开户名一样，如需更换请联系客服人员。 \n2、本站目前支持富友支付、连连支付在线进行充值。\n3、充值过程中遇到任何问题请联系我们";
    CGRect rect = [MSUStringTools danamicGetHeightFromText:str WithWidth:kDeviceWidth-50 font:17];
    UILabel *introLab = [[UILabel alloc] init];
    introLab.frame = CGRectMake(25, titLab.bottom + 5*kDeviceHeightScale, kDeviceWidth-50, rect.size.height);
    introLab.font = [UIFont systemFontOfSize:13];
    introLab.textColor = HEXCOLOR(0xA4A4A4);
    introLab.attributedText = [MSUStringTools makeLineSpaceAndAttributedWithSubText:@"400-0571-115" inOrigiText:str font:13 color:titOrangeColor space:5];
    introLab.numberOfLines = 0;
    [self.view addSubview:introLab];
    
    UILabel *kefuLab = [[UILabel alloc] init];
    kefuLab.frame = CGRectMake(0, introLab.bottom+15, kDeviceWidth, 19);
    kefuLab.text = @"--- 客服热线 ---";
    kefuLab.font = [UIFont systemFontOfSize:13];
    kefuLab.textAlignment = NSTextAlignmentCenter;
    kefuLab.textColor = HEXCOLOR(0x939393);
    [self.view addSubview:kefuLab];
    
    UILabel *phoneLab = [[UILabel alloc] init];
    phoneLab.frame = CGRectMake(0, kefuLab.bottom + 1, kDeviceWidth, 30);
    phoneLab.text = @"400-0571-115";
    phoneLab.font = [UIFont systemFontOfSize:16];
    phoneLab.textAlignment = NSTextAlignmentCenter;
    phoneLab.textColor = HEXCOLOR(0x939393);
    [self.view addSubview:phoneLab];

    
    UIButton *tapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tapBtn.frame = CGRectMake(0, kefuLab.bottom + 3, kDeviceWidth, 30);
    [self.view addSubview:tapBtn];
    [tapBtn addTarget:self action:@selector(tapBtnClick:) forControlEvents:UIControlEventTouchUpInside];

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

- (UITableView *)tableView{
    if (!_tableView) {
        if ([self.ishasfuyoupay isEqualToString:@"1"]) {
            self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 62*kDeviceHeightScale) style:UITableViewStylePlain];
        } else{
            self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 124*kDeviceHeightScale) style:UITableViewStylePlain];
        }
        _tableView.backgroundColor = WhiteColor;
        _tableView.scrollEnabled = YES;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        self.tableView.panGestureRecognizer.delaysTouchesBegan = self.tableView.delaysContentTouches;
        _tableView.rowHeight = 62*kDeviceHeightScale;
        [_tableView registerClass:[MSUChargeTableCell class] forCellReuseIdentifier:@"MSUChargeTableCell"];
        if (iOS11) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else{
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _tableView;
}

#pragma mark - 请求数据
- (void)requestBankInfo{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[DataRequestServer getDataRequestServerData] request:@"LunaP2pAppBankServlet" parameters:nil result:^(id result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([result isKindOfClass:[NSString class]] &&  [result isEqualToString:@"44"]) {
            [AddHudView addProgressView:self.view message:@"获取银行卡信息失败，请重新操作"];
        }else if([[result objectForKey:@"success"]intValue]==1 && [[result objectForKey:@"errorlog"]isEqualToString:@""]){
            
            self.isSetPWD = [NSString stringWithFormat:@"%@",result[@"IsToSetTranPas"]];
            

            NSArray *DataArr= [result objectForKey:@"items"];
            if (DataArr && DataArr.count>0) {
                NSDictionary *dic= [DataArr objectAtIndex:0];
                self.bankNum = [NSString stringWithFormat:@"尾号%@",[dic objectForKey:@"accountNumber"]];
                self.bankName = [NSString stringWithFormat:@"%@",[dic objectForKey:@"bankType"]];
                self.bankImaStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"bankIcon"]];
//                [self.bankImage sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"bankIcon"]] placeholderImage:[UIImage imageNamed:@"image_empty"]];

                if ([CoreArchive isLockedBank]) {
                    [self.tableView reloadData];
                }
            }
        }else{
            [AddHudView addProgressView:self.view message:@"获取银行卡信息失败，请重新操作"];
        }
    }];
}

- (void)requestBankLimitData{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"1" forKey:@"FuYouType"];
    
    [[DataRequestServer getDataRequestServerData] request:@"LunaP2pAppBankLimitServlet" parameters:dic result:^(id result) {
        
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
            
        
            if ([CoreArchive isLockedBank]) {
                [self.tableView reloadData];
            }
        }else{
            [AddHudView addProgressView:self.view message:@"获取银行卡限额信息失败，请重新刷新"];
        }
    }];
}

- (void)requestLogin{
    [[DataRequestServer getDataRequestServerData] requestLoginresult:^(NSString *LoginState) {
        if ([LoginState isEqualToString:@"true"]) {
            
        }else{
            [AddHudView addProgressView:self.view message:@"登录失效，请重新登录"];
            double delayInSeconds = 1.0;
            __weak __block MSUTopUpController* BlockVC = self;
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


#pragma mark - 代理相关
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.ishasfuyoupay isEqualToString:@"1"]) {
        return 1;
    } else{
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MSUChargeTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MSUChargeTableCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell.bankImaView sd_setImageWithURL:[NSURL URLWithString:self.bankImaStr] placeholderImage:[UIImage imageNamed:@"image_empty"]];
    cell.bankLab.text = self.bankName;
    CGSize sizea = [MSUStringTools danamicGetWidthFromText:cell.bankLab.text WithFont:16];
    cell.bankLab.frame = CGRectMake(39, 14*kDeviceHeightScale, sizea.width+5, 16);
    cell.signLab.frame = CGRectMake(cell.bankLab.right + 1, 14*kDeviceHeightScale, 60, 16);

    double singleLLStr = 0.0;
    double dayLLStr = 0.0;
    double monthLLStr = 0.0;

    double singleFYStr = 0.0;
    double dayFYStr = 0.0;
    double monthFYStr = 0.0;

    for (BankLimitModel *model in self.limitArr) {
        if ([cell.bankLab.text isEqualToString:model.bankName]) {
            if ([[NSString stringWithFormat:@"%@",model.disburse] isEqualToString:@"0"]) {
                singleLLStr = model.singleAmt.doubleValue;
                dayLLStr = model.dayAmt.doubleValue;
                monthLLStr = model.monthAmt.doubleValue;
                self.singleLLStr = model.singleAmt;
            } else{
                singleFYStr = model.singleAmt.doubleValue;
                dayFYStr = model.dayAmt.doubleValue;
                monthFYStr = model.monthAmt.doubleValue;
            }
        }
    }

    NSArray *arr = @[@"连连支付",@"富友支付"];
    if (singleLLStr < singleFYStr) {
        arr = @[@"富友支付",@"连连支付"];
        
    } else if (singleLLStr > singleFYStr){
        arr = @[@"连连支付",@"富友支付"];

    } else if (singleLLStr == singleFYStr){
        if (dayLLStr < dayFYStr) {
            arr = @[@"富友支付",@"连连支付"];
        } else{
            arr = @[@"连连支付",@"富友支付"];
        }
    }
    
    NSMutableArray *singleArr = [NSMutableArray array];
    NSMutableArray *dayArr = [NSMutableArray array];
    NSMutableArray *monthArr = [NSMutableArray array];

    if ([arr[0] isEqualToString:@"连连支付"]) {
        if ([self.ishasfuyoupay isEqualToString:@"1"]) {
            [singleArr addObject:[NSString stringWithFormat:@"%.2f",singleLLStr]];
            [dayArr addObject:[NSString stringWithFormat:@"%.2f",dayLLStr]];
            [monthArr addObject:[NSString stringWithFormat:@"%.2f",monthLLStr]];
        } else{
            [singleArr addObject:[NSString stringWithFormat:@"%.2f",singleLLStr]];
            [singleArr addObject:[NSString stringWithFormat:@"%.2f",singleFYStr]];
            
            [dayArr addObject:[NSString stringWithFormat:@"%.2f",dayLLStr]];
            [dayArr addObject:[NSString stringWithFormat:@"%.2f",dayFYStr]];
            
            [monthArr addObject:[NSString stringWithFormat:@"%.2f",monthLLStr]];
            [monthArr addObject:[NSString stringWithFormat:@"%.2f",monthFYStr]];
        }
    } else {
        if ([self.ishasfuyoupay isEqualToString:@"1"]) {
            [singleArr addObject:[NSString stringWithFormat:@"%.2f",singleLLStr]];
            [dayArr addObject:[NSString stringWithFormat:@"%.2f",dayLLStr]];
            [monthArr addObject:[NSString stringWithFormat:@"%.2f",monthLLStr]];
        } else{
            [singleArr addObject:[NSString stringWithFormat:@"%.2f",singleFYStr]];
            [singleArr addObject:[NSString stringWithFormat:@"%.2f",singleLLStr]];
            
            [dayArr addObject:[NSString stringWithFormat:@"%.2f",dayFYStr]];
            [dayArr addObject:[NSString stringWithFormat:@"%.2f",dayLLStr]];
            
            [monthArr addObject:[NSString stringWithFormat:@"%.2f",monthFYStr]];
            [monthArr addObject:[NSString stringWithFormat:@"%.2f",monthLLStr]];
        }
       
    }

    cell.introLab.text = [NSString stringWithFormat:@"单笔%@万元,单日%@万元,单月%@万元",singleArr[indexPath.row],dayArr[indexPath.row],monthArr[indexPath.row]];
    
    if ([self.ishasfuyoupay isEqualToString:@"1"]) {
        cell.signLab.text = @"连连支付";
        self.selectStr = @"连连支付";
        cell.seleImaView.highlighted = YES;

    } else {
        cell.signLab.text = arr[indexPath.row];
        
        self.selectStr = arr[0];
        if (indexPath.row == 0) {
            cell.signLab.textColor = HEXCOLOR(0xFF9578);
            cell.signLab.layer.borderColor = HEXCOLOR(0xFF9578).CGColor;
            cell.seleImaView.highlighted = YES;
        } else{
            cell.signLab.textColor = HEXCOLOR(0x5E98EF);
            cell.signLab.layer.borderColor = HEXCOLOR(0x5E98EF).CGColor;
            cell.seleImaView.highlighted = NO;
        }
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger lastIndex;
    if (indexPath.row == 0) {
        lastIndex = 1;
    } else{
        lastIndex = 0;
    }
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:lastIndex inSection:0];
    
    MSUChargeTableCell *currentCell = [tableView cellForRowAtIndexPath:indexPath];
    currentCell.seleImaView.highlighted = YES;
    
    MSUChargeTableCell *lastCell = [tableView cellForRowAtIndexPath:lastIndexPath];
    lastCell.seleImaView.highlighted = NO;
    
    self.selectStr = currentCell.signLab.text;
    MyLog(@"==========%@",self.selectStr);
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
    if ([self.moneyTF isFirstResponder])//判断是否是第一响应
    {
        [self.moneyTF resignFirstResponder];
    }
}

- (void)tapClick{
    [self KeyboardresignFirstResponder];
}



#pragma mark -- 点击事件
- (void)listButtonClick{
    TradeRecordViewController *VC= [[TradeRecordViewController alloc] init];
    VC.TrandeFromType = TrandeRecordFromType_TOPUP;
    VC.TrandeType = TrandeRecordTypeRecharge;
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)sureBtnClick{
    [self KeyboardresignFirstResponder];
    
    NSNumber *a=[NSNumber numberWithFloat:self.moneyTF.text.floatValue];
    NSNumber *b=[NSNumber numberWithFloat:50];
    
    if (self.moneyTF.text == nil ||self.moneyTF.text.length == 0) {
        [AddHudView addProgressView:self.view message:@"充值金额不得为空"];
        return;
    }
    if ([a compare:b]==NSOrderedAscending){
        [AddHudView addProgressView:self.view message:@"请输入正确的充值金额,最低充值金额50元"];
        return;
    }
    
    if (![CoreArchive isLockedBank]) {
        [PAProgressView showInView:self.view contentString:@"尚未绑定银行卡，请选择银行卡"];
        return;
    }
    
    if ([self.selectStr isEqualToString:@"富友支付"]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setObject:@"8" forKey:@"payConfigId"];
        [param setObject:[NSString stringWithFormat:@"%.02f",[self.moneyTF.text floatValue]] forKey:@"rechargeAmount"];
        
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
        
        if (self.moneyTF.text.floatValue <= self.singleLLStr.floatValue*10000) {//(model.singleAmt.floatValue*10000
            MyLog(@"=====没超过限额");
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
            [param setObject:@"5" forKey:@"payConfigId"];
            [param setObject:[NSString stringWithFormat:@"%.02f",[self.moneyTF.text floatValue]] forKey:@"rechargeAmount"];
            
            [[DataRequestServer getDataRequestServerData] request:@"LianLianSdkPayServlet" parameters:param result:^(id result) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                if ([result isKindOfClass:[NSString class]] &&  [result isEqualToString:@"44"]) {
                    [AddHudView addProgressView:self.view message:@"网络错误，请稍后再试"];
                }else if([[result objectForKey:@"success"]intValue]==0 && [[result objectForKey:@"errorlog"]isEqualToString:@"noLogin"]){
                    [self requestLogin];
                }else if([[result objectForKey:@"success"]intValue]==1 && [[result objectForKey:@"errorlog"]isEqualToString:@""]){
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
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
            vc.moneyText = self.moneyTF.text;
            vc.bankName = self.bankName;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (void)noBankBtnClick{
    BankLimitViewController *VC= [[BankLimitViewController alloc] init];
    VC.hidesBottomBarWhenPushed = YES;
    VC.isSetPWD = self.isSetPWD;
    [self.navigationController pushViewController:VC animated:YES];
}

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


#pragma mark - 代理
/*  富友 */
-(void) payCallBack:(BOOL) success responseParams:(NSDictionary*) responseParams{
    if (success) {
        TopUpResultViewController *VC= [[TopUpResultViewController alloc] init];
        VC.isSucess = YES;
        [TalkingData trackEvent:@"资金充值" label:@"资金充值"];
        VC.AmountStr = self.moneyTF.text;
        [self.navigationController pushViewController:VC animated:YES];
    }else{
        //        [AddHudView addProgressView:self.view message:[responseParams objectForKey:@"RESPONSEMSG"]];
        MSUTopUpFailController *fail = [[MSUTopUpFailController alloc] init];
        fail.AmountStr = self.moneyTF.text;
        fail.failCode = [NSString stringWithFormat:@"%@",[responseParams objectForKey:@"RESPONSECODE"]];
        fail.orderNum = [NSString stringWithFormat:@"%@",[responseParams objectForKey:@"RESPONSEMSG"]];
        fail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:fail animated:YES];
    }
}

-(void)callBack:(NSString*)params
{
    NSLog(@"返回的参数是：%@",params);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"支付结果:%@",params] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
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
            VC.AmountStr = self.moneyTF.text;
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
    [AddHudView addProgressView:self.view message:msg];
//    [PAProgressView showInView:self.view  contentString:msg];
    
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

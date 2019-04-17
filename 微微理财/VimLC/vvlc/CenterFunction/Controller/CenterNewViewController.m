//
//  CenterNewViewController.m
//  SmallCat
//
//  Created by H on 2017/5/3.
//  Copyright © 2017年 HM. All rights reserved.
//

#import "CenterNewViewController.h"
#import "LoginViewController.h"
#import "CouponViewController.h"
#import "CenterItemCell.h"

#import "MSUTopUpController.h"
#import "WithdrawViewController.h"
#import "MSUAboutController.h"


#import "ReceiptListVC.h"
#import "MyBidViewController.h"
#import "MangerViewController.h"
#import "AddCardViewController.h"
#import "LockNameViewController.h"
#import "RealViewController.h"
#import "TradeRecordViewController.h"
#import "MSUTestCompleteController.h"
#import "WebViewController.h"

#import "UnderLineField.h"
#import "CustomUIEdgeInsetLabel.h"
#import "VimLL_common.h"

#import "MSUAccountController.h"

#import "MSUCurrentController.h"
#import "MSUTestController.h"

#import "MSUPathTools.h"
#import "MSUStringTools.h"
#import "CustomButton.h"

#import "MSUShadowInView.h"

#import <UMAnalytics/MobClick.h>
#import "MSUMyBidController.h"
#import "MSUSetTradePWDController.h"
#import "MSUMessageController.h"
#import "MSUManagerController.h"


@interface CenterNewViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,strong) NSArray *DataArr;
@property (nonatomic,strong) NSArray *ImageArr;
@property (nonatomic,strong) NSArray *rightArr;

@property (nonatomic , strong) UIImageView *imaIconView;

@property (nonatomic,strong) UITableView *CenterTableView;

@property (nonatomic,strong) UILabel *nameLable;
@property (nonatomic,strong) UILabel *amountLable;
@property (nonatomic,strong) UILabel *moneyLable;
@property (nonatomic,strong) UILabel *TotolLable;
@property (nonatomic,strong) UILabel *leftMoneyLable;

@property (nonatomic,strong) NSMutableDictionary *userInfo;
@property (nonatomic , assign) NSInteger testCode;
@property (nonatomic , strong) UIButton *showHideBtn;
@property (nonatomic , strong) UIButton *questionBtn;
@property (nonatomic , strong) UIButton *ruleBtn;

@property (nonatomic , strong) UIView *redCircle;
@property (nonatomic , copy) NSString *incomeStr;

@property (nonatomic , strong) MSUShadowInView *shadowView;
@property (nonatomic , strong) UIView *centerView;
@property (nonatomic , strong) UIView *headerView;

@property (nonatomic , copy) NSString *registNum;
@property (nonatomic , copy) NSString *ishasfuyoupay;


@end

@implementation CenterNewViewController

#pragma mark - 加载view
- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;

    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableview];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - TableView

- (void)initTableview{
    self.DataArr= @[@"邀请奖励",@"个人设置",@"关于我们",@"帮助反馈"];
    self.ImageArr= @[@"icon_invit",@"grsz_icon",@"gywm_icon",@"bzfk_icon"];
    self.rightArr= @[@"邀请好友 佣金到手",@"修改密码 绑卡认证",@"更多信息 点击这里",@"什么不懂 请看这里"];
    
    self.CenterTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kTabBarHeight) style:UITableViewStyleGrouped];
    self.CenterTableView.delegate = self;
    self.CenterTableView.dataSource = self;
    [self.view addSubview:self.CenterTableView];
    self.CenterTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.CenterTableView.tableHeaderView = [self headViewCreate];
    __weak typeof(self) weakSelf = self;
    self.CenterTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf loadRequestWithAFN];
    }];
    if (iOS11) {
        _CenterTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

#pragma mark - 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.DataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CenterItemCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CenterItemCell"];
    if (!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"CenterItemCell" bundle:nil] forCellReuseIdentifier:@"CenterItemCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"CenterItemCell"];
    }
    
    if (indexPath.row == 0) {
        cell.TopLineview.hidden = NO;
    }else{
        cell.TopLineview.hidden = YES;
    }
    
    cell.leftTitle.text = [self.DataArr objectAtIndex:indexPath.row];
    if (indexPath.row == self.DataArr.count-1) {
        cell.BottomLineViewLeft.constant = 0;
    }else{
        cell.BottomLineViewLeft.constant = 40;
    }
    cell.leftImage.image = [UIImage imageNamed:self.ImageArr[indexPath.row]];
    
    cell.rightTltle.text = [_rightArr objectAtIndex:indexPath.row];
    
    return cell;
}

- (UIView *)redCircle{
    if (!_redCircle) {
        _redCircle = [[UIView alloc] init];
        _redCircle.frame = CGRectMake(134+kDeviceWidth*0.5, 385.5, 29, 14);
        [_headerView addSubview:_redCircle];
        
        UIImageView *imaView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 29, 14)];
        imaView.image = [MSUPathTools showImageWithContentOfFileByName:@"Rectangle26"];
        [_redCircle addSubview:imaView];
        
        UILabel *Tip1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 29, 14)];
        Tip1.textAlignment = NSTextAlignmentCenter;
        Tip1.font = TEXTFONT(7);
        Tip1.text = @"加息券";
        Tip1.textColor = [UIColor whiteColor];
        [_redCircle addSubview:Tip1];
    }
    return _redCircle;
}

- (UIView *)headViewCreate{
    self.headerView = [[UIView alloc] init];
    _headerView.backgroundColor = [UIColor whiteColor];
    
    self.imaIconView = [[UIImageView alloc] initWithFrame:CGRectMake(13, 27*kDeviceHeightScale, 30, 30)];
    _imaIconView.image = [MSUPathTools showImageWithContentOfFileByName:@"CombinedShape"];
    _imaIconView.clipsToBounds = YES;
    _imaIconView.layer.cornerRadius = 15;
    _imaIconView.layer.shouldRasterize = YES;
    _imaIconView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    [_headerView addSubview:_imaIconView];
    
    self.nameLable = [[UILabel alloc] initWithFrame:CGRectMake(_imaIconView.right + 8, 34*kDeviceHeightScale,100 , 19)];
    self.nameLable.font = TEXTFONT(13);
    self.nameLable.text = @"苏墨";
    self.nameLable.textColor = HEXCOLOR(0x515151);
    [_headerView addSubview:self.nameLable];
    
    UIButton *iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    iconBtn.frame = CGRectMake(0, 20*kDeviceHeightScale, kDeviceWidth*0.5, 30);
    [_headerView addSubview:iconBtn];
    [iconBtn addTarget:self action:@selector(iconBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *purpleView = [[UIView alloc] init];
    purpleView.frame = CGRectMake(12.5, _imaIconView.bottom+18, kDeviceWidth-25, 150);
    purpleView.backgroundColor = HEXCOLOR(0xFFfffF);
    [_headerView addSubview:purpleView];
    
    UIImageView *imaBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth-25, 150)];
    imaBgView.image = [MSUPathTools showImageWithContentOfFileByName:@"Group10"];
    [purpleView addSubview:imaBgView];

    UILabel *Tip1 = [[UILabel alloc] initWithFrame:CGRectMake((kDeviceWidth-25)*0.5-36, 14, 72, 17)];
    Tip1.textAlignment = NSTextAlignmentCenter;
    Tip1.font = TEXTFONT(14);
    Tip1.text = @"总资产(元)";
    Tip1.textColor = [UIColor whiteColor];
    [purpleView addSubview:Tip1];
    
    self.showHideBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _showHideBtn.frame = CGRectMake(Tip1.right+4,18, 15, 9);
    NSString *showHiden = [[NSUserDefaults standardUserDefaults] objectForKey:@"showHiden"];
    if ([showHiden isEqualToString:@"1"]) {
        _showHideBtn.selected = YES;
    }
    [_showHideBtn setImage:[MSUPathTools showImageWithContentOfFileByName:@"xianshi"] forState:UIControlStateNormal];
    [_showHideBtn setImage:[MSUPathTools showImageWithContentOfFileByName:@"yincang"] forState:UIControlStateSelected];
    [_showHideBtn addTarget:self action:@selector(showHideBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _showHideBtn.contentMode = UIViewContentModeScaleAspectFit;
    //    [_showHideBtn setTitle:@"****" forState:UIControlStateSelected];
    [purpleView addSubview:_showHideBtn];
    
    self.TotolLable = [[UILabel alloc] initWithFrame:CGRectMake(0, Tip1.bottom,kDeviceWidth-25 , 41)];
    self.TotolLable.font = [UIFont fontWithName:@"DINAlternate-Bold" size:35];
    self.TotolLable.text = @"20000";
    self.TotolLable.textAlignment = NSTextAlignmentCenter;
    self.TotolLable.textColor = [UIColor whiteColor];
    [purpleView addSubview:self.TotolLable];
    
    UIImageView *imaWhiteView = [[UIImageView alloc] initWithFrame:CGRectMake(kDeviceWidth-25-15-11, _TotolLable.bottom, 11, 11)];
    imaWhiteView.image = [MSUPathTools showImageWithContentOfFileByName:@"ckgd1"];
    imaWhiteView.contentMode = UIViewContentModeScaleAspectFit;
    [purpleView addSubview:imaWhiteView];
    
    UILabel *Tip2 = [[UILabel alloc] initWithFrame:CGRectMake(0, self.TotolLable.bottom+12.5 , (kDeviceWidth-25)/2, 16.5)];
    Tip2.font = TEXTFONT(12);
    Tip2.text = @"待收定期收益(元)";
    Tip2.textAlignment = NSTextAlignmentCenter;
    Tip2.textColor = [UIColor colorWithHex:0xFFFFFF alpha:1];
    [purpleView addSubview:Tip2];
    
    self.amountLable = [[UILabel alloc] initWithFrame:CGRectMake(0, Tip2.bottom,(kDeviceWidth-25)/2 , 35)];
    self.amountLable.font = [UIFont fontWithName:@"DINAlternate-Bold" size:30];
    self.amountLable.text = @"23.54";
    self.amountLable.textAlignment = NSTextAlignmentCenter;
    self.amountLable.textColor = [UIColor colorWithHex:0xFFFFFF alpha:1];
    [purpleView addSubview:self.amountLable];
    
    UILabel *Tip3 = [[UILabel alloc] initWithFrame:CGRectMake(0+(kDeviceWidth-25)/2, Tip2.top ,(kDeviceWidth-25)/2, 16.5)];
    Tip3.font = TEXTFONT(12);
    Tip3.text = @"累计总收益(元)";
    Tip3.textAlignment = NSTextAlignmentCenter;
    Tip3.textColor = [UIColor colorWithHex:0xFFFFFF alpha:1];
    [purpleView addSubview:Tip3];
    
    self.moneyLable = [[UILabel alloc] initWithFrame:CGRectMake(0+(kDeviceWidth-25)/2, Tip3.bottom,(kDeviceWidth-25)/2 , 35)];
    self.moneyLable.font = [UIFont fontWithName:@"DINAlternate-Bold" size:30];
    self.moneyLable.text = @"128.98";
    self.moneyLable.textAlignment = NSTextAlignmentCenter;
    self.moneyLable.textColor = [UIColor colorWithHex:0xFFFFFF alpha:1];
    [purpleView addSubview:_moneyLable];

    self.questionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _questionBtn.frame = CGRectMake(0, 35, kDeviceWidth-25, 115);
    [_questionBtn addTarget:self action:@selector(questionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [purpleView addSubview:_questionBtn];
    
    self.ruleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_ruleBtn setImage:[MSUPathTools showImageWithContentOfFileByName:@"Group_14"] forState:UIControlStateNormal];
    [_ruleBtn addTarget:self action:@selector(ruleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _ruleBtn.contentMode = UIViewContentModeScaleAspectFit;
    //    [_questionBtn setTitle:@"****" forState:UIControlStateSelected];
    [purpleView addSubview:_ruleBtn];
    
    UILabel *Tip4 = [[UILabel alloc] initWithFrame:CGRectMake(18, purpleView.bottom+18 ,100, 16.5)];
    Tip4.font = TEXTFONT(12);
    Tip4.text = @"账户余额（元）";
//    Tip4.textAlignment = NSTextAlignmentCenter;
    Tip4.textColor = [UIColor colorWithHex:0x9B9B9B alpha:1];
    [_headerView addSubview:Tip4];

    self.leftMoneyLable = [[UILabel alloc] initWithFrame:CGRectMake(18, Tip4.bottom,(kDeviceWidth-36)/2 , 24.5)];
    self.leftMoneyLable.font = [UIFont fontWithName:@"DINAlternate-Bold" size:18];
    self.leftMoneyLable.text = @"20023.54";
//    self.leftMoneyLable.textAlignment = NSTextAlignmentCenter;
    self.leftMoneyLable.textColor = [UIColor colorWithHex:0x4A4A4A alpha:1];
    [_headerView addSubview:_leftMoneyLable];

    UIButton *RechargeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    RechargeButton.frame = CGRectMake(kDeviceWidth-16-80, purpleView.bottom+19, 80, 35);
    RechargeButton.layer.cornerRadius = 35*0.5;
    RechargeButton.clipsToBounds = YES;
    RechargeButton.layer.shouldRasterize = YES;
    RechargeButton.layer.rasterizationScale = [UIScreen mainScreen].scale;
    [MSUPathTools drawGradientColorFromColorA:HEXCOLOR(0x787878) toColorB:HEXCOLOR(0x323232) withView:RechargeButton isLeft:NO];
    [RechargeButton setTitle:@"提现" forState:UIControlStateNormal];
    [RechargeButton setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
    RechargeButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_headerView addSubview:RechargeButton];
    [RechargeButton addTarget:self action:@selector(WithdrawButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *withdrawButton = [UIButton buttonWithType:UIButtonTypeCustom];
    withdrawButton.frame = CGRectMake(RechargeButton.left-10-80, purpleView.bottom+19, 80, 35);
    withdrawButton.layer.cornerRadius = 35*0.5;
    withdrawButton.clipsToBounds = YES;
    withdrawButton.layer.shouldRasterize = YES;
    withdrawButton.layer.rasterizationScale = [UIScreen mainScreen].scale;
    [MSUPathTools drawGradientColorFromColorA:HEXCOLOR(0xff9379) toColorB:HEXCOLOR(0xFF5D3C) withView:withdrawButton isLeft:NO];
    [withdrawButton setTitle:@"充值" forState:UIControlStateNormal];
    [withdrawButton setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
    withdrawButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_headerView addSubview:withdrawButton];
    [withdrawButton addTarget:self action:@selector(RechargeButtonClick:) forControlEvents:UIControlEventTouchUpInside];

    UIView *lineView1 = [[UIView alloc] init];
    lineView1.frame =CGRectMake(0, _leftMoneyLable.bottom+12.5, kDeviceWidth, 10);
    lineView1.backgroundColor = [UIColor colorWithHex:0xF3F3F3];
    [_headerView addSubview:lineView1];
    
    NSArray *imaArr = @[@"wdzc_icon",@"mlb_icon",@"wdtz_icon",@"wdqb_icon"];
    NSArray *topTitArr = @[@"我的明细",@"微微宝",@"我的投资",@"我的券包"];
    NSArray *boTitArr = @[@"我的明细 全在这里",@"优质资产 收益可见",@"投资记录 一目了然",@"新手红包 888现金"];
    for (NSInteger i = 0; i < 4; i++) {
        UIImageView *imaLeftView = [[UIImageView alloc] initWithFrame:CGRectMake(27+kDeviceWidth*0.5*(i%2),lineView1.bottom+ 17+69*(i/2), 37, 37)];
        imaLeftView.image = [MSUPathTools showImageWithContentOfFileByName:imaArr[i]];
        [_headerView addSubview:imaLeftView];
        
        UILabel *topLab = [[UILabel alloc] initWithFrame:CGRectMake(imaLeftView.right+10, imaLeftView.top ,70, 21)];
        topLab.font = TEXTFONT(15);
        topLab.text = topTitArr[i];
//        topLab.textAlignment = NSTextAlignmentCenter;
        topLab.textColor = [UIColor colorWithHex:0x636875 alpha:1];
        [_headerView addSubview:topLab];
        
        UILabel *bottomLab = [[UILabel alloc] initWithFrame:CGRectMake(imaLeftView.right+10, topLab.bottom ,90, 14)];
        bottomLab.font = TEXTFONT(10);
        bottomLab.text = boTitArr[i];
//        bottomLab.textAlignment = NSTextAlignmentCenter;
        bottomLab.textColor = [UIColor colorWithHex:0xBBBBBB alpha:1];
        [_headerView addSubview:bottomLab];
        
        UIButton *choiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        choiceBtn.frame = CGRectMake(kDeviceWidth*0.5*(i%2),lineView1.bottom+69*(i/2), kDeviceWidth*0.5, 69);
        choiceBtn.tag = 133+i;
        [_headerView addSubview:choiceBtn];
        [choiceBtn addTarget:self action:@selector(choiceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    UIView *lineView2 = [[UIView alloc] init];
    lineView2.frame = CGRectMake(20, lineView1.bottom+69, kDeviceWidth-40, 1);
    lineView2.backgroundColor = [UIColor colorWithHex:0xE3E3E3];
    [_headerView addSubview:lineView2];
    
    UIView *lineView3 = [[UIView alloc] init];
    lineView3.frame =CGRectMake(kDeviceWidth*0.5-1, lineView1.bottom+12.5, 1, 115);
    lineView3.backgroundColor = [UIColor colorWithHex:0xE3E3E3];
    [_headerView addSubview:lineView3];

    UIView *BottomlineView = [[UIView alloc] initWithFrame:CGRectMake(0, lineView1.bottom+140, kDeviceWidth, 10)];
    BottomlineView.backgroundColor = [UIColor colorWithHex:0xF3F3F3];
    [_headerView addSubview:BottomlineView];
    _headerView.frame = CGRectMake(0, 0, kDeviceWidth, BottomlineView.bottom);
    return _headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 140;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *V= [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 60)];
    V.backgroundColor = [UIColor colorWithHex:0xF0F0F0];
    
    UILabel *phoneLab = [[UILabel alloc] init];
    phoneLab.frame = CGRectMake(kDeviceWidth*0.5-100, 15, 200, 20);
    phoneLab.text = @"客服电话：400-0571-115";
    phoneLab.font = [UIFont fontWithName:@"PingFang-SC-Bold" size:14];
    phoneLab.textAlignment = NSTextAlignmentCenter;
    phoneLab.textColor = HEXCOLOR(0x515151);
    [V addSubview:phoneLab];
    
    UIImageView *imaView = [[UIImageView alloc] initWithFrame:CGRectMake(phoneLab.left-17-5, 17, 17, 16)];
    imaView.image = [MSUPathTools showImageWithContentOfFileByName:@"kefu-1"];
    [V addSubview:imaView];
 
    
    UILabel *timeLab = [[UILabel alloc] init];
    timeLab.frame = CGRectMake(0, phoneLab.bottom, kDeviceWidth, 20);
    timeLab.text = @"服务时间：9:00-18:00";
    timeLab.font = [UIFont fontWithName:@"PingFang-SC-Bold" size:12];
    timeLab.textAlignment = NSTextAlignmentCenter;
    timeLab.textColor = HEXCOLOR(0xBEBEBE);
    [V addSubview:timeLab];
    
    UIButton *Vbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    Vbtn.frame = CGRectMake(kDeviceWidth*0.5-86, timeLab.bottom+5, 172, 41);
    [Vbtn setBackgroundImage:[MSUPathTools showImageWithContentOfFileByName:@"bdkfrx"] forState:UIControlStateNormal];
    [Vbtn setTitle:@"拨打客服电话" forState:UIControlStateNormal];
    Vbtn.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Bold" size:15];
    [Vbtn setTitleColor:WhiteColor forState:UIControlStateNormal];
    [V addSubview:Vbtn];
    [Vbtn addTarget:self action:@selector(VbtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return V;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *V= [[UIView alloc] initWithFrame:CGRectZero];
    return V;
}

#pragma mark - 请求
- (void)requestLogin{
    [[DataRequestServer getDataRequestServerData] requestLoginresult:^(NSString *LoginState) {
        if ([LoginState isEqualToString:@"true"]) {

        }else{
            [AddHudView addProgressView:self.view message:@"登录失效，请重新登录"];
            
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                [CoreArchive removeNSUserDefaults];
                LoginViewController *loginVc= [[LoginViewController alloc] init];
                loginVc.loginType=logintypeHome;
                loginVc.hidesBottomBarWhenPushed =  YES;
                [self.navigationController pushViewController:loginVc animated:YES];
            });
        }
    }];
}

- (void)setPersonInfo{
    if (self.showHideBtn.selected) {
        _TotolLable.text = @"****";
        _moneyLable.text = @"****";
        _amountLable.text = @"****";
        _leftMoneyLable.text = @"****";
    } else{
        self.amountLable.text = [self.userInfo objectForKey:@"waitMoney"];
        self.TotolLable.text = [self.userInfo objectForKey:@"accountTotalAmount"];
        self.moneyLable.text = [self.userInfo objectForKey:@"accumulatedincome"];
        self.leftMoneyLable.text = [self.userInfo objectForKey:@"availableAmount"];

    }
    self.nameLable.text = [[self.userInfo objectForKey:@"username"] stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];

    CGSize sizeB = [MSUStringTools danamicGetWidthFromText:self.moneyLable.text WithFont:18];
    _ruleBtn.frame = CGRectMake(kDeviceWidth*0.75+sizeB.width*0.5+5,self.moneyLable.top+10, 15, 15);
    
    NSString *str = [NSString stringWithFormat:@"%@",self.userInfo[@"isHavJiaXiQuan"]];
    if ([str isEqualToString:@"1"]) {
        self.redCircle.hidden = NO;;
    } else{
        self.redCircle.hidden = YES;;
    }
    
    [_imaIconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.userInfo[@"userImage"]]] placeholderImage: [MSUPathTools showImageWithContentOfFileByName:@"CombinedShape"]];

    [self.CenterTableView reloadData];
    [[NSUserDefaults standardUserDefaults] setObject:self.userInfo forKey:@"userInfoDetial"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)loadRequestWithAFN{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"" forKey:@"risktype"];
    
    [[DataRequestServer getDataRequestServerData] request:@"LunaP2pAppRiskServlet" parameters:dic result:^(id result) {
        if ([result isKindOfClass:[NSString class]] &&  [result isEqualToString:@"44"]) {
            [AddHudView addProgressView:self.view message:@"网络错误，请稍后再试"];
        }else{
            int success = [[result objectForKey:@"success"]intValue];
            if ([[result objectForKey:@"errorlog"]isEqualToString:@"noLogin"]&& success==0)
            {
                [self requestLogin];
            }else if([[result objectForKey:@"errorlog"]isEqualToString:@""]&& success==1)
            {
                self.testCode = [result[@"risktype"] integerValue];
            }else
            {
                [AddHudView addProgressView:self.view message:@"数据获取失败，请重新获取"];
            }
        }
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            WebViewController *webVC = [[WebViewController alloc] init];
            webVC.UrlString =[ NSString stringWithFormat:@"%@wap/activity/reffer/invitation.htm",Base_url];
//            webVC.UrlString = @"http://192.168.1.27:8080/activity/registerActivity18.htm";
            webVC.title = @"邀请好友";
            webVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:webVC animated:YES];
        }

            break;
        case 1:
        {
//            MangerViewController *MangerVC = [[MangerViewController alloc] init];
//            MangerVC.hidesBottomBarWhenPushed =  YES;
//            MangerVC.testCode = self.testCode;
//            MangerVC.iconUlrStr = [NSString stringWithFormat:@"%@",self.userInfo[@"userImage"]];
//            [self.navigationController pushViewController:MangerVC animated:YES];
            MSUManagerController *mana = [[MSUManagerController alloc] init];
            mana.phoneStr = [self.userInfo objectForKey:@"username"];
            mana.registNum = self.registNum;
            mana.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:mana animated:YES];
        }
            break;
        case 2:
        {
            MSUAboutController *aboutVC = [[MSUAboutController alloc] init];
            aboutVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:aboutVC animated:YES];
        }
            break;
        case 3:
        {
            WebViewController *webVC = [[WebViewController alloc] init];
            webVC.UrlString =[ NSString stringWithFormat:@"%@content/help.htm",Base_url];
            webVC.title = @"帮助中心";
            webVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:webVC animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 点击事件
- (void)choiceBtnClick:(UIButton *)sender{
    switch (sender.tag) {
        case 133:
        {
            TradeRecordViewController *tradeVC = [[TradeRecordViewController alloc] init];
            tradeVC.TrandeType = TrandeRecordTypeAll;
            tradeVC.TrandeFromType = TrandeRecordFromType_ALL;
            tradeVC.hidesBottomBarWhenPushed =  YES;
            [self.navigationController pushViewController:tradeVC animated:YES];
        }
            break;
        case 134:
        {
            MSUCurrentController *CurrentVC = [[MSUCurrentController alloc] init];
            CurrentVC.hidesBottomBarWhenPushed =  YES;
            [self.navigationController pushViewController:CurrentVC animated:YES];
        }
            break;
        case 135:
        {
            MSUMyBidController *MyBidVC = [[MSUMyBidController alloc] init];
            //            MyBidVC.receiptType = MSUReceiptTypeCollect;
            MyBidVC.hidesBottomBarWhenPushed =  YES;
            [self.navigationController pushViewController:MyBidVC animated:YES];
        }
            break;
        case 136:
        {
            CouponViewController *cardVC = [[CouponViewController alloc] init];
            cardVC.hidesBottomBarWhenPushed =  YES;
            [self.navigationController pushViewController:cardVC animated:YES];
            
        }
            break;
            
        default:
            break;
    }
}

- (void)WithdrawButtonClick:(UIButton *)sender{
    if (![CoreArchive isLockedBank]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"未添加银行卡，请前往添加" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag=1002;
        [alertView show];
        return;
    }
    
    
    if (![CoreArchive isSetTradePass]) {
        MSUSetTradePWDController *set = [[MSUSetTradePWDController alloc] init];
        set.signStr = @"account";
        set.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:set animated:YES];
        return;
    }
    
    WithdrawViewController *WithDrawVC = [[WithdrawViewController alloc] init];
    WithDrawVC.hidesBottomBarWhenPushed =  YES;
    [self.navigationController pushViewController:WithDrawVC animated:YES];
}

- (void)RechargeButtonClick:(UIButton *)sender{
    MSUTopUpController *TopUpVC = [[MSUTopUpController alloc] init];
    TopUpVC.ishasfuyoupay = self.ishasfuyoupay;
    TopUpVC.hidesBottomBarWhenPushed =  YES;
    [self.navigationController pushViewController:TopUpVC animated:YES];
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        switch (alertView.tag) {
            case 1001:
            {
                LockNameViewController *LockName =[[LockNameViewController alloc] init];
                LockName.hidesBottomBarWhenPushed =  YES;
                [self.navigationController pushViewController:LockName animated:YES];
                break;
            }
            case 1002:
            {
                AddCardViewController *AddCardVC =[[AddCardViewController alloc] init];
                AddCardVC.hidesBottomBarWhenPushed =  YES;
                [self.navigationController pushViewController:AddCardVC animated:YES];
                break;
            }
            case 1003:
            {
                RealViewController *RealNameVC =[[RealViewController alloc] init];
                RealNameVC.hidesBottomBarWhenPushed =  YES;
                [self.navigationController pushViewController:RealNameVC animated:YES];
                break;
            }
            default:
                break;
        }
    }
}

- (void)testButtonClick:(UIButton *)sender{
    if (_testCode > 0) {
        MSUTestCompleteController *com = [[MSUTestCompleteController alloc] init];
        com.codeSign = _testCode;
        com.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:com animated:YES];
    } else{
        MSUTestController *test = [[MSUTestController alloc] init];
        test.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:test animated:YES];
    }
}

- (void)showHideBtnClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    NSString *showHiden;
    if (sender.selected == YES) {
        showHiden = [NSString stringWithFormat:@"%@",@"1"];
    } else {
        showHiden = [NSString stringWithFormat:@"%@",@"0"];
    }
    [[NSUserDefaults standardUserDefaults] setObject:showHiden forKey:@"showHiden"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (sender.selected) {
        _TotolLable.text = @"****";
        _moneyLable.text = @"****";
        _amountLable.text = @"****";
        _leftMoneyLable.text = @"****";

    } else{
        self.TotolLable.text = [self.userInfo objectForKey:@"accountTotalAmount"];
        self.moneyLable.text = [self.userInfo objectForKey:@"accumulatedincome"];
        self.amountLable.text = [self.userInfo objectForKey:@"waitMoney"];
        self.leftMoneyLable.text = [self.userInfo objectForKey:@"availableAmount"];
    }

}

- (void)questionBtnClick:(UIButton *)sender{

    MSUAccountController *AccountVC = [[MSUAccountController alloc] init];
    AccountVC.totalAmount = [[[self.userInfo objectForKey:@"accountTotalAmount"]stringByReplacingOccurrencesOfString:@"," withString:@""] floatValue];
    AccountVC.hidesBottomBarWhenPushed =  YES;
    AccountVC.waitIncome = [[self.incomeStr stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
    [self.navigationController pushViewController:AccountVC animated:YES];
}

- (void)ruleBtnClick:(UIButton *)sender{
    self.shadowView.hidden = NO;
    self.centerView.hidden = NO;
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

- (void)SetButtonClick:(UIButton *)sender{
    MSUMessageController *message = [[MSUMessageController alloc] init];
    message.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:message animated:YES];
}

- (void)iconBtnClick:(UIButton *)sender{
    MangerViewController *MangerVC = [[MangerViewController alloc] init];
    MangerVC.hidesBottomBarWhenPushed =  YES;
    MangerVC.testCode = self.testCode;
    MangerVC.iconUlrStr = [NSString stringWithFormat:@"%@",self.userInfo[@"userImage"]];
    [self.navigationController pushViewController:MangerVC animated:YES];
}

#pragma mark - 初始化
- (MSUShadowInView *)shadowView{
    if (!_shadowView) {
        self.shadowView = [[MSUShadowInView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
        _shadowView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [MSUMainWindow addSubview:_shadowView];
        _shadowView.hidden = YES;
    }
    return _shadowView;
}

- (UIView *)centerView{
    if (!_centerView) {
        self.centerView = [[UIView alloc] initWithFrame:CGRectMake(27, (kDeviceHeight-150)*0.5, kDeviceWidth-54, 150)];
        _centerView.backgroundColor = WhiteColor;
        [self.shadowView addSubview:_centerView];
        
        UILabel *titLab = [[UILabel alloc] init];
        titLab.frame = CGRectMake(17, 17, 200, 22.5);
        titLab.text = @"累计收益说明:";
        titLab.font = [UIFont systemFontOfSize:16];
        titLab.textColor = HEXCOLOR(0x2a2a2a);
        [_centerView addSubview:titLab];
        
        UILabel *centerLab = [[UILabel alloc] init];
        centerLab.text = @"累计收益=微微宝收益+定期每月已返利息";
        CGRect recta = [MSUStringTools danamicGetHeightFromText:centerLab.text WithWidth:kDeviceWidth-54-34 font:14];
        centerLab.frame = CGRectMake(17, titLab.bottom+8, kDeviceWidth-54-34, recta.size.height);
        centerLab.font = [UIFont systemFontOfSize:14];
        centerLab.textColor = HEXCOLOR(0x9b9b9b);
        centerLab.numberOfLines = 0;
        [_centerView addSubview:centerLab];
        
    }
    return _centerView;
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

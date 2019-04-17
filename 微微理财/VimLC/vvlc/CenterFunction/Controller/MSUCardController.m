//
//  MSUCardController.m
//  vvlc
//
//  Created by 007 on 2018/4/26.
//  Copyright © 2018年 HM. All rights reserved.
//

#import "MSUCardController.h"
#import "MSUTopUpController.h"
#import "AddCardViewController.h"

#import "MSUNoCardView.h"
#import "MSUBankCardView.h"
#import "MSUShadowView.h"
#import "MSUStringTools.h"

@interface MSUCardController ()

@property (nonatomic , strong) MSUNoCardView *noCardView;
@property (nonatomic , strong) MSUBankCardView *bankCardView;
@property (nonatomic , copy) NSString *isUnbind;

@property (nonatomic , strong) MSUShadowView *shadowView;
@property (nonatomic , strong) UIView *podView;
@property (nonatomic , strong) UILabel *podLab;
@property (nonatomic , copy) NSString *podStr;

@property (nonatomic , copy) NSString *isSetPWD;
@property (nonatomic , copy) NSString *realName;
@property (nonatomic , copy) NSString *idNum;

@end

@implementation MSUCardController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([CoreArchive isLockedBank]) {
        [self requestCardInfo];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我的银行卡";
    self.view.backgroundColor = HEXCOLOR(0xe8e8e8);
    
    if (![CoreArchive isLockedBank]) {
        self.noCardView.hidden = NO;
        self.bankCardView.hidden = YES;
    } else{
        self.noCardView.hidden = YES;
        self.bankCardView.hidden = NO;

    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestCardInfo{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[DataRequestServer getDataRequestServerData] request:@"LunaP2pAppBankServlet" parameters:nil result:^(id result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([result isKindOfClass:[NSString class]] &&  [result isEqualToString:@"44"]) {
            [AddHudView addProgressView:self.view message:@"网络错误，请稍后再试"];
        }else if([[result objectForKey:@"success"]intValue]==1 && [[result objectForKey:@"errorlog"]isEqualToString:@""]){
            NSArray *DataArr= [result objectForKey:@"items"];
            NSDictionary *dic= [DataArr objectAtIndex:0];
            self.isUnbind = [NSString stringWithFormat:@"%@",dic[@"isUnbind"]];
            self.podStr = [NSString stringWithFormat:@"%@",dic[@"popStr"]];
            self.isSetPWD = [NSString stringWithFormat:@"%@",dic[@"IsToSetTranPas"]];
            self.realName = [NSString stringWithFormat:@"%@",dic[@"realNameFull"]];
            self.idNum = [NSString stringWithFormat:@"%@",dic[@"idNumberFull"]];

            _bankCardView.bankName.text = [dic objectForKey:@"bankType"];
            _bankCardView.bankNum.text = [NSString stringWithFormat:@"**** **** **** %@",[dic objectForKey:@"accountNumber"]];
            [_bankCardView.bankImaView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"bankIcon"]]] placeholderImage:[UIImage imageNamed:@"image_empty"]];
            NSString *str = [NSString stringWithFormat:@"%@",[dic objectForKey:@"realNameFull"]];
            _bankCardView.nameLab.text = [str stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@"*"];
        }else{
            [AddHudView addProgressView:self.view message:@"获取数据失败"];
        }
    }];
}

- (void)rechargeBtnClick:(UIButton *)sender{
//    BankLimitViewController *VC= [[BankLimitViewController alloc] init];
////    VC.hidesBottomBarWhenPushed = YES;
//    NSString  *str;
//    if ([CoreArchive isSetTradePass]) {
//        str = @"1";
//    } else{
//        str = @"0";
//    }
//    VC.isSetPWD = str;
//    [self.navigationController pushViewController:VC animated:YES];
    
    MSUTopUpController *topUp = [[MSUTopUpController alloc] init];
    [self.navigationController pushViewController:topUp animated:YES];
}

- (void)unbindBtnClick:(UIButton *)sender{
    self.shadowView.hidden = NO;
    self.podView.hidden = NO;
    
    if ([MSUStringTools isBlankString:self.isUnbind]) {
        self.isUnbind = [NSString stringWithFormat:@"%@",@""];
    }
    
    if ([self.isUnbind isEqualToString:@"0"]) {
        _podLab.text = @"您未满足换绑条件，详见换绑规则";
    } else if([self.isUnbind isEqualToString:@"1"]){
        _podLab.text = @"更换前需要解绑现有银行卡，确定继续操作";
    }

}

- (void)cancelBtnClick:(UIButton *)sender{
    self.shadowView.hidden = YES;
}

- (void)sureBtnClick:(UIButton *)sender{
    self.shadowView.hidden = YES;
    AddCardViewController *AddCardVC =[[AddCardViewController alloc] init];
    //    AddCardVC.hidesBottomBarWhenPushed =  YES;
//    AddCardVC.bankStr = [NSString stringWithFormat:@"%@",dic[@"bankName"]];
    AddCardVC.isSetPWD = self.isSetPWD;
    AddCardVC.signIndex = 1;
    AddCardVC.realName = self.realName;
    AddCardVC.idNum = self.idNum;
    [self.navigationController pushViewController:AddCardVC animated:YES];
}

#pragma mark - 初始化
- (MSUNoCardView *)noCardView{
    if (!_noCardView) {
        _noCardView = [[MSUNoCardView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
        _noCardView.backgroundColor = HEXCOLOR(0xe8e8e8);
        [self.view addSubview:_noCardView];
        [_noCardView.rechargeBtn addTarget:self action:@selector(rechargeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _noCardView;
}

- (MSUBankCardView *)bankCardView{
    if (!_bankCardView) {
        _bankCardView = [[MSUBankCardView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
        _bankCardView.backgroundColor = HEXCOLOR(0xe8e8e8);
        [_bankCardView.unbindBtn addTarget:self action:@selector(unbindBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_bankCardView];
    }
    return _bankCardView;
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
        
        self.podLab = [[UILabel alloc] init];
        _podLab.frame = CGRectMake(40, 31*kDeviceHeightScale, kDeviceWidth-56-80, 45);
        _podLab.backgroundColor = HEXCOLOR(0xffffff);
        _podLab.text = @"--";
        _podLab.font = [UIFont systemFontOfSize:16];
        _podLab.textAlignment = NSTextAlignmentCenter;
        _podLab.numberOfLines = 0;
        _podLab.textColor = HEXCOLOR(0x757575);
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

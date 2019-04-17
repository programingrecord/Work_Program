//
//  MSUAccountController.m
//  vvlc
//
//  Created by 007 on 2018/3/19.
//  Copyright © 2018年 HM. All rights reserved.
//

#import "MSUAccountController.h"
#import "LoginViewController.h"

#import "MSUTotalView.h"
#import "MSUIncomeView.h"
#import "MSUShadowInView.h"

#import "MSUStringTools.h"

@interface MSUAccountController ()

@property (nonatomic,strong) NSMutableDictionary *userInfo;
@property (nonatomic , strong) MSUTotalView *totalView;
@property (nonatomic , strong) MSUIncomeView *incomeView;

@property (nonatomic , strong) NSDictionary *dataDic;

@property (nonatomic , strong) MSUShadowInView *shadowView;
@property (nonatomic , strong) UIView *centerView;

@end

@implementation MSUAccountController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = WhiteColor;
    self.title = @"资产详情";
    
    UIView *lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(0, 0, kDeviceWidth, 1);
    lineView.backgroundColor = LineColor;
    [self.view addSubview:lineView];
    
    NSArray *array = [NSArray arrayWithObjects:@"总资产",@"累计收益", nil];
    //初始化UISegmentedControl
    UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:array];
    //设置frame
    segment.frame = CGRectMake(kDeviceWidth*0.5-90, 22, 180, 31);
    segment.tintColor = HEXCOLOR(0xff6339);
    segment.selectedSegmentIndex = 0;
    [segment addTarget:self action:@selector(changeSegment:) forControlEvents:UIControlEventValueChanged];
    //添加到视图
    [self.view addSubview:segment];

    self.totalView.hidden = NO;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInfoDetial = [userDefaults objectForKey:@"userInfoDetial"];
    self.userInfo = [userInfoDetial mutableCopy];
    [self requestAccounDetail];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestAccounDetail{
    double frozen = [[[NSString stringWithFormat:@"%@",@"15023.54"] stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
    double available = [[[NSString stringWithFormat:@"%@",@"5000"] stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
    double MLB = [[[NSString stringWithFormat:@"%@",@"20000"] stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
    
    double january = [[[NSString stringWithFormat:@"%@",@"200"] stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
    double seven = [[[NSString stringWithFormat:@"%@",@"15000"] stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
    double march = [[[NSString stringWithFormat:@"%@",@"2000"] stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
    double income = [[[NSString stringWithFormat:@"%@",@"3000"] stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];//定期收益
    
    UILabel *lab = _totalView.muArr[0];
    lab.text = [NSString stringWithFormat:@"%.2f元",january+seven+march+self.waitIncome];
    
    UILabel *lab1 = _totalView.muArr[1];
    lab1.text = [NSString stringWithFormat:@"%@元",@"200"];
    
    UILabel *lab2 = _totalView.muArr[2];
    lab2.text = [NSString stringWithFormat:@"%@元",@"5000"];
    
    UILabel *lab3 = _totalView.muArr[3];
    lab3.text = [NSString stringWithFormat:@"%@元",@"15023.54"];
    
    NSString *str = [NSString stringWithFormat:@"%@",@"20023.54"];
    self.totalAmount = [[str stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
    double totalStr = frozen+available+MLB+january+seven+march+_waitIncome;
    if (_totalAmount !=0) {
        [_totalView.proGress setfrozenPersent:frozen/totalStr availablePersent:available/totalStr MLBPersent:MLB/totalStr januaryPercent:0 sevenPercent:0 MarchPercent:(january+seven+march+_waitIncome)/totalStr totalAcoount:totalStr totalIncome:self.totalAmount];
    }
}

- (void)requestLogin{
    [[DataRequestServer getDataRequestServerData] requestLoginresult:^(NSString *LoginState) {
        if ([LoginState isEqualToString:@"true"]) {
            [self requestAccounDetail];
        }else{
            [AddHudView addProgressView:self.view message:@"登录失效，请重新登录"];
            double delayInSeconds = 1.2;
            __block MSUAccountController* BlockVC = self;
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

#pragma mark - 点击
-(void)changeSegment:(UISegmentedControl *)sender{
    if (sender.selectedSegmentIndex == 0) {
        self.totalView.hidden = NO;
        self.incomeView.hidden = YES;
    } else {
        self.totalView.hidden = YES;
        self.incomeView.hidden = NO;
        
        UILabel *lab11 = _incomeView.muArr[0];
        lab11.text = [NSString stringWithFormat:@"%@元",@"60.75"];
        
        UILabel *lab22 = _incomeView.muArr[1];
        lab22.text = [NSString stringWithFormat:@"%@元",@"68.23"];
        
        float accumulated = [[[NSString stringWithFormat:@"%@",@"128.98"] stringByReplacingOccurrencesOfString:@"," withString:@""] floatValue];//定期收益
        if (accumulated != 0) {
            float mlb = [[[NSString stringWithFormat:@"%@",@"33.21"] stringByReplacingOccurrencesOfString:@"," withString:@""] floatValue];
            float income = [[[NSString stringWithFormat:@"%@",@"12.32"] stringByReplacingOccurrencesOfString:@"," withString:@""] floatValue];//定期收益
           
            [_incomeView.proGress setRegIncomePersent:income/accumulated MLBIncomePersent:mlb/accumulated totalIncome:accumulated];
        }
    }
}

- (void)detailBtnClick:(UIButton *)sender{
    self.shadowView.hidden = NO;
    self.centerView.hidden = NO;
}

#pragma mark - 初始化
- (MSUTotalView *)totalView{
    if (!_totalView) {
        _totalView = [[MSUTotalView alloc] initWithFrame:CGRectMake(0, 80, kDeviceWidth, kDeviceHeight-80)];
        _totalView.backgroundColor = WhiteColor;
        [self.view addSubview:_totalView];
        [_totalView.detailBtn addTarget:self action:@selector(detailBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _totalView;
}

- (MSUIncomeView *)incomeView{
    if (!_incomeView) {
        _incomeView = [[MSUIncomeView alloc] initWithFrame:CGRectMake(0, 80, kDeviceWidth, kDeviceHeight-80)];
        _incomeView.backgroundColor = WhiteColor;
        [self.view addSubview:_incomeView];
    }
    return _incomeView;
}

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
        self.centerView = [[UIView alloc] initWithFrame:CGRectMake(27, (kDeviceHeight-290)*0.5, kDeviceWidth-54, 290)];
        _centerView.backgroundColor = WhiteColor;
        [self.shadowView addSubview:_centerView];
        
        UILabel *titLab = [[UILabel alloc] init];
        titLab.frame = CGRectMake(17, 17, 100, 22.5);
        titLab.text = @"资产说明:";
        titLab.font = [UIFont systemFontOfSize:16];
        titLab.textColor = HEXCOLOR(0x2a2a2a);
        [_centerView addSubview:titLab];
        
        UILabel *centerLab = [[UILabel alloc] init];
        centerLab.text = @"总资产 = 定期资产+微微宝+账户余额+冻结资金\n\n定期资产 = 本金+应收收益（应收本金+应收利息）\n\n微微宝 = 微微宝本金\n\n账户余额 = 账户中剩余的金额\n\n冻结金额 = 募集中+提现中";
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

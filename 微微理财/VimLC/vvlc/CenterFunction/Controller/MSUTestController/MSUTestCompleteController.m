//
//  MSUTestCompleteController.m
//  vvlc
//
//  Created by 007 on 2018/2/5.
//  Copyright © 2018年 HM. All rights reserved.
//

#import "MSUTestCompleteController.h"
#import "MSUTestController.h"
#import "LoginViewController.h"
#import "MSUTestFirstController.h"
#import "CenterNewViewController.h"

#import "MSUStringTools.h"

@interface MSUTestCompleteController ()

@property (nonatomic , copy) NSString *styleStr;
@property (nonatomic , copy) NSString *numStr;

@end

@implementation MSUTestCompleteController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"风险测评";
    self.view.backgroundColor = WhiteColor;
    
    [self createCenterUI];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI
- (void)createCenterUI{
    UILabel *titLab = [[UILabel alloc] init];
    titLab.frame = CGRectMake(35*kDeviceWidthScale, 28*kDeviceHeightScale, kDeviceWidth*0.5, 25);
    titLab.font = [UIFont systemFontOfSize:14];
    titLab.textColor = HEXCOLOR(0xbdbdbd);
    titLab.text = @"您的投资类型为";
    [self.view addSubview:titLab];
    
    
    NSString *quesStr;
    NSString *anserStr;
    if ((self.answerCode <= 5 && self.answerCode > 0) || self.codeSign == 1) {
        self.styleStr = @"保守型";
        self.numStr = @"1";
        quesStr = @"不能承担任何风险，保本，专业才是你最放心的产品";
        anserStr = @"微微宝";
    } else if ((self.answerCode > 5 && self.answerCode <= 10) || self.codeSign == 2){
        self.styleStr = @"稳健型";
        self.numStr = @"2";
        quesStr = @"投资考虑的第一要素便是投资是否安全，稳健、谨慎是您最大特点，能承受一定的风险";
        anserStr = @"七天标";
    } else if ((self.answerCode > 10 && self.answerCode <= 15) || self.codeSign == 3){
        self.styleStr = @"理性型";
        self.numStr = @"3";
        quesStr = @"能够根据自身情况，合理分配资产，对于风险有一定的认知；会根据自身情况进行资产配置，合理搭配，投资不同的项目，同时也积极参加活动，提升投资收益。";
        anserStr = @"一月标";
    } else if ((self.answerCode > 15 && self.answerCode <= 20) || self.codeSign == 4){
        self.styleStr = @"冒险型";
        self.numStr = @"4";
        quesStr = @"偏爱极高的年化收益，冒险性高，建议一定要在保证资金安全的前提下，选择适当合理的高收益";
        anserStr = @"三月标";
    }
    
    UILabel *styleLab = [[UILabel alloc] init];
    styleLab.frame = CGRectMake(35*kDeviceWidthScale,titLab.bottom + 1*kDeviceHeightScale, kDeviceWidth*0.5, 45);
    styleLab.font = [UIFont systemFontOfSize:32];
    styleLab.textColor = HEXCOLOR(0xff4b1f);
    styleLab.text = _styleStr;
    [self.view addSubview:styleLab];

    UILabel *quesLab = [[UILabel alloc] init];
    quesLab.text = quesStr;
    CGRect rectA = [MSUStringTools danamicGetHeightFromText:quesLab.text WithWidth:kDeviceWidth-72*kDeviceWidthScale font:16];
    quesLab.frame = CGRectMake(styleLab.left,styleLab.bottom + 29.5*kDeviceHeightScale, kDeviceWidth-72*kDeviceWidthScale, rectA.size.height);
    quesLab.numberOfLines = 0;
    quesLab.font = [UIFont systemFontOfSize:16];
    quesLab.textColor = HEXCOLOR(0x9b9b9b);
    [MSUStringTools changeLineSpaceForLabel:quesLab WithSpace:5];
    [self.view addSubview:quesLab];
    
    UILabel *answerLab = [[UILabel alloc] init];
    answerLab.frame = CGRectMake(35*kDeviceWidthScale,quesLab.bottom +  14.5*kDeviceHeightScale, kDeviceWidth-70*kDeviceWidthScale, 25);
    answerLab.font = [UIFont systemFontOfSize:16];
    answerLab.textColor = HEXCOLOR(0x9b9b9b);
    answerLab.attributedText = [MSUStringTools makeKeyWordAttributedWithSubText:anserStr inOrigiText:[NSString stringWithFormat:@"适合您的产品为：%@",anserStr] font:16 color:HEXCOLOR(0xff4b1f)];;
    [self.view addSubview:answerLab];
    
    UIButton *pushBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    pushBtn.frame = CGRectMake(36*kDeviceWidthScale,answerLab.bottom + 88*kDeviceHeightScale, kDeviceWidth-72*kDeviceWidthScale, 49);
    pushBtn.clipsToBounds = YES;
    pushBtn.layer.cornerRadius = 49*0.5;
    pushBtn.layer.shouldRasterize = YES;
    pushBtn.layer.rasterizationScale = [UIScreen mainScreen].scale;
    pushBtn.backgroundColor = HEXCOLOR(0xfb6337);
    [pushBtn setTitle:@"去投资" forState:UIControlStateNormal];
    [pushBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
    pushBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:pushBtn];
    [pushBtn addTarget:self action:@selector(pushBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *beforeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    beforeBtn.frame = CGRectMake(0, kDeviceHeight-34-22.5-64, kDeviceWidth, 22.5);
    [beforeBtn setTitle:@"重测" forState:UIControlStateNormal];
    beforeBtn.backgroundColor = WhiteColor;
    [beforeBtn setTitleColor:HEXCOLOR(0xff4b1f) forState:UIControlStateNormal];
    beforeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:beforeBtn];
    [beforeBtn addTarget:self action:@selector(beforeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self loadRequestWithAFN];
}


#pragma mark - 加载数据
- (void)loadRequestWithAFN{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:self.numStr forKey:@"risktype"];
    
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
               
                
            }else
            {
                [AddHudView addProgressView:self.view message:@"数据获取失败，请重新获取"];
            }
        }
    }];
}

- (void)requestLogin{
    
    [[DataRequestServer getDataRequestServerData] requestLoginresult:^(NSString *LoginState) {
        if ([LoginState isEqualToString:@"true"]) {
            [self loadRequestWithAFN];
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

#pragma amrk - 点击事件
- (void)pushBtnClick:(UIButton *)sender{
    AppDelegate *jj = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [jj loadMainView];
    [jj.mainVC setSelectedIndex:1];
}

- (void)beforeBtnClick:(UIButton *)sender{
    for (UIViewController *ciewController in self.navigationController.viewControllers) {
        if ([ciewController isKindOfClass:[MSUTestFirstController class]]) {
            [self.navigationController popToViewController:ciewController animated:YES];
        } else{
            self.codeSign = 1;
        }
    }
    
    if (self.codeSign > 0) {
        MSUTestFirstController *first = [[MSUTestFirstController alloc] init];
        first.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:first animated:YES];
    }
}

- (void)LeftNavigationButtonClick:(UIButton *)leftbtn{
    for (UIViewController *ciewController in self.navigationController.viewControllers) {
        if ([ciewController isKindOfClass:[CenterNewViewController class]]) {
            [self.navigationController popToViewController:ciewController animated:YES];
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

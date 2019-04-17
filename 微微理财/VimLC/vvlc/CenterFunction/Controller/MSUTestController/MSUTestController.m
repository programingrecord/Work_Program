//
//  MSUTestController.m
//  vvlc
//
//  Created by 007 on 2018/2/5.
//  Copyright © 2018年 HM. All rights reserved.
//

#import "MSUTestController.h"
#import "MSUTestFirstController.h"


#import "MSUPathTools.h"
#import "MSUStringTools.h"

@interface MSUTestController ()

@end

@implementation MSUTestController

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
    UIImageView *imaView = [[UIImageView alloc] initWithFrame:CGRectMake(61*kDeviceWidthScale, 20*kDeviceHeightScale, kDeviceWidth-122*kDeviceWidthScale, 142*kDeviceHeightScale)];
    imaView.image = [MSUPathTools showImageWithContentOfFileByName:@"ch"];
    [self.view addSubview:imaView];
    
    UILabel *attentionLab = [[UILabel alloc] init];
    attentionLab.text = @"为了更好的了解您的风险承受力，请根据真实情况填写问卷。问卷所涉及的信息将全部保密，感谢您的配合。\n根据评估结果，您的风险承受力将为一下四种类型中的一种:保守型、稳健型、理性型、冒险型。\n本问卷共13道选择题，预计耗时2分钟。";
    CGRect rectA = [MSUStringTools danamicGetHeightFromText:attentionLab.text WithWidth:kDeviceWidth-70*kDeviceWidthScale font:16];
    attentionLab.frame = CGRectMake(35*kDeviceWidthScale, 220*kDeviceHeightScale, kDeviceWidth-70*kDeviceWidthScale, rectA.size.height);
    attentionLab.font = [UIFont systemFontOfSize:16];
    attentionLab.textColor = titQianColor;
    attentionLab.numberOfLines = 0;
    [MSUStringTools changeLineSpaceForLabel:attentionLab WithSpace:5];
    [self.view addSubview:attentionLab];
    
    UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    startBtn.frame = CGRectMake(35*kDeviceWidthScale, attentionLab.bottom + 40*kDeviceHeightScale, kDeviceWidth-70*kDeviceWidthScale, 49);
    startBtn.layer.cornerRadius = 49*0.5;
    startBtn.clipsToBounds = YES;
    startBtn.layer.shouldRasterize = YES;
    startBtn.layer.rasterizationScale = [UIScreen mainScreen].scale;
    [startBtn setTitle:@"开始评测" forState:UIControlStateNormal];
    startBtn.backgroundColor = HEXCOLOR(0xfb6337);
    [startBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
    startBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:startBtn];
    [startBtn addTarget:self action:@selector(startBtnClick:) forControlEvents:UIControlEventTouchUpInside];
  
}

- (void)startBtnClick:(UIButton *)sender{
    MSUTestFirstController *first = [[MSUTestFirstController alloc] init];
    first.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:first animated:YES];
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

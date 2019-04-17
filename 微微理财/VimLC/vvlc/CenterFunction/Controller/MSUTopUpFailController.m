//
//  MSUTopUpFailController.m
//  vvlc
//
//  Created by 007 on 2018/3/27.
//  Copyright © 2018年 HM. All rights reserved.
//

#import "MSUTopUpFailController.h"

#import "MSUPathTools.h"

@interface MSUTopUpFailController ()

@end

@implementation MSUTopUpFailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"充值失败";
    self.view.backgroundColor = HEXCOLOR(0xE4E4E4);
    
    [self creatCenterView];
}

- (void)creatCenterView{
    UIView *lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(0, 0, kDeviceWidth, 1);
    lineView.backgroundColor = LineColor;
    [self.view addSubview:lineView];
    
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(0, 1, kDeviceWidth, 208);
    bgView.backgroundColor = HEXCOLOR(0xffffff);
    [self.view addSubview:bgView];
    
    UIImageView *imaView = [[UIImageView alloc] initWithFrame:CGRectMake(kDeviceWidth*0.5-30, 50, 60, 60)];
    imaView.image = [MSUPathTools showImageWithContentOfFileByName:@"Shape"];
    imaView.contentMode = UIViewContentModeScaleAspectFit;
    [bgView addSubview:imaView];
    
    UILabel *failLab = [[UILabel alloc] init];
    failLab.frame = CGRectMake(0, imaView.bottom + 16, kDeviceWidth, 25);
    failLab.text = @"充值失败";
    failLab.font = [UIFont systemFontOfSize:18];
    failLab.textAlignment = NSTextAlignmentCenter;
    failLab.textColor = HEXCOLOR(0x454545);
    [bgView addSubview:failLab];
    
    UILabel *detailLab = [[UILabel alloc] init];
    detailLab.frame = CGRectMake(0, failLab.bottom + 5, kDeviceWidth, 25);
    detailLab.text = [NSString stringWithFormat:@"抱歉您充值的%@元充值失败",self.AmountStr];
    detailLab.font = [UIFont systemFontOfSize:14];
    detailLab.textAlignment = NSTextAlignmentCenter;
    detailLab.textColor = HEXCOLOR(0xbababa);
    [bgView addSubview:detailLab];
    
    UIView *bg1View = [[UIView alloc] init];
    bg1View.frame = CGRectMake(0, bgView.bottom + 12, kDeviceWidth, 93);
    bg1View.backgroundColor = HEXCOLOR(0xffffff);
    [self.view addSubview:bg1View];
    
    NSArray *titArr = @[@"错误码: ",@"订单号: "];
    NSMutableArray *rightArr = [NSMutableArray arrayWithObjects:self.failCode,self.orderNum, nil];
    for (NSInteger i = 0; i < 2; i++) {
        UILabel *leftLab = [[UILabel alloc] init];
        leftLab.frame = CGRectMake(16, 47*i, kDeviceWidth, 47);
        leftLab.text = [NSString stringWithFormat:@"%@%@",titArr[i],rightArr[i]];
        leftLab.font = [UIFont systemFontOfSize:16];
        leftLab.textColor = HEXCOLOR(0x3B3D43);
        [bg1View addSubview:leftLab];
    }
    
    UIView *line1View = [[UIView alloc] init];
    line1View.frame = CGRectMake(0, 47, kDeviceWidth, 1);
    line1View.backgroundColor = LineColor;
    [bg1View addSubview:line1View];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

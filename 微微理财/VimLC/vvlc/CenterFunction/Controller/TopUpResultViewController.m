//
//  TopUpResultViewController.m
//  SmallCat
//
//  Created by H on 2017/6/15.
//  Copyright © 2017年 HM. All rights reserved.
//

#import "TopUpResultViewController.h"
#import "CenterNewViewController.h"
@interface TopUpResultViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *ResultImage;
@property (weak, nonatomic) IBOutlet UILabel *ResultTip;
@property (weak, nonatomic) IBOutlet UIButton *rightToTrade;

@end

@implementation TopUpResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"充值结果";
    if (self.isSucess) {
        self.ResultImage.image = [UIImage imageNamed:@"TopUpSucess"];
        self.ResultTip.text =[NSString stringWithFormat:@"你已成功充值¥ %@",self.AmountStr];
        self.rightToTrade.hidden = NO;
    }else{
        self.ResultImage.image = [UIImage imageNamed:@"TopUpFail"];
        self.rightToTrade.hidden = YES;

        if (self.isAuth) {
            self.ResultTip.text =[NSString stringWithFormat:@"鉴权失败，请重新操作"];
        }else{
            self.ResultTip.text =[NSString stringWithFormat:@"充值失败，请重新操作"];
        }
    }
}

#pragma mark - 代理
- (IBAction)WCButtonClick:(id)sender {
    for (UIViewController *VC in self.navigationController.viewControllers) {
        if ([VC isKindOfClass:[CenterNewViewController class]]) {
            [self.navigationController popToViewController:VC animated:YES];
            return;
        }
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
    AppDelegate *jj = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [jj loadMainView];
    [jj.mainVC setSelectedIndex:1];
}

- (IBAction)RightTradeButtonclick:(id)sender {
    AppDelegate *jj = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [jj loadMainView];
    [jj.mainVC setSelectedIndex:1];
}

- (void)BackViewController{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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

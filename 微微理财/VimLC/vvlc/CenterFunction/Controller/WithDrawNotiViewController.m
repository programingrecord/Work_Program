//
//  WithDrawNotiViewController.m
//  WTJR
//
//  Created by H on 16/8/24.
//  Copyright © 2016年 HM. All rights reserved.
//

#import "WithDrawNotiViewController.h"

@interface WithDrawNotiViewController ()
@property (weak, nonatomic) IBOutlet UILabel *withMoney;
@property (weak, nonatomic) IBOutlet UILabel *withCard;

@end

@implementation WithDrawNotiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提现";
    self.withMoney.text = [NSString stringWithFormat:@"%.2f元",self.withDrawMoney.floatValue];
    self.withCard.text = [NSString stringWithFormat:@"%@（%@）",self.cardName,self.cardNumber];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)finish:(id)sender {
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appdelegate loadMainView];
    appdelegate.mainVC.selectedIndex = 3;
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

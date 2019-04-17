//
//  CardViewController.m
//  WTJR
//
//  Created by H on 16/6/5.
//  Copyright © 2016年 HM. All rights reserved.
//

#import "CardViewController.h"
#import "AddCardViewController.h"
#import "UIImageView+WebCache.h"



@interface CardViewController ()<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIView *NoCardView;
@property (weak, nonatomic) IBOutlet UIView *ADDCardBgView;
@property (weak, nonatomic) IBOutlet UIView *CardView;
@property (weak, nonatomic) IBOutlet UILabel *cardName;
@property (weak, nonatomic) IBOutlet UILabel *cardNum;
@property (weak, nonatomic) IBOutlet UIImageView *cardImage;
@property (nonatomic,strong) NSMutableDictionary *infoDic;
@property (nonatomic,assign) BOOL ishaveCard;
@property (weak, nonatomic) IBOutlet UILabel *CardTipLabel;

@end

@implementation CardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的银行卡";
    UITapGestureRecognizer *PhoneLabeltap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(PhoneLabeltapGesture:)];
    PhoneLabeltap.numberOfTapsRequired = 1;
    PhoneLabeltap.numberOfTouchesRequired = 1;
    PhoneLabeltap.delegate = self;
    [self.CardTipLabel addGestureRecognizer:PhoneLabeltap];
}

- (void)PhoneLabeltapGesture:(UIGestureRecognizer *)tap{
    [self.CardTipLabel removeGestureRecognizer:tap];
    NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"tel://%@",@"400-0571-115"];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    
    NSURL *url = [NSURL URLWithString:str];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        if (iOS10) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                if (success) {
                    MyLog(@"hahah");
                    [self.CardTipLabel addGestureRecognizer:tap];
                } else{
                    [self.CardTipLabel addGestureRecognizer:tap];
                }
            }];
        }else{
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated{
    if (![CoreArchive isLockedBank]) {
        _CardView.hidden = YES;
        _NoCardView.hidden =NO;
    }else{
        _CardView.hidden = NO;
        self.cardImage.layer.cornerRadius = 22;
        self.cardImage.layer.borderWidth = 1;
        self.cardImage.clipsToBounds = YES;
        self.cardImage.layer.borderColor = [UIColor colorWithHex:0xFFFFFF].CGColor;
        _NoCardView.hidden =YES;
        [self requestCardInfo];
    }
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
            self.cardName.text = [dic objectForKey:@"bankType"];
            self.cardNum.text = [NSString stringWithFormat:@"**** **** **** %@",[dic objectForKey:@"accountNumber"]];
            [self.cardImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"bankIcon"]]] placeholderImage:[UIImage imageNamed:@"image_empty"]];
        }else{
            [AddHudView addProgressView:self.view message:@"获取数据失败"];
        }
    }];
}

- (void)ADDCardBgViewLayer{
    _CardView.layer.borderColor = RGBA(223, 223, 223, 1).CGColor;
    CAShapeLayer *border = [CAShapeLayer layer];
    
    border.strokeColor = [UIColor colorWithHex:0xFB6337].CGColor;
    border.fillColor = nil;
    border.path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, kDeviceWidth-40, 80)].CGPath;
    border.frame = self.ADDCardBgView.bounds;
    border.lineWidth = 1.f;
    border.lineCap = @"square";
    border.lineDashPattern = @[@4, @2];
    
    [self.ADDCardBgView.layer addSublayer:border];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addCardClick:(id)sender {
    AddCardViewController *AddcardVC = [[AddCardViewController alloc] init];
    [self.navigationController pushViewController:AddcardVC animated:YES];
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

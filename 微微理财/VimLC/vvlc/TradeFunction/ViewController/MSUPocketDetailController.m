//
//  MSUPocketDetailController.m
//  vvlc
//
//  Created by 007 on 2018/1/11.
//  Copyright © 2018年 HM. All rights reserved.
//

#import "MSUPocketDetailController.h"
#import "LoginViewController.h"
#import "PocketBuyViewController.h"
#import "MSUProductIntroController.h"

#import "MSUPocketTopView.h"
#import "MSUPoceketCenterView.h"

#import "MSUStringTools.h"
#import "MSUPathTools.h"

@interface MSUPocketDetailController ()<UIScrollViewDelegate>

@property (nonatomic , strong) UIScrollView *scrollView;
@property (nonatomic , strong) MSUPocketTopView *topView;
@property (nonatomic , strong) MSUPoceketCenterView *centerView;
@property (nonatomic , strong)  UIView *bgView;
@property (nonatomic , strong) UIButton *tranInBtn;

@property (nonatomic , strong) NSDictionary *dataDic;

@end

@implementation MSUPocketDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"微微宝";
    self.view.backgroundColor = BGWhiteColor;
    
    [self createCenterView];
    [self reloadUIWithDic:_dataDic];
}

- (void)createCenterView{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    _scrollView.backgroundColor  = BGWhiteColor;
    _scrollView.contentSize = CGSizeMake(kDeviceWidth, kDeviceHeight);
    _scrollView.scrollEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    if (iOS11) {
        _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    self.topView = [[MSUPocketTopView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 204*kDeviceHeightScale)];
    _topView.backgroundColor = HEXCOLOR(0xff6735);
    [_scrollView addSubview:_topView];
    
    self.centerView = [[MSUPoceketCenterView alloc] init];
    _centerView.backgroundColor = WhiteColor;
    _centerView.frame = CGRectMake(0, _topView.bottom+5*kDeviceHeightScale, kDeviceWidth, 264*kDeviceHeightScale);
    [_scrollView addSubview:_centerView];
    
    self.bgView = [[UIView alloc] init];
    _bgView.frame = CGRectMake(0, _centerView.bottom+5*kDeviceHeightScale, kDeviceWidth, 50*kDeviceHeightScale);
    _bgView.backgroundColor = WhiteColor;
    [_scrollView addSubview:_bgView];
    
    UIImageView *imaView = [[UIImageView alloc] initWithFrame:CGRectMake(14.5*kDeviceWidthScale, 16.5*kDeviceHeightScale, 15.1*kDeviceWidthScale, 16.9*kDeviceHeightScale)];
    imaView.image = [MSUPathTools showImageWithContentOfFileByName:@"cpjs_icon"];
    imaView.contentMode = UIViewContentModeScaleAspectFit;
    [_bgView addSubview:imaView];
    
    UILabel *attentionLab = [[UILabel alloc] init];
    attentionLab.frame = CGRectMake(imaView.right+12.4*kDeviceWidthScale, 13.5*kDeviceHeightScale, kDeviceWidth*0.5, 22.5*kDeviceHeightScale);
    attentionLab.text = @"产品介绍";
    attentionLab.font = [UIFont systemFontOfSize:16];
    attentionLab.textColor = titBlackColor;
    [_bgView addSubview:attentionLab];
    
    UIImageView *arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(kDeviceWidth - 31*kDeviceWidthScale, 16.5*kDeviceHeightScale, 15.1*kDeviceWidthScale, 16.9*kDeviceHeightScale)];
    arrowView.image = [MSUPathTools showImageWithContentOfFileByName:@"enter_icon"];
    arrowView.contentMode = UIViewContentModeScaleAspectFit;
    [_bgView addSubview:arrowView];
    
    UIButton *introBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    introBtn.frame =  CGRectMake(0, 0, kDeviceWidth, 50*kDeviceHeightScale);
    introBtn.backgroundColor = [UIColor clearColor];
    [_bgView addSubview:introBtn];
    [introBtn addTarget:self action:@selector(introBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.tranInBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _tranInBtn.frame = CGRectMake(22*kDeviceWidthScale, _bgView.bottom+17*kDeviceWidthScale, kDeviceWidth-44*kDeviceWidthScale, 49*kDeviceHeightScale);
    _tranInBtn.backgroundColor = HEXCOLOR(0xfb6337);
    _tranInBtn.layer.cornerRadius = 4;
    _tranInBtn.clipsToBounds = YES;
    _tranInBtn.layer.shouldRasterize = YES;
    _tranInBtn.layer.rasterizationScale = [UIScreen mainScreen].scale;
    [_tranInBtn setTitle:@"立即转入" forState:UIControlStateNormal];
    [_tranInBtn setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
    _tranInBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [_scrollView addSubview:_tranInBtn];
    [_tranInBtn addTarget:self action:@selector(tranInBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 点击事件
- (void)tranInBtnClick:(UIButton *)sender{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [userDefaults objectForKey:@"registerData"];
    if ([dic objectForKey:@"UserName"] && [dic objectForKey:@"PassWord"]) {
        PocketBuyViewController *BuyVC = [[PocketBuyViewController alloc] init];
        BuyVC.rate = self.topView.priceLab.text;
        [self.navigationController pushViewController:BuyVC animated:YES];
    }else{
        [CoreArchive removeNSUserDefaults];
        LoginViewController *loginView = [[LoginViewController alloc] init];
        loginView.loginType = logintypeHome;
        loginView.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:loginView animated:YES];
    }
}

- (void)introBtnClick:(UIButton *)sender{

}

#pragma mark - 数据请求
- (void)reloadUIWithDic:(NSDictionary *)DetailDic{
    _centerView.startLab.text = [NSString stringWithFormat:@"%@元起购",@"50"];
    _centerView.ruleLab.text = [NSString stringWithFormat:@"%@",@"高于银行一个点的存款利息"];
    CGRect rectaa = [MSUStringTools danamicGetHeightFromText:_centerView.ruleLab.text WithWidth:kDeviceWidth-78*kDeviceWidthScale font:13];
    _centerView.ruleLab.frame = CGRectMake(_centerView.ruleLab.left, (36+60)*kDeviceHeightScale, kDeviceWidth-78*kDeviceWidthScale, rectaa.size.height);

    _centerView.fengLab.text = [NSString stringWithFormat:@"%@",@"华生银行合作单位，安全有保障"];
    CGRect recta = [MSUStringTools danamicGetHeightFromText:_centerView.fengLab.text WithWidth:kDeviceWidth-78*kDeviceWidthScale font:13];
    _centerView.fengLab.frame = CGRectMake(_centerView.ruleLab.left, (36+60*2)*kDeviceHeightScale, kDeviceWidth-78*kDeviceWidthScale, recta.size.height);
    
    _centerView.jixiLab.text = [NSString stringWithFormat:@"%@",@"当日存入，当日计息"];
    _centerView.cunLab.text = [NSString stringWithFormat:@"%@",@"随存随取，方便生活"];
    
    _centerView.frame = CGRectMake(0, _topView.bottom+5*kDeviceHeightScale, kDeviceWidth,_centerView.cunLab.bottom + 10*kDeviceHeightScale);

    _bgView.frame = CGRectMake(0, _centerView.bottom+5*kDeviceHeightScale, kDeviceWidth, 50*kDeviceHeightScale);
    
    _tranInBtn.frame = CGRectMake(22*kDeviceWidthScale, _bgView.bottom+15*kDeviceWidthScale, kDeviceWidth-44*kDeviceWidthScale, 49*kDeviceHeightScale);

    _scrollView.contentSize = CGSizeMake(0, _tranInBtn.bottom + 84*kDeviceHeightScale);
}

@end


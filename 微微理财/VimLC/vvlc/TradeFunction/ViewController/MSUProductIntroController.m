//
//  MSUProductIntroController.m
//  vvlc
//
//  Created by 007 on 2018/1/18.
//  Copyright © 2018年 HM. All rights reserved.
//

#import "MSUProductIntroController.h"

#import "MSUStringTools.h"

@interface MSUProductIntroController ()<UIScrollViewDelegate>

@property (nonatomic , strong) UIScrollView *scrollView;
@property (nonatomic , assign) NSInteger scrollHeight;

@end

@implementation MSUProductIntroController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"产品介绍";
    self.view.backgroundColor = BGWhiteColor;
    
    [self createUiView];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _scrollView.contentSize = CGSizeMake(kDeviceWidth,self.scrollHeight);
}

-(void)viewDidLayoutSubviews
{
    self.scrollView.contentSize = CGSizeMake(712,1000);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createUiView{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    _scrollView.backgroundColor  = BGWhiteColor;
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width,self.view.frame.size.height);
    _scrollView.scrollEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:_scrollView];
    if (iOS11) {
        _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    /// 介绍详情
    NSString *introStr = [NSString stringWithFormat:@"      %@",_dataDic[@"briefing"]];
    CGRect rectA = [MSUStringTools danamicGetHeightFromText:introStr WithWidth:kDeviceWidth-28*kDeviceWidthScale font:14];
    
    UIView *introView = [[UIView alloc] init];
    introView.frame = CGRectMake(0, 0, kDeviceWidth, rectA.size.height+44*kDeviceHeightScale);
    introView.backgroundColor = WhiteColor;
    [_scrollView addSubview:introView];
    
    UILabel *introLab = [[UILabel alloc] init];
    introLab.text = introStr;
    [MSUStringTools changeLineSpaceForLabel:introLab WithSpace:5];
    introLab.frame = CGRectMake(14*kDeviceWidthScale, 10*kDeviceHeightScale, kDeviceWidth-28*kDeviceWidthScale, rectA.size.height+24);
    introLab.font = [UIFont systemFontOfSize:14];
    introLab.textColor = titBlackQianColor;
    introLab.numberOfLines = 0;
    [introView addSubview:introLab];
    
//    /// 借款企业
//    UIView *qiyeView = [[UIView alloc] init];
//    qiyeView.frame = CGRectMake(0, introView.bottom+13*kDeviceHeightScale, kDeviceWidth, 87*kDeviceHeightScale);
//    qiyeView.backgroundColor = WhiteColor;
//    [_scrollView addSubview:qiyeView];
//
//    UIView *orange2View = [[UIView alloc] init];
//    orange2View.frame = CGRectMake(0, 13.5*kDeviceHeightScale, 4*kDeviceWidthScale, 16*kDeviceHeightScale);
//    orange2View.backgroundColor = titOrangeColor;
//    [qiyeView addSubview:orange2View];
//
//
//    UILabel *describeLab = [[UILabel alloc] init];
//    describeLab.frame = CGRectMake(orange2View.right + 14*kDeviceWidthScale,10*kDeviceHeightScale, 120*kDeviceWidthScale, 22.5*kDeviceHeightScale);
//    describeLab.text = @"合作企业";
//    describeLab.font = [UIFont systemFontOfSize:16];
//    describeLab.textColor = titBlackColor;
//    [qiyeView addSubview:describeLab];
//
//    UIView *lineView = [[UIView alloc] init];
//    lineView.frame = CGRectMake(0,describeLab.bottom + 10.7*kDeviceHeightScale, kDeviceWidth, 1*kDeviceHeightScale);
//    lineView.backgroundColor = LineColor;
//    [qiyeView addSubview:lineView];
//
//    UILabel *qiyeLab = [[UILabel alloc] init];
//    qiyeLab.text = _dataDic[@"enterprise"];
//    qiyeLab.frame = CGRectMake(14*kDeviceWidthScale, describeLab.bottom + 22.5*kDeviceHeightScale, kDeviceWidth-28*kDeviceWidthScale, 20*kDeviceHeightScale);
//    qiyeLab.font = [UIFont systemFontOfSize:14];
//    qiyeLab.textColor = titBlackQianColor;
//    [qiyeView addSubview:qiyeLab];
//
//    /// 资金用途
//    UIView *useView = [[UIView alloc] init];
//    useView.frame = CGRectMake(0, qiyeView.bottom + 13*kDeviceHeightScale, kDeviceWidth, 87*kDeviceHeightScale);
//    useView.backgroundColor = WhiteColor;
//    [_scrollView addSubview:useView];
//
//    UIView *orange3View = [[UIView alloc] init];
//    orange3View.frame = CGRectMake(0, 13.5*kDeviceHeightScale, 4*kDeviceWidthScale, 16*kDeviceHeightScale);
//    orange3View.backgroundColor = titOrangeColor;
//    [useView addSubview:orange3View];
//
//
//    UILabel *describeLab1 = [[UILabel alloc] init];
//    describeLab1.frame = CGRectMake(orange3View.right + 14*kDeviceWidthScale,10*kDeviceHeightScale, 120*kDeviceWidthScale, 22.5*kDeviceHeightScale);
//    describeLab1.text = @"资金用途";
//    describeLab1.font = [UIFont systemFontOfSize:16];
//    describeLab1.textColor = titBlackColor;
//    [useView addSubview:describeLab1];
//
//    UIView *line1View = [[UIView alloc] init];
//    line1View.frame = CGRectMake(0,describeLab1.bottom + 10.7*kDeviceHeightScale, kDeviceWidth, 1*kDeviceHeightScale);
//    line1View.backgroundColor = LineColor;
//    [useView addSubview:line1View];
//
//    UILabel *useLab = [[UILabel alloc] init];
//    useLab.text = _dataDic[@"purpose"];
//    useLab.frame = CGRectMake(14*kDeviceWidthScale, describeLab1.bottom + 22.5*kDeviceHeightScale, kDeviceWidth-28*kDeviceWidthScale, 20*kDeviceHeightScale);
//    useLab.font = [UIFont systemFontOfSize:14];
//    useLab.textColor = titBlackQianColor;
//    [useView addSubview:useLab];
    
    /// 风控措施
    NSString *cuoshiStr = _dataDic[@"piaojubao"];
    CGRect rectC = [MSUStringTools danamicGetHeightFromText:cuoshiStr WithWidth:kDeviceWidth-28*kDeviceHeightScale font:14];
    
    UIView *cuoshiView = [[UIView alloc] init];
    if (IS_IPHONE_5) {
        cuoshiView.frame = CGRectMake(0, introView.bottom + 13*kDeviceHeightScale, kDeviceWidth,rectC.size.height+ (66.5+44+75+55)*kDeviceHeightScale);
    } else{
        cuoshiView.frame = CGRectMake(0, introView.bottom + 13*kDeviceHeightScale, kDeviceWidth,rectC.size.height+ (66.5+44+75+20)*kDeviceHeightScale);
    }
    cuoshiView.backgroundColor = WhiteColor;
    [_scrollView addSubview:cuoshiView];
    
    UIView *orange4View = [[UIView alloc] init];
    orange4View.frame = CGRectMake(0, 13.5*kDeviceHeightScale, 4*kDeviceWidthScale, 16*kDeviceHeightScale);
    orange4View.backgroundColor = titOrangeColor;
    [cuoshiView addSubview:orange4View];
    
    
    UILabel *describeLab2 = [[UILabel alloc] init];
    describeLab2.frame = CGRectMake(orange4View.right + 14*kDeviceWidthScale,10*kDeviceHeightScale, 120*kDeviceWidthScale, 22.5*kDeviceHeightScale);
    describeLab2.text = @"常见问题";
    describeLab2.font = [UIFont systemFontOfSize:16];
    describeLab2.textColor = titBlackColor;
    [cuoshiView addSubview:describeLab2];
    
    UIView *line2View = [[UIView alloc] init];
    line2View.frame = CGRectMake(0,describeLab2.bottom + 10.7*kDeviceHeightScale, kDeviceWidth, 1*kDeviceHeightScale);
    line2View.backgroundColor = LineColor;
    [cuoshiView addSubview:line2View];
    
    UILabel *cuoshiLab = [[UILabel alloc] init];
    cuoshiLab.text = cuoshiStr;
    cuoshiLab.frame = CGRectMake(14*kDeviceWidthScale, describeLab2.bottom + 22.5*kDeviceHeightScale, kDeviceWidth-28*kDeviceWidthScale, rectC.size.height);
    cuoshiLab.font = [UIFont systemFontOfSize:14];
    cuoshiLab.textColor = titBlackQianColor;
    cuoshiLab.numberOfLines = 0;
    [cuoshiView addSubview:cuoshiLab];
    [MSUStringTools changeLineSpaceForLabel:cuoshiLab WithSpace:5];

    self.scrollHeight =  cuoshiView.bottom+21.5*kDeviceHeightScale+64;
}




@end

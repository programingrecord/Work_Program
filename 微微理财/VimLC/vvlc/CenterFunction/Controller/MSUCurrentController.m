//
//  MSUCurrentController.m
//  vvlc
//
//  Created by 007 on 2018/1/15.
//  Copyright © 2018年 HM. All rights reserved.
//

#import "MSUCurrentController.h"
#import "TradeRecordViewController.h"
#import "MSUCurrentOutController.h"
#import "MSUPocketDetailController.h"

#import "MSUCurrentView.h"
#import "BezierCurveView.h"
#import "MSUStringTools.h"

@interface MSUCurrentController ()<UIScrollViewDelegate>

@property (nonatomic , strong) UIScrollView *scrollView;
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (nonatomic,assign)     NSInteger pageIndex;

@property (nonatomic , strong) MSUCurrentView *currentView;
@property (strong,nonatomic)BezierCurveView *bezierView;

@property (nonatomic,copy)NSString *fundAmount;

@property (nonatomic , strong) UIView *bgView;
@property (nonatomic , strong) UILabel *liziLab;


@end

@implementation MSUCurrentController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self GetCurrentDataRefresh:NO ishead:YES index:self.pageIndex];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"微微宝";
    self.fundAmount = @"0";

    [self addNavigationItemTitleView];

    [self createScrollView];
    self.dataArr = [[NSMutableArray alloc] init];
}

- (void)addNavigationItemTitleView{
    UIButton *listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [listButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [listButton setTitle:@"交易记录" forState:UIControlStateNormal];
    listButton.titleLabel.font = TEXTFONT(14);
    listButton.frame = CGRectMake(0, 0, 60, 30);
    [listButton addTarget:self action:@selector(listButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:listButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)listButtonClick{
    TradeRecordViewController *tradeVC = [[TradeRecordViewController alloc] init];
    tradeVC.TrandeFromType = TrandeRecordFromType_MLB;
    [self.navigationController pushViewController:tradeVC animated:YES];
}

- (void)createScrollView{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-64)];
    _scrollView.backgroundColor  = BGWhiteColor;
    _scrollView.contentSize = CGSizeMake(kDeviceWidth, kDeviceHeight-64);
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
    
    self.pageIndex = 1;

    self.currentView = [[MSUCurrentView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 194*kDeviceHeightScale)];
    _currentView.backgroundColor = HEXCOLOR(0xff6735);
    [_scrollView addSubview:_currentView];
    
    //1.初始化
    self.bgView = [[UIView alloc] init];
    _bgView.frame = CGRectMake(0, _currentView.bottom+13, kDeviceWidth, 242.5*kDeviceHeightScale);
    _bgView.backgroundColor = HEXCOLOR(0xffffff);
    [_scrollView addSubview:_bgView];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(20*kDeviceWidthScale, 17, 10*kDeviceWidthScale, 4);
    lineView.backgroundColor = HEXCOLOR(0x659fee);
    [_bgView addSubview:lineView];
    
    UILabel *attentionLab = [[UILabel alloc] init];
    attentionLab.frame = CGRectMake(lineView.right+8*kDeviceWidthScale, 9, 65*kDeviceWidthScale, 20);
    attentionLab.text = @"收益(元)";
    attentionLab.font = [UIFont systemFontOfSize:14];
    attentionLab.textColor = titBlackColor;
    [_bgView addSubview:attentionLab];
    
    self.liziLab = [[UILabel alloc] init];
    _liziLab.frame = CGRectMake(attentionLab.right+1*kDeviceWidthScale, 14, kDeviceWidth-attentionLab.right+1*kDeviceWidthScale, 12);
    _liziLab.text = @"(以本金10000元，利率4.3%为例)";
    _liziLab.font = [UIFont systemFontOfSize:12];
    _liziLab.textColor = titQianColor;
    [_bgView addSubview:_liziLab];
    self.liziLab.hidden = NO;;

    self.bezierView = [BezierCurveView initWithFrame:CGRectMake(5*kDeviceWidthScale, attentionLab.bottom+16, kDeviceWidth-20*kDeviceWidthScale, 190*kDeviceHeightScale)];
    [_bgView addSubview:_bezierView];
    
    //2.折线图
    UIButton *transOutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    transOutBtn.backgroundColor = WhiteColor;
    [transOutBtn setTitle:@"赎回" forState:UIControlStateNormal];
    [transOutBtn setTitleColor:titOrangeColor forState:UIControlStateNormal];
    transOutBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.scrollView addSubview:transOutBtn];
    [transOutBtn addTarget:self action:@selector(transOutBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *transInBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    transInBtn.backgroundColor = titOrangeColor;
    [transInBtn setTitle:@"转入" forState:UIControlStateNormal];
    [transInBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
    transInBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.scrollView addSubview:transInBtn];
    [transInBtn addTarget:self action:@selector(transInBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if (is_iPhoneX) {
        transOutBtn.frame = CGRectMake(0, kDeviceHeight-64-49*kDeviceHeightScale-40, kDeviceWidth*0.5, 49*kDeviceHeightScale);
        transInBtn.frame = CGRectMake(kDeviceWidth*0.5, kDeviceHeight-64-49*kDeviceHeightScale-40, kDeviceWidth*0.5, 49*kDeviceHeightScale);
//        self.bezierView.frame = CGRectMake(5*kDeviceWidthScale, attentionLab.bottom+16,  kDeviceWidth-20*kDeviceWidthScale, <#CGFloat height#>)
    } else{
        transOutBtn.frame = CGRectMake(0, kDeviceHeight-64-49*kDeviceHeightScale, kDeviceWidth*0.5, 49*kDeviceHeightScale);
        transInBtn.frame = CGRectMake(kDeviceWidth*0.5, kDeviceHeight-64-49*kDeviceHeightScale, kDeviceWidth*0.5, 49*kDeviceHeightScale);
    }
}

#pragma mark - 数据请求
- (void)GetCurrentDataRefresh:(BOOL)isRefresh ishead:(BOOL)ishead index:(NSInteger)pageIndex{
    self.liziLab.hidden = NO;;
    [self drawLineChartWithyArr:nil xArr:nil dataArr:nil space:0];
}

//画折线图
-(void)drawLineChartWithyArr:(NSArray *)yArr xArr:(NSArray *)xArr dataArr:(NSArray *)dataArr space:(CGFloat)space{
    //直线
    if (yArr.count > 0) {
        //曲线
        [_bezierView drawLineChartViewWithX_Value_Names:[xArr mutableCopy] TargetValues:[yArr mutableCopy] dataArr:dataArr space:space LineType:LineType_Curve];
        
    } else{
        NSArray *arr = @[@0,@2.28,@2.28,@2.28,@2.28,@2.28,@2.28];//@[@0,@20,@40,@60,@80,@100,@123.23];
        NSMutableArray *x_names = [NSMutableArray arrayWithArray:@[[MSUStringTools getNDay:0],[MSUStringTools getNDay:1],[MSUStringTools getNDay:2],[MSUStringTools getNDay:3],[MSUStringTools getNDay:4],[MSUStringTools getNDay:5],[MSUStringTools getNDay:6]]];
        NSMutableArray *targets = [NSMutableArray arrayWithArray:@[@0,@0.92,@1.84,@2.76,@3.68,@4.60]];//[NSMutableArray arrayWithArray:@[@0,@24.65,@49.29,@73.94,@98.58,@123.23]];
        [_bezierView drawLineChartViewWithX_Value_Names:x_names TargetValues:targets dataArr:arr space:0.92 LineType:LineType_Curve];
    }
}

- (void)reloadUIWithDic:(NSDictionary *)dic{
    self.fundAmount =[NSString stringWithFormat:@"%.2f",[NSString stringWithFormat:@"%@",[dic objectForKey:@"fundAmount"]].floatValue];

    self.currentView.priceLab.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"interestAmount"]];
//    self.currentView.priceLab.text = @"8.2%";
    
    self.currentView.totalLab.text = [NSString stringWithFormat:@"%.2f",[NSString stringWithFormat:@"%@",[dic objectForKey:@"fundAmount"]].floatValue];
    self.currentView.moneyLab.text = [NSString stringWithFormat:@"%.2f",[NSString stringWithFormat:@"%@",[dic objectForKey:@"sumInterest"]].floatValue];
}

#pragma mark - 点击事件
- (void)transOutBtnClick:(UIButton *)sender{
    MSUCurrentOutController *VC= [[MSUCurrentOutController alloc] init];
    VC.AmountStr = self.fundAmount;
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)transInBtnClick:(UIButton *)sender{
    MSUPocketDetailController *VC= [[MSUPocketDetailController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

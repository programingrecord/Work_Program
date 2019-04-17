//
//  MSUTradeDetailController.m
//  vvlc
//
//  Created by 007 on 2018/1/11.
//  Copyright © 2018年 HM. All rights reserved.
//

#import "MSUTradeDetailController.h"
#import "BuyTradeViewController.h"
#import "LoginViewController.h"
#import "WebViewController.h"
#import "MSUProtocalController.h"
#import "MSUImageShowController.h"

#import "MSUTradeTopView.h"
#import "MSUTradeBottomView.h"
#import "MSUTradeDetailView.h"
#import "MSUQuestionView.h"

#import "CoreArchive.h"
#import "MSUPathTools.h"

#import <UMAnalytics/MobClick.h>

@interface MSUTradeDetailController ()<UIScrollViewDelegate>

@property (nonatomic , strong) UIScrollView *scrollView;
@property (nonatomic , strong) MSUTradeTopView *topView;
@property (nonatomic , strong) MSUTradeBottomView *bottomView;
@property (nonatomic , strong) MSUTradeDetailView *nextView;
@property (nonatomic , assign) BOOL isScrollDown;

@property (nonatomic , copy) NSString *signStr;
@property (nonatomic , assign) NSInteger questionHeight;

/// 更多信息view
@property (nonatomic , strong) UIView *moreView;

/// 投资View
@property (nonatomic , strong) UIView *touZiView;
@property (nonatomic , strong) UIButton *touZiBtn;

@property (nonatomic , strong) NSDictionary *dataDic;
@property (nonatomic , strong) NSDictionary *resultDic;

@property (nonatomic , strong) UIImageView *adImaView;

@end

@implementation MSUTradeDetailController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBarTintColor:HEXCOLOR(0xff6735)];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0xffffff],NSFontAttributeName: [UIFont systemFontOfSize:18]}];
    
    [self createLeftNavigationItem:[UIImage imageNamed:@"nav_icon_back_white"]];
    
    [self requestData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [MobClick event:@"dingqibiao" durations:2];

    [self createUIView];
}

- (void)createUIView{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    _scrollView.backgroundColor  = HEXCOLOR(0xf3f3f3);
    _scrollView.contentSize = CGSizeMake(kDeviceWidth, kDeviceHeight+20*kDeviceHeightScale);
    _scrollView.scrollEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:_scrollView];

    self.topView = [[MSUTradeTopView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 189*kDeviceHeightScale)];
    _topView.backgroundColor = HEXCOLOR(0xffffff);
    [_scrollView addSubview:_topView];
    
    self.adImaView = [[UIImageView alloc] initWithFrame:CGRectMake(0, _topView.bottom+13*kDeviceHeightScale, kDeviceWidth, 71*kDeviceHeightScale)];
//    _adImaView.image = [MSUPathTools showImageWithContentOfFileByName:@""];
    _adImaView.backgroundColor = HEXCOLOR(0xfff5da);
    [_scrollView addSubview:_adImaView];
    
    self.bottomView = [[MSUTradeBottomView alloc] init];
    _bottomView.frame = CGRectMake(0, _adImaView.bottom+13*kDeviceHeightScale, kDeviceWidth, (50.5*4+35)*kDeviceHeightScale);
    _bottomView.backgroundColor = WhiteColor;
    [_scrollView addSubview:_bottomView];

    self.nextView = [[MSUTradeDetailView alloc] init];
    _nextView.frame = CGRectMake(0, _bottomView.bottom, kDeviceWidth, kDeviceHeight+400*kDeviceHeightScale);
    _nextView.backgroundColor = HEXCOLOR(0xf3f3f3);
    [_nextView.programView.safeBtn addTarget:self action:@selector(safeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_nextView.programView.danbaoBtn addTarget:self action:@selector(danbaoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_nextView.programView.protoBtn addTarget:self action:@selector(protoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_nextView.programView.xieyiBtn addTarget:self action:@selector(xieyiBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    
    [_scrollView addSubview:_nextView];
    _nextView.hidden = YES;
    
    /// 
   self.moreView = [[UIView alloc] init];
    _moreView.backgroundColor = HEXCOLOR(0xf2f8ff);
    [self.view addSubview:_moreView];

    UIButton *moreBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    moreBtn.frame = CGRectMake(0, 0, kDeviceWidth, 35*kDeviceHeightScale);
    [_moreView addSubview:moreBtn];
    [moreBtn addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *moreLab = [[UILabel alloc] init];
    moreLab.frame = CGRectMake(kDeviceWidth*0.5-55*kDeviceWidthScale, 8.5*kDeviceHeightScale, 110*kDeviceWidthScale, 20*kDeviceWidthScale);
    moreLab.text = @"更多项目信息";
    moreLab.font = [UIFont systemFontOfSize:14];
    moreLab.textColor = HEXCOLOR(0x757575);
    [_moreView addSubview:moreLab];

    UIImageView *imaView = [[UIImageView alloc] initWithFrame:CGRectMake(moreLab.left - 6-13*kDeviceWidthScale, 11.5*kDeviceHeightScale, 13*kDeviceWidthScale, 17*kDeviceHeightScale)];
    imaView.image = [MSUPathTools showImageWithContentOfFileByName:@"gdxm_icon"];
    imaView.contentMode =UIViewContentModeScaleAspectFit;;
    [_moreView addSubview:imaView];
    
    self.touZiView = [[UIView alloc] init];
    _touZiView.backgroundColor = WhiteColor;
    [self.view addSubview:_touZiView];
    
    self.touZiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _touZiBtn.frame = CGRectMake(14*kDeviceWidthScale, 12, kDeviceWidth-28*kDeviceHeightScale, 44*kDeviceHeightScale);
    _touZiBtn.backgroundColor = HEXCOLOR(0xfb6337);
    _touZiBtn.layer.cornerRadius = 4;
    _touZiBtn.clipsToBounds = YES;
    _touZiBtn.layer.shouldRasterize = YES;
    _touZiBtn.layer.rasterizationScale = [UIScreen mainScreen].scale;
    [_touZiBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
    _touZiBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [_touZiView addSubview:_touZiBtn];
    [_touZiBtn addTarget:self action:@selector(touZiBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if (is_iPhoneX) {
        _moreView.frame = CGRectMake(0, kDeviceHeight-108-(44+35)*kDeviceHeightScale, kDeviceWidth, 35*kDeviceHeightScale);
        _touZiView.frame = CGRectMake(0, kDeviceHeight-108-44*kDeviceHeightScale, kDeviceWidth,44*kDeviceHeightScale+ 24);
    } else{
        _moreView.frame = CGRectMake(0, kDeviceHeight-88-(44+35)*kDeviceHeightScale, kDeviceWidth, 35*kDeviceHeightScale);
        _touZiView.frame = CGRectMake(0, kDeviceHeight-88-44*kDeviceHeightScale, kDeviceWidth,44*kDeviceHeightScale+ 24);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)safeBtnClick:(UIButton *)sender{
    WebViewController *webVC = [[WebViewController alloc] init];
    webVC.UrlString =[ NSString stringWithFormat:@"%@wap/content/security.htm",Base_url];
    webVC.title = @"安全保障";
    webVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)danbaoBtnClick:(UIButton *)sender{
    
    NSString *danbaoStr = [NSString stringWithFormat:@"%@",self.resultDic[@"dealTwo"]];
    if (danbaoStr.length == 0) {
        [PAProgressView showInView:self.view  contentString:@"无保证担保函"];
    } else {
        WebViewController *webVC = [[WebViewController alloc] init];
        webVC.title = @"保证担保函";
        webVC.hidesBottomBarWhenPushed = YES;
        webVC.UrlString = danbaoStr;
        [self.navigationController pushViewController:webVC animated:YES];

    }
    
}

- (void)protoBtnClick:(UIButton *)sender{
    NSArray *arr = self.resultDic[@"dealThreeJpgs"];
    if (arr.count == 0) {
        [PAProgressView showInView:self.view  contentString:@"无担保函通用条款"];
    } else {
        
        MSUImageShowController *show = [[MSUImageShowController alloc] init];
        show.imaArr = arr;
        show.signInteger = 2;
        show.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:show animated:YES];
    }
}

- (void)xieyiBtnClick:(UIButton *)sender{
    NSString *xieStr = [NSString stringWithFormat:@"%@",self.resultDic[@"dealOne"]];
    if (xieStr.length == 0) {
        [PAProgressView showInView:self.view  contentString:@"无借款协议"];
    } else {
        WebViewController *webVC = [[WebViewController alloc] init];
        webVC.title = @"借款协议";
        webVC.hidesBottomBarWhenPushed = YES;
        webVC.UrlString = xieStr;
        [self.navigationController pushViewController:webVC animated:YES];
    }
}

#pragma mark - 代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    static CGFloat lastOffsetY = 0;

//    NSLog(@"---- %f  %f ,%d",lastOffsetY,scrollView.contentOffset.y,_isScrollDown);
    _isScrollDown = lastOffsetY < scrollView.contentOffset.y;
    lastOffsetY = scrollView.contentOffset.y;
    
    if (scrollView.contentOffset.y > 100 && scrollView.contentOffset.y < _nextView.top && _isScrollDown == 0) {
        [UIView animateWithDuration:0.25 animations:^{
            [scrollView setContentOffset:CGPointZero animated:NO];
            _nextView.hidden = YES;
        } completion:^(BOOL finished) {
            _moreView.hidden = NO;
            _touZiView.hidden = NO;
            _scrollView.contentSize = CGSizeMake(kDeviceWidth, kDeviceHeight+20*kDeviceHeightScale);
        }];
    }
}


-(void)scrollViewWillBeginDecelerating: (UIScrollView *)scrollView{
    MyLog(@"1");

    if (_isScrollDown && scrollView.contentOffset.y < _nextView.top ) {//
        [UIView animateWithDuration:0.25 animations:^{
            [scrollView setContentOffset:CGPointMake(0, _nextView.top) animated:NO];
            _moreView.hidden = YES;
            _touZiView.hidden = YES;
            _nextView.hidden = NO;
            _scrollView.contentSize = CGSizeMake(kDeviceWidth, kDeviceHeight*2+160*kDeviceHeightScale);

            __weak typeof(self) weakSelf = self;
            _nextView.indexBlock = ^(NSString *signStr, NSInteger isEmpty) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                strongSelf.signStr = [NSString stringWithFormat:@"%@",signStr];
                if ([signStr isEqualToString:@"投标记录"] ){
                    strongSelf.scrollView.contentSize = CGSizeMake(kDeviceWidth, kDeviceHeight*2-(47+64+47)*kDeviceHeightScale);
                } else{
                    strongSelf.scrollView.contentSize = CGSizeMake(kDeviceWidth, kDeviceHeight*2+160*kDeviceHeightScale);
                }
            };
            if (self.signStr && ![_signStr isEqualToString:@"项目详情"]) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                if ([_signStr isEqualToString:@"常见问题"]) {
                    strongSelf.scrollView.contentSize = CGSizeMake(kDeviceWidth, self.questionHeight);
                } else if([_signStr isEqualToString:@"投标记录"]){
                    strongSelf.scrollView.contentSize = CGSizeMake(kDeviceWidth, kDeviceHeight*2-(47+64)*kDeviceHeightScale);
                }
            }
            
        }];
    } else if(_isScrollDown == 0 && scrollView.contentOffset.y < _nextView.top && scrollView.contentOffset.y >10){
        [UIView animateWithDuration:0.25 animations:^{
            [scrollView setContentOffset:CGPointZero animated:NO];
            _nextView.hidden = YES;
        } completion:^(BOOL finished) {
            _moreView.hidden = NO;
            _touZiView.hidden = NO;
            _scrollView.contentSize = CGSizeMake(kDeviceWidth, kDeviceHeight+20*kDeviceHeightScale);
        }];
    } else if(_isScrollDown == 0){
        if ([self.signStr isEqualToString:@"常见问题"]) {
            self.signStr = [NSString stringWithFormat:@"%@",@"项目详情"];
        }
    }
}

#pragma mark - 初始化


#pragma mark - 点击事件
- (void)touZiBtnClick:(UIButton *)sender{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [userDefaults objectForKey:@"registerData"];
    if ([dic objectForKey:@"UserName"] && [dic objectForKey:@"PassWord"]) {
        BuyTradeViewController *BuyVC = [[BuyTradeViewController alloc] init];
        [self.navigationController pushViewController:BuyVC animated:YES];
    }else{
        [CoreArchive removeNSUserDefaults];
        LoginViewController *loginView = [[LoginViewController alloc] init];
        loginView.loginType = logintypeHome;
        loginView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:loginView animated:YES];
    }
}

- (void)moreBtnClick:(UIButton *)sender{
    [UIView animateWithDuration:0.25 animations:^{
        [self.scrollView setContentOffset:CGPointMake(0, self.nextView.top) animated:NO];
        _moreView.hidden = YES;
        _touZiView.hidden = YES;
        self.nextView.hidden = NO;
        self.scrollView.contentSize = CGSizeMake(kDeviceWidth, kDeviceHeight*2+200*kDeviceHeightScale);
    }];
}

#pragma mark - 请求数据
- (void)requestData{
//    MyLog(@"lunaP2pBorrowId%@",_postDic[@"lunaP2pBorrowId"]);
    NSMutableDictionary *dic= [[NSMutableDictionary alloc] init];
    [dic setObject:[NSString stringWithFormat:@"%@",_idStr] forKey:@"brid"];

    [self setUIWithDic:_dataDic withDic:dic];

}

- (void)setUIWithDic:(NSDictionary *)dic withDic:(NSDictionary *)totalDic{

    self.title = [NSString stringWithFormat:@"%@",@"详情"];
    NSString *text = @"立即投标";
    if ([[NSString stringWithFormat:@"%@",_dataDic[@"borrowState"]] isEqualToString:@"还款中"] || [[NSString stringWithFormat:@"%@",_dataDic[@"borrowState"]] isEqualToString:@"已还清"]) {
        _touZiBtn.backgroundColor = [UIColor colorWithRed:214/255.0 green:214/255.0 blue:214/255.0 alpha:1];
        text = [NSString stringWithFormat:@"%@",_dataDic[@"borrowState"]];
        _touZiBtn.enabled = NO;
    }
    [_touZiBtn setTitle:text forState:UIControlStateNormal];
    
    _topView.totalLab.text = [NSString stringWithFormat:@"%@万",@"2000000"];
    
    _topView.progressView.progress = 0.85;
    _topView.progressBtn.center = CGPointMake(45*kDeviceWidthScale+_topView.progressView.progress*(kDeviceWidth-90*kDeviceWidthScale),_topView.progressView.top - 17*kDeviceHeightScale);
    [_topView.progressBtn setTitle:[NSString stringWithFormat:@"%ld%%",85] forState:UIControlStateNormal];
    
    NSArray *arr = @[@"1",@"2",@"3",@"4"];//[dic objectForKey:@"jixiStyle"]
    _bottomView.dataArr = arr;
    
    _adImaView.hidden = YES;
    _bottomView.frame = CGRectMake(0, _topView.bottom+13*kDeviceHeightScale, kDeviceWidth, (50.5*4+35)*kDeviceHeightScale);
    _nextView.frame = CGRectMake(0, _bottomView.bottom, kDeviceWidth, kDeviceHeight+300*kDeviceHeightScale);
    
    NSString *isInvest = [NSString stringWithFormat:@"%@",@"1"];
    NSString *typeStr = [NSString stringWithFormat:@"%@",@"新手标"];
    if ([isInvest isEqualToString:@"1"] && [typeStr isEqualToString:@"新手标"]) {
        _touZiBtn.enabled = YES;
        _touZiBtn.backgroundColor = HEXCOLOR(0xfb6337);
    } else if([isInvest isEqualToString:@"2"] && [typeStr isEqualToString:@"新手标"]){
        [_touZiBtn setTitle:@"您已投过新手标" forState:UIControlStateNormal];
        _touZiBtn.enabled = NO;
        _touZiBtn.backgroundColor = [UIColor colorWithRed:214/255.0 green:214/255.0 blue:214/255.0 alpha:1];
    }
}


@end

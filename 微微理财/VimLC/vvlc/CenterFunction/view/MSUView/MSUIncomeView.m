//
//  MSUIncomeView.m
//  vvlc
//
//  Created by 007 on 2018/3/19.
//  Copyright © 2018年 HM. All rights reserved.
//

#import "MSUIncomeView.h"

@implementation MSUIncomeView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self createView];
        
    }
    return self;
}


- (void)createView{
    self.muArr = [NSMutableArray array];
    self.bottomArr = [NSMutableArray array];

    _proGress = [[MSUProgressView alloc] init];
    //    _proGress.center = CGPointMake(kDeviceWidth/2, 0);
    //    _proGress.bounds = CGRectMake(0, 0, 150, 150);
    _proGress.frame = CGRectMake(kDeviceWidth/2-75, 0, 150, 150);
    _proGress.arcBackColor = RGBA(255, 222, 203, 1);
    _proGress.regularColor = [UIColor colorWithHex:0x54bfe2];
    _proGress.MLBColor = [UIColor colorWithHex:0xffc65a];
    _proGress.width = 20;
    [self addSubview:_proGress];
    
    NSArray *titArr = @[@"定期收益:",@"微微宝收益:"];
    NSArray *colorArr = @[HEXCOLOR(0x54bfe2),HEXCOLOR(0xffc65a)];
    for (NSInteger i = 0; i < titArr.count; i++) {
        UIView *bgView = [[UIView alloc] init];
        bgView.frame = CGRectMake(22, _proGress.bottom + 39*kDeviceHeightScale + (12*kDeviceHeightScale+39*kDeviceHeightScale)*i, kDeviceWidth-44, 39*kDeviceHeightScale);
        bgView.clipsToBounds = YES;
        bgView.layer.cornerRadius = 6;
        bgView.layer.shouldRasterize = YES;
        bgView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        bgView.layer.borderWidth = 1;
        bgView.layer.borderColor = HEXCOLOR(0xa3b8cf).CGColor;
        [self addSubview:bgView];
        
        UIView *circleView = [[UIView alloc] init];
        circleView.frame = CGRectMake(22, 15.5*kDeviceHeightScale, 8*kDeviceHeightScale, 8*kDeviceHeightScale);
        circleView.clipsToBounds = YES;
        circleView.layer.cornerRadius = 4*kDeviceHeightScale;
        circleView.layer.shouldRasterize = YES;
        circleView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        circleView.backgroundColor = colorArr[i];
        [bgView addSubview:circleView];
        
        UILabel *leftTitLab = [[UILabel alloc] init];
        leftTitLab.frame = CGRectMake(circleView.right + 12, 10*kDeviceHeightScale, 100, 20*kDeviceHeightScale);
        leftTitLab.text = titArr[i];
        leftTitLab.font = [UIFont systemFontOfSize:14];
        leftTitLab.textColor = HEXCOLOR(0xbababa);
        [bgView addSubview:leftTitLab];
        
        UILabel *rightTitLab = [[UILabel alloc] init];
        rightTitLab.frame = CGRectMake(kDeviceWidth-44-22-kDeviceWidth*0.5, 10*kDeviceHeightScale, kDeviceWidth*0.5, 20*kDeviceHeightScale);
        rightTitLab.text = @"--";
        rightTitLab.font = [UIFont systemFontOfSize:16];
        rightTitLab.textAlignment = NSTextAlignmentRight;
        rightTitLab.textColor = HEXCOLOR(0x3f3f3f);
        [bgView addSubview:rightTitLab];
        [self.muArr addObject:rightTitLab];
    }
    
//    UIView *rewardView = [[UIView alloc] init];
//    rewardView.frame = CGRectMake(22, _proGress.bottom + 39*kDeviceHeightScale + (12*kDeviceHeightScale+39*kDeviceHeightScale)*2, kDeviceWidth-44, 140*kDeviceHeightScale);
//    rewardView.clipsToBounds = YES;
//    rewardView.layer.cornerRadius = 6;
//    rewardView.layer.shouldRasterize = YES;
//    rewardView.layer.rasterizationScale = [UIScreen mainScreen].scale;
//    rewardView.layer.borderWidth = 1;
//    rewardView.layer.borderColor = HEXCOLOR(0xa3b8cf).CGColor;
//    [self addSubview:rewardView];
//
//    UIView *circleRewardView = [[UIView alloc] init];
//    circleRewardView.frame = CGRectMake(22, 15.5*kDeviceHeightScale, 8*kDeviceHeightScale, 8*kDeviceHeightScale);
//    circleRewardView.clipsToBounds = YES;
//    circleRewardView.layer.cornerRadius = 4*kDeviceHeightScale;
//    circleRewardView.layer.shouldRasterize = YES;
//    circleRewardView.layer.rasterizationScale = [UIScreen mainScreen].scale;
//    circleRewardView.backgroundColor = HEXCOLOR(0xfe6974);
//    [rewardView addSubview:circleRewardView];
//
//    UILabel *leftRewardTitLab = [[UILabel alloc] init];
//    leftRewardTitLab.frame = CGRectMake(circleRewardView.right + 12, 10*kDeviceHeightScale, 100, 20*kDeviceHeightScale);
//    leftRewardTitLab.text = @"奖励收益:";
//    leftRewardTitLab.font = [UIFont systemFontOfSize:14];
//    leftRewardTitLab.textColor = HEXCOLOR(0xbababa);
//    [rewardView addSubview:leftRewardTitLab];
//
//    UILabel *rightRewardTitLab = [[UILabel alloc] init];
//    rightRewardTitLab.frame = CGRectMake(kDeviceWidth-44-22-100, 10*kDeviceHeightScale, 100, 20*kDeviceHeightScale);
//    rightRewardTitLab.font = [UIFont systemFontOfSize:16];
//    rightRewardTitLab.textAlignment = NSTextAlignmentRight;
//    rightRewardTitLab.textColor = HEXCOLOR(0x3f3f3f);
//    [self addSubview:rightRewardTitLab];
//    [self.muArr addObject:rightRewardTitLab];
//
//    UIView *lineView = [[UIView alloc] init];
//    lineView.frame = CGRectMake(10, 38*kDeviceHeightScale, kDeviceWidth-44-20, 1);
//    lineView.backgroundColor = LineColor;
//    [rewardView addSubview:lineView];
//
//    NSArray *styleArr =@[@"加息",@"返现",@"佣金",@"其他"];
//    for (NSInteger i = 0; i < styleArr.count; i++) {
//        UILabel *styleTopLab = [[UILabel alloc] init];
//        styleTopLab.text = @"--";
//        styleTopLab.frame = CGRectMake((kDeviceWidth-44)/4*i, 70.5*kDeviceHeightScale, (kDeviceWidth-44)/4, 20*kDeviceHeightScale);
//        styleTopLab.font = [UIFont systemFontOfSize:14];
//        styleTopLab.textColor = HEXCOLOR(0x3f3f3f);
//        styleTopLab.textAlignment = NSTextAlignmentCenter;
//        [rewardView addSubview:styleTopLab];
//        [self.bottomArr addObject:styleTopLab];
//
//        UILabel *styleBottomLab = [[UILabel alloc] init];
//        styleBottomLab.frame = CGRectMake((kDeviceWidth-44)/4*i,styleTopLab.bottom + 7*kDeviceHeightScale, (kDeviceWidth-44)/4, 20*kDeviceHeightScale);
//        styleBottomLab.text = styleArr[i];
//        styleBottomLab.font = [UIFont systemFontOfSize:14];
//        styleBottomLab.textAlignment = NSTextAlignmentCenter;
//        styleBottomLab.textColor = HEXCOLOR(0xbababa);
//        [rewardView addSubview:styleBottomLab];
//    }
    
}


@end

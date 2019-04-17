//
//  MSUTotalView.m
//  vvlc
//
//  Created by 007 on 2018/3/19.
//  Copyright © 2018年 HM. All rights reserved.
//

#import "MSUTotalView.h"

@implementation MSUTotalView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self createView];
        
    }
    return self;
}


- (void)createView{
    self.muArr = [NSMutableArray array];
    
    _proGress = [[ProgressViews alloc] init];
//    _proGress.center = CGPointMake(kDeviceWidth/2, 0);
//    _proGress.bounds = CGRectMake(0, 0, 150, 150);
    _proGress.frame = CGRectMake(kDeviceWidth/2-75, 0, 150, 150);
    _proGress.arcBackColor = RGBA(255, 222, 203, 1);
    _proGress.receiptColor = [UIColor colorWithHex:0xFB6337];
    _proGress.frozenColor = [UIColor colorWithHex:0x99a0ac];
    _proGress.availableColor = [UIColor colorWithHex:0x61e1b0];
    _proGress.MLBColor = [UIColor colorWithHex:0x72aefd];
    _proGress.MarchColor = HEXCOLOR(0xFA7960);
//    _proGress.sevenColor = HEXCOLOR(0xFED473);
//    _proGress.januaryColor = HEXCOLOR(0xF79D4A);
//    _proGress.regIncomeColor = HEXCOLOR(0xfe6974);
    _proGress.width = 20;
    [self addSubview:_proGress];
    
    self.detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _detailBtn.frame = CGRectMake(kDeviceWidth*0.5+30, 55, 20, 20);
    [self addSubview:_detailBtn];
    
//    UIView *rewardView = [[UIView alloc] init];
//    rewardView.frame = CGRectMake(22, _proGress.bottom + 35*kDeviceHeightScale, kDeviceWidth-44, 129*kDeviceHeightScale);
//    rewardView.clipsToBounds = YES;
//    rewardView.layer.cornerRadius = 6;
//    rewardView.layer.shouldRasterize = YES;
//    rewardView.layer.rasterizationScale = [UIScreen mainScreen].scale;
//    rewardView.layer.borderWidth = 1;
//    rewardView.layer.borderColor = HEXCOLOR(0xa3b8cf).CGColor;
//    [self addSubview:rewardView];
//
//    UIView *circleRewardView = [[UIView alloc] init];
//    circleRewardView.frame = CGRectMake(22, 19*kDeviceHeightScale, 8*kDeviceHeightScale, 8*kDeviceHeightScale);
//    circleRewardView.backgroundColor = HEXCOLOR(0xfe6974);
//    [rewardView addSubview:circleRewardView];
//
//    UILabel *leftRewardTitLab = [[UILabel alloc] init];
//    leftRewardTitLab.frame = CGRectMake(circleRewardView.right + 12, 12*kDeviceHeightScale, 100, 20*kDeviceHeightScale);
//    leftRewardTitLab.text = @"定期资产:";
//    leftRewardTitLab.font = [UIFont systemFontOfSize:14];
//    leftRewardTitLab.textColor = HEXCOLOR(0xbababa);
//    [rewardView addSubview:leftRewardTitLab];
//
//    UILabel *rightRewardTitLab = [[UILabel alloc] init];
//    rightRewardTitLab.frame = CGRectMake(kDeviceWidth-44-22-100, 12*kDeviceHeightScale, 100, 20*kDeviceHeightScale);
//    rightRewardTitLab.font = [UIFont systemFontOfSize:16];
//    rightRewardTitLab.textAlignment = NSTextAlignmentRight;
//    rightRewardTitLab.text = @"--";
//    rightRewardTitLab.textColor = HEXCOLOR(0x3f3f3f);
//    [rewardView addSubview:rightRewardTitLab];
//    [self.muArr addObject:rightRewardTitLab];
//
//    UIView *lineView = [[UIView alloc] init];
//    lineView.frame = CGRectMake(10, 46*kDeviceHeightScale, kDeviceWidth-44-20, 1);
//    lineView.backgroundColor = LineColor;
//    [rewardView addSubview:lineView];
//
//    NSArray *styleArr =@[@"七天标",@"一月标",@"三月标"];
//    NSArray *styleColorArr =@[HEXCOLOR(0xFED473),HEXCOLOR(0xF79D4A),HEXCOLOR(0xFA7960)];
//    for (NSInteger i = 0; i < styleArr.count; i++) {
//        UILabel *styleTopLab = [[UILabel alloc] init];
//        styleTopLab.text = @"--";
//        styleTopLab.frame = CGRectMake((kDeviceWidth-44)/styleArr.count*i, 66*kDeviceHeightScale, (kDeviceWidth-44)/styleArr.count, 20*kDeviceHeightScale);
//        styleTopLab.font = [UIFont systemFontOfSize:14];
//        styleTopLab.textColor = HEXCOLOR(0x3f3f3f);
//        styleTopLab.textAlignment = NSTextAlignmentCenter;
//        [rewardView addSubview:styleTopLab];
//        [self.muArr addObject:styleTopLab];
//
//        UIView *bgView = [[UIView alloc] init];
//        bgView.frame = CGRectMake((kDeviceWidth-44)/styleArr.count*i, styleTopLab.bottom + 7*kDeviceHeightScale, (kDeviceWidth-44)/styleArr.count, 20*kDeviceHeightScale);
//        [rewardView addSubview:bgView];
//
//        UIView *circleRewardView1 = [[UIView alloc] init];
//        circleRewardView1.frame = CGRectMake(22, 6.5*kDeviceHeightScale, 7*kDeviceHeightScale, 7*kDeviceHeightScale);
//        circleRewardView1.clipsToBounds = YES;
//        circleRewardView1.layer.cornerRadius = 3.5*kDeviceHeightScale;
//        circleRewardView1.layer.shouldRasterize = YES;
//        circleRewardView1.layer.rasterizationScale = [UIScreen mainScreen].scale;
//        circleRewardView1.backgroundColor = styleColorArr[i];
//        [bgView addSubview:circleRewardView1];
//
//        UILabel *styleBottomLab = [[UILabel alloc] init];
//        styleBottomLab.frame = CGRectMake(circleRewardView1.right+10,0, 45, 20*kDeviceHeightScale);
//        styleBottomLab.text = styleArr[i];
//        styleBottomLab.font = [UIFont systemFontOfSize:14];
//        styleBottomLab.textAlignment = NSTextAlignmentCenter;
//        styleBottomLab.textColor = HEXCOLOR(0xbababa);
//        [bgView addSubview:styleBottomLab];
//    }
    
    NSArray *titArr = @[@"定期资产",@"微微宝",@"账户余额",@"冻结金额"];
    NSArray *colorArr = @[HEXCOLOR(0xff6339),HEXCOLOR(0x72aefd),HEXCOLOR(0x61e1b0),HEXCOLOR(0x99a0ac)];
    for (NSInteger i = 0; i < titArr.count; i++) {
        UIView *bgView = [[UIView alloc] init];
        bgView.frame = CGRectMake(22, _proGress.bottom + 35*kDeviceHeightScale + (12*kDeviceHeightScale+39*kDeviceHeightScale)*i, kDeviceWidth-44, 39*kDeviceHeightScale);
        bgView.clipsToBounds = YES;
        bgView.layer.cornerRadius = 6;
        bgView.layer.shouldRasterize = YES;
        bgView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        bgView.layer.borderWidth = 1;
        bgView.layer.borderColor = HEXCOLOR(0xa3b8cf).CGColor;
        [self addSubview:bgView];
        
        UIView *circleView = [[UIView alloc] init];
        circleView.frame = CGRectMake(22, 15.5*kDeviceHeightScale, 8*kDeviceHeightScale, 8*kDeviceHeightScale);
        circleView.backgroundColor = colorArr[i];
        [bgView addSubview:circleView];
        
        UILabel *leftTitLab = [[UILabel alloc] init];
        leftTitLab.frame = CGRectMake(circleView.right + 12, 10*kDeviceHeightScale, 100, 20*kDeviceHeightScale);
        leftTitLab.text = [NSString stringWithFormat:@"%@:",titArr[i]];
        leftTitLab.font = [UIFont systemFontOfSize:14];
        leftTitLab.textColor = HEXCOLOR(0xbababa);
        [bgView addSubview:leftTitLab];
        
        UILabel *rightTitLab = [[UILabel alloc] init];
        rightTitLab.frame = CGRectMake(kDeviceWidth-44-22-kDeviceWidth*0.5, 10*kDeviceHeightScale, kDeviceWidth*0.5, 20*kDeviceHeightScale);
        rightTitLab.font = [UIFont systemFontOfSize:16];
        rightTitLab.textAlignment = NSTextAlignmentRight;
        rightTitLab.text = @"--";
        rightTitLab.textColor = HEXCOLOR(0x3f3f3f);
        [bgView addSubview:rightTitLab];
        [self.muArr addObject:rightTitLab];
        
    }
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

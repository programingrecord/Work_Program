//
//  MSUCurrentView.m
//  vvlc
//
//  Created by 007 on 2018/1/15.
//  Copyright © 2018年 HM. All rights reserved.
//

#import "MSUCurrentView.h"

@implementation MSUCurrentView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self createView];
        
    }
    return self;
}


- (void)createView{
    self.priceLab = [[UILabel alloc] init];
    _priceLab.frame = CGRectMake(0, 20*kDeviceHeightScale, kDeviceWidth, 50*kDeviceHeightScale);
    self.priceLab.font = [UIFont fontWithName:@"DINAlternate-Bold" size:36];
    _priceLab.text = @"4.3%";
    _priceLab.textColor = WhiteColor;
    _priceLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_priceLab];
    
    UILabel *attentionLab = [[UILabel alloc] init];
    attentionLab.frame = CGRectMake(0, _priceLab.bottom+4.25*kDeviceHeightScale, kDeviceWidth, 20*kDeviceHeightScale);
    attentionLab.text = @"预期年化收益率";
    attentionLab.font = [UIFont systemFontOfSize:14];
    attentionLab.textAlignment = NSTextAlignmentCenter;
    attentionLab.textColor = [UIColor colorWithWhite:1 alpha:0.57];
    [self addSubview:attentionLab];
    
    self.totalLab = [[UILabel alloc] init];
    _totalLab.frame = CGRectMake(0,attentionLab.bottom+ 48*kDeviceHeightScale, kDeviceWidth*0.5, 22.5*kDeviceHeightScale);
    self.totalLab.font = [UIFont fontWithName:@"DINAlternate-Bold" size:16];
    _totalLab.textColor = WhiteColor;
    _totalLab.text = @"20023.98";
    _totalLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_totalLab];
    
    UILabel *base1Lab = [[UILabel alloc] init];
    base1Lab.frame = CGRectMake(_totalLab.left, _totalLab.bottom+1.5*kDeviceHeightScale, kDeviceWidth*0.5, 20*kDeviceHeightScale);
    base1Lab.text = @"总金额(元)";
    base1Lab.font = [UIFont systemFontOfSize:14];
    base1Lab.textAlignment = NSTextAlignmentCenter;
    base1Lab.textColor = WhiteColor;
    [self addSubview:base1Lab];
    
    self.moneyLab = [[UILabel alloc] init];
    _moneyLab.frame = CGRectMake(_totalLab.right,_totalLab.top, kDeviceWidth*0.5, 22.5*kDeviceHeightScale);
    self.moneyLab.font = [UIFont fontWithName:@"DINAlternate-Bold" size:16];
    _moneyLab.textColor = WhiteColor;
    _moneyLab.text = @"128.98";
    _moneyLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_moneyLab];
    
    UILabel *base2Lab = [[UILabel alloc] init];
    base2Lab.frame = CGRectMake(_moneyLab.left, _moneyLab.bottom+1.5*kDeviceHeightScale,  kDeviceWidth*0.5, 20*kDeviceHeightScale);
    base2Lab.text = @"累计收益(元)";
    base2Lab.font = [UIFont systemFontOfSize:14];
    base2Lab.textAlignment = NSTextAlignmentCenter;
    base2Lab.textColor = WhiteColor;
    [self addSubview:base2Lab];
}

@end

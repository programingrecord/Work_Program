//
//  MSUPocketTopView.m
//  vvlc
//
//  Created by 007 on 2018/1/12.
//  Copyright © 2018年 HM. All rights reserved.
//

#import "MSUPocketTopView.h"

#import "MSUPathTools.h"
#import "ZJLabel.h"

@implementation MSUPocketTopView

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
    
    ZJLabel * label = [[ZJLabel alloc]initWithFrame:CGRectMake(0,attentionLab.bottom, kDeviceWidth, 110*kDeviceHeightScale)];
    label.backgroundColor = HEXCOLOR(0xff6735);
    label.present = 0.5;
    [self addSubview:label];
    
    self.baseLab = [[UILabel alloc] init];
    _baseLab.frame = CGRectMake(0,attentionLab.bottom+ 53.5*kDeviceHeightScale, kDeviceWidth/3, 22.5*kDeviceHeightScale);
    self.baseLab.font = [UIFont fontWithName:@"DINAlternate-Bold" size:16];
    _baseLab.textColor = WhiteColor;
    _baseLab.text = @"4.3%";
    _baseLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_baseLab];
    
    UILabel *base1Lab = [[UILabel alloc] init];
    base1Lab.frame = CGRectMake(_baseLab.left, _baseLab.bottom+1.5*kDeviceHeightScale, kDeviceWidth/3, 20*kDeviceHeightScale);
    base1Lab.text = @"基础利率";
    base1Lab.font = [UIFont systemFontOfSize:14];
    base1Lab.textAlignment = NSTextAlignmentCenter;
    base1Lab.textColor = WhiteColor;
    [self addSubview:base1Lab];
    
    self.addLab = [[UILabel alloc] init];
    _addLab.frame = CGRectMake(base1Lab.right ,_baseLab.top, kDeviceWidth/3, 22.5*kDeviceHeightScale);
    self.addLab.font = [UIFont fontWithName:@"DINAlternate-Bold" size:16];
    _addLab.textColor = WhiteColor;
    _addLab.text = @"1.2%";
    _addLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_addLab];
    
    UILabel *base2Lab = [[UILabel alloc] init];
    base2Lab.frame = CGRectMake(_addLab.left, _baseLab.bottom+1.5*kDeviceHeightScale, kDeviceWidth/3, 20*kDeviceHeightScale);
    base2Lab.text = @"加息利率";
    base2Lab.font = [UIFont systemFontOfSize:14];
    base2Lab.textAlignment = NSTextAlignmentCenter;
    base2Lab.textColor = WhiteColor;
    [self addSubview:base2Lab];
    
    self.startLab = [[UILabel alloc] init];
    _startLab.frame = CGRectMake(base2Lab.right,_baseLab.top, kDeviceWidth/3, 22.5*kDeviceHeightScale);
    self.startLab.font = [UIFont fontWithName:@"DINAlternate-Bold" size:16];
    _startLab.textColor = WhiteColor;
    _startLab.text = @"50";
    _startLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_startLab];
    
    UILabel *base3Lab = [[UILabel alloc] init];
    base3Lab.frame = CGRectMake(_startLab.left, _baseLab.bottom+1.5*kDeviceHeightScale, kDeviceWidth/3, 20*kDeviceHeightScale);
    base3Lab.text = @"起投金额";
    base3Lab.font = [UIFont systemFontOfSize:14];
    base3Lab.textAlignment = NSTextAlignmentCenter;
    base3Lab.textColor = WhiteColor;
    [self addSubview:base3Lab];
}


@end

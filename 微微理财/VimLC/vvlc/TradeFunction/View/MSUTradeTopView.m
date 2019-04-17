//
//  MSUTradeTopView.m
//  vvlc
//
//  Created by 007 on 2018/1/15.
//  Copyright © 2018年 HM. All rights reserved.
//

#import "MSUTradeTopView.h"

#import "MSUPathTools.h"
#import "ZJLabel.h"

@implementation MSUTradeTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self createView];
        
    }
    return self;
}


- (void)createView{
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(0, 0, kDeviceWidth, 188*kDeviceHeightScale);
    bgView.backgroundColor = HEXCOLOR(0xff6735);
    [self addSubview:bgView];
    
    self.priceLab = [[UILabel alloc] init];
    _priceLab.frame = CGRectMake(0, 10*kDeviceHeightScale, kDeviceWidth, 50*kDeviceHeightScale);
    self.priceLab.font = [UIFont fontWithName:@"DINAlternate-Bold" size:36];
    _priceLab.text = @"4.3%";
    _priceLab.textColor = WhiteColor;
    _priceLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_priceLab];
    
    UILabel *attentionLab = [[UILabel alloc] init];
    attentionLab.frame = CGRectMake(0, _priceLab.bottom, kDeviceWidth, 16.5*kDeviceHeightScale);
    attentionLab.text = @"预期年化收益率";
    attentionLab.font = [UIFont systemFontOfSize:12];
    attentionLab.textAlignment = NSTextAlignmentCenter;
    attentionLab.textColor = [UIColor colorWithWhite:1 alpha:1];
    [self addSubview:attentionLab];
    
    ZJLabel * label = [[ZJLabel alloc]initWithFrame:CGRectMake(0,attentionLab.bottom+20*kDeviceHeightScale, kDeviceWidth, 100*kDeviceHeightScale)];
    label.backgroundColor = HEXCOLOR(0xff6735);
    label.present = 0.5;
    [self addSubview:label];
    
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    _progressView.frame = CGRectMake(45*kDeviceWidthScale, attentionLab.bottom + 28*kDeviceHeightScale, kDeviceWidth-90*kDeviceWidthScale, 1.5);
    [self addSubview:_progressView];
    _progressView.trackTintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
    _progressView.progressTintColor = HEXCOLOR(0xffffff);
    //设置进度
    //    _processView.progress = 0.2;
    
    self.progressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _progressBtn.frame = CGRectMake(45*kDeviceHeightScale,_progressView.top - 17*kDeviceHeightScale, 25, 16*kDeviceHeightScale);
    [_progressBtn setBackgroundImage:[MSUPathTools showImageWithContentOfFileByName:@"progressSign"] forState:UIControlStateNormal];
    _progressBtn.layer.rasterizationScale = [UIScreen mainScreen].scale;
    [_progressBtn setTitleColor:HEXCOLOR(0xff6745) forState:UIControlStateNormal];
    _progressBtn.titleLabel.font = [UIFont systemFontOfSize:9];
    [_progressBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0,3, 0)];
    [self addSubview:_progressBtn];
    
    UILabel *base1Lab = [[UILabel alloc] init];
    base1Lab.frame = CGRectMake(0, attentionLab.bottom+51.5*kDeviceHeightScale, kDeviceWidth/3, 16.5*kDeviceHeightScale);
    base1Lab.text = @"募集期限";
    base1Lab.font = [UIFont systemFontOfSize:12];
    base1Lab.textAlignment = NSTextAlignmentCenter;
    base1Lab.textColor = WhiteColor;
    [self addSubview:base1Lab];
    
    self.limitLab = [[UILabel alloc] init];
    _limitLab.frame = CGRectMake(base1Lab.left,base1Lab.bottom+ 5*kDeviceHeightScale, kDeviceWidth/3, 25*kDeviceHeightScale);
    self.limitLab.font = [UIFont fontWithName:@"DINAlternate-Bold" size:18];
    _limitLab.textColor = WhiteColor;
    _limitLab.text = @"7天";
    _limitLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_limitLab];
    
    UILabel *base2Lab = [[UILabel alloc] init];
    base2Lab.frame = CGRectMake(base1Lab.right, base1Lab.top, kDeviceWidth/3, 16.5*kDeviceHeightScale);
    base2Lab.text = @"剩余金额(元)";
    base2Lab.font = [UIFont systemFontOfSize:12];
    base2Lab.textAlignment = NSTextAlignmentCenter;
    base2Lab.textColor = WhiteColor;
    [self addSubview:base2Lab];
    
    self.surplusLab = [[UILabel alloc] init];
    _surplusLab.frame = CGRectMake(base2Lab.left ,base2Lab.bottom+ 5*kDeviceHeightScale,kDeviceWidth/3, 25*kDeviceHeightScale);
    self.surplusLab.font = [UIFont fontWithName:@"DINAlternate-Bold" size:18];
    _surplusLab.textColor = WhiteColor;
    _surplusLab.text = @"200000";
    _surplusLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_surplusLab];
    
    UILabel *base3Lab = [[UILabel alloc] init];
    base3Lab.frame = CGRectMake(base2Lab.right, base1Lab.top, kDeviceWidth/3, 16.5*kDeviceHeightScale);
    base3Lab.text = @"募集金额(元)";
    base3Lab.font = [UIFont systemFontOfSize:12];
    base3Lab.textAlignment = NSTextAlignmentCenter;
    base3Lab.textColor = WhiteColor;
    [self addSubview:base3Lab];
    
    self.totalLab = [[UILabel alloc] init];
    _totalLab.frame = CGRectMake(base3Lab.left,base3Lab.bottom+ 5*kDeviceHeightScale, kDeviceWidth/3, 25*kDeviceHeightScale);
    self.totalLab.font = [UIFont fontWithName:@"DINAlternate-Bold" size:18];
    _totalLab.textColor = WhiteColor;
    _totalLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_totalLab];
}


@end

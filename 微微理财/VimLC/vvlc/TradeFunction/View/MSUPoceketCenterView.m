//
//  MSUPoceketCenterView.m
//  vvlc
//
//  Created by 007 on 2018/1/12.
//  Copyright © 2018年 HM. All rights reserved.
//

#import "MSUPoceketCenterView.h"

#import "MSUPathTools.h"

@implementation MSUPoceketCenterView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self createView];
        
    }
    return self;
}


- (void)createView{
    NSInteger rowH = 60;
    NSArray *imaArr = @[@"qgje_icon",@"syg",@"fxd",@"zjtx_icon",@"sygz_icon"];
    for (NSInteger i = 0; i < imaArr.count; i++) {
        UIImageView *imaView = [[UIImageView alloc] initWithFrame:CGRectMake(14*kDeviceWidthScale, 16*kDeviceHeightScale+rowH*kDeviceHeightScale*i, 38*kDeviceWidthScale, 38*kDeviceWidthScale)];
        imaView.image = [MSUPathTools showImageWithContentOfFileByName:imaArr[i]];
        [self addSubview:imaView];
    }
    
    UILabel *topLab = [[UILabel alloc] init];
    topLab.frame = CGRectMake(62*kDeviceWidthScale,17*kDeviceHeightScale, 70*kDeviceWidthScale, 20*kDeviceHeightScale);
    topLab.text = @"门槛低";
    topLab.font = [UIFont systemFontOfSize:14];
    topLab.textColor = titBlackColor;
    [self addSubview:topLab];
    
    self.startLab = [[UILabel alloc] init];
    _startLab.frame = CGRectMake(topLab.left, topLab.bottom+1*kDeviceHeightScale, kDeviceWidth*0.5, 18.5*kDeviceHeightScale);
    _startLab.font = TEXTFONT(13);
    _startLab.textColor = titLightColor;
    [self addSubview:_startLab];
    
    UILabel *centerLab = [[UILabel alloc] init];
    centerLab.frame = CGRectMake(62*kDeviceWidthScale,16*kDeviceHeightScale+rowH*kDeviceHeightScale, 70*kDeviceWidthScale, 20*kDeviceHeightScale);
    centerLab.text = @"收益高";
    centerLab.font = [UIFont systemFontOfSize:14];
    centerLab.textColor = titBlackColor;
    [self addSubview:centerLab];
    
    self.ruleLab = [[UILabel alloc] init];
    _ruleLab.frame = CGRectMake(topLab.left, centerLab.bottom+1*kDeviceHeightScale, kDeviceWidth-78*kDeviceWidthScale, 18.5*kDeviceHeightScale);
    _ruleLab.font = TEXTFONT(13);
    _ruleLab.numberOfLines = 0;
    _ruleLab.textColor = titLightColor;
    [self addSubview:_ruleLab];
    
    UILabel *bottomLab = [[UILabel alloc] init];
    bottomLab.frame = CGRectMake(62*kDeviceWidthScale,16*kDeviceHeightScale+rowH*2*kDeviceHeightScale, 70*kDeviceWidthScale, 20*kDeviceHeightScale);
    bottomLab.text = @"风险低";
    bottomLab.font = [UIFont systemFontOfSize:14];
    bottomLab.textColor = titBlackColor;
    [self addSubview:bottomLab];
    
    self.fengLab = [[UILabel alloc] init];
    _fengLab.frame = CGRectMake(topLab.left, bottomLab.bottom+1*kDeviceHeightScale, kDeviceWidth-78*kDeviceWidthScale, 18.5*kDeviceHeightScale);
    _fengLab.numberOfLines = 0;
    _fengLab.font = TEXTFONT(13);
    _fengLab.textColor = titLightColor;
    [self addSubview:_fengLab];
    
    UILabel *dangLab = [[UILabel alloc] init];
    dangLab.frame = CGRectMake(62*kDeviceWidthScale,16*kDeviceHeightScale+rowH*3*kDeviceHeightScale, 70*kDeviceWidthScale, 20*kDeviceHeightScale);
    dangLab.text = @"当日计息";
    dangLab.font = [UIFont systemFontOfSize:14];
    dangLab.textColor = titBlackColor;
    [self addSubview:dangLab];
    
    self.jixiLab = [[UILabel alloc] init];
    _jixiLab.frame = CGRectMake(topLab.left, dangLab.bottom+1*kDeviceHeightScale, kDeviceWidth-78*kDeviceWidthScale, 18.5*kDeviceHeightScale);
    _jixiLab.numberOfLines = 0;
    _jixiLab.font = TEXTFONT(13);
    _jixiLab.textColor = titLightColor;
    [self addSubview:_jixiLab];
    
    UILabel *suiLab = [[UILabel alloc] init];
    suiLab.frame = CGRectMake(62*kDeviceWidthScale,16*kDeviceHeightScale+rowH*4*kDeviceHeightScale, 70*kDeviceWidthScale, 20*kDeviceHeightScale);
    suiLab.text = @"随存随取";
    suiLab.font = [UIFont systemFontOfSize:14];
    suiLab.textColor = titBlackColor;
    [self addSubview:suiLab];
    
    self.cunLab = [[UILabel alloc] init];
    _cunLab.frame = CGRectMake(topLab.left, suiLab.bottom+1*kDeviceHeightScale, kDeviceWidth-78*kDeviceWidthScale, 18.5*kDeviceHeightScale);
    _cunLab.numberOfLines = 0;
    _cunLab.font = TEXTFONT(13);
    _cunLab.textColor = titLightColor;
    [self addSubview:_cunLab];
    
//    self.getLab = [[UILabel alloc] init];
//    _getLab.frame = CGRectMake(topLab.left, centerLab.bottom+1*kDeviceHeightScale, kDeviceWidth-78*kDeviceWidthScale, 18.5*kDeviceHeightScale);
//    _getLab.numberOfLines = 0;
//    _getLab.font = TEXTFONT(13);
//    _getLab.textColor = titLightColor;
//    [self addSubview:_getLab];
}


@end

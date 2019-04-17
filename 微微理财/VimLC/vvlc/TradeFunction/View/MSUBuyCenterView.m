//
//  MSUBuyCenterView.m
//  vvlc
//
//  Created by 007 on 2018/1/12.
//  Copyright © 2018年 HM. All rights reserved.
//

#import "MSUBuyCenterView.h"

#import "MSUPathTools.h"

@implementation MSUBuyCenterView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}

- (void)createView{
    UILabel *mineLab = [[UILabel alloc] init];
    mineLab.frame = CGRectMake(17*kDeviceWidthScale, 15.5*kDeviceHeightScale, 64*kDeviceWidth, 22.5*kDeviceHeightScale);
    mineLab.font = TEXTFONT(16);
    mineLab.textColor = titBlackColor;
    mineLab.text = @"我的券包";
    [self addSubview:mineLab];

    UIImageView *imaView = [[UIImageView alloc] initWithFrame:CGRectMake(kDeviceWidth-15.9*kDeviceWidthScale-14.15*kDeviceWidthScale, 19.95*kDeviceHeightScale, 14.15*kDeviceWidthScale, 14.15*kDeviceWidthScale)];
    imaView.contentMode = UIViewContentModeScaleAspectFit;
    imaView.image = [MSUPathTools showImageWithContentOfFileByName:@"enter_icon"];
    [self addSubview:imaView];

    self.topLab = [[UILabel alloc] init];
    _topLab.frame = CGRectMake(kDeviceWidth-33.95*kDeviceWidthScale-kDeviceWidth*0.5, 17.5*kDeviceHeightScale, kDeviceWidth*0.5, 20*kDeviceHeightScale);
    _topLab.font = TEXTFONT(14);
    _topLab.textColor = titQianColor;
    _topLab.textAlignment = NSTextAlignmentRight;
    [self addSubview:_topLab];

    self.topBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _topBtn.backgroundColor = [UIColor clearColor];
    _topBtn.frame = CGRectMake(0, 0, kDeviceWidth, 46);
    [self addSubview:_topBtn];
 
    UILabel *yuLab = [[UILabel alloc] init];
    yuLab.frame = CGRectMake(17*kDeviceWidthScale, mineLab.bottom+27.5*kDeviceHeightScale, 64*kDeviceWidth, 22.5*kDeviceHeightScale);
//    yuLab.frame = CGRectMake(17*kDeviceWidthScale, 15.5*kDeviceHeightScale, 64*kDeviceWidth, 22.5*kDeviceHeightScale);
    yuLab.font = TEXTFONT(16);
    yuLab.text = @"预计总收益";
    yuLab.textColor = titBlackColor;
    [self addSubview:yuLab];
    
    self.centerLab = [[UILabel alloc] init];
    _centerLab.frame = CGRectMake(kDeviceWidth-34*kDeviceWidthScale-kDeviceWidth*0.5, yuLab.top, kDeviceWidth*0.5, 22.5);
    self.centerLab.font = TEXTFONT(14);
    _centerLab.text = @"0元";
    _centerLab.textColor = titOrangeColor;
    _centerLab.textAlignment = NSTextAlignmentRight;
    [self addSubview:_centerLab];
    
    UILabel *payLab = [[UILabel alloc] init];
    payLab.frame = CGRectMake(17*kDeviceWidthScale, yuLab.bottom + 27.5*kDeviceHeightScale, 64*kDeviceWidth, 22.5*kDeviceHeightScale);
    payLab.font = TEXTFONT(16);
    payLab.text = @"还需支付";
    payLab.textColor = titBlackColor;
    [self addSubview:payLab];
    
    self.bottomLab = [[UILabel alloc] init];
    _bottomLab.frame = CGRectMake(kDeviceWidth-34*kDeviceWidthScale-kDeviceWidth*0.5, payLab.top, kDeviceWidth*0.5, 22.5);
    self.bottomLab.font = TEXTFONT(14);
    _bottomLab.textColor = titOrangeColor;
    _bottomLab.text = @"0元";
    _bottomLab.textAlignment = NSTextAlignmentRight;
    [self addSubview:_bottomLab];
    
    for (NSInteger i = 0; i < 2; i++) {
        UIView *lineView = [[UIView alloc] init];
        if (is_iPhoneX) {
            lineView.frame = CGRectMake(17*kDeviceWidthScale, 60*kDeviceWidthScale+61*kDeviceWidthScale*i, kDeviceWidth-17*kDeviceWidthScale, 1);
        } else{
            lineView.frame = CGRectMake(17*kDeviceWidthScale, 51*kDeviceWidthScale+48*kDeviceWidthScale*i, kDeviceWidth-17*kDeviceWidthScale, 1);
        }
        lineView.backgroundColor = LineColor;
        [self addSubview:lineView];
    }
}


@end

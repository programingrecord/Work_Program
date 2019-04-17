//
//  MSUActivityView.m
//  vvlc
//
//  Created by 007 on 2018/1/27.
//  Copyright © 2018年 HM. All rights reserved.
//

#import "MSUActivityView.h"

#import "MSUPathTools.h"

@implementation MSUActivityView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self createView];
        
    }
    return self;
}


- (void)createView{
    
    self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _closeBtn.frame = CGRectMake(kDeviceWidth-(80+35.5)*kDeviceWidthScale, 0, 25*kDeviceWidthScale, 42.5*kDeviceHeightScale);
    _closeBtn.clipsToBounds = YES;
    _closeBtn.layer.cornerRadius = 25*kDeviceWidthScale*0.5;
    _closeBtn.layer.shouldRasterize = YES;
    _closeBtn.layer.rasterizationScale = [UIScreen mainScreen].scale;
    //    _closeBtn.backgroundColor = WhiteColor;
    [_closeBtn setImage:[MSUPathTools showImageWithContentOfFileByName:@"upgrade_close"] forState:UIControlStateNormal];
    [self addSubview:_closeBtn];
    
    self.activityImaView = [[UIImageView alloc] initWithFrame:CGRectMake(10*kDeviceWidthScale, 42.5*kDeviceHeightScale, kDeviceWidth-100*kDeviceWidthScale, kDeviceHeight-300*kDeviceHeightScale)];
//    _activityImaView.image = [MSUPathTools showImageWithContentOfFileByName:@""];
    _activityImaView.clipsToBounds = YES;
    _activityImaView.layer.cornerRadius = 10;
    _activityImaView.layer.shouldRasterize = YES;
    _activityImaView.layer.rasterizationScale = [UIScreen mainScreen].scale;
//    _activityImaView.backgroundColor = titQianColor;

    [self addSubview:_activityImaView];
    
    self.activityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _activityBtn.frame = CGRectMake(10*kDeviceWidthScale, 42.5*kDeviceHeightScale, kDeviceWidth-100*kDeviceWidthScale, kDeviceHeight-300*kDeviceHeightScale);
    [self addSubview:_activityBtn];
    _activityBtn.backgroundColor = [UIColor clearColor];
    

    
}


@end

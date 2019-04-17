//
//  MSUScoreView.m
//  vvlc
//
//  Created by 007 on 2018/6/26.
//  Copyright © 2018年 HM. All rights reserved.
//

#import "MSUScoreView.h"

#import "MSUPathTools.h"

@implementation MSUScoreView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self createView];
        
    }
    return self;
}


- (void)createView{
    UIImageView *imaView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth-100, 300*kDeviceHeightScale)];
    imaView.image = [MSUPathTools showImageWithContentOfFileByName:@"MSUScore"];
    imaView.layer.cornerRadius = 4;
    imaView.clipsToBounds = YES;
    imaView.layer.shouldRasterize = YES;
    imaView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    [self addSubview:imaView];
    
    self.clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _clickBtn.frame = CGRectMake(0, 0, kDeviceWidth-100, 300*kDeviceHeightScale);
    _clickBtn.layer.cornerRadius = 4;
    _clickBtn.clipsToBounds = YES;
    _clickBtn.layer.shouldRasterize = YES;
    _clickBtn.layer.rasterizationScale = [UIScreen mainScreen].scale;
    [self addSubview:_clickBtn];

}


@end

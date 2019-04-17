//
//  MSUNoCardView.m
//  vvlc
//
//  Created by 007 on 2018/4/26.
//  Copyright © 2018年 HM. All rights reserved.
//

#import "MSUNoCardView.h"

@implementation MSUNoCardView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self createView];
        
    }
    return self;
}


- (void)createView{
    UIView *topView = [[UIView alloc] init];
    topView.frame = CGRectMake(0, 0, kDeviceWidth, 75);
    topView.backgroundColor = HEXCOLOR(0xFFFDF1);
    [self addSubview:topView];
    
    UILabel *attentionLab = [[UILabel alloc] init];
    attentionLab.frame = CGRectMake(17, 10, kDeviceWidth-34, 55);
    attentionLab.text = @"在【充值】页面可进行绑卡的相关操作\n为保障账户安全，目前只支持绑定一张银行卡，充值提现同卡进出";
    attentionLab.font = [UIFont systemFontOfSize:13];
    attentionLab.textColor = HEXCOLOR(0xE7AD57);
    attentionLab.numberOfLines = 0;
    [self addSubview:attentionLab];

    self.rechargeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rechargeBtn.frame = CGRectMake(17, attentionLab.bottom + 60, kDeviceWidth-34, 44);
    _rechargeBtn.backgroundColor = HEXCOLOR(0xFB6337);
    _rechargeBtn.layer.cornerRadius = 4;
    _rechargeBtn.clipsToBounds = YES;
    _rechargeBtn.layer.shouldRasterize = YES;
    _rechargeBtn.layer.rasterizationScale = [UIScreen mainScreen].scale;
    [_rechargeBtn setTitle:@"充值绑卡" forState:UIControlStateNormal];
    [_rechargeBtn setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
    _rechargeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:_rechargeBtn];
}


@end

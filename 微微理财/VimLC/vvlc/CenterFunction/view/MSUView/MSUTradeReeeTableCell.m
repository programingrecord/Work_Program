//
//  MSUTradeReeeTableCell.m
//  vvlc
//
//  Created by 007 on 2018/4/24.
//  Copyright © 2018年 HM. All rights reserved.
//

#import "MSUTradeReeeTableCell.h"

#import "MSUPathTools.h"

@implementation MSUTradeReeeTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createContentView];
    }
    return self;
}

- (void)createContentView{
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(0, 0, kDeviceWidth, 10*kDeviceHeightScale);
    bgView.backgroundColor = HEXCOLOR(0xf3f3f3);
    [self addSubview:bgView];
    
    self.bgViewa = [[UIView alloc] init];
    _bgViewa.frame = CGRectMake(10, bgView.bottom, kDeviceWidth-20, 120*kDeviceHeightScale);
    _bgViewa.backgroundColor = HEXCOLOR(0xffffff);
    _bgViewa.clipsToBounds = YES;
    _bgViewa.layer.cornerRadius = 5;
    _bgViewa.layer.shouldRasterize = YES;
    _bgViewa.layer.rasterizationScale = [UIScreen mainScreen].scale;
    [self addSubview:_bgViewa];
    
    self.titLab = [[UILabel alloc] init];
    _titLab.frame = CGRectMake(15,9*kDeviceHeightScale, kDeviceWidth-60, 22.5*kDeviceHeightScale);
    _titLab.text = @"--";
    _titLab.font = [UIFont systemFontOfSize:16];
    _titLab.textColor = HEXCOLOR(0x3B3D43);
    [_bgViewa addSubview:_titLab];
    
    self.signLab = [[UILabel alloc] init];
    _signLab.backgroundColor = HEXCOLOR(0xFF6339);
    _signLab.frame = CGRectMake(kDeviceWidth-20-55, _titLab.top, 55, 20*kDeviceHeightScale);
    _signLab.text = @"--";
    _signLab.font = [UIFont systemFontOfSize:12];
    _signLab.textColor = HEXCOLOR(0xffffff);
    _signLab.textAlignment = NSTextAlignmentCenter;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_signLab.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopLeft cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _signLab.bounds;
    maskLayer.path = maskPath.CGPath;
    _signLab.layer.mask = maskLayer;
    [_bgViewa addSubview:_signLab];
    
    self.moneyLab = [[UILabel alloc] init];
    _moneyLab.frame = CGRectMake(15,_titLab.bottom + 21*kDeviceHeightScale, kDeviceWidth*0.5, 22*kDeviceHeightScale);
    _moneyLab.text = @"--";
    self.moneyLab.font = [UIFont fontWithName:@"DINAlternate-Bold" size:18];
    _moneyLab.textColor = HEXCOLOR(0xFF6339);
    [_bgViewa addSubview:_moneyLab];
    
    UILabel *touzinLab = [[UILabel alloc] init];
    touzinLab.frame = CGRectMake(15, _moneyLab.bottom, 50, 22*kDeviceHeightScale);
    touzinLab.text = @"投资金额";
    touzinLab.font = [UIFont systemFontOfSize:12];
    touzinLab.textColor = HEXCOLOR(0xBABABA);
    [_bgViewa addSubview:touzinLab];
    
    self.dateLab = [[UILabel alloc] init];
    _dateLab.frame = CGRectMake(kDeviceWidth-20-15-kDeviceWidth*0.5,_titLab.bottom + 21*kDeviceHeightScale, kDeviceWidth*0.5, 22*kDeviceHeightScale);
    _dateLab.text = @"--";
    _dateLab.font = [UIFont systemFontOfSize:14];
    _dateLab.textAlignment = NSTextAlignmentRight;
    _dateLab.textColor = HEXCOLOR(0x6D6E6E);
    [_bgViewa addSubview:_dateLab];
    
    UILabel *reciptLab = [[UILabel alloc] init];
    reciptLab.frame = CGRectMake(kDeviceWidth-20-15-50, _dateLab.bottom, 50, 22*kDeviceHeightScale);
    reciptLab.text = @"还款日期";
    reciptLab.font = [UIFont systemFontOfSize:12];
    reciptLab.textColor = HEXCOLOR(0xBABABA);
    reciptLab.textAlignment = NSTextAlignmentRight;
    [_bgViewa addSubview:reciptLab];
    
    self.planView = [[UIView alloc] init];
    _planView.frame = CGRectMake(0,reciptLab.bottom + 12*kDeviceHeightScale, kDeviceWidth-20, 54*kDeviceHeightScale);
    _planView.backgroundColor = HEXCOLOR(0xffffff);
    [_bgViewa addSubview:_planView];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(0, 0, kDeviceWidth, 1);
    lineView.backgroundColor = HEXCOLOR(0xe8e8e8);
    [_planView addSubview:lineView];
    
//    UIImageView *imaView = [[UIImageView alloc] initWithFrame:CGRectMake(kDeviceWidth-12-14*kDeviceHeightScale,lineView.bottom + 15*kDeviceHeightScale, 14*kDeviceHeightScale, 14*kDeviceHeightScale)];
//    imaView.image = [MSUPathTools showImageWithContentOfFileByName:@"icon_arrow_right"];
//    imaView.contentMode = UIViewContentModeScaleAspectFit;
//    [_planView addSubview:imaView];
//
//    UILabel *planLab = [[UILabel alloc] init];
//    planLab.frame = CGRectMake(kDeviceWidth-12-14*kDeviceHeightScale-100-3, lineView.bottom + 12*kDeviceHeightScale, 100, 20*kDeviceHeightScale);
//    planLab.text = @"还款计划";
//    planLab.font = [UIFont systemFontOfSize:14];
//    planLab.textColor = HEXCOLOR(0x939393);
//    planLab.textAlignment = NSTextAlignmentRight;
//    [_planView addSubview:planLab];
    
    self.protocalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _protocalBtn.frame = CGRectMake(kDeviceWidth-20-15-80, lineView.bottom + 9*kDeviceHeightScale, 80, 35*kDeviceHeightScale);
    _protocalBtn.layer.cornerRadius = 35*kDeviceHeightScale*0.5;
    _protocalBtn.clipsToBounds = YES;
    _protocalBtn.layer.shouldRasterize = YES;
    _protocalBtn.layer.rasterizationScale = [UIScreen mainScreen].scale;
    _protocalBtn.layer.borderWidth = 0.5;
    _protocalBtn.layer.borderColor = HEXCOLOR(0xBABABA).CGColor;
    [_protocalBtn setTitle:@"借款协议" forState:UIControlStateNormal];
    [_protocalBtn setTitleColor:HEXCOLOR(0x3B3D43) forState:UIControlStateNormal];
    _protocalBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_planView addSubview:_protocalBtn];
    [_protocalBtn addTarget:self action:@selector(protocalBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.planBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _planBtn.frame = CGRectMake(_protocalBtn.left - 80 - 10, lineView.bottom + 9*kDeviceHeightScale, 80, 35*kDeviceHeightScale);
    _planBtn.layer.cornerRadius = 35*kDeviceHeightScale*0.5;
    _planBtn.clipsToBounds = YES;
    _planBtn.layer.shouldRasterize = YES;
    _planBtn.layer.rasterizationScale = [UIScreen mainScreen].scale;
    _planBtn.layer.borderWidth = 0.5;
    _planBtn.layer.borderColor = HEXCOLOR(0xBABABA).CGColor;
    [_planBtn setTitle:@"还款计划" forState:UIControlStateNormal];
    [_planBtn setTitleColor:HEXCOLOR(0x3B3D43) forState:UIControlStateNormal];
    _planBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_planView addSubview:_planBtn];
    _planBtn.enabled = NO;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)protocalBtnClick:(UIButton *)sender{
    if (self.proBlock) {
        self.proBlock(sender);
    }
}

@end

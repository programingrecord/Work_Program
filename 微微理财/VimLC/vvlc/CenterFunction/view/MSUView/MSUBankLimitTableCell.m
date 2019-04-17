//
//  MSUBankLimitTableCell.m
//  vvlc
//
//  Created by 007 on 2018/4/20.
//  Copyright © 2018年 HM. All rights reserved.
//

#import "MSUBankLimitTableCell.h"

#import "MSUStringTools.h"

@implementation MSUBankLimitTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createContentView];
    }
    return self;
}

- (void)createContentView{
    self.bankImage = [[UIImageView alloc] initWithFrame:CGRectMake(17, 17*kDeviceHeightScale, 18, 20*kDeviceHeightScale)];
    _bankImage.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_bankImage];
    
    self.bankLab = [[UILabel alloc] init];
    _bankLab.frame = CGRectMake(_bankImage.right+8,16*kDeviceHeightScale, 96, 16*kDeviceHeightScale);
    _bankLab.text = @"--";
    _bankLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    _bankLab.textColor = HEXCOLOR(0x3B3D43);
    [self addSubview:_bankLab];
    
    self.signLab = [[UILabel alloc] init];
    _signLab.frame = CGRectMake(_bankLab.right+8,17*kDeviceHeightScale, 95, 15*kDeviceHeightScale);
    _signLab.text = @"支持手机银行支付";
    _signLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
    _signLab.textColor = HEXCOLOR(0x5E98EF);
    _signLab.layer.borderWidth = 1;
    _signLab.layer.borderColor = HEXCOLOR(0x5E98EF).CGColor;
    _signLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_signLab];

    self.introLLLab = [[UILabel alloc] init];
    _introLLLab.frame = CGRectMake(44, _bankLab.bottom + 8*kDeviceHeightScale, kDeviceWidth-60, 12*kDeviceHeightScale);
    _introLLLab.text = @"--";
    _introLLLab.font = [UIFont systemFontOfSize:12];
    _introLLLab.textColor = HEXCOLOR(0x939393);
    _introLLLab.numberOfLines = 0;
    [self addSubview:_introLLLab];
    
    self.introFYLab = [[UILabel alloc] init];
    _introFYLab.frame = CGRectMake(44, _introLLLab.bottom + 6*kDeviceHeightScale, kDeviceWidth-60, 12*kDeviceHeightScale);
    _introFYLab.text = @"--";
    _introFYLab.font = [UIFont systemFontOfSize:12];
    _introFYLab.textColor = HEXCOLOR(0x939393);
    _introFYLab.numberOfLines = 0;
    [self addSubview:_introFYLab];
    
    self.lineView = [[UIView alloc] init];
    _lineView.frame = CGRectMake(0, 82*kDeviceHeightScale-1, kDeviceWidth, 1);
    _lineView.backgroundColor = HEXCOLOR(0xF0F0F0);
    [self addSubview:_lineView];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

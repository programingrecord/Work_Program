//
//  MSUTradePlanTableCell.m
//  vvlc
//
//  Created by 007 on 2018/1/16.
//  Copyright © 2018年 HM. All rights reserved.
//

#import "MSUTradePlanTableCell.h"

@implementation MSUTradePlanTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createContentView];
    }
    return self;
}

- (void)createContentView{
    self.qiLab = [[UILabel alloc] init];
    _qiLab.frame = CGRectMake(15*kDeviceWidthScale, 10*kDeviceHeightScale, 30*kDeviceWidthScale, 22.5*kDeviceHeightScale);
    _qiLab.font = TEXTFONT(16);
    _qiLab.textColor = titBlackColor;
    [self addSubview:_qiLab];
    
    self.timeLab = [[UILabel alloc] init];
    _timeLab.frame = CGRectMake(16*kDeviceWidthScale, _qiLab.bottom + 1*kDeviceHeightScale, 115.5*kDeviceWidthScale, 16.5*kDeviceHeightScale);
    _timeLab.font = TEXTFONT(12);
    _timeLab.textColor = titQianColor;
    [self addSubview:_timeLab];
    
    UILabel *totalLab = [[UILabel alloc] init];
    totalLab.frame = CGRectMake(kDeviceWidth-75*kDeviceWidthScale, 13*kDeviceHeightScale, 60*kDeviceWidthScale, 16.5*kDeviceHeightScale);
    totalLab.font = TEXTFONT(12);
    totalLab.text = @"还款总额";
    totalLab.textColor = titQianColor;
    [self addSubview:totalLab];
    
    self.moneyLab = [[UILabel alloc] init];
    _moneyLab.frame = CGRectMake(kDeviceWidth*0.5, totalLab.bottom + 1*kDeviceHeightScale, kDeviceWidth*0.5-15*kDeviceWidthScale, 22.5*kDeviceHeightScale);
    _moneyLab.font = TEXTFONT(16);
    _moneyLab.textAlignment = NSTextAlignmentRight;
    _moneyLab.textColor = titBlackColor;
    [self addSubview:_moneyLab];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(15*kDeviceWidthScale, 58*kDeviceHeightScale, kDeviceWidth-15*kDeviceWidthScale, 1);
    lineView.backgroundColor = LineColor;
    [self addSubview:lineView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

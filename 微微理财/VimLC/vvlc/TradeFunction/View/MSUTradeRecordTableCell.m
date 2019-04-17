//
//  MSUTradeRecordTableCell.m
//  vvlc
//
//  Created by 007 on 2018/1/16.
//  Copyright © 2018年 HM. All rights reserved.
//

#import "MSUTradeRecordTableCell.h"

@implementation MSUTradeRecordTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createContentView];
    }
    return self;
}

- (void)createContentView{
   self.topImaView = [[UIImageView alloc] initWithFrame:CGRectMake(15*kDeviceWidthScale, 16*kDeviceHeightScale, 31*kDeviceWidthScale, 23*kDeviceHeightScale)];
    _topImaView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_topImaView];
    
    self.nameLab = [[UILabel alloc] init];
    _nameLab.frame = CGRectMake(53.5*kDeviceWidthScale, 10*kDeviceHeightScale, 100*kDeviceWidthScale, 22.5*kDeviceHeightScale);
//    _nameLab.frame = CGRectMake(15*kDeviceWidthScale, 10*kDeviceHeightScale, 100*kDeviceWidthScale, 22.5*kDeviceHeightScale);
    _nameLab.font = TEXTFONT(16);
    _nameLab.textColor = titBlackColor;
    [self addSubview:_nameLab];
    
    self.timeLab = [[UILabel alloc] init];
    _timeLab.frame = CGRectMake(_nameLab.left, _nameLab.bottom + 1*kDeviceHeightScale, kDeviceWidth*0.5, 16.5*kDeviceHeightScale);
    _timeLab.font = TEXTFONT(12);
    _timeLab.textColor = titQianColor;
    [self addSubview:_timeLab];
    
    self.moneyLab = [[UILabel alloc] init];
    _moneyLab.frame = CGRectMake(kDeviceWidth*0.5, 18*kDeviceHeightScale, kDeviceWidth*0.5-15*kDeviceWidthScale, 22.5*kDeviceHeightScale);
    _moneyLab.font = TEXTFONT(16);
    _moneyLab.textAlignment = NSTextAlignmentRight;
    _moneyLab.textColor = titBlackColor;
    [self addSubview:_moneyLab];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(_nameLab.left, 58*kDeviceHeightScale, kDeviceWidth-_nameLab.left, 1);
    lineView.backgroundColor = HEXCOLOR(0xefefef);
    [self addSubview:lineView];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

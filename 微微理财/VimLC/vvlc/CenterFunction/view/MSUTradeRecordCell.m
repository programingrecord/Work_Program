//
//  MSUTradeRecordCell.m
//  vvlc
//
//  Created by 007 on 2018/4/25.
//  Copyright © 2018年 HM. All rights reserved.
//

#import "MSUTradeRecordCell.h"

@implementation MSUTradeRecordCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createContentView];
    }
    return self;
}

- (void)createContentView{
    self.titLab = [[UILabel alloc] init];
    _titLab.frame = CGRectMake(16, 12*kDeviceHeightScale, kDeviceWidth*0.5, 25*kDeviceHeightScale);
    _titLab.text = @"--";
    _titLab.font = [UIFont systemFontOfSize:18];
    _titLab.textColor = HEXCOLOR(0x2B2A2D);
    [self addSubview:_titLab];
    
    self.introLab = [[UILabel alloc] init];
    _introLab.frame = CGRectMake(16,_titLab.bottom +  8*kDeviceHeightScale, kDeviceWidth*0.5, 20*kDeviceHeightScale);
    _introLab.text = @"--";
    _introLab.font = [UIFont systemFontOfSize:14];
    _introLab.textColor = HEXCOLOR(0x3B3D43);
    [self addSubview:_introLab];
    
    self.moneyLab = [[UILabel alloc] init];
    _moneyLab.frame = CGRectMake(kDeviceWidth-16-kDeviceWidth*0.5,27*kDeviceHeightScale, kDeviceWidth*0.5, 20*kDeviceHeightScale);
    _moneyLab.text = @"--";
    _moneyLab.font = [UIFont systemFontOfSize:18];
    _moneyLab.textAlignment = NSTextAlignmentRight;
    _moneyLab.textColor = HEXCOLOR(0x3B3D43);
    [self addSubview:_moneyLab];
    
    self.yueLab = [[UILabel alloc] init];
    _yueLab.frame = CGRectMake(kDeviceWidth-16-kDeviceWidth*0.5,_moneyLab.bottom + 4*kDeviceHeightScale, kDeviceWidth*0.5, 16.5*kDeviceHeightScale);
    _yueLab.text = @"余额：--";
    _yueLab.font = [UIFont systemFontOfSize:12];
    _yueLab.textAlignment = NSTextAlignmentRight;
    _yueLab.textColor = HEXCOLOR(0xB0B0B0);
    [self addSubview:_yueLab];

    self.dateLab = [[UILabel alloc] init];
    _dateLab.frame = CGRectMake(16,_introLab.bottom +  8*kDeviceHeightScale, kDeviceWidth, 16*kDeviceHeightScale);
    _dateLab.text = @"--";
    _dateLab.font = [UIFont systemFontOfSize:12];
    _dateLab.textColor = HEXCOLOR(0xB0B0B0);
    [self addSubview:_dateLab];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(0, _dateLab.bottom+12*kDeviceHeightScale, kDeviceWidth, 1);
    lineView.backgroundColor = HEXCOLOR(0xe8e8e8);
    [self addSubview:lineView];
    
}

- (void)setModel:(TrandRecordModel *)model{
    if (_model != model) {
        _model =model;
    }
    _dateLab.text = _model.createDate;
    _titLab.text = _model.tallyType;
    _moneyLab.text = _model.incomeAmount;
//    _introLab.text = _model.intro;
//    _yueLab.text = _model.balance;
    _introLab.hidden = YES;
    _yueLab.hidden = YES;
    if ([_model.isIncome isEqualToString:@"0"]) {
        _moneyLab.textColor = RGBA(0, 188, 141, 1);
        _moneyLab.text = [NSString stringWithFormat:@"%@",_model.incomeAmount];
        
    }else{
        _moneyLab.textColor = HEXCOLOR(0xF2591F);
        _moneyLab.text = [NSString stringWithFormat:@"＋%@",_model.incomeAmount];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

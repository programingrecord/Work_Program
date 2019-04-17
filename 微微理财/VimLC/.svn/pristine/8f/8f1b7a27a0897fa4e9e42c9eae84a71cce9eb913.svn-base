//
//  TrandReecordCell.m
//  WTJR
//
//  Created by HM on 16/6/6.
//  Copyright © 2016年 HM. All rights reserved.
//

#import "TrandReecordCell.h"

@implementation TrandReecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(TrandRecordModel *)model{
    if (_model != model) {
        _model =model;
    }
    _TradeDate.text = _model.createDate;
    if ([self.titStr isEqualToString:@"充值记录"]) {
        if ([_model.tallyType isEqualToString:@"线上充值"]) {
            _model.tallyType = @"充值成功";
        }
    }
    _TradeType.text = _model.tallyType;
    _TradeType.textColor = titBlackColor;
//    _TradeState.text = _model.balance;
    _TradeState.hidden = YES;
    _TradeAmount.font = [UIFont fontWithName:@"DINAlternate-Bold" size:16];
    if ([_model.isIncome isEqualToString:@"0"]) {
        _TradeAmount.textColor = RGBA(0, 188, 141, 1);
        _TradeAmount.text = [NSString stringWithFormat:@"%@",_model.incomeAmount];

    }else{
        _TradeAmount.textColor = HEXCOLOR(0xF2591F);
        _TradeAmount.text = [NSString stringWithFormat:@"＋%@",_model.incomeAmount];
    }
}

@end

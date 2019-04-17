//
//  BankLimitTableViewCell.m
//  vvlc
//
//  Created by 慧明 on 2017/10/31.
//  Copyright © 2017年 HM. All rights reserved.
//

#import "BankLimitTableViewCell.h"

@implementation BankLimitTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(BankLimitModel *)model{
    if (_model != model) {
        _model = model;
    }
    self.TitleLabel.text =_model.bankName;
    [self.BankImage sd_setImageWithURL:[NSURL URLWithString:_model.bankIcon] placeholderImage:[UIImage imageNamed:@"image_empty"]];
    self.TitleValueLabel.text = [NSString stringWithFormat:@"单笔%@万元，单日%@万元，单月%@万元",_model.singleAmt,_model.dayAmt,_model.monthAmt];
}
@end

//
//  CouponTableViewCell.m
//  vvlc
//
//  Created by 慧明 on 2017/11/7.
//  Copyright © 2017年 HM. All rights reserved.
//

#import "CouponTableViewCell.h"

@implementation CouponTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(CouponModel *)model{
    if (_model!= model) {
        _model = model;
    }
    self.AmountLabel.text = [NSString stringWithFormat:@"%@",_model.amount];
    self.TypeLabel.text = [NSString stringWithFormat:@"%@",_model.tip];
    self.BidAmountLabel.text = [NSString stringWithFormat:@"%@",_model.bidAmount];
    self.TipLabel.text = [NSString stringWithFormat:@"%@",_model.timeCount];
    self.DateLabel.text = [NSString stringWithFormat:@"%@",_model.endDate];
    NSString *bagState= [NSString stringWithFormat:@"%@",_model.bagState];
    
    if ([bagState isEqualToString:@"0"]) {
        self.StateLabel.text = @"立即使用";
        self.BidAmountLabel.textColor = [UIColor colorWithHex:0x666666];
        self.TipLabel.textColor = [UIColor colorWithHex:0xB0B0B0];
        self.DateLabel.textColor = [UIColor colorWithHex:0xB0B0B0];
        self.ColorView.backgroundColor = [UIColor colorWithHex:0xF26059];
        self.StateLabel.textColor = [UIColor colorWithHex:0xF26059];
    }else if([bagState isEqualToString:@"1"]){
        self.StateLabel.text = @"已使用";
        self.BidAmountLabel.textColor = [UIColor colorWithHex:0xD1D1D1];
        self.TipLabel.textColor = [UIColor colorWithHex:0xD1D1D1];
        self.DateLabel.textColor = [UIColor colorWithHex:0xD1D1D1];
        self.ColorView.backgroundColor = [UIColor colorWithHex:0xD1D1D1];
        self.StateLabel.textColor = [UIColor colorWithHex:0xD1D1D1];
    }else{
        self.StateLabel.text = @"已过期";
        self.BidAmountLabel.textColor = [UIColor colorWithHex:0xD1D1D1];
        self.TipLabel.textColor = [UIColor colorWithHex:0xD1D1D1];
        self.DateLabel.textColor = [UIColor colorWithHex:0xD1D1D1];
        self.ColorView.backgroundColor = [UIColor colorWithHex:0xD1D1D1];
        self.StateLabel.textColor = [UIColor colorWithHex:0xD1D1D1];
    }
}
@end

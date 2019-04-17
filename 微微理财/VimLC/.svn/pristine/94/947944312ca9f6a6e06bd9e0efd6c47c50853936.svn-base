//
//  MybidTableViewCell.m
//  WTJR
//
//  Created by H on 16/8/10.
//  Copyright © 2016年 HM. All rights reserved.
//

#import "MybidTableViewCell.h"

@implementation MybidTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setMyBidModel:(MyBidModel *)myBidModel
{
    if (_myBidModel != myBidModel) {
        _myBidModel =myBidModel;
    }
    _titleLabel.text = _myBidModel.borrowTitle;
    _DateLabel.text = _myBidModel.createDate;
    _stateLabel.text = _myBidModel.borrowState;
    _moneyLabel.text = _myBidModel.amount;
}
@end

//
//  InviteListTableViewCell.m
//  vvlc
//
//  Created by 慧明 on 2017/12/18.
//  Copyright © 2017年 HM. All rights reserved.
//

#import "InviteListTableViewCell.h"

@implementation InviteListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(InviteListModel *)model{
    if (_model != model) {
        _model = model;
    }
    self.LeftLabel.text = [NSString stringWithFormat:@"%@",_model.name];
    self.MinLabel.text =[NSString stringWithFormat:@"%@",_model.date];
    self.RightLabel.text = [NSString stringWithFormat:@"%@", _model.amount];
}

@end

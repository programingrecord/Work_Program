//
//  CenterItemCell.m
//  WTJR
//
//  Created by HM on 16/6/2.
//  Copyright © 2016年 HM. All rights reserved.
//

#import "CenterItemCell.h"

@implementation CenterItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(CenterModel *)model
{
    if (_model != model) {
        _model = model;
    }
    _leftImage.image = [UIImage imageNamed:_model.imageName];
    _leftTitle.text = _model.titleString;
    if (_model.rightString && _model.rightString.length >0) {
        _rightTltle.text = _model.rightString;
    }
}
@end

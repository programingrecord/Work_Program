//
//  MSUTestAnswerTableCell.m
//  vvlc
//
//  Created by 007 on 2018/2/5.
//  Copyright © 2018年 HM. All rights reserved.
//

#import "MSUTestAnswerTableCell.h"

@implementation MSUTestAnswerTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createContentView];
    }
    return self;
}

- (void)createContentView{
    self.anwserLab = [[UILabel alloc] init];
    _anwserLab.frame = CGRectMake(36*kDeviceWidthScale, 13.5, kDeviceWidth-72*kDeviceWidthScale, 25);
    _anwserLab.font = [UIFont systemFontOfSize:16];
    _anwserLab.textColor = HEXCOLOR(0xbdbdbd);
    _anwserLab.numberOfLines = 0;
    [self addSubview:_anwserLab];

    self.lineView = [[UIView alloc] init];
    _lineView.frame = CGRectMake(_anwserLab.left, 49, kDeviceWidth-72*kDeviceWidthScale, 1);
    _lineView.backgroundColor = LineColor;
    [self addSubview:_lineView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state

}

@end

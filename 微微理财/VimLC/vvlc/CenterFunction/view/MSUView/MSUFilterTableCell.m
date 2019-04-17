//
//  MSUFilterTableCell.m
//  vvlc
//
//  Created by 007 on 2018/5/2.
//  Copyright © 2018年 HM. All rights reserved.
//

#import "MSUFilterTableCell.h"

@implementation MSUFilterTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createContentView];
    }
    return self;
}

- (void)createContentView{
    self.titLab = [[UILabel alloc] init];
    _titLab.frame = CGRectMake(26, 0, 90, 33);
    _titLab.backgroundColor = HEXCOLOR(0xEDEDED);
    _titLab.clipsToBounds = YES;
    _titLab.layer.cornerRadius = 33*0.5;
    _titLab.layer.shouldRasterize = YES;
    _titLab.layer.rasterizationScale = [UIScreen mainScreen].scale;
    _titLab.text = @"--";
    _titLab.font = [UIFont systemFontOfSize:14];
    _titLab.textAlignment = NSTextAlignmentCenter;
    _titLab.textColor = HEXCOLOR(0x4A4A4A);
    [self addSubview:_titLab];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

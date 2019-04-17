//
//  MSUProtocalCell.m
//  vvlc
//
//  Created by 007 on 2018/6/5.
//  Copyright © 2018年 HM. All rights reserved.
//

#import "MSUProtocalCell.h"

@implementation MSUProtocalCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createContentView];
    }
    return self;
}

- (void)createContentView{
    self.titLab = [[UILabel alloc] init];
    _titLab.frame = CGRectMake(14, 15*kDeviceHeightScale, kDeviceWidth*0.5, 20*kDeviceHeightScale);
    _titLab.text = @"--";
    _titLab.font = [UIFont systemFontOfSize:15];
    _titLab.textColor = HEXCOLOR(0x333333);
    [self addSubview:_titLab];
    
//    self.timeLab = [[UILabel alloc] init];
//    _timeLab.frame = CGRectMake(kDeviceWidth*0.5-14, 15*kDeviceHeightScale, kDeviceWidth*0.5, 20*kDeviceHeightScale);
//    _timeLab.text = @"--";
//    _timeLab.font = [UIFont systemFontOfSize:15];
//    _timeLab.textColor = HEXCOLOR(0x333333);
//    _timeLab.textAlignment = NSTextAlignmentRight;
//    [self addSubview:_timeLab];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(0, 50*kDeviceHeightScale-0.5, kDeviceWidth, 0.5);
    lineView.backgroundColor = HEXCOLOR(0xe3e3e3);
    [self addSubview:lineView];

}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

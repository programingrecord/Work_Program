//
//  MSUTradeBottomTableCell.m
//  vvlc
//
//  Created by 007 on 2018/1/15.
//  Copyright © 2018年 HM. All rights reserved.
//

#import "MSUTradeBottomTableCell.h"

@implementation MSUTradeBottomTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createContentView];
    }
    return self;
}

- (void)createContentView{
//    self.leftImaView = [[UIImageView alloc] init];
//    _leftImaView.frame = CGRectMake(14.5*kDeviceWidthScale, 16.5*kDeviceHeightScale, 17*kDeviceHeightScale, 17*kDeviceHeightScale);
//    _leftImaView.contentMode = UIViewContentModeScaleAspectFit;
//    [self addSubview:_leftImaView];
//
    self.leftLab = [[UILabel alloc] init];
    _leftLab.frame = CGRectMake(19*kDeviceWidthScale, 13.5*kDeviceHeightScale,120*kDeviceWidthScale, 22.5*kDeviceHeightScale);
    _leftLab.font = TEXTFONT(16);
    _leftLab.textColor = titBlackColor;
    [self addSubview:_leftLab];
    
    self.rightLab = [[UILabel alloc] init];
    _rightLab.frame = CGRectMake(kDeviceWidth*0.5-16*kDeviceWidthScale, 15.5*kDeviceHeightScale,kDeviceWidth*0.5-5.2*kDeviceWidthScale, 20*kDeviceHeightScale);
    _rightLab.font = TEXTFONT(14);
    _rightLab.textColor = HEXCOLOR(0x9f9f9f);
    _rightLab.textAlignment = NSTextAlignmentRight;
    [self addSubview:_rightLab];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(14*kDeviceWidthScale, 49.5*kDeviceHeightScale, kDeviceWidth-14*kDeviceWidthScale, 0.5);
    lineView.backgroundColor = LineColor;
    [self addSubview:lineView];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

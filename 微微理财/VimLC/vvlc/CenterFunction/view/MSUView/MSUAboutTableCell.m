//
//  MSUAboutTableCell.m
//  vvlc
//
//  Created by 007 on 2018/4/19.
//  Copyright © 2018年 HM. All rights reserved.
//

#import "MSUAboutTableCell.h"
#import "MSUPathTools.h"

@implementation MSUAboutTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createContentView];
    }
    return self;
}

- (void)createContentView{
    self.leftLab = [[UILabel alloc] init];
    _leftLab.frame = CGRectMake(15, 0, 100, 55);
    _leftLab.font = [UIFont systemFontOfSize:16];
    _leftLab.textColor = HEXCOLOR(0x1F2425);
    [self addSubview:_leftLab];
    
    self.rightLab = [[UILabel alloc] init];
    _rightLab.frame = CGRectMake(kDeviceWidth*0.5-35, 18, kDeviceWidth*0.5, 20);
    _rightLab.font = [UIFont systemFontOfSize:14];
    _rightLab.textColor = HEXCOLOR(0x939393);
    _rightLab.textAlignment = NSTextAlignmentRight;
    [self addSubview:_rightLab];

    UIImageView *imaView = [[UIImageView alloc] initWithFrame:CGRectMake(kDeviceWidth-15-14, 21, 14, 14)];
    imaView.image = [MSUPathTools showImageWithContentOfFileByName:@"icon_arrow_right"];
    imaView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:imaView];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

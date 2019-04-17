//
//  MSUMessageTableCell.m
//  vvlc
//
//  Created by 007 on 2018/5/29.
//  Copyright © 2018年 HM. All rights reserved.
//

#import "MSUMessageTableCell.h"
#import "MSUPathTools.h"

@implementation MSUMessageTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createContentView];
    }
    return self;
}

- (void)createContentView{
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(10, 10*kDeviceHeightScale, kDeviceWidth-20, 120*kDeviceHeightScale);
    bgView.backgroundColor = HEXCOLOR(0xffffff);
    bgView.clipsToBounds = YES;
    bgView.layer.cornerRadius = 5;
    bgView.layer.shouldRasterize = YES;
    bgView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    [self addSubview:bgView];
    
    self.titLab = [[UILabel alloc] init];
    _titLab.frame = CGRectMake(10, 16*kDeviceHeightScale, kDeviceWidth-40, 21*kDeviceHeightScale);
    _titLab.text = @"--";
    _titLab.font = [UIFont fontWithName:@"PingFang-SC-Bold" size:15];
    _titLab.textColor = HEXCOLOR(0x454545);
    [bgView addSubview:_titLab];
   
    self.contentLab = [[UILabel alloc] init];
    _contentLab.frame = CGRectMake(10, _titLab.bottom, kDeviceWidth-70, 44*kDeviceHeightScale);
    _contentLab.text = @"--";
    _contentLab.font = [UIFont systemFontOfSize:13];
    _contentLab.textColor = HEXCOLOR(0xBBBBBB);
    _contentLab.numberOfLines = 0;
    [bgView addSubview:_contentLab];
    
    self.timeLab = [[UILabel alloc] init];
    _timeLab.frame = CGRectMake(10, _contentLab.bottom+7.5*kDeviceHeightScale, kDeviceWidth-40, 16.5*kDeviceHeightScale);
    _timeLab.text = @"--";
    _timeLab.font = [UIFont systemFontOfSize:12];
    _timeLab.textColor = HEXCOLOR(0xBBBBBB);
    [bgView addSubview:_timeLab];
    
    UIImageView *imaView = [[UIImageView alloc] initWithFrame:CGRectMake(kDeviceWidth-35-15*kDeviceHeightScale, 57*kDeviceHeightScale, 15*kDeviceHeightScale, 15*kDeviceHeightScale)];
    imaView.image = [MSUPathTools showImageWithContentOfFileByName:@"icon_arrow_right"];
    imaView.contentMode = UIViewContentModeScaleAspectFit;
    [bgView addSubview:imaView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  MSUChargeTableCell.m
//  vvlc
//
//  Created by 007 on 2018/4/19.
//  Copyright © 2018年 HM. All rights reserved.
//

#import "MSUChargeTableCell.h"

#import "MSUPathTools.h"

@implementation MSUChargeTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createContentView];
    }
    return self;
}

- (void)createContentView{
    self.bankImaView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 14.5*kDeviceHeightScale, 19*kDeviceHeightScale, 19*kDeviceHeightScale)];
    _bankImaView.image = [MSUPathTools showImageWithContentOfFileByName:@"wxz"];
    [self addSubview:_bankImaView];
    
    self.bankLab = [[UILabel alloc] init];
    _bankLab.frame = CGRectMake(_bankImaView.right + 8, 14*kDeviceHeightScale, 100, 16);
    _bankLab.text = @"--";
    _bankLab.font = [UIFont systemFontOfSize:16];
    _bankLab.textColor = HEXCOLOR(0x3B3D43);
    [self addSubview:_bankLab];
    
    self.signLab = [[UILabel alloc] init];
    _signLab.frame = CGRectMake(_bankLab.right + 8, 14*kDeviceHeightScale, 60, 16);
    _signLab.text = @"--";
    _signLab.textAlignment = NSTextAlignmentCenter;
    _signLab.font = [UIFont systemFontOfSize:11];
    _signLab.clipsToBounds = YES;
    _signLab.layer.cornerRadius = 2;
    _signLab.layer.shouldRasterize = YES;
    _signLab.layer.rasterizationScale = [UIScreen mainScreen].scale;
    _signLab.textColor = HEXCOLOR(0xFF9578);
    _signLab.layer.borderWidth = 1;
    _signLab.layer.borderColor = HEXCOLOR(0xFF9578).CGColor;
    [self addSubview:_signLab];
    
    self.introLab = [[UILabel alloc] init];
    _introLab.frame = CGRectMake(_bankLab.left , _bankLab.bottom +  8*kDeviceHeightScale, kDeviceWidth - 77, 12);
    _introLab.text = @"--";
    _introLab.font = [UIFont systemFontOfSize:12];
    _introLab.textColor = HEXCOLOR(0xC7C7C7);
    [self addSubview:_introLab];
    
    self.seleImaView = [[UIImageView alloc] initWithFrame:CGRectMake(kDeviceWidth-16-22*kDeviceHeightScale, 20*kDeviceHeightScale, 22*kDeviceHeightScale, 22*kDeviceHeightScale)];
    _seleImaView.image = [MSUPathTools showImageWithContentOfFileByName:@"wxz"];
    _seleImaView.highlightedImage = [MSUPathTools showImageWithContentOfFileByName:@"xz"];
    [self addSubview:_seleImaView];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(0, 62*kDeviceHeightScale-1, kDeviceWidth, 1);
    lineView.backgroundColor = HEXCOLOR(0xf0f0f0);
    [self addSubview:lineView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

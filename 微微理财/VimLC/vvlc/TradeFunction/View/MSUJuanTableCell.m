//
//  MSUJuanTableCell.m
//  vvlc
//
//  Created by 007 on 2018/1/12.
//  Copyright © 2018年 HM. All rights reserved.
//

#import "MSUJuanTableCell.h"

#import "MSUPathTools.h"

@implementation MSUJuanTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createContentView];
    }
    return self;
}

- (void)createContentView{
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(25*kDeviceHeightScale, 17*kDeviceHeightScale, kDeviceWidth-50*kDeviceWidthScale, 93*kDeviceHeightScale);
//    bgView.clipsToBounds = YES;
    bgView.layer.cornerRadius = 5;
    bgView.layer.shouldRasterize = YES;
    bgView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    bgView.backgroundColor = WhiteColor;
    bgView.layer.shadowColor = HEXCOLOR(0xcccccc).CGColor;
    bgView.layer.shadowOffset = CGSizeMake(0, 0);
    bgView.layer.shadowRadius = 4;
    bgView.layer.shadowOpacity = 1;
    [self addSubview:bgView];
    
    self.whiteView = [[UIView alloc] init];
    _whiteView.frame = CGRectMake(25*kDeviceHeightScale, 17*kDeviceHeightScale, kDeviceWidth-50*kDeviceWidthScale, 93*kDeviceHeightScale);
    _whiteView.backgroundColor = HEXCOLOR(0xffffff);
    _whiteView.alpha = 0.5;
    _whiteView.clipsToBounds = YES;
    _whiteView.layer.cornerRadius = 5;
    _whiteView.layer.shouldRasterize = YES;
    _whiteView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    [self addSubview:_whiteView];
    _whiteView.hidden = YES;
    
    self.imaView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0 ,120*kDeviceWidthScale, 93*kDeviceHeightScale)];
    _imaView.image = [MSUPathTools showImageWithContentOfFileByName:@"hb_bg"];
    _imaView.backgroundColor = HEXCOLOR(0xF3F3F3);
    _imaView.clipsToBounds = YES;
    _imaView.layer.cornerRadius = 5;
    _imaView.layer.shouldRasterize = YES;
    _imaView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    [bgView addSubview:_imaView];
    
    self.priceLab = [[UILabel alloc] init];
    _priceLab.frame = CGRectMake(0, 15*kDeviceHeightScale, 120*kDeviceWidthScale, 37*kDeviceHeightScale);
    self.priceLab.font = [UIFont fontWithName:@"DINAlternate-Bold" size:32];
    _priceLab.textColor = WhiteColor;
    _priceLab.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:_priceLab];
    
    self.introLab = [[UILabel alloc] init];
    _introLab.frame = CGRectMake(0, _priceLab.bottom + 3.5*kDeviceHeightScale, 120*kDeviceWidthScale, 22.5*kDeviceHeightScale);
    _introLab.font = TEXTFONT(16);
    _introLab.textColor = WhiteColor;
    _introLab.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:_introLab];
    
    self.priLimitLab = [[UILabel alloc] init];
    _priLimitLab.frame = CGRectMake(self.imaView.right+17.5, 12*kDeviceHeightScale, kDeviceWidth*0.5, 22.5*kDeviceHeightScale);
//    _priLimitLab.textAlignment = NSTextAlignmentRight;
    _priLimitLab.font = TEXTFONT(16);
    _priLimitLab.textColor = HEXCOLOR(0x454545);
    [bgView addSubview:_priLimitLab];
    
    self.infoLab = [[UILabel alloc] init];
    _infoLab.frame = CGRectMake(_priLimitLab.left, _priLimitLab.bottom + 9.5*kDeviceHeightScale, kDeviceWidth*0.5, 13*kDeviceHeightScale);
//    _infoLab.textAlignment = NSTextAlignmentRight;
    _infoLab.font = TEXTFONT(13);
    _infoLab.textColor = HEXCOLOR(0xb0b0b0);
    [bgView addSubview:_infoLab];
    
    self.timeLab = [[UILabel alloc] init];
    _timeLab.frame = CGRectMake(_priLimitLab.left, _infoLab.bottom + 8*kDeviceHeightScale, kDeviceWidth*0.5, 13*kDeviceHeightScale);
//    _timeLab.textAlignment = NSTextAlignmentRight;
    _timeLab.font = TEXTFONT(13);
    _timeLab.textColor = HEXCOLOR(0xb0b0b0);
    [bgView addSubview:_timeLab];
    
    self.selectImaView = [[UIImageView alloc] initWithFrame: CGRectMake(kDeviceWidth-50*kDeviceWidthScale-21-23*kDeviceHeightScale, 12*kDeviceHeightScale, 23*kDeviceHeightScale, 23*kDeviceHeightScale)];
    _selectImaView.image = [MSUPathTools showImageWithContentOfFileByName:@"Group5Copy"];
    _selectImaView.highlightedImage = [MSUPathTools showImageWithContentOfFileByName:@"Group5"];
    [bgView addSubview:_selectImaView];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end

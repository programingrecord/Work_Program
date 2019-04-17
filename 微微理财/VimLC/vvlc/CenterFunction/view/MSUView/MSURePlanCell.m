//
//  MSURePlanCell.m
//  vvlc
//
//  Created by 007 on 2018/4/25.
//  Copyright © 2018年 HM. All rights reserved.
//

#import "MSURePlanCell.h"

#import "MSUPathTools.h"

@implementation MSURePlanCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createContentView];
    }
    return self;
}

- (void)createContentView{
    self.gouImaView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 13.5*kDeviceHeightScale, 19*kDeviceHeightScale, 19*kDeviceHeightScale)];
    _gouImaView.image = [MSUPathTools showImageWithContentOfFileByName:@"wxz"];
    _gouImaView.highlightedImage = [MSUPathTools showImageWithContentOfFileByName:@"seleGou"];
    _gouImaView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_gouImaView];
    
    self.lineView = [[UIView alloc] init];
    _lineView.frame = CGRectMake(20+9.5*kDeviceHeightScale, _gouImaView.bottom, 1, 38.7*kDeviceHeightScale);
    _lineView.backgroundColor = HEXCOLOR(0xD8D8D8);
    [self addSubview:_lineView];
    
    self.lineTopView = [[UIView alloc] init];
    _lineTopView.frame = CGRectMake(20+9.5*kDeviceHeightScale, 0, 1, 13.5*kDeviceHeightScale);
    _lineTopView.backgroundColor = HEXCOLOR(0xD8D8D8);
    [self addSubview:_lineTopView];
    
    self.titLab = [[UILabel alloc] init];
    _titLab.frame = CGRectMake(_gouImaView.right + 9,12*kDeviceHeightScale, kDeviceWidth*0.5, 22.5*kDeviceHeightScale);
    _titLab.text = @"--";
    _titLab.font = [UIFont systemFontOfSize:16];
    _titLab.textColor = HEXCOLOR(0x454545);
    _titLab.highlightedTextColor = HEXCOLOR(0x1FC69F);
    [self addSubview:_titLab];
    
    self.dateLab = [[UILabel alloc] init];
    _dateLab.frame = CGRectMake(_gouImaView.right + 9,_titLab.bottom, kDeviceWidth*0.5, 16.5*kDeviceHeightScale);
    _dateLab.text = @"--";
    _dateLab.font = [UIFont systemFontOfSize:12];
    _dateLab.textColor = HEXCOLOR(0xB0B0B0);
    _dateLab.highlightedTextColor = HEXCOLOR(0x1FC69F);
    [self addSubview:_dateLab];
    
    self.moneyLab = [[UILabel alloc] init];
    _moneyLab.frame = CGRectMake(kDeviceWidth-20-kDeviceWidth*0.5,_titLab.top, kDeviceWidth*0.5, 22.5*kDeviceHeightScale);
    _moneyLab.text = @"--";
    self.moneyLab.font = [UIFont fontWithName:@"DINAlternate-Bold" size:16];
    _moneyLab.textAlignment = NSTextAlignmentRight;
    _moneyLab.textColor = HEXCOLOR(0x454545);
    _moneyLab.highlightedTextColor = HEXCOLOR(0xFF6339);
    [self addSubview:_moneyLab];
    
    self.introLab = [[UILabel alloc] init];
    _introLab.frame = CGRectMake(kDeviceWidth-20-kDeviceWidth*0.5,_dateLab.top, kDeviceWidth*0.5, 22.5*kDeviceHeightScale);
    _introLab.text = @"--";
    _introLab.font = [UIFont systemFontOfSize:12];
    _introLab.textAlignment = NSTextAlignmentRight;
    _introLab.textColor = HEXCOLOR(0xB0B0B0);
    [self addSubview:_introLab];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

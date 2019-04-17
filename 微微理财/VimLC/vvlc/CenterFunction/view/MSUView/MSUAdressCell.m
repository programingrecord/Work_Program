//
//  MSUAdressCell.m
//  vvlc
//
//  Created by 007 on 2018/6/26.
//  Copyright © 2018年 HM. All rights reserved.
//

#import "MSUAdressCell.h"

#import "MSUPathTools.h"

@implementation MSUAdressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createContentView];
    }
    return self;
}

- (void)createContentView{
    self.nameLab = [[UILabel alloc] init];
    _nameLab.frame = CGRectMake(15, 19*kDeviceHeightScale, 70, 22*kDeviceHeightScale);
    _nameLab.text = @"--";
    _nameLab.font = [UIFont systemFontOfSize:16];
    _nameLab.textColor = HEXCOLOR(0x1f2425);
    [self addSubview:_nameLab];

    self.phoneLab = [[UILabel alloc] init];
    _phoneLab.frame = CGRectMake(_nameLab.right + 22, 19*kDeviceHeightScale, 110, 22*kDeviceHeightScale);
    _phoneLab.text = @"--";
    _phoneLab.font = [UIFont systemFontOfSize:16];
    _phoneLab.textColor = HEXCOLOR(0x1f2425);
    [self addSubview:_phoneLab];
    
    self.signImaView = [[UIImageView alloc] init];
    _signImaView.frame = CGRectMake(_phoneLab.right + 19, 18*kDeviceHeightScale, 45, 22*kDeviceHeightScale);
    _signImaView.image = [MSUPathTools showImageWithContentOfFileByName:@"default_msu"];
    [self addSubview:_signImaView];
    
    self.adressLab = [[UILabel alloc] init];
    _adressLab.text = @"--";
    _adressLab.font = [UIFont systemFontOfSize:14];
    _adressLab.textColor = HEXCOLOR(0x1f2425);
    _adressLab.numberOfLines = 0;
    [self addSubview:_adressLab];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

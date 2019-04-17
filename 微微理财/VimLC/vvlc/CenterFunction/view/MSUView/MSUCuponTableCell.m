//
//  MSUCuponTableCell.m
//  vvlc
//
//  Created by 007 on 2018/3/19.
//  Copyright © 2018年 HM. All rights reserved.
//

#import "MSUCuponTableCell.h"

#import "MSUPathTools.h"

@implementation MSUCuponTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createContentView];
    }
    return self;
}

- (void)createContentView{
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(20*kDeviceHeightScale, 13.5*kDeviceHeightScale, kDeviceWidth-40*kDeviceWidthScale, 99*kDeviceHeightScale);
    bgView.layer.shadowColor = HEXCOLOR(0xcccccc).CGColor;
    bgView.layer.shadowOffset = CGSizeMake(0, 0);
    bgView.layer.shadowRadius = 4;
    bgView.layer.shadowOpacity = 1;
    [self addSubview:bgView];
    
    self.whiteView = [[UIView alloc] init];
    _whiteView.frame = CGRectMake(20*kDeviceHeightScale, 13.5*kDeviceHeightScale, kDeviceWidth-40*kDeviceWidthScale, 99*kDeviceHeightScale);
    _whiteView.backgroundColor = HEXCOLOR(0xffffff);
    _whiteView.alpha = 0.5;
    [self addSubview:_whiteView];
    _whiteView.hidden = YES;
    
    self.imaView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0 ,kDeviceWidth-40*kDeviceWidthScale, 99*kDeviceHeightScale)];
    _imaView.image = [MSUPathTools showImageWithContentOfFileByName:@"msuhb_bg"];
    [bgView addSubview:_imaView];
    
    self.priceLab = [[UILabel alloc] init];
    _priceLab.frame = CGRectMake(0, 15*kDeviceHeightScale, 110*kDeviceWidthScale, 37*kDeviceHeightScale);
    _priceLab.font = TEXTFONT(32);
    _priceLab.textColor = WhiteColor;
    _priceLab.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:_priceLab];
    
    self.introLab = [[UILabel alloc] init];
    _introLab.frame = CGRectMake(15, _priceLab.bottom + 3.5*kDeviceHeightScale, 80*kDeviceWidthScale, 22.5*kDeviceHeightScale);
    _introLab.font = TEXTFONT(13);
    _introLab.backgroundColor = WhiteColor;
    _introLab.textColor = HEXCOLOR(0xff6339);
    _introLab.textAlignment = NSTextAlignmentCenter;
    _introLab.clipsToBounds = YES;
    _introLab.layer.cornerRadius = 22.5*kDeviceHeightScale*0.5;
    _introLab.layer.shouldRasterize = YES;
    _introLab.layer.rasterizationScale = [UIScreen mainScreen].scale;
    [bgView addSubview:_introLab];
    
    //满多少可用
    self.priLimitLab = [[UILabel alloc] init];
    _priLimitLab.frame = CGRectMake(130, 12*kDeviceHeightScale, kDeviceWidth*0.5, 22.5*kDeviceHeightScale);
//    _priLimitLab.textAlignment = NSTextAlignmentRight;
    _priLimitLab.font = TEXTFONT(16);
    _priLimitLab.textColor = HEXCOLOR(0x454545);
    [bgView addSubview:_priLimitLab];
    
    //几月标
    self.infoLab = [[UILabel alloc] init];
    _infoLab.frame = CGRectMake(_priLimitLab.left, _priLimitLab.bottom + 9.5*kDeviceHeightScale, kDeviceWidth*0.5-30, 13*kDeviceHeightScale);
//    _infoLab.textAlignment = NSTextAlignmentRight;
    _infoLab.font = TEXTFONT(13);
    _infoLab.textColor = HEXCOLOR(0xb0b0b0);
    [bgView addSubview:_infoLab];
    
    //时间
    self.timeLab = [[UILabel alloc] init];
    _timeLab.frame = CGRectMake(_priLimitLab.left, _infoLab.bottom + 8*kDeviceHeightScale, kDeviceWidth*0.5-30, 13*kDeviceHeightScale);
//    _timeLab.textAlignment = NSTextAlignmentRight;
    _timeLab.font = TEXTFONT(13);
    _timeLab.textColor = HEXCOLOR(0xb0b0b0);
    [bgView addSubview:_timeLab];
    
    //立即使用
    self.useLab = [[UILabel alloc] init];
    _useLab.frame = CGRectMake(kDeviceWidth-40-50, 0, 50, 93*kDeviceHeightScale);
//    useLab.backgroundColor = [UIColor redColor];
    _useLab.text = @"立\n即\n使\n用";
    _useLab.numberOfLines = [_useLab.text length];
    _useLab.textAlignment = NSTextAlignmentCenter;
    _useLab.font = TEXTFONT(14);
    _useLab.textColor = HEXCOLOR(0xff6339);
    [bgView addSubview:_useLab];
    
}


- (void)setModel:(CouponModel *)model{
    if (_model!= model) {
        _model = model;
    }
    self.priceLab.text = [NSString stringWithFormat:@"%@",_model.amount];
    self.introLab.text = [NSString stringWithFormat:@"%@",_model.tip];
    self.priLimitLab.text = [NSString stringWithFormat:@"%@",_model.bidAmount];
    self.infoLab.text = [NSString stringWithFormat:@"%@",_model.timeCount];
    self.timeLab.text = [NSString stringWithFormat:@"%@",_model.endDate];
    NSString *bagState= [NSString stringWithFormat:@"%@",_model.bagState];
    NSString *bagType= [NSString stringWithFormat:@"%@",_model.bagType];

    
    if (self.useIndex) {
        _imaView.image = [MSUPathTools showImageWithContentOfFileByName:@"jxq1_bg"];
    } else{
        if ([bagType isEqualToString:@"1"]) {
            _imaView.image = [MSUPathTools showImageWithContentOfFileByName:@"msuhb_bg"];
            _introLab.textColor = HEXCOLOR(0xff6339);
            _useLab.textColor = HEXCOLOR(0xF1B673);
        } else if ([bagType isEqualToString:@"0"] || [self.priceLab.text containsString:@"%"]){
            _imaView.image = [MSUPathTools showImageWithContentOfFileByName:@"jxq_bg"];
            _introLab.textColor = HEXCOLOR(0xE8C399);
            _useLab.textColor = HEXCOLOR(0xF1B673);
        }
    }
    
    
    
    if ([bagState isEqualToString:@"0"]) {
        self.whiteView.hidden = YES;
    } else{
        _introLab.textColor = HEXCOLOR(0xD1D1D1);
        _useLab.textColor = HEXCOLOR(0x454545);
        _useLab.text = @"已\n过\n期";
//        self.whiteView.hidden = NO;
//        self.whiteView.alpha = 0.5;
    }
    
//    if ([bagState isEqualToString:@"0"]) {
//        self.StateLabel.text = @"立即使用";
//        self.priLimitLab.textColor = [UIColor colorWithHex:0x666666];
//        self.introLab.textColor = [UIColor colorWithHex:0xB0B0B0];
//        self.timeLab.textColor = [UIColor colorWithHex:0xB0B0B0];
//        self.ColorView.backgroundColor = [UIColor colorWithHex:0xF26059];
//        self.StateLabel.textColor = [UIColor colorWithHex:0xF26059];
//    }else if([bagState isEqualToString:@"1"]){
//        self.StateLabel.text = @"已使用";
//        self.priLimitLab.textColor = [UIColor colorWithHex:0xD1D1D1];
//        self.introLab.textColor = [UIColor colorWithHex:0xD1D1D1];
//        self.timeLab.textColor = [UIColor colorWithHex:0xD1D1D1];
//        self.ColorView.backgroundColor = [UIColor colorWithHex:0xD1D1D1];
//        self.StateLabel.textColor = [UIColor colorWithHex:0xD1D1D1];
//    }else{
//        self.StateLabel.text = @"已过期";
//        self.priLimitLab.textColor = [UIColor colorWithHex:0xD1D1D1];
//        self.introLab.textColor = [UIColor colorWithHex:0xD1D1D1];
//        self.timeLab.textColor = [UIColor colorWithHex:0xD1D1D1];
//        self.ColorView.backgroundColor = [UIColor colorWithHex:0xD1D1D1];
//        self.StateLabel.textColor = [UIColor colorWithHex:0xD1D1D1];
//    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

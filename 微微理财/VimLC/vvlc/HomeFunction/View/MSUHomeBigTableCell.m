//
//  MSUHomeBigTableCell.m
//  vvlc
//
//  Created by 007 on 2018/1/11.
//  Copyright © 2018年 HM. All rights reserved.
//

#import "MSUHomeBigTableCell.h"
#import "MSUStringTools.h"
#import "MSUPathTools.h"

#define SelfWidth self.frame.size.width

@implementation MSUHomeBigTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createContentView];
    }
    return self;
}

- (void)createContentView{
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(12*kDeviceWidthScale, 0, kDeviceWidth-24*kDeviceWidthScale, 251.5*kDeviceHeightScale);
    bgView.backgroundColor = WhiteColor;
    //    _bg1View.layer.shouldRasterize = YES;
    //    _bg1View.layer.rasterizationScale = [UIScreen mainScreen].scale;
    bgView.layer.cornerRadius = 8;
    bgView.clipsToBounds = YES;
    [self addSubview:bgView];
    
    self.bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12*kDeviceWidthScale, 0, kDeviceWidth-24*kDeviceWidthScale, 251.5)];
    _bgImageView.image = [MSUPathTools showImageWithContentOfFileByName:@"qq-bg1"];
    [self addSubview:_bgImageView];
    _bgImageView.hidden = YES;
    
    UIView *_bg1View = [[UIView alloc] init];
    _bg1View.frame = CGRectMake(12*kDeviceWidthScale, 0, kDeviceWidth-24*kDeviceWidthScale, 251.5*kDeviceHeightScale);
    _bg1View.backgroundColor = [UIColor clearColor];
    //    _bg1View.layer.shouldRasterize = YES;
    //    _bg1View.layer.rasterizationScale = [UIScreen mainScreen].scale;
    _bg1View.layer.cornerRadius = 8;
    _bg1View.clipsToBounds = YES;
    [self addSubview:_bg1View];
    

    
    self.titLab = [[UILabel alloc] init];
    _titLab.frame = CGRectMake(0, 9*kDeviceHeightScale, kDeviceWidth-24*kDeviceWidthScale, 22.5*kDeviceHeightScale);
    _titLab.font = TEXTFONT(16);
    _titLab.textColor = titBlackColor;
    _titLab.textAlignment = NSTextAlignmentCenter;
    [_bg1View addSubview:_titLab];
    
    self.signImaView = [[UIImageView alloc] initWithFrame:CGRectMake(kDeviceWidth-50*kDeviceWidthScale, 0, 26*kDeviceWidthScale, 26*kDeviceWidthScale)];
    _signImaView.contentMode = UIViewContentModeScaleAspectFit;
    [_bg1View addSubview:_signImaView];
    
    self.incomeLab = [[UILabel alloc] init];
    _incomeLab.frame = CGRectMake(0, _titLab.bottom+31*kDeviceHeightScale, kDeviceWidth-24*kDeviceWidthScale, 45*kDeviceHeightScale);
    _incomeLab.textAlignment = NSTextAlignmentCenter;
    self.incomeLab.font = [UIFont fontWithName:@"DINAlternate-Bold" size:45];
    _incomeLab.textColor = titOrangeColor;
    [_bg1View addSubview:_incomeLab];
    
    self.introLab = [[UILabel alloc] init];
    _introLab.frame = CGRectMake(0, _incomeLab.bottom+5*kDeviceHeightScale, kDeviceWidth-24*kDeviceWidthScale, 18.5*kDeviceHeightScale);
    _introLab.textAlignment = NSTextAlignmentCenter;
    _introLab.font = TEXTFONT(13);
    _introLab.textColor = HEXCOLOR(0x4a4a4a);
    [_bg1View addSubview:_introLab];
    
    self.leftLab = [[UILabel alloc] init];
    _leftLab.clipsToBounds = YES;
    _leftLab.layer.cornerRadius = 3;
    _leftLab.layer.shouldRasterize = YES;
    _leftLab.layer.rasterizationScale = [UIScreen mainScreen].scale;
    _leftLab.layer.borderColor = HEXCOLOR(0xff6132).CGColor;
    _leftLab.layer.borderWidth = 1.0;
    _leftLab.font = TEXTFONT(12);
    _leftLab.textColor = HEXCOLOR(0xff6132);
    _leftLab.textAlignment = NSTextAlignmentCenter;
    [_bg1View addSubview:_leftLab];
    
    self.centerLab = [[UILabel alloc] init];
    _centerLab.clipsToBounds = YES;
    _centerLab.layer.cornerRadius = 3;
    _centerLab.layer.shouldRasterize = YES;
    _centerLab.layer.rasterizationScale = [UIScreen mainScreen].scale;
    _centerLab.layer.borderColor = HEXCOLOR(0xff6132).CGColor;
    _centerLab.layer.borderWidth = 1.0;
    _centerLab.font = TEXTFONT(12);
    _centerLab.textColor = HEXCOLOR(0xff6132);
    _centerLab.textAlignment = NSTextAlignmentCenter;
    [_bg1View addSubview:_centerLab];
    
    self.rightLab = [[UILabel alloc] init];
    _rightLab.clipsToBounds = YES;
    _rightLab.layer.cornerRadius = 3;
    _rightLab.layer.shouldRasterize = YES;
    _rightLab.layer.rasterizationScale = [UIScreen mainScreen].scale;
    _rightLab.layer.borderColor = HEXCOLOR(0xff6132).CGColor;
    _rightLab.layer.borderWidth = 1.0;
    _rightLab.font = TEXTFONT(12);
    _rightLab.textColor = HEXCOLOR(0xff6132);
    _rightLab.textAlignment = NSTextAlignmentCenter;
    [_bg1View addSubview:_rightLab];
    
    self.giveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _giveBtn.frame = CGRectMake((kDeviceWidth-24*kDeviceWidthScale)*0.5-106*kDeviceWidthScale, 191*kDeviceHeightScale, 212*kDeviceWidthScale, 34*kDeviceHeightScale);
//    [MSUPathTools drawGradientColorFromColorA:HEXCOLOR(0xffaa67) toColorB:HEXCOLOR(0xff5c39) WithView:_giveBtn];
    [MSUPathTools drawGradientColorFromColorA:HEXCOLOR(0xffaa67) toColorB:HEXCOLOR(0xff5c39) withView:_giveBtn isLeft:YES];
    _giveBtn.layer.cornerRadius = 34*kDeviceHeightScale*0.5;
    _giveBtn.clipsToBounds = YES;
    _giveBtn.layer.shouldRasterize = YES;
    _giveBtn.layer.rasterizationScale = [UIScreen mainScreen].scale;
    [_giveBtn setTitle:@"我要投资" forState:UIControlStateNormal];
    [_giveBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
    _giveBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_bg1View addSubview:_giveBtn];
    [_giveBtn addTarget:self action:@selector(giveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    
    NSString *teSt = [NSString stringWithFormat:@"%@",_dataDic[@"showName"]];
    if ([teSt containsString:@"微微宝"]) {
        teSt = @"微微宝";
    }
    _titLab.text = teSt;
    
    NSString *imaStr = [NSString stringWithFormat:@"%@",dataDic[@"rightImage"]];
    if (imaStr.length == 0) {
        _signImaView.hidden = YES;
    } else{
        _signImaView.hidden = NO;
        [_signImaView sd_setImageWithURL:[NSURL URLWithString:imaStr]];
    }
    
    NSString *origiStr = [NSString stringWithFormat:@"%@ %@",_dataDic[@"realInterest"],_dataDic[@"addInterest"]];
    _incomeLab.attributedText = [MSUStringTools makeKeyWordAttributedWithSubText:_dataDic[@"addInterest"] textA:@"%" textB:@"" textC:@"" inOrigiText:origiStr font:23 color:lightOrangeColor];

    _introLab.text = [NSString stringWithFormat:@"%@",_dataDic[@"disExpectedRevenue"]];
    
    NSString *str =  [NSString stringWithFormat:@"%@",_dataDic[@"disGetMoney"]];
    if (str.length == 0) {
        str = @"随存随取";
    }
    _centerLab.text = str;
    CGSize sizee = [MSUStringTools danamicGetWidthFromText:_centerLab.text WithFont:12];
    _centerLab.frame = CGRectMake((kDeviceWidth-24*kDeviceWidthScale)*0.5-sizee.width*0.5, _introLab.bottom+21, sizee.width+5, 19*kDeviceHeightScale);
    
    _leftLab.text = [NSString stringWithFormat:@"%@",_dataDic[@"disLimit"]];
    CGSize sizeqw = [MSUStringTools danamicGetWidthFromText:_leftLab.text WithFont:12];
    _leftLab.frame = CGRectMake(_centerLab.left-9-sizeqw.width-5, _centerLab.top, sizeqw.width+5, 19*kDeviceHeightScale);

    _rightLab.text = [NSString stringWithFormat:@"%@",_dataDic[@"disStartMoney"]];
    CGSize sizeqaa = [MSUStringTools danamicGetWidthFromText:_rightLab.text WithFont:12];
    _rightLab.frame = CGRectMake(_centerLab.right+9, _centerLab.top, sizeqaa.width+5, 19*kDeviceHeightScale);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)giveBtnClick:(UIButton *)sender{
    if (self.giveBtnClick) {
        self.giveBtnClick(sender);
    }
}



@end

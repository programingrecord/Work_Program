//
//  MSUHuoQiTableCell.m
//  vvlc
//
//  Created by 007 on 2018/1/11.
//  Copyright © 2018年 HM. All rights reserved.
//

#import "MSUHuoQiTableCell.h"

#import "MSUStringTools.h"
#import "MSUPathTools.h"

#define SelfWidth self.frame.size.width


@implementation MSUHuoQiTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createContentView];
    }
    return self;
}

- (void)createContentView{
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(0, 0, kDeviceWidth, 165*kDeviceHeightScale);
    bgView.backgroundColor = WhiteColor;
//    bgView.layer.shouldRasterize = YES;
//    bgView.layer.rasterizationScale = [UIScreen mainScreen].scale;
//    bgView.layer.cornerRadius = 10;
//    bgView.clipsToBounds = YES;
    [self addSubview:bgView];
    
    UIImageView *imaView = [[UIImageView alloc] initWithFrame:CGRectMake(10*kDeviceWidthScale, 11*kDeviceHeightScale,kDeviceWidth-20*kDeviceWidthScale, 143*kDeviceHeightScale)];
    imaView.image = [MSUPathTools showImageWithContentOfFileByName:@"Group16"];
    [bgView addSubview:imaView];
    
//    self.titLab = [[UILabel alloc] init];
//    _titLab.font = TEXTFONT(25);
//    _titLab.textColor = WhiteColor;
//    [bgView addSubview:_titLab];
//    
    self.mlbImaView = [[UIImageView alloc] initWithFrame:CGRectMake(21.5, 14*kDeviceHeightScale, 70, 36*kDeviceHeightScale)];
    _mlbImaView.image = [MSUPathTools showImageWithContentOfFileByName:@"mlbmsu"];
    _mlbImaView.contentMode = UIViewContentModeScaleAspectFit;
    _mlbImaView.layer.shadowColor = HEXCOLOR(0xf46536).CGColor;
    _mlbImaView.layer.shadowOffset = CGSizeMake(0, 0);
    _mlbImaView.layer.shadowRadius = 4;
    _mlbImaView.layer.shadowOpacity = 1;
    [bgView addSubview:_mlbImaView];
    
    self.leftTitLab = [[UILabel alloc] init];
    _leftTitLab.font = TEXTFONT(10);
    _leftTitLab.textColor = HEXCOLOR(0xFF703F);
    _leftTitLab.backgroundColor = WhiteColor;
    _leftTitLab.clipsToBounds = YES;
    _leftTitLab.layer.cornerRadius = 3;
    _leftTitLab.layer.shouldRasterize = YES;
    _leftTitLab.layer.rasterizationScale = [UIScreen mainScreen].scale;
    _leftTitLab.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:_leftTitLab];
    
    self.rightTitLab = [[UILabel alloc] init];
    _rightTitLab.font = TEXTFONT(10);
    _rightTitLab.textColor = HEXCOLOR(0xFF703F);
    _rightTitLab.backgroundColor = WhiteColor;
    _rightTitLab.clipsToBounds = YES;
    _rightTitLab.layer.cornerRadius = 3;
    _rightTitLab.layer.shouldRasterize = YES;
    _rightTitLab.layer.rasterizationScale = [UIScreen mainScreen].scale;
    _rightTitLab.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:_rightTitLab];
    
    self.signImaView = [[UIImageView alloc] initWithFrame:CGRectMake(kDeviceWidth-65*kDeviceWidthScale, 11*kDeviceHeightScale, 55*kDeviceWidthScale, 55*kDeviceWidthScale)];
    _signImaView.contentMode = UIViewContentModeScaleAspectFit;
    _signImaView.image = [MSUPathTools showImageWithContentOfFileByName:@"rmjb"];
    [bgView addSubview:_signImaView];
    
    self.incomeLab = [[UILabel alloc] init];
    self.incomeLab.font = [UIFont fontWithName:@"DINAlternate-Bold" size:34];
    _incomeLab.textColor = WhiteColor;
    [bgView addSubview:_incomeLab];
    
    self.introLab = [[UILabel alloc] init];
    _introLab.font = TEXTFONT(15);
    _introLab.textColor = WhiteColor;
    [bgView addSubview:_introLab];
    
    self.yearIncomeLab = [[UILabel alloc] init];
    _yearIncomeLab.font = TEXTFONT(13);
    _yearIncomeLab.textColor = [UIColor colorWithHex:0xffffff alpha:0.5];
    [bgView addSubview:_yearIncomeLab];
    
    self.dayIncome = [[UILabel alloc] init];
    _dayIncome.font = TEXTFONT(13);
    _dayIncome.textColor = [UIColor colorWithHex:0xffffff alpha:0.5];
    [bgView addSubview:_dayIncome];
    
    self.giveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _giveBtn.frame = CGRectMake((kDeviceWidth-20*kDeviceWidthScale)-109*kDeviceWidthScale, 80*kDeviceHeightScale, 95*kDeviceWidthScale, 40*kDeviceHeightScale);
    _giveBtn.backgroundColor = [UIColor colorWithHex:0xffffff alpha:1];
//    [MSUPathTools drawGradientColorFromColorA:HEXCOLOR(0xffaa67) toColorB:HEXCOLOR(0xff5c39) withView:_giveBtn isLeft:YES];
    _giveBtn.layer.cornerRadius = 40*kDeviceHeightScale*0.5;
    _giveBtn.clipsToBounds = YES;
    _giveBtn.layer.shouldRasterize = YES;
    _giveBtn.layer.rasterizationScale = [UIScreen mainScreen].scale;
    [_giveBtn setTitle:@"立即加入" forState:UIControlStateNormal];
    [_giveBtn setTitleColor:HEXCOLOR(0x050505) forState:UIControlStateNormal];
    _giveBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [bgView addSubview:_giveBtn];
    [_giveBtn addTarget:self action:@selector(giveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setLoanModel:(loanModel *)loanModel{
    _loanModel = loanModel;
    
//    _titLab.text = loanModel.borrowTypeOther;
//    CGSize sizea = [MSUStringTools danamicGetWidthFromText:_titLab.text WithFont:25];
//    _titLab.frame = CGRectMake(32*kDeviceWidthScale, 25*kDeviceHeightScale, sizea.width, 36*kDeviceHeightScale);
    _mlbImaView.frame = CGRectMake(31, 28*kDeviceHeightScale, 70, 36*kDeviceHeightScale);
    
    NSString *imaStr = _loanModel.signImage;
    if (imaStr.length == 0) {
        _signImaView.hidden = YES;
    } else{
        _signImaView.hidden = NO;
        [_signImaView sd_setImageWithURL:[NSURL URLWithString:imaStr]];
    }
    
    NSString *leftStr = [NSString stringWithFormat:@"%@",_loanModel.leftTittle];
    NSString *rigntStr = [NSString stringWithFormat:@"%@",_loanModel.rightTittle];
    
    _leftTitLab.hidden = NO;
    _rightTitLab.hidden = NO;
    if (leftStr.length > 0 && rigntStr.length > 0) {
        _leftTitLab.text = leftStr;
        CGSize sizeb = [MSUStringTools danamicGetWidthFromText:_leftTitLab.text WithFont:10];
        _leftTitLab.frame = CGRectMake(_mlbImaView.right+10*kDeviceWidthScale, 38*kDeviceHeightScale, sizeb.width+10, 19*kDeviceHeightScale);
        
        _rightTitLab.text = rigntStr;
        CGSize sizec = [MSUStringTools danamicGetWidthFromText:_rightTitLab.text WithFont:10];
        _rightTitLab.frame = CGRectMake(_leftTitLab.right+10*kDeviceWidthScale, 38*kDeviceHeightScale, sizec.width+10, 19*kDeviceHeightScale);
    } else if (leftStr.length == 0 && rigntStr.length == 0){
        _leftTitLab.hidden = YES;
        _rightTitLab.hidden = YES;
    } else if ((leftStr.length == 0 && rigntStr.length > 0) || (leftStr.length > 0 && rigntStr.length == 0)){
        NSString *str ;
        if (leftStr.length > 0) {
            str = leftStr;
        } else{
            str = rigntStr;
        }
        _leftTitLab.text = str;
        CGSize sizeb = [MSUStringTools danamicGetWidthFromText:_leftTitLab.text WithFont:11];
        _leftTitLab.frame = CGRectMake(_titLab.right+10*kDeviceWidthScale, 38*kDeviceHeightScale, sizeb.width+10, 19*kDeviceHeightScale);
        
        _rightTitLab.hidden = YES;
    }
    
    _incomeLab.attributedText = [MSUStringTools makeKeyWordAttributedWithSubText:@"%" inOrigiText:[NSString stringWithFormat:@"%@%%",_loanModel.rate] font:20 color:WhiteColor];
    CGSize sized = [MSUStringTools danamicGetWidthFromText:_incomeLab.text WithFont:32];
    _incomeLab.frame = CGRectMake(31.5*kDeviceWidthScale, _mlbImaView.bottom+6*kDeviceHeightScale, sized.width, 45*kDeviceHeightScale);

    _introLab.text = _loanModel.currentTip2;
    CGSize sizee = [MSUStringTools danamicGetWidthFromText:_introLab.text WithFont:15];
    _introLab.frame = CGRectMake(150*kDeviceWidthScale, _mlbImaView.bottom+24*kDeviceHeightScale, sizee.width, 21*kDeviceHeightScale);
    
    _yearIncomeLab.text = @"预期年化收益率";
    CGSize sizef = [MSUStringTools danamicGetWidthFromText:_yearIncomeLab.text WithFont:13];
    _yearIncomeLab.frame = CGRectMake(_incomeLab.left+1, _incomeLab.bottom+1*kDeviceHeightScale, sizef.width, 18.5*kDeviceHeightScale);

    _dayIncome.text = _loanModel.dayIncome.length>0 ? _loanModel.dayIncome : @"天天赚收益";
    CGSize size12 = [MSUStringTools danamicGetWidthFromText:_dayIncome.text WithFont:13];
    _dayIncome.frame = CGRectMake(_introLab.left+1, _incomeLab.bottom+1*kDeviceHeightScale, size12.width, 18.5*kDeviceHeightScale);

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

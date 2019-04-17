//
//  MSUHomeTableCell.m
//  vvlc
//
//  Created by 007 on 2018/1/11.
//  Copyright © 2018年 HM. All rights reserved.
//

#import "MSUHomeTableCell.h"
#import "MSUStringTools.h"
#import "MSUPathTools.h"

@implementation MSUHomeTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createContentView];
    }
    return self;
}

- (void)createContentView{

    self.bg1View = [[UIView alloc] init];
    _bg1View.frame = CGRectMake(15*kDeviceWidthScale, 0, kDeviceWidth-30, 135*kDeviceHeightScale);
    _bg1View.backgroundColor = WhiteColor;
    _bg1View.layer.shouldRasterize = YES;
    _bg1View.layer.rasterizationScale = [UIScreen mainScreen].scale;
    _bg1View.layer.cornerRadius = 9;
    _bg1View.clipsToBounds = YES;
    [self addSubview:_bg1View];
    
    self.titLab = [[UILabel alloc] init];
    _titLab.font = TEXTFONT(14);
    _titLab.textColor = titBlackColor;
    [_bg1View addSubview:_titLab];
    
    self.leftTitLab = [[UILabel alloc] init];
    _leftTitLab.font = TEXTFONT(11);
    _leftTitLab.textColor = WhiteColor;
    _leftTitLab.backgroundColor = BGBlueColor;
    _leftTitLab.clipsToBounds = YES;
    _leftTitLab.layer.cornerRadius = 3;
    _leftTitLab.layer.shouldRasterize = YES;
    _leftTitLab.layer.rasterizationScale = [UIScreen mainScreen].scale;
    _leftTitLab.textAlignment = NSTextAlignmentCenter;
    [_bg1View addSubview:_leftTitLab];
 
    self.rightTitLab = [[UILabel alloc] init];
    _rightTitLab.font = TEXTFONT(11);
    _rightTitLab.textColor = WhiteColor;
    _rightTitLab.backgroundColor = BGBlueColor;
    _rightTitLab.clipsToBounds = YES;
    _rightTitLab.layer.cornerRadius = 3;
    _rightTitLab.layer.shouldRasterize = YES;
    _rightTitLab.layer.rasterizationScale = [UIScreen mainScreen].scale;
    _rightTitLab.textAlignment = NSTextAlignmentCenter;
    [_bg1View addSubview:_rightTitLab];
    
    self.bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kDeviceWidth - 24*kDeviceWidthScale-93.5*kDeviceWidthScale, 37*kDeviceHeightScale, 93.5*kDeviceWidthScale, 73*kDeviceHeightScale)];
    _bgImageView.contentMode = UIViewContentModeScaleToFill;;
    _bgImageView.image = [MSUPathTools showImageWithContentOfFileByName:@"CombinedShaped"];
    [_bg1View addSubview:_bgImageView];
    
    self.signImaView = [[UIImageView alloc] initWithFrame:CGRectMake(kDeviceWidth-64*kDeviceWidthScale, 0*kDeviceHeightScale, 34*kDeviceWidthScale, 34*kDeviceWidthScale)];
    _signImaView.contentMode = UIViewContentModeScaleAspectFit;
    [_bg1View addSubview:_signImaView];
    
    self.incomeLab = [[UILabel alloc] init];
    self.incomeLab.font = [UIFont fontWithName:@"DINAlternate-Bold" size:36];
    _incomeLab.textColor = titOrangeColor;
    [_bg1View addSubview:_incomeLab];
    
    self.introLab = [[UILabel alloc] init];
    self.introLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    _introLab.textColor = HEXCOLOR(0x2a2a2a);
    _introLab.textAlignment = NSTextAlignmentCenter;
    [_bg1View addSubview:_introLab];
    
    self.statusImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kDeviceWidth - 36*kDeviceWidthScale-60*kDeviceWidthScale, 37*kDeviceHeightScale, 60*kDeviceWidthScale, 60*kDeviceWidthScale)];
    _statusImageView.contentMode = UIViewContentModeScaleToFill;;
    [_bg1View addSubview:_statusImageView];
    _statusImageView.hidden = YES;
    
    self.yearIncomeLab = [[UILabel alloc] init];
    _yearIncomeLab.font = TEXTFONT(13);
    _yearIncomeLab.textColor = HEXCOLOR(0x616161);
    _yearIncomeLab.textAlignment = NSTextAlignmentCenter;
    [_bg1View addSubview:_yearIncomeLab];
    
    self.dayIncomeLab = [[UILabel alloc] init];
    _dayIncomeLab.font = TEXTFONT(13);
    _dayIncomeLab.textColor = HEXCOLOR(0xb0b0b0);
    _dayIncomeLab.textAlignment = NSTextAlignmentCenter;
    [_bg1View addSubview:_dayIncomeLab];
    
    self.leftAmountLab = [[UILabel alloc] init];
    _leftAmountLab.font = TEXTFONT(16);
    _leftAmountLab.textColor = HEXCOLOR(0x000000);
    _leftAmountLab.textAlignment = NSTextAlignmentCenter;
    [_bg1View addSubview:_leftAmountLab];
    
    self.leftIntroLab = [[UILabel alloc] init];
    _leftIntroLab.font = TEXTFONT(13);
    _leftIntroLab.textColor = HEXCOLOR(0xb0b0b0);
    _leftIntroLab.textAlignment = NSTextAlignmentCenter;
    [_bg1View addSubview:_leftIntroLab];
    
    self.ProssView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    _ProssView.frame = CGRectMake(0, 133*kDeviceHeightScale, kDeviceWidth, 2*kDeviceHeightScale);
    [_bg1View addSubview:_ProssView];
    _ProssView.trackTintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
    _ProssView.progressTintColor = HEXCOLOR(0xf78d7d);
    //设置进度
    //    _processView.progress = 0.2;
    
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(14*kDeviceWidthScale, 135*kDeviceHeightScale, kDeviceWidth-28*kDeviceWidthScale, 8*kDeviceHeightScale);
    bgView.backgroundColor = BGWhiteColor;
    [self addSubview:bgView];
}

- (void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    
    NSString *sre = [NSString stringWithFormat:@"%@",_dataDic[@"showName"]];
    NSString *teSt;
    if ([sre rangeOfString:@"编"].location > 20) {
        teSt = sre;
    } else{
        teSt = [sre substringToIndex:[sre rangeOfString:@"编"].location-1];
    }
    
    if ([teSt containsString:@"微微宝"]) {
        teSt = @"微微宝";
    }
    
    _titLab.text = teSt;
    CGSize sizea = [MSUStringTools danamicGetWidthFromText:_titLab.text WithFont:14];
    _titLab.frame = CGRectMake(24*kDeviceWidthScale, 15.5*kDeviceHeightScale, sizea.width, 22.5*kDeviceHeightScale);
    
    NSString *leftStr = [NSString stringWithFormat:@"%@",_dataDic[@"leftTit"]];
    NSString *rigntStr = [NSString stringWithFormat:@"%@",_dataDic[@"rightTit"]];
    
    _leftTitLab.hidden = NO;
    _rightTitLab.hidden = NO;
    if (leftStr.length > 0 && rigntStr.length > 0) {
        _leftTitLab.text = leftStr;
        CGSize sizeb = [MSUStringTools danamicGetWidthFromText:_leftTitLab.text WithFont:11];
        _leftTitLab.frame = CGRectMake(_titLab.right+10*kDeviceWidthScale, 19*kDeviceHeightScale, sizeb.width+5, 15*kDeviceHeightScale);
        
        _rightTitLab.text = rigntStr;
        CGSize sizec = [MSUStringTools danamicGetWidthFromText:_rightTitLab.text WithFont:11];
        _rightTitLab.frame = CGRectMake(_leftTitLab.right+10*kDeviceWidthScale, 19*kDeviceHeightScale, sizec.width+5, 15*kDeviceHeightScale);
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
        _leftTitLab.frame = CGRectMake(_titLab.right+10*kDeviceWidthScale, 19*kDeviceHeightScale, sizeb.width+5, 15*kDeviceHeightScale);
        
        _rightTitLab.hidden = YES;
    }
    
    
    
//    NSString *bgIma = _dataDic[@"bgImage"];
//    if (bgIma.length > 0) {
//        _bgImageView.hidden = NO;
//        [_bgImageView sd_setImageWithURL:[NSURL URLWithString:bgIma]];
//    } else{
//        _bgImageView.hidden = YES;
//    }
    
    NSString *imaStr = [NSString stringWithFormat:@"%@",_dataDic[@"rightImage"]];
    if (imaStr.length > 0) {
        _signImaView.hidden = NO;
        [_signImaView sd_setImageWithURL:[NSURL URLWithString:imaStr]];
    } else{
        _signImaView.hidden = YES;
    }
    
    NSString *stateStr = [NSString stringWithFormat:@"%@",_dataDic[@"borrowState"]];
    if ([stateStr isEqualToString:@"还款中"]) {
        _statusImageView.hidden = NO;
        _statusImageView.image = [MSUPathTools showImageWithContentOfFileByName:@"hkz"];
    } else if ([stateStr isEqualToString:@"已还清"]){
        _statusImageView.hidden = NO;
        _statusImageView.image = [MSUPathTools showImageWithContentOfFileByName:@"yhq"];
    } else{
        _statusImageView.hidden = YES;
    }
    
    NSString *origiStr = [NSString stringWithFormat:@"%@ %@",_dataDic[@"realInterest"],_dataDic[@"addInterest"]];
    _incomeLab.attributedText = [MSUStringTools makeKeyWordAttributedWithSubText:_dataDic[@"addInterest"] inOrigiText:origiStr font:18 color:lightOrangeColor];
    CGSize sized = [MSUStringTools danamicGetWidthFromText:_incomeLab.text WithFont:36];
    _incomeLab.frame = CGRectMake(_titLab.left, _titLab.bottom+12.5*kDeviceHeightScale, sized.width, 50*kDeviceHeightScale);
    
    _introLab.text = [NSString stringWithFormat:@"%@",_dataDic[@"disGetMoney"]];
    CGSize sizee = [MSUStringTools danamicGetWidthFromText:_introLab.text WithFont:16];
    _introLab.frame = CGRectMake(kDeviceWidth*0.5-(sizee.width+5)*0.5, _titLab.bottom+35.5*kDeviceHeightScale, sizee.width+5, 22.5*kDeviceHeightScale);
    
    _yearIncomeLab.text = [NSString stringWithFormat:@"%@",_dataDic[@"disExpectedRevenue"]];
    CGSize sizef = [MSUStringTools danamicGetWidthFromText:_yearIncomeLab.text WithFont:13];
    _yearIncomeLab.frame = CGRectMake(_titLab.left, _incomeLab.bottom+0*kDeviceHeightScale, sizef.width, 18.5*kDeviceHeightScale);
    
    _dayIncomeLab.text = [NSString stringWithFormat:@"%@",@"期限7天"];
    CGSize sizeg = [MSUStringTools danamicGetWidthFromText:_dayIncomeLab.text WithFont:13];
    _dayIncomeLab.frame = CGRectMake(kDeviceWidth*0.5-(sizeg.width)*0.5, _yearIncomeLab.top, sizeg.width, 18.5*kDeviceHeightScale);
    
    _leftAmountLab.text = [NSString stringWithFormat:@"%@",_dataDic[@"leftAmount"]];
    CGSize sizeaaa = [MSUStringTools danamicGetWidthFromText:_leftAmountLab.text WithFont:16];
    _leftAmountLab.frame = CGRectMake(kDeviceWidth*0.75-(sizeaaa.width)*0.5, _introLab.top, sizeaaa.width, 22.5*kDeviceHeightScale);
    
    _leftIntroLab.text = [NSString stringWithFormat:@"%@",@"剩余可投(元)"];
    CGSize sizexxx = [MSUStringTools danamicGetWidthFromText:_leftIntroLab.text WithFont:13];
    _leftIntroLab.frame = CGRectMake(kDeviceWidth*0.75-(sizexxx.width)*0.5, _dayIncomeLab.top, sizexxx.width, 18.5*kDeviceHeightScale);
    
    _ProssView.hidden = NO;
    NSString *str = [NSString stringWithFormat:@"%@",_dataDic[@"completePercent"]];
    if ([str containsString:@"%"]) {
        str = [str substringToIndex:str.length-1];
    }
    _ProssView.progress = str.doubleValue/100.00;
}

- (void)setLoanModel:(loanModel *)loanModel{
    _loanModel = loanModel;
    
    _titLab.text = _loanModel.title;
    CGSize sizea = [MSUStringTools danamicGetWidthFromText:_titLab.text WithFont:14];
    _titLab.frame = CGRectMake(20*kDeviceWidthScale, 10*kDeviceHeightScale, sizea.width, 16*kDeviceHeightScale);
    
    _leftTitLab.hidden = YES;
    _rightTitLab.hidden = YES;
    
    NSString *imaStr = _loanModel.rigntImage;
    if (imaStr.length > 0) {
        _signImaView.hidden = YES;
    } else{
        _signImaView.hidden = NO;
        [_signImaView sd_setImageWithURL:[NSURL URLWithString:imaStr]];
    }
    
    NSString *stateStr = _loanModel.borrowState;
    if ([stateStr isEqualToString:@"还款中"]) {
        _statusImageView.hidden = NO;
        _statusImageView.image = [MSUPathTools showImageWithContentOfFileByName:@"hkz"];
    } else if ([stateStr isEqualToString:@"已还清"]){
        _statusImageView.hidden = NO;
        _statusImageView.image = [MSUPathTools showImageWithContentOfFileByName:@"yhq"];
    } else{
        _statusImageView.hidden = YES;
    }
    
    if (_loanModel.AddInterest.length > 0) {
        NSString *origiStr = [NSString stringWithFormat:@"%@%@",_loanModel.rate,_loanModel.AddInterest];
        _incomeLab.attributedText = [MSUStringTools makeKeyWordAttributedWithSubText:_loanModel.AddInterest inOrigiText:origiStr font:18 color:lightOrangeColor];
    } else{
        _incomeLab.text = _loanModel.rate;
    }
    CGSize sized = [MSUStringTools danamicGetWidthFromText:_incomeLab.text WithFont:27];
    _incomeLab.frame = CGRectMake(_titLab.left, _titLab.bottom+16*kDeviceHeightScale, sized.width, 27*kDeviceHeightScale);
    
    _introLab.text = _loanModel.timeCount;
    CGSize sizee = [MSUStringTools danamicGetWidthFromText:_introLab.text WithFont:18];
    _introLab.frame = CGRectMake(193*kDeviceWidthScale, _titLab.bottom+21*kDeviceHeightScale, sizee.width, 18*kDeviceHeightScale);
    
    _yearIncomeLab.text = @"预期年化收益率";
    CGSize sizef = [MSUStringTools danamicGetWidthFromText:_yearIncomeLab.text WithFont:13];
    _yearIncomeLab.frame = CGRectMake(_titLab.left, _incomeLab.bottom+8*kDeviceHeightScale, sizef.width, 13*kDeviceHeightScale);
    
    _dayIncomeLab.text = loanModel.currentTip1;
    CGSize sizeg = [MSUStringTools danamicGetWidthFromText:_dayIncomeLab.text WithFont:13];
    _dayIncomeLab.frame = CGRectMake(_introLab.left, _yearIncomeLab.top, sizeg.width, 13*kDeviceHeightScale);
    
    _ProssView.hidden = NO;
    _ProssView.progress = _loanModel.completePercent.doubleValue/100.00;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

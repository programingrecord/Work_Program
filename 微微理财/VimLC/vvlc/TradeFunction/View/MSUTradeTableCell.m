//
//  MSUTradeTableCell.m
//  vvlc
//
//  Created by 007 on 2018/5/25.
//  Copyright © 2018年 HM. All rights reserved.
//

#import "MSUTradeTableCell.h"

#import "MSUStringTools.h"
#import "MSUPathTools.h"
#import <SDWebImageManager.h>

@implementation MSUTradeTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createContentView];
    }
    return self;
}

- (void)createContentView{
    self.bg1View = [[UIView alloc] init];
    _bg1View.frame = CGRectMake(10*kDeviceWidthScale, 0, kDeviceWidth-20*kDeviceWidthScale, 120*kDeviceHeightScale);
    _bg1View.backgroundColor = WhiteColor;
    _bg1View.layer.shouldRasterize = YES;
    _bg1View.layer.rasterizationScale = [UIScreen mainScreen].scale;
    _bg1View.layer.cornerRadius = 8;
//    _bg1View.clipsToBounds = YES;
    _bg1View.layer.shadowColor = HEXCOLOR(0xcccccc).CGColor;
    _bg1View.layer.shadowOffset = CGSizeMake(0, 0);
    _bg1View.layer.shadowRadius = 4;
    _bg1View.layer.shadowOpacity = 1;
    [self addSubview:_bg1View];
   
    
    self.signImaView = [[UIImageView alloc] initWithFrame:CGRectMake(kDeviceWidth-46*kDeviceWidthScale, 0, 26*kDeviceWidthScale, 26*kDeviceWidthScale)];
    _signImaView.contentMode = UIViewContentModeScaleAspectFit;
    [_bg1View addSubview:_signImaView];
    
    self.titLab = [[UILabel alloc] init];
    _titLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    _titLab.textColor = titBlackColor;
    [_bg1View addSubview:_titLab];
    
    self.leftTitLab = [[UILabel alloc] init];
    _leftTitLab.font = TEXTFONT(9);
    _leftTitLab.textColor = WhiteColor;
    _leftTitLab.backgroundColor = HEXCOLOR(0x6982FF);
    _leftTitLab.clipsToBounds = YES;
    _leftTitLab.layer.cornerRadius = 4;
    _leftTitLab.layer.shouldRasterize = YES;
    _leftTitLab.layer.rasterizationScale = [UIScreen mainScreen].scale;
    _leftTitLab.textAlignment = NSTextAlignmentCenter;
    [_bg1View addSubview:_leftTitLab];
    
    self.rightTitLab = [[UILabel alloc] init];
    _rightTitLab.font = TEXTFONT(9);
    _rightTitLab.textColor = WhiteColor;
    _rightTitLab.backgroundColor = HEXCOLOR(0x6982FF);
    _rightTitLab.clipsToBounds = YES;
    _rightTitLab.layer.cornerRadius = 4;
    _rightTitLab.layer.shouldRasterize = YES;
    _rightTitLab.layer.rasterizationScale = [UIScreen mainScreen].scale;
    _rightTitLab.textAlignment = NSTextAlignmentCenter;
    [_bg1View addSubview:_rightTitLab];
    
    self.bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kDeviceWidth - 24*kDeviceWidthScale-93.5*kDeviceWidthScale, 37*kDeviceHeightScale, 93.5*kDeviceWidthScale, 73*kDeviceHeightScale)];
    _bgImageView.contentMode = UIViewContentModeScaleToFill;;
    _bgImageView.image = [MSUPathTools showImageWithContentOfFileByName:@"CombinedShaped"];
    [_bg1View addSubview:_bgImageView];
    
    self.incomeLab = [[UILabel alloc] init];
    self.incomeLab.font = [UIFont fontWithName:@"DINAlternate-Bold" size:32];
    _incomeLab.textColor = HEXCOLOR(0xFF6339);
    [_bg1View addSubview:_incomeLab];
    
    self.introLab = [[UILabel alloc] init];
    self.introLab.font = [UIFont fontWithName:@"DINAlternate-Bold" size:16];
    _introLab.textColor = HEXCOLOR(0x000000);
    [_bg1View addSubview:_introLab];
    
    self.statusImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kDeviceWidth - 36*kDeviceWidthScale-60*kDeviceWidthScale, 37*kDeviceHeightScale, 60*kDeviceWidthScale, 60*kDeviceWidthScale)];
    _statusImageView.contentMode = UIViewContentModeScaleToFill;;
    [_bg1View addSubview:_statusImageView];
    _statusImageView.hidden = YES;
    
    self.yearIncomeLab = [[UILabel alloc] init];
    _yearIncomeLab.font = TEXTFONT(12);
    _yearIncomeLab.textColor = HEXCOLOR(0xB0B0B0);
    [_bg1View addSubview:_yearIncomeLab];
    
    self.dayIncomeLab = [[UILabel alloc] init];
    _dayIncomeLab.font = TEXTFONT(12);
    _dayIncomeLab.textColor = HEXCOLOR(0xB0B0B0);
    [_bg1View addSubview:_dayIncomeLab];
    
    self.leftAmount = [[UILabel alloc] init];
    self.leftAmount.font = [UIFont fontWithName:@"DINAlternate-Bold" size:16];
    _leftAmount.textColor = HEXCOLOR(0x000000);
    [_bg1View addSubview:_leftAmount];
    
    self.leftIntro = [[UILabel alloc] init];
    _leftIntro.font = TEXTFONT(12);
    _leftIntro.textColor = HEXCOLOR(0xB0B0B0);
    [_bg1View addSubview:_leftIntro];

    
    self.ProssView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    _ProssView.frame = CGRectMake(4, 118*kDeviceHeightScale, kDeviceWidth-20*kDeviceWidthScale-8, 2*kDeviceHeightScale);
    [_bg1View addSubview:_ProssView];
    _ProssView.trackTintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
    _ProssView.progressTintColor = HEXCOLOR(0xf78d7d);
    //设置进度
    //    _processView.progress = 0.2;
    
//   self.bgView = [[UIView alloc] init];
//    _bgView.frame = CGRectMake(10*kDeviceWidthScale, 120*kDeviceHeightScale, kDeviceWidth-20*kDeviceWidthScale, 10*kDeviceHeightScale);
//    _bgView.backgroundColor = BGWhiteColor;
//    [self addSubview:_bgView];
    

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
    CGSize sizea = [MSUStringTools danamicGetWidthFromText:_titLab.text WithFont:15];
    _titLab.frame = CGRectMake(15, 17*kDeviceHeightScale, sizea.width+10, 21*kDeviceHeightScale);
    
    NSString *leftStr = [NSString stringWithFormat:@"%@",_dataDic[@"leftTit"]];
    NSString *rigntStr = [NSString stringWithFormat:@"%@",_dataDic[@"rightTit"]];
    
    _leftTitLab.hidden = NO;
    _rightTitLab.hidden = NO;
    if (leftStr.length > 0 && rigntStr.length > 0) {
        _leftTitLab.text = leftStr;
        CGSize sizeb = [MSUStringTools danamicGetWidthFromText:_leftTitLab.text WithFont:11];
        _leftTitLab.frame = CGRectMake(_titLab.right+7*kDeviceWidthScale, 17*kDeviceHeightScale, sizeb.width+5, 20*kDeviceHeightScale);
        
        _rightTitLab.text = rigntStr;
        CGSize sizec = [MSUStringTools danamicGetWidthFromText:_rightTitLab.text WithFont:11];
        _rightTitLab.frame = CGRectMake(_leftTitLab.right+7*kDeviceWidthScale, 17*kDeviceHeightScale, sizec.width+5, 20*kDeviceHeightScale);
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
        _leftTitLab.frame = CGRectMake(_titLab.right+7*kDeviceWidthScale, 17*kDeviceHeightScale, sizeb.width+5, 20*kDeviceHeightScale);
        
        _rightTitLab.hidden = YES;
    }
    
    //    NSString *bgIma = _dataDic[@"bgImage"];
    //    if (bgIma.length > 0) {
    //        _bgImageView.hidden = NO;
    //        [_bgImageView sd_setImageWithURL:[NSURL URLWithString:bgIma]];
    //    } else{
    //        _bgImageView.hidden = YES;
    //    }
    


    
    NSString *stateStr = [NSString stringWithFormat:@"%@",_dataDic[@"borrowState"]];
    _incomeLab.textColor = HEXCOLOR(0xB0B0B0);
    _introLab.textColor = HEXCOLOR(0xB0B0B0);
    _leftAmount.textColor = HEXCOLOR(0xB0B0B0);
    _titLab.textColor = HEXCOLOR(0xB0B0B0);
    _leftTitLab.backgroundColor = HEXCOLOR(0xD8D8D8);
    _rightTitLab.backgroundColor = HEXCOLOR(0xD8D8D8);
    
    NSString *imaStr = [NSString stringWithFormat:@"%@",_dataDic[@"rightImage"]];
//    if (imaStr.length > 0) {
//        _signImaView.hidden = NO;
//        if ([stateStr isEqualToString:@"招标中"]) {
//            [_signImaView sd_setImageWithURL:[NSURL URLWithString:imaStr] placeholderImage:[MSUPathTools showImageWithContentOfFileByName:@"bkjba"]];
//        } else{
//            [_signImaView sd_setImageWithURL:[NSURL URLWithString:imaStr] placeholderImage:[MSUPathTools showImageWithContentOfFileByName:@"bkjb"]];
//        }
//    } else{
//        _signImaView.hidden = YES;
//    }
    
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:imaStr] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        if (image && finished) {
            // do something with image
            
            if ([stateStr isEqualToString:@"招标中"]) {
                [_signImaView sd_setImageWithURL:[NSURL URLWithString:imaStr] placeholderImage:[MSUPathTools showImageWithContentOfFileByName:@"bkjba"]];
            } else {
//                _signImaView.image = [MSUPathTools grayscale:image type:1];
                _signImaView.image = [MSUPathTools whiteBlackImageWithImage:image];

            }
        } else {
            if ([stateStr isEqualToString:@"招标中"]) {
                _signImaView.image = [MSUPathTools showImageWithContentOfFileByName:@"bkjba"];
            } else{
                _signImaView.image = [MSUPathTools showImageWithContentOfFileByName:@"bkjb"];
            }
        }
    }];
    
    NSString *origiStr = [NSString stringWithFormat:@"%@ %@",_dataDic[@"realInterest"],_dataDic[@"addInterest"]];
    _incomeLab.attributedText = [MSUStringTools makeKeyWordAttributedWithSubText:@"%" inOrigiText:origiStr font:20 color:HEXCOLOR(0xB0B0B0)];
    
    if ([stateStr isEqualToString:@"还款中"]) {
        _statusImageView.hidden = NO;
        _statusImageView.image = [MSUPathTools showImageWithContentOfFileByName:@"hkz"];

    } else if ([stateStr isEqualToString:@"已还清"]){
        _statusImageView.hidden = NO;
        _statusImageView.image = [MSUPathTools showImageWithContentOfFileByName:@"yhq"];
    } else{
        _leftTitLab.backgroundColor = HEXCOLOR(0x6982FF);
        _rightTitLab.backgroundColor = HEXCOLOR(0x6982FF);

        _statusImageView.hidden = YES;
        _incomeLab.textColor = HEXCOLOR(0xFF6339);
        _introLab.textColor = HEXCOLOR(0x000000);
        _leftAmount.textColor = HEXCOLOR(0x000000);
        _titLab.textColor = titBlackColor;
        _incomeLab.attributedText = [MSUStringTools makeKeyWordAttributedWithSubText:@"%" inOrigiText:origiStr font:20 color:HEXCOLOR(0xFF6339)];
    }

    CGSize sized = [MSUStringTools danamicGetWidthFromText:_incomeLab.text WithFont:32];
    _incomeLab.frame = CGRectMake(15, _titLab.bottom+7*kDeviceHeightScale, sized.width, 45*kDeviceHeightScale);
    
    _introLab.text = [NSString stringWithFormat:@"%@",_dataDic[@"disGetMoney"]];
    CGSize sizee = [MSUStringTools danamicGetWidthFromText:_introLab.text WithFont:16];
    _introLab.frame = CGRectMake(156*kDeviceWidthScale, _titLab.bottom+21*kDeviceHeightScale, sizee.width+5, 22.5*kDeviceHeightScale);
    
    _yearIncomeLab.text = [NSString stringWithFormat:@"%@",_dataDic[@"disExpectedRevenue"]];
    CGSize sizef = [MSUStringTools danamicGetWidthFromText:_yearIncomeLab.text WithFont:12];
    _yearIncomeLab.frame = CGRectMake(_incomeLab.left, _incomeLab.bottom, sizef.width, 16.5*kDeviceHeightScale);
    
    _dayIncomeLab.text = [NSString stringWithFormat:@"%@",_dataDic[@"disLimit"]];
    CGSize sizeg = [MSUStringTools danamicGetWidthFromText:_dayIncomeLab.text WithFont:12];
    _dayIncomeLab.frame = CGRectMake(_introLab.left, _yearIncomeLab.top, sizeg.width, 16.5*kDeviceHeightScale);
    
    _leftAmount.text = [NSString stringWithFormat:@"%@",_dataDic[@"leftAmount"]];
    CGSize sizeaa = [MSUStringTools danamicGetWidthFromText:_leftAmount.text WithFont:16];
    _leftAmount.frame = CGRectMake(240*kDeviceWidthScale, _introLab.top, sizeaa.width+5, 22.5*kDeviceHeightScale);
    
    _leftIntro.text = @"剩余可投(元)";
    _leftIntro.frame = CGRectMake(_leftAmount.left, _yearIncomeLab.top, 80, 16.5*kDeviceHeightScale);

    _ProssView.hidden = NO;
    NSString *str = [NSString stringWithFormat:@"%@",_dataDic[@"completePercent"]];
    if ([str containsString:@"%"]) {
        str = [str substringToIndex:str.length-1];
    }
    _ProssView.progress = str.doubleValue/100.00;
}

- (void)setLoanModel:(loanModel *)loanModel{
    _loanModel = loanModel;
    
    _titLab.text = [NSString stringWithFormat:@"新手专享%@",loanModel.title];
    CGSize sizea = [MSUStringTools danamicGetWidthFromText:_titLab.text WithFont:15];
    _titLab.frame = CGRectMake(15, 17*kDeviceHeightScale, sizea.width+10, 21*kDeviceHeightScale);
    
    NSString *leftStr = [NSString stringWithFormat:@"%@",_loanModel.currentTip1];
    NSString *rigntStr = [NSString stringWithFormat:@"%@",_loanModel.currentTip2];
    
    _leftTitLab.hidden = NO;
    _rightTitLab.hidden = NO;
    if (leftStr.length > 0 && rigntStr.length > 0) {
        _leftTitLab.text = leftStr;
        CGSize sizeb = [MSUStringTools danamicGetWidthFromText:_leftTitLab.text WithFont:11];
        _leftTitLab.frame = CGRectMake(_titLab.right+7*kDeviceWidthScale, 17*kDeviceHeightScale, sizeb.width+5, 20*kDeviceHeightScale);
        
        _rightTitLab.text = rigntStr;
        CGSize sizec = [MSUStringTools danamicGetWidthFromText:_rightTitLab.text WithFont:11];
        _rightTitLab.frame = CGRectMake(_leftTitLab.right+7*kDeviceWidthScale, 17*kDeviceHeightScale, sizec.width+5, 20*kDeviceHeightScale);
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
        _leftTitLab.frame = CGRectMake(_titLab.right+7*kDeviceWidthScale, 17*kDeviceHeightScale, sizeb.width+5, 20*kDeviceHeightScale);
        
        _rightTitLab.hidden = YES;
    }
    
    NSString *stateStr = [NSString stringWithFormat:@"%@",_loanModel.borrowState];
    if ([stateStr isEqualToString:@"还款中"]) {
        _statusImageView.hidden = NO;
        _statusImageView.image = [MSUPathTools showImageWithContentOfFileByName:@"hkz"];
        
    } else if ([stateStr isEqualToString:@"已还清"]){
        _statusImageView.hidden = NO;
        _statusImageView.image = [MSUPathTools showImageWithContentOfFileByName:@"yhq"];
    } else{
        _leftTitLab.backgroundColor = HEXCOLOR(0x6982FF);
        _rightTitLab.backgroundColor = HEXCOLOR(0x6982FF);
        
        _statusImageView.hidden = YES;
        _incomeLab.textColor = HEXCOLOR(0xFF6339);
        _introLab.textColor = HEXCOLOR(0x000000);
        _leftAmount.textColor = HEXCOLOR(0x000000);
        _titLab.textColor = titBlackColor;
    }
    
    NSString *imaStr = [NSString stringWithFormat:@"%@",_loanModel.rigntImage];
    [_signImaView sd_setImageWithURL:[NSURL URLWithString:imaStr] placeholderImage:[MSUPathTools showImageWithContentOfFileByName:@"bkjba"]];

    NSString *origiStr = [NSString stringWithFormat:@"%@",_loanModel.rate];
    _incomeLab.attributedText = [MSUStringTools makeKeyWordAttributedWithSubText:@"%" inOrigiText:origiStr font:20 color:HEXCOLOR(0xFF6339)];
    CGSize sized = [MSUStringTools danamicGetWidthFromText:_incomeLab.text WithFont:32];
    _incomeLab.frame = CGRectMake(15, _titLab.bottom+7*kDeviceHeightScale, sized.width, 45*kDeviceHeightScale);
    
    _introLab.text = [NSString stringWithFormat:@"%@",_loanModel.timeCount];
    CGSize sizee = [MSUStringTools danamicGetWidthFromText:_introLab.text WithFont:16];
    _introLab.frame = CGRectMake(156*kDeviceWidthScale, _titLab.bottom+21*kDeviceHeightScale, sizee.width+5, 22.5*kDeviceHeightScale);
    
    _yearIncomeLab.text = [NSString stringWithFormat:@"%@",@"预期年化收益率"];
    CGSize sizef = [MSUStringTools danamicGetWidthFromText:_yearIncomeLab.text WithFont:12];
    _yearIncomeLab.frame = CGRectMake(_incomeLab.left, _incomeLab.bottom, sizef.width, 16.5*kDeviceHeightScale);
    
    _dayIncomeLab.text = [NSString stringWithFormat:@"%@",@"期限"];
    CGSize sizeg = [MSUStringTools danamicGetWidthFromText:_dayIncomeLab.text WithFont:12];
    _dayIncomeLab.frame = CGRectMake(_introLab.left, _yearIncomeLab.top, sizeg.width, 16.5*kDeviceHeightScale);
    
    _leftAmount.text = [NSString stringWithFormat:@"%@",_loanModel.amountLeft];
    CGSize sizeaa = [MSUStringTools danamicGetWidthFromText:_leftAmount.text WithFont:16];
    _leftAmount.frame = CGRectMake(240*kDeviceWidthScale, _introLab.top, sizeaa.width+5, 22.5*kDeviceHeightScale);
    
    _leftIntro.text = @"剩余可投(元)";
    _leftIntro.frame = CGRectMake(_leftAmount.left, _yearIncomeLab.top, 80, 16.5*kDeviceHeightScale);
    
    _ProssView.hidden = NO;
    NSString *str = [NSString stringWithFormat:@"%@",_loanModel.completePercent];
    if ([str containsString:@"%"]) {
        str = [str substringToIndex:str.length-1];
    }
    _ProssView.progress = str.doubleValue/100.00;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

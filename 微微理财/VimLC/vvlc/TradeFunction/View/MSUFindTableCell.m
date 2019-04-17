//
//  MSUFindTableCell.m
//  vvlc
//
//  Created by 007 on 2018/1/12.
//  Copyright © 2018年 HM. All rights reserved.
//

#import "MSUFindTableCell.h"

#import "MSUStringTools.h"

@implementation MSUFindTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createContentView];
    }
    return self;
}

- (void)createContentView{
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(12*kDeviceWidthScale, 12*kDeviceHeightScale, kDeviceWidth-24*kDeviceWidthScale, 203.8*kDeviceHeightScale);
    bgView.backgroundColor = WhiteColor;
    bgView.layer.shouldRasterize = YES;
    bgView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    bgView.layer.cornerRadius = 4;
    bgView.clipsToBounds = YES;
    [self addSubview:bgView];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(0, 0, kDeviceWidth, 12*kDeviceHeightScale);
    lineView.backgroundColor = HEXCOLOR(0xc3c3c3);
    [bgView addSubview:lineView];
    
    self.gameImaView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth-24*kDeviceWidthScale, 164.5*kDeviceHeightScale)];
    _gameImaView.backgroundColor = BGOrangeColor;
    _gameImaView.clipsToBounds = YES;
    _gameImaView.contentMode = UIViewContentModeScaleAspectFill;
    [bgView addSubview:_gameImaView];
    
//    self.gameImaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _gameImaBtn.frame = CGRectMake(0, 0, kDeviceWidth-24*kDeviceWidthScale, 164.5*kDeviceHeightScale);
//    _gameImaBtn.backgroundColor = BGOrangeColor;
//    _gameImaBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
//    [bgView addSubview:_gameImaBtn];

    
    self.gameLab = [[UILabel alloc] init];
    _gameLab.frame = CGRectMake(12*kDeviceWidthScale, _gameImaView.bottom + 9*kDeviceHeightScale, kDeviceWidth*0.5, 22.5*kDeviceHeightScale);
    _gameLab.font = TEXTFONT(16);
    _gameLab.textColor = titBlackColor;
    [bgView addSubview:_gameLab];
    
    self.timeLab = [[UILabel alloc] init];
    _timeLab.frame = CGRectMake(kDeviceWidth - 136*kDeviceWidthScale,_gameImaView.bottom + 10.5*kDeviceHeightScale, 100*kDeviceWidthScale, 20*kDeviceHeightScale);
    _timeLab.font = TEXTFONT(14);
    _timeLab.textAlignment = NSTextAlignmentRight;
    _timeLab.textColor = titQianColor;
    [bgView addSubview:_timeLab];
}

- (void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    
    NSString *str = _dataDic[@"imagesUrl"];
    NSString *imaStr;
    if (str.length > 0 && [imaStr  containsString:@"?"]) {
        imaStr = [str substringToIndex:[str rangeOfString:@"?"].location];
    }  else{
        imaStr = str;
    }
    [_gameImaView sd_setImageWithURL:[NSURL URLWithString:imaStr]];
    
    _gameLab.text = _dataDic[@"Title"];
//    CGSize sizea = [MSUStringTools danamicGetWidthFromText:_gameLab.text WithFont:16];
    
    _timeLab.text = _dataDic[@"endDate"];
//    CGSize sizeb = [MSUStringTools danamicGetWidthFromText:_timeLab.text WithFont:14];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

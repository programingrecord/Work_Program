//
//  MSUHomeNotifaTableCell.m
//  vvlc
//
//  Created by 007 on 2018/1/16.
//  Copyright © 2018年 HM. All rights reserved.
//

#import "MSUHomeNotifaTableCell.h"

#import "MSUPathTools.h"
#import "MSUStringTools.h"

@implementation MSUHomeNotifaTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createContentView];
    }
    return self;
}

- (void)createContentView{
    self.bgView = [[UIView alloc] init];
    _bgView.frame = CGRectMake(12*kDeviceWidthScale, 12*kDeviceHeightScale, kDeviceWidth-24*kDeviceWidthScale, 61*kDeviceHeightScale);
    _bgView.backgroundColor = HEXCOLOR(0xffffff);
    _bgView.clipsToBounds = YES;
    _bgView.layer.cornerRadius = 8;
    _bgView.layer.shouldRasterize = YES;
    _bgView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    [self addSubview:_bgView];
    
    self.titLab = [[UILabel alloc] init];
    _titLab.frame = CGRectMake(15*kDeviceWidthScale, 12*kDeviceHeightScale, kDeviceWidth-54*kDeviceWidthScale, 22.5*kDeviceHeightScale);
    _titLab.font = TEXTFONT(16);
    _titLab.textColor = titBlackColor;
    _titLab.numberOfLines = 0;
    [_bgView addSubview:_titLab];
    
    self.dateLab = [[UILabel alloc] init];
//    _dateLab.frame = CGRectMake(kDeviceWidth-216*kDeviceWidthScale, 13.5*kDeviceHeightScale, 180*kDeviceWidthScale, 20*kDeviceHeightScale);
    _dateLab.frame = CGRectMake(_titLab.left, 13.5*kDeviceHeightScale, 180*kDeviceWidthScale, 20*kDeviceHeightScale);
    _dateLab.font = TEXTFONT(14);
    _dateLab.textAlignment = NSTextAlignmentRight;
    _dateLab.textColor = titQianColor;
    [_bgView addSubview:_dateLab];
    
    self.contentLab = [[UILabel alloc] init];
    _contentLab.font = TEXTFONT(14);
    _contentLab.textColor = titBlackQianColor;
    _contentLab.numberOfLines = 0;
    [_bgView addSubview:_contentLab];
    
   self.contentLineView = [[UIView alloc] init];
    _contentLineView.backgroundColor = titOrangeColor;
    [_bgView addSubview:_contentLineView];
    _contentLineView.hidden = YES;

}


- (void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    
    if (self.signView == 1) {
        self.titLab.text = _dataDic[@"title"];
    } else {
        self.titLab.text = _dataDic[@"titStr"];
    }
    CGRect rectS = [MSUStringTools danamicGetHeightFromText:self.titLab.text WithWidth:kDeviceWidth-54*kDeviceWidthScale font:19];
    [MSUStringTools changeLineSpaceForLabel:self.titLab WithSpace:5.0];
    self.titLab.frame = CGRectMake(15*kDeviceWidthScale, 12*kDeviceHeightScale, kDeviceWidth-54*kDeviceWidthScale, rectS.size.height);
    
    
    if (self.signView == 1) {
        self.dateLab.text = _dataDic[@"lastUpdateLong"];
    } else {
        self.dateLab.text = _dataDic[@"timeStr"];
    }
    self.dateLab.frame = CGRectMake(kDeviceWidth-216*kDeviceWidthScale,self.titLab.bottom, 180*kDeviceWidthScale, 20*kDeviceHeightScale);
    
    NSString *str;
    if (self.signView == 1) {
        str = [NSString stringWithFormat:@"%@",_dataDic[@"content"]];
    } else{
        str = [NSString stringWithFormat:@"%@",_dataDic[@"contentStr"]];
    }
    str = [MSUStringTools htmlEntityDecode:str];
    //    NSMutableAttributedString *contentStr = [[NSMutableAttributedString alloc] initWithAttributedString:[MSUStringTools attributedStringWithHTMLString:str]];
    NSMutableAttributedString *contentStr = [[NSMutableAttributedString alloc] initWithString:str];
    
    NSString *linkStr = [NSString stringWithFormat:@"%@",_dataDic[@"linkUrl"]];
//    if (self.signView != 1) {
//        linkStr = ;
//    }
    // 设置有 url 的文字下划线并改变颜色
    if (linkStr.length > 0) {
        self.contentLab.textColor = titOrangeColor;
        contentStr = [MSUStringTools setUnderLineWithString:str WithSpace:5.0];
    } else{
        self.contentLab.textColor = titBlackQianColor;
    }
    self.contentLab.attributedText = contentStr;

    if (self.signIndex == 1) {
        CGRect rectA = [MSUStringTools danamicGetHeightFromText:self.contentLab.text WithWidth:kDeviceWidth-27*kDeviceWidthScale font:17];
        // 设置行间距
        if (linkStr.length == 0) {
            [MSUStringTools changeLineSpaceForLabel:self.contentLab WithSpace:5.0];
        }
        self.contentLab.frame = CGRectMake(15*kDeviceWidthScale,self.dateLab.bottom + 5*kDeviceHeightScale, kDeviceWidth-54*kDeviceWidthScale, rectA.size.height);
        self.bgView.frame = CGRectMake(12*kDeviceWidthScale, 12*kDeviceHeightScale, kDeviceWidth-24*kDeviceWidthScale, rectS.size.height+47*kDeviceHeightScale+rectA.size.height);

    } else{
        if ([str containsString:@"活动请戳"]) {
            self.contentLab.frame = CGRectMake(15*kDeviceWidthScale,self.dateLab.bottom, kDeviceWidth-54*kDeviceWidthScale, 40*kDeviceHeightScale);
            
            //    self.bgView.frame = CGRectMake(12*kDeviceWidthScale, 12*kDeviceHeightScale, kDeviceWidth-24*kDeviceWidthScale, rectS.size.height+47*kDeviceHeightScale+rectA.size.height);
            self.bgView.frame = CGRectMake(12*kDeviceWidthScale, 12*kDeviceHeightScale, kDeviceWidth-24*kDeviceWidthScale,rectS.size.height + 95*kDeviceHeightScale);
        } else{
            self.contentLab.frame = CGRectMake(15*kDeviceWidthScale,self.dateLab.bottom, kDeviceWidth-54*kDeviceWidthScale, 55*kDeviceHeightScale);
            
            //    self.bgView.frame = CGRectMake(12*kDeviceWidthScale, 12*kDeviceHeightScale, kDeviceWidth-24*kDeviceWidthScale, rectS.size.height+47*kDeviceHeightScale+rectA.size.height);
            self.bgView.frame = CGRectMake(12*kDeviceWidthScale, 12*kDeviceHeightScale, kDeviceWidth-24*kDeviceWidthScale,rectS.size.height + 110*kDeviceHeightScale);
        }
    }
    
    if (self.bgViewHeightBlck) {
        self.bgViewHeightBlck(self.bgView.height);
    }
}

- (void)setPostDic:(NSDictionary *)postDic{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

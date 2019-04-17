//
//  MSUProgramDetailView.m
//  vvlc
//
//  Created by 007 on 2018/1/15.
//  Copyright © 2018年 HM. All rights reserved.
//

#import "MSUProgramDetailView.h"


#import "MSUPathTools.h"
#import "MSUStringTools.h"

@implementation MSUProgramDetailView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.cicleViewArr = [NSMutableArray array];
        self.textArr = [NSMutableArray array];

        [self createView];
    }
    return self;
}


- (void)createView{
    //
    UIView *topView = [[UIView alloc] init];
    topView.frame = CGRectMake(0, 10*kDeviceHeightScale, kDeviceWidth, 154*kDeviceHeightScale);
    topView.backgroundColor = HEXCOLOR(0xffffff);
    [self addSubview:topView];
    
    self.historyTopLab = [[UILabel alloc] init];
    _historyTopLab.frame = CGRectMake(28*kDeviceWidthScale, 13.5*kDeviceHeightScale, kDeviceWidth-56*kDeviceWidthScale, 20*kDeviceHeightScale);
    _historyTopLab.font = [UIFont systemFontOfSize:14];
    _historyTopLab.textColor = HEXCOLOR(0x4a4a4a);
    _historyTopLab.text = @"历史年化收益率：4.3%";
    [topView addSubview:_historyTopLab];
    
    self.limitTopLab = [[UILabel alloc] init];
    _limitTopLab.frame = CGRectMake(28*kDeviceWidthScale,_historyTopLab.bottom + 5*kDeviceHeightScale, kDeviceWidth-56*kDeviceWidthScale, 20*kDeviceHeightScale);
    _limitTopLab.font = [UIFont systemFontOfSize:14];
    _limitTopLab.textColor = HEXCOLOR(0x4a4a4a);
    _limitTopLab.text = @"募集期限：7天";
    [topView addSubview:_limitTopLab];
    
    self.totalTopLab = [[UILabel alloc] init];
    _totalTopLab.frame = CGRectMake(28*kDeviceWidthScale,_limitTopLab.bottom + 5*kDeviceHeightScale, kDeviceWidth-56*kDeviceWidthScale, 20*kDeviceHeightScale);
    _totalTopLab.font = [UIFont systemFontOfSize:14];
    _totalTopLab.textColor = HEXCOLOR(0x4a4a4a);
    _totalTopLab.text = @"募集金额：2000000元";
    [topView addSubview:_totalTopLab];
    
    self.incomeStyleLab = [[UILabel alloc] init];
    _incomeStyleLab.frame = CGRectMake(28*kDeviceWidthScale,_totalTopLab.bottom + 5*kDeviceHeightScale, kDeviceWidth-56*kDeviceWidthScale, 20*kDeviceHeightScale);
    _incomeStyleLab.font = [UIFont systemFontOfSize:14];
    _incomeStyleLab.textColor = HEXCOLOR(0x4a4a4a);
    _incomeStyleLab.text = @"收益方式：按月计息，到期还本";
    [topView addSubview:_incomeStyleLab];
    
    self.qixiTopLab = [[UILabel alloc] init];
    _qixiTopLab.frame = CGRectMake(28*kDeviceWidthScale,_incomeStyleLab.bottom + 5*kDeviceHeightScale, kDeviceWidth-56*kDeviceWidthScale, 20*kDeviceHeightScale);
    _qixiTopLab.font = [UIFont systemFontOfSize:14];
    _qixiTopLab.textColor = HEXCOLOR(0x4a4a4a);
    _qixiTopLab.text = @"起息日：募集成功次日计息";
    [topView addSubview:_qixiTopLab];

    self.introView = [[UIView alloc] init];
    _introView.frame = CGRectMake(0, topView.bottom + 10*kDeviceHeightScale, kDeviceWidth, 155*kDeviceHeightScale);
    _introView.backgroundColor = HEXCOLOR(0xffffff);
    [self addSubview:_introView];
    
    UIImageView *orangeImaView = [[UIImageView alloc] initWithFrame:CGRectMake(14, 14*kDeviceHeightScale, 22*kDeviceHeightScale, 22*kDeviceHeightScale)];
    orangeImaView.image = [MSUPathTools showImageWithContentOfFileByName:@"xmjs_icon"];
    orangeImaView.contentMode = UIViewContentModeScaleAspectFit;
    [_introView addSubview:orangeImaView];
    
    UILabel *introLab = [[UILabel alloc] init];
    introLab.frame = CGRectMake(orangeImaView.right + 10, 15*kDeviceHeightScale, 120*kDeviceWidthScale, 22*kDeviceHeightScale);
    introLab.text = @"项目介绍";
    introLab.font = [UIFont systemFontOfSize:16];
    introLab.textColor = titBlackColor;
    [_introView addSubview:introLab];

    self.introDetailLab = [[UILabel alloc] init];
    _introDetailLab.font = [UIFont systemFontOfSize:14];
    _introDetailLab.textColor = titBlackQianColor;
    _introDetailLab.numberOfLines = 0;
    _introDetailLab.text = @"鉴于网络信息撮合交易过程中，可能面临的多种风险因素，微米在线就存续期间可能存在的风险进行说明，望您在出借前仔细阅读以下内容，以便于您充分了解、清楚知晓并自愿承担相关风险。";
    [_introView addSubview:_introDetailLab];
    //项目介绍
    CGRect recta = [MSUStringTools danamicGetHeightFromText:_introDetailLab.text WithWidth:kDeviceWidth-32*kDeviceWidthScale font:14];
    _introDetailLab.frame = CGRectMake(16*kDeviceWidthScale, 49*kDeviceHeightScale, kDeviceWidth-32*kDeviceWidthScale, recta.size.height);
    [MSUStringTools changeLineSpaceForLabel:_introDetailLab WithSpace:5.0];
    _introView.frame = CGRectMake(0, 174*kDeviceHeightScale, kDeviceWidth, _introDetailLab.bottom+8*kDeviceHeightScale);

    /// 借款描述
    self.describeView = [[UIView alloc] init];
    _describeView.frame = CGRectMake(0, _introView.bottom, kDeviceWidth, 140*kDeviceHeightScale);
    _describeView.backgroundColor = HEXCOLOR(0xffffff);
    [self addSubview:_describeView];
    
    UIImageView *desImaView = [[UIImageView alloc] initWithFrame:CGRectMake(14, 14*kDeviceHeightScale, 22*kDeviceHeightScale, 22*kDeviceHeightScale)];
    desImaView.image = [MSUPathTools showImageWithContentOfFileByName:@"jkms_icon"];
    desImaView.contentMode = UIViewContentModeScaleAspectFit;
    [_describeView addSubview:desImaView];

    UILabel *describeLab = [[UILabel alloc] init];
    describeLab.frame = CGRectMake(desImaView.right + 10*kDeviceWidthScale,15*kDeviceHeightScale, 120*kDeviceWidthScale, 22.5*kDeviceHeightScale);
    describeLab.text = @"项目描述";
    describeLab.font = [UIFont systemFontOfSize:16];
    describeLab.textColor = titBlackColor;
    [_describeView addSubview:describeLab];

    self.describeDetailLab = [[UILabel alloc] init];
    _describeDetailLab.frame = CGRectMake(16*kDeviceWidthScale, describeLab.bottom+12*kDeviceHeightScale, kDeviceWidth-32*kDeviceWidthScale, 20*kDeviceHeightScale);
    _describeDetailLab.font = [UIFont systemFontOfSize:14];
    _describeDetailLab.textColor = titBlackQianColor;
    _describeDetailLab.numberOfLines = 0;
    [_describeView addSubview:_describeDetailLab];
    
    self.moneyLab = [[UILabel alloc] init];
    _moneyLab.frame = CGRectMake(16*kDeviceWidthScale, _describeDetailLab.bottom+8*kDeviceHeightScale, kDeviceWidth-32*kDeviceWidthScale, 20*kDeviceHeightScale);
    _moneyLab.font = [UIFont systemFontOfSize:14];
    _moneyLab.textColor = titBlackQianColor;
    _moneyLab.numberOfLines = 0;
    [_describeView addSubview:_moneyLab];
    
    self.numLab = [[UILabel alloc] init];
    _numLab.frame = CGRectMake(16*kDeviceWidthScale, _moneyLab.bottom+8*kDeviceHeightScale, kDeviceWidth-32*kDeviceWidthScale, 20*kDeviceHeightScale);
    _numLab.font = [UIFont systemFontOfSize:14];
    _numLab.textColor = titBlackQianColor;
    _numLab.numberOfLines = 0;
    [_describeView addSubview:_numLab];
    
    _describeView.frame = CGRectMake(0, _introView.bottom+10*kDeviceHeightScale, kDeviceWidth, 140*kDeviceHeightScale);
    
    _describeDetailLab.text = [NSString stringWithFormat:@"承兑银行 : %@",@"华生银行"];
    _moneyLab.text = [NSString stringWithFormat:@"票面金额 : %@元",@"200,000,000"];
    _numLab.text = [NSString stringWithFormat:@"票   号 : %@",@"545575827581528735218"];
    
    /// 安全保障
    self.informationView = [[UIView alloc] init];
    _informationView.frame = CGRectMake(0, _describeView.bottom + 10*kDeviceHeightScale, kDeviceWidth, 171*kDeviceHeightScale);
    _informationView.backgroundColor = HEXCOLOR(0xffffff);
    [self addSubview:_informationView];
    
    UIImageView *safeImaView = [[UIImageView alloc] initWithFrame:CGRectMake(14, 14*kDeviceHeightScale, 22*kDeviceHeightScale, 22*kDeviceHeightScale)];
    safeImaView.image = [MSUPathTools showImageWithContentOfFileByName:@"jkms_icon"];
    safeImaView.contentMode = UIViewContentModeScaleAspectFit;
    [_informationView addSubview:safeImaView];
    
    UILabel *infoLab = [[UILabel alloc] init];
    infoLab.frame = CGRectMake(safeImaView.right + 10*kDeviceWidthScale,15*kDeviceHeightScale, 120*kDeviceWidthScale, 22.5*kDeviceHeightScale);
    infoLab.text = @"安全保障";
    infoLab.font = [UIFont systemFontOfSize:16];
    infoLab.textColor = titBlackColor;
    [_informationView addSubview:infoLab];

    UIImageView *imaView = [[UIImageView alloc] initWithFrame:CGRectMake(kDeviceWidth-14-17*kDeviceHeightScale, 15*kDeviceHeightScale,17*kDeviceHeightScale, 17*kDeviceHeightScale)];
    imaView.image = [MSUPathTools showImageWithContentOfFileByName:@"icon_arrow_right"];
    imaView.contentMode = UIViewContentModeScaleAspectFit;
    [_informationView addSubview:imaView];
    
    NSArray *imaaRR = @[@"fkbz_icon",@"aqbz2_icon",@"sjaq_icon"];
    NSArray *safeArr = @[@"风控保障",@"财产保障",@"数据安全"];
    NSArray *detaiArr = @[@"专业团队 风控把关",@"多重还款保障",@"保障账户安全"];
    for (NSInteger i = 0; i < 3; i++) {
        UIImageView *imaLView = [[UIImageView alloc] initWithFrame:CGRectMake(49+(50*kDeviceHeightScale+60)*i,infoLab.bottom + 15*kDeviceHeightScale, 50*kDeviceHeightScale, 50*kDeviceHeightScale)];
        imaLView.image = [MSUPathTools showImageWithContentOfFileByName:imaaRR[i]];
        imaLView.contentMode = UIViewContentModeScaleAspectFit;
        [_informationView addSubview:imaLView];
        
        UILabel *safeLLab = [[UILabel alloc] init];
        safeLLab.size = CGSizeMake(60, 20*kDeviceHeightScale);
        safeLLab.center = CGPointMake(imaLView.center.x, imaLView.center.y+46.5*kDeviceHeightScale);
        safeLLab.text = safeArr[i];
        safeLLab.font = [UIFont systemFontOfSize:14];
        safeLLab.textColor = HEXCOLOR(0x313131);
        safeLLab.textAlignment = NSTextAlignmentCenter;
        [_informationView addSubview:safeLLab];
        
        UILabel *safe2Lab = [[UILabel alloc] init];
        safe2Lab.size = CGSizeMake(88, 14*kDeviceHeightScale);
        safe2Lab.center = CGPointMake(imaLView.center.x, safeLLab.center.y + 17*kDeviceHeightScale);
        safe2Lab.text = detaiArr[i];
        safe2Lab.font = [UIFont systemFontOfSize:10];
        safe2Lab.textAlignment = NSTextAlignmentCenter;
        safe2Lab.textColor = HEXCOLOR(0xaaaaaa);
        [_informationView addSubview:safe2Lab];
    }

    self.safeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _safeBtn.frame = CGRectMake(0, _describeView.bottom + 10*kDeviceHeightScale, kDeviceWidth, 171*kDeviceHeightScale);
    [self addSubview:_safeBtn];
    
    // 财产保险
    self.lastView = [[UIView alloc] init];
    _lastView.frame = CGRectMake(0, _informationView.bottom+10*kDeviceHeightScale, kDeviceWidth,107*kDeviceHeightScale);
    _lastView.backgroundColor = HEXCOLOR(0xffffff);
    [self addSubview:_lastView];
    
    UIImageView *tishiImaView = [[UIImageView alloc] initWithFrame:CGRectMake(14, 15*kDeviceHeightScale, 22*kDeviceHeightScale, 22*kDeviceHeightScale)];
    tishiImaView.image = [MSUPathTools showImageWithContentOfFileByName:@"fxts_icon"];
    tishiImaView.contentMode = UIViewContentModeScaleAspectFit;
    [_lastView addSubview:tishiImaView];
    
    UILabel *lastLab = [[UILabel alloc] init];
    lastLab.frame = CGRectMake(tishiImaView.right + 10*kDeviceWidthScale,15*kDeviceHeightScale, 120*kDeviceWidthScale, 22.5*kDeviceHeightScale);
    lastLab.text = @"相关文件";
    lastLab.font = [UIFont systemFontOfSize:16];
    lastLab.textColor = titBlackColor;
    [_lastView addSubview:lastLab];
    
    self.danbaoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _danbaoBtn.frame = CGRectMake(14,lastLab.bottom + 14*kDeviceHeightScale, 100*kDeviceWidthScale, 35*kDeviceHeightScale);
    _danbaoBtn.backgroundColor = HEXCOLOR(0xF6F6F6);
    _danbaoBtn.layer.cornerRadius = 35*kDeviceHeightScale*0.5;
    _danbaoBtn.clipsToBounds = YES;
    _danbaoBtn.layer.shouldRasterize = YES;
    _danbaoBtn.layer.borderWidth = 0.5;
    _danbaoBtn.layer.borderColor = HEXCOLOR(0x979797).CGColor;
    _danbaoBtn.layer.rasterizationScale = [UIScreen mainScreen].scale;
    [_danbaoBtn setTitle:@"《保证担保函》" forState:UIControlStateNormal];
    [_danbaoBtn setTitleColor:HEXCOLOR(0x4A79DC) forState:UIControlStateNormal];
    _danbaoBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_lastView addSubview:_danbaoBtn];
    
    self.protoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _protoBtn.frame = CGRectMake(_danbaoBtn.right+10, _danbaoBtn.top, 132*kDeviceWidthScale, 35*kDeviceHeightScale);
    _protoBtn.backgroundColor = HEXCOLOR(0xF6F6F6);
    _protoBtn.layer.cornerRadius = 35*kDeviceHeightScale*0.5;
    _protoBtn.clipsToBounds = YES;
    _protoBtn.layer.shouldRasterize = YES;
    _protoBtn.layer.rasterizationScale = [UIScreen mainScreen].scale;
    _protoBtn.layer.borderWidth = 0.5;
    _protoBtn.layer.borderColor = HEXCOLOR(0x979797).CGColor;
    [_protoBtn setTitle:@"《担保函通用条款》" forState:UIControlStateNormal];
    [_protoBtn setTitleColor:HEXCOLOR(0x4A79DC) forState:UIControlStateNormal];
    _protoBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_lastView addSubview:_protoBtn];
    
    self.xieyiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _xieyiBtn.frame = CGRectMake(_protoBtn.right + 10,_danbaoBtn.top, 100*kDeviceWidthScale, 35*kDeviceHeightScale);
    _xieyiBtn.backgroundColor = HEXCOLOR(0xF6F6F6);
    _xieyiBtn.layer.cornerRadius = 35*kDeviceHeightScale*0.5;
    _xieyiBtn.clipsToBounds = YES;
    _xieyiBtn.layer.shouldRasterize = YES;
    _xieyiBtn.layer.rasterizationScale = [UIScreen mainScreen].scale;
    _xieyiBtn.layer.borderWidth = 0.5;
    _xieyiBtn.layer.borderColor = HEXCOLOR(0x979797).CGColor;
    [_xieyiBtn setTitle:@"《借款协议》" forState:UIControlStateNormal];
    [_xieyiBtn setTitleColor:HEXCOLOR(0x4A79DC) forState:UIControlStateNormal];
    _xieyiBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_lastView addSubview:_xieyiBtn];
    
}

- (void)describeDetailBtnClick:(UIButton *)sender{
    [UIView animateWithDuration:0.25 animations:^{
        self.shadowView.hidden = NO;
        self.imaSView.hidden = NO;
        
        NSDictionary *dic = _imaArr[0];
        NSString *str = dic[@"borrowImageUrl"];
        NSString *imaStr;
        if (str.length > 0 && [imaStr  containsString:@"?"]) {
            imaStr = [str substringToIndex:[str rangeOfString:@"?"].location];
        } else{
            imaStr = str;
        }
        [_imaSView sd_setImageWithURL:[NSURL URLWithString:imaStr]];
    }];
    
}


- (void)setDataArr:(NSArray *)dataArr{
    _dataArr = dataArr;
    
   

    //借款描述

    
    // 安全保障
    _informationView.frame = CGRectMake(0, _describeView.bottom + 10*kDeviceHeightScale, kDeviceWidth, 171*kDeviceHeightScale);

    //财产保险
    _lastView.frame = CGRectMake(0, _informationView.bottom+10*kDeviceHeightScale, kDeviceWidth,107*kDeviceHeightScale);
}

- (void)setDateArr:(NSArray *)dateArr{
    _dateArr = dateArr;
    
    if (_dataArr.count > 0) {
        NSDictionary *dic = _dateArr[0];
        NSMutableArray *muArr = [NSMutableArray array];
        [muArr addObject:dic[@"todayDate"]];
        [muArr addObject:dic[@"fillData"]];
        [muArr addObject:dic[@"nextDate"]];
        [muArr addObject:dic[@"moneyDate"]];
        
        for (NSInteger i = 0; i < _cicleViewArr.count; i++) {
            UILabel *lab = _cicleViewArr[i];
            lab.text = muArr[i];
        }
    }
}

- (void)setImaArr:(NSArray *)imaArr{
    _imaArr = imaArr;
    if (_imaArr.count > 0) {
        NSDictionary *dic = _imaArr[0];
        
        NSString *str = dic[@"borrowImageUrl"];
        NSString *imaStr;
        if (str.length > 0 && [imaStr  containsString:@"?"]) {
            imaStr = [str substringToIndex:[str rangeOfString:@"?"].location];
        } else{
            imaStr = str;
        }
        
        [_describeDetailBtn sd_setImageWithURL:[NSURL URLWithString:imaStr] forState:UIControlStateNormal];
        //    [_describeDetailView sd_setImageWithURL:[NSURL URLWithString:dic[@"borrowImageUrl"]]];
        //    _describeDetailView.frame = CGRectMake(16*kDeviceWidthScale, _describeDetailLab.bottom+12.5*kDeviceHeightScale, 130*kDeviceWidthScale, 65*kDeviceHeightScale);
        _describeDetailBtn.frame = CGRectMake(16*kDeviceWidthScale, _lastView.bottom+12.5*kDeviceHeightScale, 130*kDeviceWidthScale, 65*kDeviceHeightScale);
    }

}

- (void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    
    _historyTopLab.text = [NSString stringWithFormat:@"历史年化收益率：%@",@"4.3"];
    _limitTopLab.text = [NSString stringWithFormat:@"募集期限：%@",@"7天"];
    _totalTopLab.text = [NSString stringWithFormat:@"募集金额：%@元",@"2000000"];
    
    NSString *yqbHiden = [NSString stringWithFormat:@"%@",dataDic[@"yqbOnOff"]];
    if ([yqbHiden isEqualToString:@"1"]) {
        self.lastView.hidden = YES;
    }
}

- (MSUShadowInView *)shadowView{
    if (!_shadowView) {
        _shadowView = [[MSUShadowInView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
        _shadowView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        [MSUMainWindow addSubview:_shadowView];
        _shadowView.hidden = YES;
    }
    return _shadowView;
}

- (UIImageView *)imaSView{
    if (!_imaSView) {
        _imaSView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kDeviceHeight*0.5-100*kDeviceHeightScale, kDeviceWidth, 200*kDeviceHeightScale)];
        [self.shadowView addSubview:_imaSView];
    }
    return _imaSView;
}

@end

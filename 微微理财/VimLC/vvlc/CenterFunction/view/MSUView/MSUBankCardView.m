//
//  MSUBankCardView.m
//  vvlc
//
//  Created by 007 on 2018/4/26.
//  Copyright © 2018年 HM. All rights reserved.
//

#import "MSUBankCardView.h"
#import "MSUPathTools.h"

@implementation MSUBankCardView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self createView];
        
    }
    return self;
}


- (void)createView{
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(32, 32, kDeviceWidth-64, 154);
    [MSUPathTools drawGradientColorFromColorA:HEXCOLOR(0xFF8B50) toColorB:HEXCOLOR(0xFF5C30) withView:bgView isLeft:NO];
    bgView.clipsToBounds = YES;
    bgView.layer.cornerRadius = 10;
    bgView.layer.shouldRasterize = YES;
    bgView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    [self addSubview:bgView];
    
    UIView *whiteView = [[UIView alloc] init];
    whiteView.frame = CGRectMake(20, 22.5, 44, 44);
    whiteView.backgroundColor = HEXCOLOR(0xffffff);
    whiteView.clipsToBounds = YES;
    whiteView.layer.cornerRadius = 22;
    whiteView.layer.shouldRasterize = YES;
    whiteView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    [bgView addSubview:whiteView];
    
    self.bankImaView = [[UIImageView alloc] initWithFrame:CGRectMake(28, 30, 28, 29)];
    _bankImaView.contentMode = UIViewContentModeScaleAspectFit;
    [bgView addSubview:_bankImaView];
    
    self.bankName = [[UILabel alloc] init];
    _bankName.frame = CGRectMake(whiteView.right + 7.5, 20, kDeviceWidth*0.5, 25);
    _bankName.text = @"--";
    _bankName.font = [UIFont systemFontOfSize:18];
    _bankName.textColor = HEXCOLOR(0xffffff);
    [bgView addSubview:_bankName];
    
    self.bankNum = [[UILabel alloc] init];
    _bankNum.frame = CGRectMake(whiteView.right + 7.5,_bankName.bottom + 4, kDeviceWidth-64-72, 25);
    _bankNum.text = @"--";
    _bankNum.font = [UIFont systemFontOfSize:18];
    _bankNum.textColor = HEXCOLOR(0xffffff);
    [bgView addSubview:_bankNum];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(20, 102, kDeviceWidth-64-40, 1);
    lineView.backgroundColor = HEXCOLOR(0xFFA58D);
    [bgView addSubview:lineView];
    
    self.nameLab = [[UILabel alloc] init];
    _nameLab.frame = CGRectMake(20,whiteView.bottom + 55, kDeviceWidth*0.5, 16.5);
    _nameLab.text = @"--";
    _nameLab.font = [UIFont systemFontOfSize:12];
    _nameLab.textColor = HEXCOLOR(0xffffff);
    [bgView addSubview:_nameLab];
    
    UILabel *typeLab = [[UILabel alloc] init];
    typeLab.frame = CGRectMake(kDeviceWidth-64-20-kDeviceWidth*0.5, _nameLab.top, kDeviceWidth*0.5, 16.5);
    typeLab.text = @"储蓄卡";
    typeLab.font = [UIFont systemFontOfSize:12];
    typeLab.textAlignment = NSTextAlignmentRight;
    typeLab.textColor = HEXCOLOR(0xffffff);
    [bgView addSubview:typeLab];

//    UILabel *introLab = [[UILabel alloc] init];
//    introLab.frame = CGRectMake(42, bgView.bottom+13.5, kDeviceWidth-84, 49);
//    introLab.text = @"本平台只支持绑定一张银行卡，如需更换请联系客服，并提供相关文件";
//    introLab.font = [UIFont systemFontOfSize:12];
//    introLab.textColor = HEXCOLOR(0xA4A4A4);
//    introLab.numberOfLines = 0;
//    [self addSubview:introLab];
    
//    UIView *limitView = [[UIView alloc] init];
//    limitView.frame = CGRectMake(_bankImaView.left,bgView.bottom + 15, kDeviceWidth-56, 122);
//    limitView.clipsToBounds = YES;
//    limitView.layer.cornerRadius = 4;
//    limitView.layer.shouldRasterize = YES;
//    limitView.layer.rasterizationScale = [UIScreen mainScreen].scale;
//    limitView.backgroundColor = HEXCOLOR(0xffffff);
//    [self addSubview:limitView];
//    
//    UILabel *leftLimitLab = [[UILabel alloc] init];
//    leftLimitLab.frame = CGRectMake(15, 21, kDeviceWidth*0.5, 19);
//    leftLimitLab.text = @"单笔限额（元）";
//    leftLimitLab.font = [UIFont systemFontOfSize:13];
//    leftLimitLab.textColor = HEXCOLOR(0x333333);
//    [limitView addSubview:leftLimitLab];
//    
//    self.singleLimitLab = [[UILabel alloc] init];
//    _singleLimitLab.frame = CGRectMake((kDeviceWidth-56)*0.5-15, 21, (kDeviceWidth-56)*0.5, 19);
//    _singleLimitLab.text = @"--元";
//    _singleLimitLab.font = [UIFont systemFontOfSize:13];
//    _singleLimitLab.textAlignment = NSTextAlignmentRight;
//    _singleLimitLab.textColor = HEXCOLOR(0x333333);
//    [limitView addSubview:_singleLimitLab];
//    
//    UILabel *rightLimitLab = [[UILabel alloc] init];
//    rightLimitLab.frame = CGRectMake(leftLimitLab.left, 61+21, kDeviceWidth*0.5, 19);
//    rightLimitLab.text = @"单日限额（元）";
//    rightLimitLab.font = [UIFont systemFontOfSize:13];
//    rightLimitLab.textColor = HEXCOLOR(0x333333);
//    [limitView addSubview:rightLimitLab];
//    
//    self.dayLimitLab = [[UILabel alloc] init];
//    _dayLimitLab.frame = CGRectMake((kDeviceWidth-56)*0.5-15,61+ 21, (kDeviceWidth-56)*0.5, 19);
//    _dayLimitLab.text = @"--";
//    _dayLimitLab.font = [UIFont systemFontOfSize:13];
//    _dayLimitLab.textAlignment = NSTextAlignmentRight;
//    _dayLimitLab.textColor = HEXCOLOR(0x333333);
//    [limitView addSubview:_dayLimitLab];
//    
//    UIView *lineLimitView = [[UIView alloc] init];
//    lineLimitView.frame = CGRectMake(0, 61, (kDeviceWidth-56)*0.5, 0.5);
//    lineLimitView.backgroundColor = HEXCOLOR(0xe4e4e4);
//    [limitView addSubview:lineLimitView];
//    
//    UIImageView *tanView = [[UIImageView alloc] initWithFrame:CGRectMake(limitView.left,limitView.bottom + 15, 15, 15)];
//    tanView.image = [MSUPathTools showImageWithContentOfFileByName:@"tan.jpg"];
//    [self addSubview:tanView];
//    
//    UILabel *ruleLab = [[UILabel alloc] init];
//    ruleLab.frame = CGRectMake(tanView.right+7.5,limitView.bottom +  13, kDeviceWidth*0.5, 19);
//    ruleLab.text = @"请查看换绑规则";
//    ruleLab.font = [UIFont systemFontOfSize:13];
//    ruleLab.textColor = HEXCOLOR(0x6aacfc);
//    [self addSubview:ruleLab];
//    
//    UIButton *ruleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    ruleBtn.frame = CGRectMake(0, limitView.bottom, kDeviceWidth, 45);
//    [self addSubview:ruleBtn];
//    [ruleBtn addTarget:self action:@selector(ruleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    
//    self.unbindBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _unbindBtn.frame = CGRectMake(_bankImaView.left, ruleLab.bottom+40, kDeviceWidth-56, 45);
//    _unbindBtn.backgroundColor = HEXCOLOR(0xFF6339);
//    _unbindBtn.layer.cornerRadius = 4;
//    _unbindBtn.clipsToBounds = YES;
//    _unbindBtn.layer.shouldRasterize = YES;
//    _unbindBtn.layer.rasterizationScale = [UIScreen mainScreen].scale;
//    [_unbindBtn setTitle:@"我要换卡" forState:UIControlStateNormal];
//    [_unbindBtn setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
//    _unbindBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
//    [self addSubview:_unbindBtn];
//    
    UILabel *kefuLab = [[UILabel alloc] init];
    kefuLab.frame = CGRectMake(0, kDeviceHeight-64-55-19, kDeviceWidth, 19);
    kefuLab.text = @"--- 客服热线 ---";
    kefuLab.font = [UIFont systemFontOfSize:13];
    kefuLab.textAlignment = NSTextAlignmentCenter;
    kefuLab.textColor = HEXCOLOR(0x939393);
    [self addSubview:kefuLab];
    
    UILabel *phoneLab = [[UILabel alloc] init];
    phoneLab.frame = CGRectMake(0, kefuLab.bottom + 1, kDeviceWidth, 30);
    phoneLab.text = @"400-0571-115";
    phoneLab.font = [UIFont systemFontOfSize:16];
    phoneLab.textAlignment = NSTextAlignmentCenter;
    phoneLab.textColor = HEXCOLOR(0x939393);
    [self addSubview:phoneLab];
    
    UIButton *tapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tapBtn.frame = CGRectMake(0, kefuLab.bottom + 3, kDeviceWidth, 30);
    [self addSubview:tapBtn];
    [tapBtn addTarget:self action:@selector(tapBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)tapBtnClick:(UIButton *)sender{
    sender.enabled = NO;
    NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"tel://%@",@"400-0571-115"];
    //    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    
    NSURL *url = [NSURL URLWithString:str];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        if (iOS10) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                if (success) {
                    MyLog(@"hahah");
                    sender.enabled = YES;
                } else{
                    sender.enabled = YES;
                }
            }];
        }else{
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

- (void)ruleBtnClick:(UIButton *)sender{
    
}


@end

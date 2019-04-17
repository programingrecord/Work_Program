//
//  MSUPwdView.m
//  vvlc
//
//  Created by 007 on 2018/4/26.
//  Copyright © 2018年 HM. All rights reserved.
//

#import "MSUPwdView.h"

#import "MSUPathTools.h"

@implementation MSUPwdView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.pwdArr = [NSMutableArray array];
        [self createView];
        
    }
    return self;
}


- (void)createView{
    self.backgroundColor = HEXCOLOR(0xF5F5F8);
    
    self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _closeBtn.frame = CGRectMake(20, 13.5, 22*kDeviceHeightScale, 22*kDeviceHeightScale);
    [_closeBtn setImage:[MSUPathTools showImageWithContentOfFileByName:@"icon-close"] forState:UIControlStateNormal];
    _closeBtn.adjustsImageWhenHighlighted = NO;
    [self addSubview:_closeBtn];
    
    UILabel *topLab = [[UILabel alloc] init];
    topLab.frame = CGRectMake(kDeviceWidth*0.5-70, 16*kDeviceHeightScale, 140, 16*kDeviceHeightScale);
    topLab.text = @"请输入交易密码";
    topLab.textColor = HEXCOLOR(0x2A2A2A);
    topLab.font = [UIFont systemFontOfSize:16];
    [self addSubview:topLab];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(0, topLab.bottom + 18*kDeviceHeightScale, kDeviceWidth, 1);
    lineView.backgroundColor = HEXCOLOR(0xe4e4e4);
    [self addSubview:lineView];
    
    CGFloat wid = (kDeviceWidth-40)/6;
    
    UIView *fuView = [[UIView alloc] init];
    fuView.frame = CGRectMake(20, topLab.bottom + 36*kDeviceHeightScale, kDeviceWidth-40, wid);
    fuView.backgroundColor = HEXCOLOR(0xF5F5F8);
    fuView.layer.borderWidth = 1;
    fuView.layer.borderColor = HEXCOLOR(0XE4E4E4).CGColor;
    [self addSubview:fuView];
    
    self.pwdTF = [[MSUTextField alloc] init];
    _pwdTF.frame = CGRectMake(0, 0, kDeviceWidth-40, wid);
    _pwdTF.textColor = HEXCOLOR(0xF5F5F8);
    _pwdTF.keyboardType = UIKeyboardTypeNumberPad;
    [fuView addSubview:_pwdTF];

    [_pwdTF becomeFirstResponder];
    
    for (NSInteger i = 0; i < 6; i++) {
        UILabel *pwdLab = [[UILabel alloc] init];
        pwdLab.frame = CGRectMake(wid*i, 0, wid, wid);
        pwdLab.textAlignment = NSTextAlignmentCenter;
        pwdLab.backgroundColor = HEXCOLOR(0xffffff);
        pwdLab.textColor = HEXCOLOR(0x333333);
        pwdLab.font = [UIFont systemFontOfSize:14];
        [fuView addSubview:pwdLab];
        [self.pwdArr addObject:pwdLab];
    }
    
    for (NSInteger i = 0; i < 5; i++) {
        UIView *lineView = [[UIView alloc] init];
        lineView.frame = CGRectMake(wid+wid*i, 0, 1, wid);
        lineView.backgroundColor = HEXCOLOR(0xE4E4E4);
        [fuView addSubview:lineView];
    }
}


@end

//
//  MSUProgressView.h
//  vvlc
//
//  Created by 007 on 2018/3/26.
//  Copyright © 2018年 HM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSUProgressView : UIView

//中心颜色

@property (strong, nonatomic)UIColor *centerColor;

//圆环背景色

@property (strong, nonatomic)UIColor *arcBackColor;

@property (strong, nonatomic)UIColor *regularColor;//一月
@property (strong, nonatomic)UIColor *MLBColor;//七天

//百分比数值（0-1）
@property (assign,nonatomic) float totalAccount;
//圆环宽度
@property (assign, nonatomic)float width;

- (void)setRegIncomePersent:(float)regIncomePersent MLBIncomePersent:(float)MLBIncomePersent totalIncome:(float)totalIncome;

@end

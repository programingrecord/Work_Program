//
//  ProgressViews.h
//  ProgressView
//
//  Created by HM on 16/6/15.
//  Copyright © 2016年 HM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressViews : UIView
//中心颜色

@property (strong, nonatomic)UIColor *centerColor;

//圆环背景色

@property (strong, nonatomic)UIColor *arcBackColor;


//圆环色
@property (strong, nonatomic)UIColor *MLBColor;//微微宝
@property (strong, nonatomic)UIColor *frozenColor;//冻结
@property (strong, nonatomic)UIColor *receiptColor;//回收
@property (strong, nonatomic)UIColor *MarchColor;//三月
@property (strong, nonatomic)UIColor *availableColor;//账户余额
@property (strong, nonatomic)UIColor *januaryColor;//一月
@property (strong, nonatomic)UIColor *sevenColor;//七天


//百分比数值（0-1）
@property (assign,nonatomic) double totalAccount;
//圆环宽度
@property (assign, nonatomic)double width;

- (void)setfrozenPersent:(double) frozenPeresent  availablePersent:(double) availablePersent MLBPersent:(double) MLBPersent januaryPercent:(double) januaryPercent sevenPercent:(double) sevenPercent MarchPercent:(double) MarchPercent totalAcoount:(double)totalAcoount totalIncome:(double)totalIncome;

@end

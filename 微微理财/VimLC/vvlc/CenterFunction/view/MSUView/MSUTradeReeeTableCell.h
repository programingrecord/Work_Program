//
//  MSUTradeReeeTableCell.h
//  vvlc
//
//  Created by 007 on 2018/4/24.
//  Copyright © 2018年 HM. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^protocalBtnClickBlock)(UIButton *btn);

@interface MSUTradeReeeTableCell : UITableViewCell

@property (nonatomic , strong) UILabel *titLab;

@property (nonatomic , strong) UILabel *moneyLab;

@property (nonatomic , strong) UILabel *signLab;

@property (nonatomic , strong) UILabel *dateLab;

@property (nonatomic , strong) UIView *planView;

@property (nonatomic , strong) UIButton *protocalBtn;

@property (nonatomic , strong) UIButton *planBtn;

@property (nonatomic , strong) UIView *bgViewa;

@property (nonatomic , copy) protocalBtnClickBlock proBlock;

@end

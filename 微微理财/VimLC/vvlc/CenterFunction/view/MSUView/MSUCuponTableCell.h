//
//  MSUCuponTableCell.h
//  vvlc
//
//  Created by 007 on 2018/3/19.
//  Copyright © 2018年 HM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CouponModel.h"


@interface MSUCuponTableCell : UITableViewCell

@property (nonatomic , assign) NSInteger useIndex;

@property (nonatomic , strong) UIView *bgView;

@property (nonatomic , strong) UILabel *priceLab;

@property (nonatomic , strong) UIImageView *imaView;

///返现红包
@property (nonatomic , strong) UILabel *introLab;

@property (nonatomic , strong) UILabel *priLimitLab;

@property (nonatomic , strong) UILabel *infoLab;

@property (nonatomic , strong) UILabel *timeLab;

@property (nonatomic , strong) UIView *whiteView;

@property (strong, nonatomic)  CouponModel *model;

@property (nonatomic , strong) UILabel *useLab;


@end

//
//  MSUTradeRecordCell.h
//  vvlc
//
//  Created by 007 on 2018/4/25.
//  Copyright © 2018年 HM. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TrandRecordModel.h"


@interface MSUTradeRecordCell : UITableViewCell

@property (nonatomic , strong) UILabel *titLab;

@property (nonatomic , strong) UILabel *moneyLab;

@property (nonatomic , strong) UILabel *introLab;

@property (nonatomic , strong) UILabel *dateLab;

@property (nonatomic , strong) UILabel *yueLab;

@property (nonatomic,strong) TrandRecordModel *model;


@end

//
//  MSUHuoQiTableCell.h
//  vvlc
//
//  Created by 007 on 2018/1/11.
//  Copyright © 2018年 HM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "loanModel.h"

@interface MSUHuoQiTableCell : UITableViewCell

@property (nonatomic , copy) void(^giveBtnClick)(UIButton *btn);

@property (nonatomic , strong) UILabel *titLab;

@property (nonatomic , strong) UIImageView *signImaView;

@property (nonatomic , strong) UILabel *leftTitLab;

@property (nonatomic , strong) UILabel *rightTitLab;

@property (nonatomic , strong) UILabel *incomeLab;

@property (nonatomic , strong) UILabel *introLab;

@property (nonatomic , strong) UILabel *yearIncomeLab;

@property (nonatomic , strong) UILabel *dayIncome;

@property (nonatomic , strong) UIButton *giveBtn;

@property (nonatomic , strong) loanModel *loanModel;

@property (nonatomic , strong) UIImageView *mlbImaView;


@end

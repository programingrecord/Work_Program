//
//  MSUHomeTableCell.h
//  vvlc
//
//  Created by 007 on 2018/1/11.
//  Copyright © 2018年 HM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "loanModel.h"

@interface MSUHomeTableCell : UITableViewCell

@property (nonatomic , strong) UIImageView *bgImageView;

@property (nonatomic , strong) UIImageView *statusImageView;

@property (nonatomic , strong) UILabel *titLab;

@property (nonatomic , strong) UILabel *leftTitLab;

@property (nonatomic , strong) UILabel *rightTitLab;

@property (nonatomic , strong) UIImageView *signImaView;

@property (nonatomic , strong) UILabel *incomeLab;

@property (nonatomic , strong) UILabel *introLab;

@property (nonatomic , strong) UILabel *yearIncomeLab;

@property (nonatomic , strong) UILabel *dayIncomeLab;

@property (nonatomic , strong) NSDictionary *dataDic;

@property (nonatomic , strong) loanModel *loanModel;

@property (nonatomic , strong) UIProgressView *ProssView;

@property (nonatomic , strong) UIView *bg1View;

@property (nonatomic , strong) UILabel *leftAmountLab;

@property (nonatomic , strong) UILabel *leftIntroLab;

@end

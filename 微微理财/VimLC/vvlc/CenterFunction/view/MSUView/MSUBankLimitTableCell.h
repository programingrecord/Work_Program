//
//  MSUBankLimitTableCell.h
//  vvlc
//
//  Created by 007 on 2018/4/20.
//  Copyright © 2018年 HM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BankLimitModel.h"


@interface MSUBankLimitTableCell : UITableViewCell

@property (nonatomic , strong) UILabel *bankLab;
@property (nonatomic , strong) UILabel *introLLLab;
@property (nonatomic , strong) UILabel *introFYLab;
@property (nonatomic , strong) UIImageView *bankImage;
@property (nonatomic , strong) UILabel *signLab;


@property (nonatomic , strong) UIView *lineView;

@end

//
//  MSUJuanTableCell.h
//  vvlc
//
//  Created by 007 on 2018/1/12.
//  Copyright © 2018年 HM. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MSUJuanTableCell : UITableViewCell

@property (nonatomic , strong) UIView *bgView;

@property (nonatomic , strong) UILabel *priceLab;

///返现红包
@property (nonatomic , strong) UILabel *introLab;

@property (nonatomic , strong) UILabel *priLimitLab;

@property (nonatomic , strong) UILabel *infoLab;

@property (nonatomic , strong) UILabel *timeLab;

@property (nonatomic , strong) UIView *whiteView;

@property (nonatomic , strong) UIImageView *imaView;

@property (nonatomic , strong) UIImageView *selectImaView;



@end

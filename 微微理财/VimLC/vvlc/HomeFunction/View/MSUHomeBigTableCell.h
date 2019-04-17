//
//  MSUHomeBigTableCell.h
//  vvlc
//
//  Created by 007 on 2018/1/11.
//  Copyright © 2018年 HM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSUHomeBigTableCell : UITableViewCell

@property (nonatomic , copy) void(^giveBtnClick)(UIButton *btn);

@property (nonatomic , strong) UIImageView *bgImageView;

@property (nonatomic , strong) UILabel *titLab;

@property (nonatomic , strong) UIImageView *signImaView;

@property (nonatomic , strong) UILabel *incomeLab;

@property (nonatomic , strong) UILabel *introLab;

@property (nonatomic , strong) UILabel *leftLab;

@property (nonatomic , strong) UILabel *centerLab;

@property (nonatomic , strong) UILabel *rightLab;

@property (nonatomic , strong) UIButton *giveBtn;

@property (nonatomic , strong) NSDictionary *dataDic;

//@property (nonatomic , assign) NSInteger index;



@end

//
//  MSUBankCardView.h
//  vvlc
//
//  Created by 007 on 2018/4/26.
//  Copyright © 2018年 HM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSUBankCardView : UIView

@property (nonatomic , strong) UIImageView *bankImaView;

@property (nonatomic , strong) UILabel *bankName;

@property (nonatomic , strong) UILabel *bankNum;

@property (nonatomic , strong) UILabel *nameLab;

@property (nonatomic , strong) UIButton *unbindBtn;

@property (nonatomic , strong) UILabel *singleLimitLab;

@property (nonatomic , strong) UILabel *dayLimitLab;

@end

//
//  MSUTradeTopView.h
//  vvlc
//
//  Created by 007 on 2018/1/15.
//  Copyright © 2018年 HM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSUTradeTopView : UIView

@property (nonatomic , strong) UILabel *priceLab;

@property (nonatomic , strong) UILabel *limitLab;

@property (nonatomic , strong) UILabel *surplusLab;

@property (nonatomic , strong) UILabel *totalLab;

@property (nonatomic , strong) UIProgressView *progressView;

@property (nonatomic , strong) UIButton *progressBtn;


@end

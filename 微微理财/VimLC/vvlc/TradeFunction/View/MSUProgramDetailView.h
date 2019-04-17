//
//  MSUProgramDetailView.h
//  vvlc
//
//  Created by 007 on 2018/1/15.
//  Copyright © 2018年 HM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSUShadowInView.h"

@interface MSUProgramDetailView : UIView

@property (nonatomic , strong) UILabel *historyTopLab;
@property (nonatomic , strong) UILabel *limitTopLab;
@property (nonatomic , strong) UILabel *totalTopLab;
@property (nonatomic , strong) UILabel *incomeStyleLab;
@property (nonatomic , strong) UILabel *qixiTopLab;
@property (nonatomic , strong) UILabel *daoqiTopLab;

@property (nonatomic , strong) UIView *progressView;
@property (nonatomic , strong) UIView *describeView;
//@property (nonatomic , strong) UIView *lineView;
//@property (nonatomic , strong) UIView *lineView1;
//@property (nonatomic , strong) UIView *lineView2;

@property (nonatomic , strong) UIView *introView;
@property (nonatomic , strong) UILabel *introDetailLab;

@property (nonatomic , strong) NSMutableArray *cicleViewArr;
@property (nonatomic , strong) NSMutableArray *textArr;

@property (nonatomic , strong) UILabel *describeDetailLab;
@property (nonatomic , strong) UILabel *moneyLab;
@property (nonatomic , strong) UILabel *numLab;
@property (nonatomic , strong) UIImageView* describeDetailView;;
@property (nonatomic , strong) UIButton* describeDetailBtn;;

@property (nonatomic , strong) UIView *informationView;
@property (nonatomic , strong) UIButton *safeBtn;


/// 财产保险
@property (nonatomic , strong) UIView *lastView;
@property (nonatomic , strong) UIButton *danbaoBtn;
@property (nonatomic , strong) UIButton *protoBtn;
@property (nonatomic , strong) UIButton *xieyiBtn;

//@property (nonatomic , strong) NSMutableArray* describeBtnArr;;

@property (nonatomic , strong) NSArray *dataArr;
@property (nonatomic , strong) NSArray *dateArr;
@property (nonatomic , strong) NSArray *imaArr;
@property (nonatomic , strong) NSDictionary *dataDic;

@property (nonatomic , strong) MSUShadowInView *shadowView;
@property (nonatomic , strong) UIImageView *imaSView;



@end

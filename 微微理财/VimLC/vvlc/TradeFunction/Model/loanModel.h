//
//  loanModel.h
//  WTJR
//
//  Created by HM on 16/6/8.
//  Copyright © 2016年 HM. All rights reserved.
//
/**
  amount = "60,000.00";
 borrowType = "\U62c5\U4fdd\U6807";
 borrowTypeOther = "\U62c5\U4fdd\U6807";
 completePercent = "0.00";
 lunaP2pBorrowId = 16;
 maxBidAmount = "60,000.00";
 minBidAmount = "50.00";
 rate = "8.00%";
 rewardrate = "0.00%";
 timeCount = "2\U6708";
 title = "\U7ea2\U672c\U62b5\U62bc\U501f\U6b3e";
*/

#import "BaseModel.h"

@interface loanModel : BaseModel
@property (nonatomic,strong) NSString *amount;
@property (nonatomic,strong) NSString *borrowType;

@property (nonatomic,strong) NSString *lunaP2pBorrowId;

@property (nonatomic,strong) NSString *borrowTypeOther;

@property (nonatomic,strong) NSString *completePercent;

@property (nonatomic,strong) NSString *maxBidAmount;

@property (nonatomic,strong) NSString *minBidAmount;

@property (nonatomic,strong) NSString *rate;

@property (nonatomic,strong) NSString *rewardrate;

@property (nonatomic,strong) NSString *timeCount;

@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *borrowState;


@property (nonatomic,strong) NSString *currentTip1;
@property (nonatomic,strong) NSString *currentTip2;
@property (nonatomic,strong) NSString *currentTip3;

@property (nonatomic,strong) NSString *amountLeft;

@property (nonatomic,strong) NSString *rate2;
@property (nonatomic,strong) NSString *rate1;
@property (nonatomic,strong) NSString *hasActivity;

@property (nonatomic,strong) NSString *rateIncrease;

@property (nonatomic , copy) NSString *rigntImage;

@property (nonatomic,strong) NSString *AddInterest;

@property (nonatomic , copy) NSString *leftTittle;
@property (nonatomic , copy) NSString *rightTittle;
@property (nonatomic , copy) NSString *dayIncome;
@property (nonatomic , copy) NSString *signImage;

@end

//
//  TransferModel.h
//  WTJR
//
//  Created by H on 16/6/9.
//  Copyright © 2016年 HM. All rights reserved.
//

#import "BaseModel.h"

@interface TransferModel : BaseModel

@property (nonatomic,strong) NSString *brid;
@property (nonatomic,strong) NSString *calculatedSuccessAmountD;

@property (nonatomic,strong) NSString *calculatedProfitAmountD;

@property (nonatomic,strong) NSString *daysLeft2Receipt;

@property (nonatomic,strong) NSString *eid;
@property (nonatomic,strong) NSString *expireDate;
@property (nonatomic,strong) NSString *index;

@property (nonatomic,strong) NSString *profitRateDNoPercentSign;

@property (nonatomic,strong) NSString *transferAmount;
@property (nonatomic,strong) NSString *title;

@end

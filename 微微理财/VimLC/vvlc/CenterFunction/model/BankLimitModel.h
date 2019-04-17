//
//  BankLimitModel.h
//  vvlc
//
//  Created by 慧明 on 2017/10/31.
//  Copyright © 2017年 HM. All rights reserved.
//

#import "BaseModel.h"

@interface BankLimitModel : BaseModel

@property (nonatomic,strong) NSString *bankCode;
@property (nonatomic,strong) NSString *bankName;
@property (nonatomic,strong) NSString *bankStatus;
@property (nonatomic,strong) NSString *cardType;
@property (nonatomic,strong) NSString *dayAmt;
@property (nonatomic,strong) NSString *monthAmt;
@property (nonatomic,strong) NSString *singleAmt;
@property (nonatomic,strong) NSString *bankIcon;
@property (nonatomic,strong) NSString *disburse;

@end

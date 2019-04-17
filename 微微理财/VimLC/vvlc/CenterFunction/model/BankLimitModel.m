//
//  BankLimitModel.m
//  vvlc
//
//  Created by 慧明 on 2017/10/31.
//  Copyright © 2017年 HM. All rights reserved.
//

#import "BankLimitModel.h"

@implementation BankLimitModel
- (NSDictionary*)setMapAttributes{
    
    NSDictionary *mapAtt = @{
                             @"bankCode" : @"bankCode",
                             @"bankName" : @"bankName",
                             @"bankStatus" :@"bankStatus",
                             @"cardType" :@"cardType",
                             @"dayAmt" :@"dayAmt",
                             @"monthAmt" :@"monthAmt",
                             @"singleAmt" :@"singleAmt",
                             @"bankIcon" :@"bankIcon",
                             @"disburse":@"disburse"
                             };
    return mapAtt;
    
    
}
@end

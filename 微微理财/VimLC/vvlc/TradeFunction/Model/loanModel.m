//
//  loanModel.m
//  WTJR
//
//  Created by HM on 16/6/8.
//  Copyright © 2016年 HM. All rights reserved.
//

#import "loanModel.h"

@implementation loanModel
- (NSDictionary*)setMapAttributes{
    
    NSDictionary *mapAtt = @{
                             @"amount":@"amount",
                             @"borrowType" : @"borrowType",
                             @"lunaP2pBorrowId" : @"lunaP2pBorrowId",
                             @"borrowTypeOther" : @"borrowTypeOther",
                             @"completePercent" :@"completePercent",
                             @"maxBidAmount" :@"maxBidAmount",
                             @"minBidAmount" :@"minBidAmount",
                             @"rate" :@"rate",
                             @"rewardrate" :@"rewardrate",
                             @"timeCount" :@"timeCount",
                             @"title" :@"title",
                             @"borrowState" :@"borrowState",
                             @"currentTip1" :@"currentTip1",
                             @"currentTip2" :@"currentTip2",
                             @"currentTip3" :@"currentTip3",
                            @"amountLeft":@"amountLeft",
                             @"rate1" :@"rate1",
                             @"rate2" :@"rate2",
                             @"hasActivity":@"hasActivity",
                             @"rateIncrease":@"rateIncrease",
                             @"rightImage":@"rightImage",
                             @"leftTittle":@"leftTittle",
                             @"rightTittle":@"rightTittle",
                             @"dayIncome":@"dayIncome",
                             @"signImage":@"signImage"
                                 };
    return mapAtt;
}


@end

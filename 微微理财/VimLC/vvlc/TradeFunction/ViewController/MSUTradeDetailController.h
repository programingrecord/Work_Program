//
//  MSUTradeDetailController.h
//  vvlc
//
//  Created by 007 on 2018/1/11.
//  Copyright © 2018年 HM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "loanModel.h"
#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, MSUTradeInfoType) {
    MSUTradeinfoTypeloanInfo = 0,                         // no button type
    MSUTradeinfoTypeBidrecord ,                         // no button type
    MSUTradeinfoTypeRepaymentplan,
};

@interface MSUTradeDetailController : BaseViewController

@property (nonatomic,strong) loanModel *Loanmodel;
@property (nonatomic , strong) NSDictionary *postDic;
@property (nonatomic , copy) NSString *idStr;

@property (nonatomic,assign) MSUTradeInfoType TradeinfoType;

@end

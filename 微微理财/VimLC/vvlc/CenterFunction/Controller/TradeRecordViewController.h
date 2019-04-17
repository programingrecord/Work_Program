//
//  TradeRecordViewController.h
//  WTJR
//
//  Created by HM on 16/6/6.
//  Copyright © 2016年 HM. All rights reserved.
//

#import "BaseViewController.h"

typedef enum : NSUInteger{
    TrandeRecordTypeAll = 0,
    TrandeRecordTypeRecharge,//线上充值
    TrandeRecordTypeWithdrawals,//提现
    TrandeRecordTypeBid,//投标
    TrandeRecordTypeReceivables,//收款
    TrandeRecordTypeBidAward,//投标奖励
    TrandeRecordTypeInterest,//利息管理费
    TrandeRecordTypeRecommendAward,//推荐奖励
    TrandeRecordTypeCurrentJoin,//加入微微宝
    TrandeRecordTypeCurrentWithDraw,//微微宝提现
    TrandeRecordTypeRegistCash,//注册红包投资兑现

}TrandeRecordType;


typedef enum : NSUInteger{
    TrandeRecordFromType_ALL = 0,//所有
    TrandeRecordFromType_MLB,//微微宝
    TrandeRecordFromType_WITHDRAW,//提现记录
    TrandeRecordFromType_TOPUP,//充值记录
}TrandeRecordFromType;

@interface TradeRecordViewController : BaseViewController

@property (nonatomic,assign)TrandeRecordType  TrandeType;
@property (nonatomic,assign)TrandeRecordFromType  TrandeFromType;

@end

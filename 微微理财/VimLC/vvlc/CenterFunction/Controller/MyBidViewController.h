//
//  MyBidViewController.h
//  WTJR
//
//  Created by H on 16/8/10.
//  Copyright © 2016年 HM. All rights reserved.
//

#import "BaseViewController.h"

@interface MyBidViewController : BaseViewController
typedef NS_ENUM(NSInteger, MybidType){
    
    MybidTypeTypeAll = 0,
    MybidTypeZhaoBiao,//招标中
    MybidTypeCancel,//撤销
    MybidTypeLiubiao,//流标
    MybidTypeHuankuan,//还款中
    MybidTypeHuanQing,//还清
    MybidTypeYuQi,//逾期
    MybidTypeBadBid,//坏账
};

@property (nonatomic,assign)MybidType  BidType;


@end

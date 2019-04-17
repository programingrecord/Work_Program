//
//  MSUExpireController.h
//  vvlc
//
//  Created by 007 on 2018/3/20.
//  Copyright © 2018年 HM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, MSUCouponType) {
    MSUCouponTypeHB = 0,                         // no button type
    MSUCouponType_LC,
    MSUCouponType_JX
};

@interface MSUExpireController : BaseViewController

@property (nonatomic,assign) MSUCouponType type;

@end

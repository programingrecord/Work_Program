//
//  CouponViewController.h
//  vvlc
//
//  Created by 慧明 on 2017/11/7.
//  Copyright © 2017年 HM. All rights reserved.
//

#import "BaseViewController.h"


typedef NS_ENUM(NSInteger, CouponType) {
    CouponTypeHB = 0,                         // no button type
    CouponType_LC,
    CouponType_JX
};

@interface CouponViewController : BaseViewController

@property (nonatomic,assign) CouponType type;

@end

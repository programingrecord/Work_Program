//
//  CouponModel.h
//  vvlc
//
//  Created by 慧明 on 2017/11/7.
//  Copyright © 2017年 HM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CouponModel : NSObject

@property (nonatomic,strong) NSString *amount;
@property (nonatomic,strong) NSString *bagState;
@property (nonatomic,strong) NSString *bagType;
@property (nonatomic,strong) NSString *bidAmount;
@property (nonatomic,strong) NSString *endDate;
@property (nonatomic,strong) NSString *timeCount;
@property (nonatomic,strong) NSString *tip;

+ (CouponModel *)createCouponListModel:(NSDictionary *)dic;

@end

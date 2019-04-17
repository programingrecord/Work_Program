//
//  CouponModel.m
//  vvlc
//
//  Created by 慧明 on 2017/11/7.
//  Copyright © 2017年 HM. All rights reserved.
//

#import "CouponModel.h"

@implementation CouponModel

+ (CouponModel *)createCouponListModel:(NSDictionary *)dic{
    
    CouponModel *model = [[CouponModel alloc] init];
    if (dic) {
        [model setValuesForKeysWithDictionary:dic];
    }
    return model;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"CouponModel--%@",key);
}
@end

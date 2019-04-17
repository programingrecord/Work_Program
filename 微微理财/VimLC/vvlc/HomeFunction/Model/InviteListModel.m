//
//  InviteListModel.m
//  vvlc
//
//  Created by 慧明 on 2017/12/18.
//  Copyright © 2017年 HM. All rights reserved.
//

#import "InviteListModel.h"

@implementation InviteListModel

+ (InviteListModel *)createInviteListModel:(NSDictionary *)dic{
    InviteListModel *model = [[InviteListModel alloc] init];
    if (dic) {
        [model setValuesForKeysWithDictionary:dic];
    }
    return model;
}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"InviteListModel--%@",key);
}

@end

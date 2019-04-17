//
//  InviteListModel.h
//  vvlc
//
//  Created by 慧明 on 2017/12/18.
//  Copyright © 2017年 HM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InviteListModel : NSObject

@property (nonatomic,strong)  NSString *amount;
@property (nonatomic,strong)  NSString *date;
@property (nonatomic,strong)  NSString *name;

+ (InviteListModel *)createInviteListModel:(NSDictionary *)dic;

@end

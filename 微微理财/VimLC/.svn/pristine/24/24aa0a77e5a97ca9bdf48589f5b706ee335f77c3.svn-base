//
//  VerifyRegexTool.m
//  ClassmateUnion
//
//  Created by 朱逸嘉 on 16/7/18.
//  Copyright © 2016年 zhonghaicheng. All rights reserved.
//

#import "VerifyRegexTool.h"

@implementation VerifyRegexTool

#pragma 正则匹配手机号
+ (BOOL)checkTelNumber:(NSString *) telNumber
{
    NSString *MOBILE = @"^1([0-9][0-9])\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    BOOL isMatch = [pred evaluateWithObject:telNumber];
    return isMatch;
}

#pragma 正则匹配用户密码8-16位数字和字母组合
+ (BOOL)checkPassword:(NSString *) password
{
    NSString *pattern = @"^(?![0-9]+$)(?![a-zA-Z]+$)(?![~!@#$%^&_]+$)[a-zA-Z0-9~!@#$%^&_]{8,16}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:password];
    return isMatch;
    
}

#pragma 正则匹配用户姓名,20位的中文或英文
+ (BOOL)checkUserName : (NSString *) userName
{
    NSString *pattern = @"^[a-zA-Z一-龥]{1,20}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:userName];
    return isMatch;
    
}

#pragma 正则匹配用户身份证号15或18位
+ (BOOL)checkUserIdCard: (NSString *) idCard
{
    NSString *pattern = @"(^[0-9]{15}$)|([0-9]{17}([0-9]|X)$)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:idCard];
    return isMatch;
}

#pragma 正则匹员工号,10位的数字
+ (BOOL)checkEmployeeNumber : (NSString *) number
{
    NSString *pattern = @"^[0-9]{10}";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:number];
    return isMatch;
    
}

#pragma 正则匹配URL
+ (BOOL)checkURL : (NSString *) url
{
    NSString *pattern = @"^[0-9A-Za-z]{1,50}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:url];
    return isMatch;
    
}

@end

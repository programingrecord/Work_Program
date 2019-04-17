//
//  ToolArc.m
//  私人通讯录
//
//  Created by muxi on 14-9-3.
//  Copyright (c) 2014年 muxi. All rights reserved.
//

#import "CoreArchive.h"

@implementation CoreArchive

#pragma mark - 偏好类信息存储


+(void)setDictionary:(NSDictionary *)Dic key:(NSString *)key
{
    //获取preference
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //保存
    [defaults setObject:Dic forKey:key];
    
    //立即同步
    [defaults synchronize];
}


//保存普通对象
+(void)setStr:(NSString *)str key:(NSString *)key{
    
    //获取preference
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //保存
    [defaults setObject:str forKey:key];
    
    //立即同步
    [defaults synchronize];

}

//读取
+(NSString *)strForKey:(NSString *)key{
    
    //获取preference
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //读取
    NSString *str=(NSString *)[defaults objectForKey:key];
    
    return str;

}

//删除
+(void)removeStrForKey:(NSString *)key{
    
    [self setStr:nil key:key];

}

//保存int
+(void)setInt:(NSInteger)i key:(NSString *)key{
    //获取preference
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //保存
    [defaults setInteger:i forKey:key];
    
    //立即同步
    [defaults synchronize];

}

//读取
+(NSInteger)intForKey:(NSString *)key{
    //获取preference
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //读取
    NSInteger i=[defaults integerForKey:key];
    
    return i;
}

//保存float
+(void)setFloat:(CGFloat)floatValue key:(NSString *)key{
    
    //获取preference
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //保存
    [defaults setFloat:floatValue forKey:key];
    
    //立即同步
    [defaults synchronize];

}
//读取
+(CGFloat)floatForKey:(NSString *)key{
    //获取preference
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //读取
    CGFloat floatValue=[defaults floatForKey:key];
    
    return floatValue;
}


//保存bool
+(void)setBool:(BOOL)boolValue key:(NSString *)key{
    //获取preference
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //保存
    [defaults setBool:boolValue forKey:key];
    
    //立即同步
    [defaults synchronize];

}
//读取
+(BOOL)boolForKey:(NSString *)key{
    //获取preference
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //读取
    BOOL boolValue=[defaults boolForKey:key];
    
    return boolValue;
}




#pragma mark - 文件归档
//归档
+(BOOL)archiveRootObject:(id)obj toFile:(NSString *)path{
   return [NSKeyedArchiver archiveRootObject:obj toFile:path];
}
//删除
+(BOOL)removeRootObjectWithFile:(NSString *)path{
    return [self archiveRootObject:nil toFile:path];
}
//解档
+(id)unarchiveObjectWithFile:(NSString *)path{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:path];
}



+(void)removeNSUserDefaults{
    NSUserDefaults*  defs = [NSUserDefaults standardUserDefaults];
    
    NSDictionary* dict = [defs dictionaryRepresentation];
    
    for(NSString * idkey in dict) {
        if ([idkey isEqualToString:@"last_run_version_of_application"] || [idkey isEqualToString:@"isUPActivate"] || [idkey isEqualToString:@"MSUUserName"] || [idkey isEqualToString:@"tradeHistory"] || [idkey isEqualToString:@"listHistory"] || [idkey isEqualToString:@"homeHistory"] || [idkey isEqualToString:@"showHiden"] || [idkey isEqualToString:@"MSUTradePwd"]) {
            
        }else{
            [defs removeObjectForKey:idkey];
        }
    }
    [defs synchronize];
}


//是否绑定银行卡
+(void)ishasLockedBank:(BOOL)isLockedBank{
    [[NSUserDefaults standardUserDefaults] setBool:isLockedBank forKey:@"isLockedBank"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

+(BOOL)isLockedBank{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"isLockedBank"];

}

//是否收到通知
+(void)isHasRecieveNoti:(BOOL)isRecieveNoti{
    [[NSUserDefaults standardUserDefaults] setBool:isRecieveNoti forKey:@"isRecieveNoti"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

+(BOOL)isRecieveNoti{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"isRecieveNoti"];
    
}


//是否绑定姓名
+(void)ishasLockName:(BOOL)isLockName{
    [[NSUserDefaults standardUserDefaults] setBool:isLockName forKey:@"isLockName"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}
+(BOOL)isLockName{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"isLockName"];

}


//是否上传过
+(void)isUPActivateData:(BOOL)isUPActivate{
    [[NSUserDefaults standardUserDefaults] setBool:isUPActivate forKey:@"isUPActivate"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

+(BOOL)isUPActivate{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"isUPActivate"];
    
}

+(void)isSetTradePassWord:(BOOL)isTradePass{
    [[NSUserDefaults standardUserDefaults] setBool:isTradePass forKey:@"isSetTradePass"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
+(BOOL)isSetTradePass{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"isSetTradePass"];
}

+(void)isSetHandPassWord:(BOOL)isHandPassWord{
    [[NSUserDefaults standardUserDefaults] setBool:isHandPassWord forKey:@"isHandPassWord"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(BOOL)isSetHandPassWord{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"isHandPassWord"];

}

@end

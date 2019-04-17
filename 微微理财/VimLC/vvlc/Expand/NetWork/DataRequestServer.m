//
//  DataRequestServer.m
//  WTJR
//
//  Created by HM on 16/6/3.
//  Copyright © 2016年 HM. All rights reserved.
//

#import "DataRequestServer.h"

#import "MSUPathTools.h"


static DataRequestServer *DataRequestServerObj = nil;

@implementation DataRequestServer
+(DataRequestServer*) getDataRequestServerData{
    static dispatch_once_t once;
    dispatch_once( &once, ^{
        if(!DataRequestServerObj){
            DataRequestServerObj = [[self alloc] init];
        }
    });
    return DataRequestServerObj;
}
- (void)request:(NSString *)urlString  parameters:(NSMutableDictionary *) parameters result:(RequestBlock ) block{
    self.resultBlock = block;
    
    if (!self.maxRequest) {
        self.maxRequest = 0;
    }

    NSString *URLString = [NSString stringWithFormat:@"%@%@",Base_url,urlString];
    
    if (!parameters || parameters.allKeys.count == 0) {
        parameters = [NSMutableDictionary dictionary];
    }
    [parameters setObject:@"WeiMi" forKey:@"appIdenty"];
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary]
                                objectForKey:@"CFBundleShortVersionString"];
    [parameters setObject:currentVersion forKey:@"appVersion"];
    [parameters setObject:@"MSUOnline" forKey:@"appAsign"];

    MyLog(@"URLString=%@=%@",URLString,parameters);
    
    [CoreArchive setStr:urlString key:@"msuexception"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 30;

    [manager.requestSerializer setValue:@"LUNA.APP.U.AGENT" forHTTPHeaderField:@"User-Agent"];

    [manager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        if ([urlString isEqualToString:@"LunaP2pAppBannerHdServlet"]) {
            [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"homeHistory"];
        } else if ([urlString isEqualToString:@"LunaP2pAppActivityRunServlet"]){
            [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"listHistory"];
        } else if ([urlString isEqualToString:@"LunaP2pAppBorrowListNewServlet"]){
            [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"tradeHistory"];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];

        MyLog(@"%@=%@",urlString,dic);
        block(dic);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(@"44");
        [self requestImportWithUrl:URLString Error:error urlParams:parameters];

        self.maxRequest++;
        if (self.maxRequest < 10) {
            if ([urlString isEqualToString:@"LunaP2pAppActivateDataServlet"]) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self request:urlString parameters:parameters result:^(id result) {
                        MyLog(@"idfa重新发送中 %ld",self.maxRequest);
                    }];
                });
            }
        }
        
        
        MyLog(@"%@=%@",urlString,error);
    }];
}
- (void)requestLoginparameters:(NSMutableDictionary *)parameters result:(RequestBlock ) block{
    [parameters setObject:@"WeiMi" forKey:@"appIdenty"];
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary]
                                objectForKey:@"CFBundleShortVersionString"];
    [parameters setObject:currentVersion forKey:@"appVersion"];
    
    self.resultBlock = block;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 30;

    [manager.requestSerializer setValue:@"LUNA.APP.U.AGENT" forHTTPHeaderField:@"User-Agent"];

    NSString *URLString =[NSString stringWithFormat:@"%@login.do",Base_url];
    [CoreArchive setStr:URLString key:@"msuexception"];

    [manager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        block(dic);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        AFHTTPSessionManager *manager2 = [AFHTTPSessionManager manager];
        manager2.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager2.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager2.requestSerializer setValue:@"LUNA.APP.U.AGENT" forHTTPHeaderField:@"User-Agent"];
        
        NSString *URLString2 =[NSString stringWithFormat:@"%@LunaP2pAppLoginServlet",Base_url];
        [CoreArchive setStr:URLString key:@"msuexception"];

        [manager POST:URLString2 parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"requestLoginparameters2=%@",dic);
            block(dic);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            block(@"44");
            [self requestImportWithUrl:URLString Error:error urlParams:parameters];
        }];
    }];
}


- (void)requestLoginresult:(RequestLoginBlock)LoginBlock{

    self.LoginBlock = LoginBlock;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *NSdic = [defaults objectForKey:@"registerData"];
    NSString *username = [NSdic objectForKey:@"UserName"];
    NSString *password = [NSdic objectForKey:@"PassWord"];
    NSMutableDictionary *parms = [[NSMutableDictionary alloc] init];//登录保存的字典
    if (username == nil || password == nil) {
        [CoreArchive removeNSUserDefaults];
        self.LoginBlock(@"false");
        return;
    }
    [parms setObject:username forKey:@"username"];
    [parms setObject:password forKey:@"password"];
    [parms setObject:@"WeiMi" forKey:@"appIdenty"];
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary]
                                objectForKey:@"CFBundleShortVersionString"];
    [parms setObject:currentVersion forKey:@"appVersion"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:@"LUNA.APP.U.AGENT" forHTTPHeaderField:@"User-Agent"];
    NSString *URLString =[NSString stringWithFormat:@"%@login.do",Base_url];
    [CoreArchive setStr:URLString key:@"msuexception"];

    [manager POST:URLString parameters:parms progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSString *value = [dic objectForKey:@"errorlog"];
        int  isNeedToActive =[[dic objectForKey:@"isNeedToActivated"]intValue];
        int  success = [[dic objectForKey:@"success"]intValue];
        if ([value isEqualToString:@""]&& success==1 && isNeedToActive !=1){
            self.LoginBlock(@"true");
        }else{
            [CoreArchive removeNSUserDefaults];
            self.LoginBlock(@"false");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        
        AFHTTPSessionManager *manager2 = [AFHTTPSessionManager manager];
        manager2.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager2.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager2.requestSerializer setValue:@"LUNA.APP.U.AGENT" forHTTPHeaderField:@"User-Agent"];
        NSString *URLString2 =[NSString stringWithFormat:@"%@LunaP2pAppLoginServlet",Base_url];
        [CoreArchive setStr:URLString key:@"msuexception"];

        [manager2 POST:URLString2 parameters:parms progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSString *value = [dic objectForKey:@"errorlog"];
            int  isNeedToActive =[[dic objectForKey:@"isNeedToActivated"]intValue];
            int  success = [[dic objectForKey:@"success"]intValue];
            if ([value isEqualToString:@""]&& success==1 && isNeedToActive !=1){
                self.LoginBlock(@"true");
                
            }else{
                [CoreArchive removeNSUserDefaults];
                self.LoginBlock(@"false");
            }

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [CoreArchive removeNSUserDefaults];
            
            [self requestImportWithUrl:URLString Error:error urlParams:parms];
            self.LoginBlock(@"false");
        }];
    }];
}


- (void)requestImportWithUrl:(NSString *)url Error:(NSError *)error urlParams:(NSMutableDictionary *)urlParams{
    NSDictionary *dic = @{@"ft":@"5",@"fileType":@"2"};
    
    NSString * pathUrl = [NSString stringWithFormat:@"========URL访问错误报告========,\nManufacturer:%@\n,PhoneType:%@\n,SystemVersion:%@\n,ErrorType:%@,\nErrorReason:\n%@,ErrorUrl:%@,\nErrorSignal:%@\n,appidenty:%@\n,appversion:%@,\n,urlParams:%@,\n",@"iPhone",[MSUPathTools getInfoFromPhone:MSUPhoneType],[MSUPathTools getInfoFromPhone:MSUPhoneSystemVersion],@"请求接口访问出错",error,url,@"",@"WeiMi",[MSUPathTools getInfoFromPhone:MSUPhoneAppVersion],urlParams];
    
    NSString * path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"urlError.txt"];
    [pathUrl writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    // 发送重要日志
//    NSString *path1 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    NSString *dataPath = [path1 stringByAppendingPathComponent:@"urlError.txt"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    if (data != nil) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer.timeoutInterval = 5.0f;
        [manager.requestSerializer setValue:@"LUNA.APP.U.AGENT" forHTTPHeaderField:@"User-Agent"];
        
        //告诉AFN，支持接受 text/xml 的数据
        [AFJSONResponseSerializer serializer].acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
        NSString *urlString = [NSString stringWithFormat:@"%@file_upload_errorlog.do",Base_url];
        
        
        [manager POST:urlString parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            [formData appendPartWithFileData:data name:@"file" fileName:@"urlError.txt" mimeType:@"txt"];
            //        [formData appendPartWithFileData:imaData name:@"image" fileName:@"bug.jpg" mimeType:@"image/jpg"];
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            NSLog(@"成功");
            // 删除文件
            NSFileManager *fileManger = [NSFileManager defaultManager];
            [fileManger removeItemAtPath:path error:nil];
            
            
            
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            NSLog(@"失败");
            
            
        }];
    }
    
    
}


@end

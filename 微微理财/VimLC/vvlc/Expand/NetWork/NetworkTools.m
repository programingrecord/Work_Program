//
//  NetworkTools.m
//  WTJR
//
//  Created by H on 2017/4/18.
//  Copyright © 2017年 HM. All rights reserved.
//

#import "NetworkTools.h"

@implementation NetworkTools

+(void)GetImageFromUrlString:(NSString *)urlString withParams:(NSDictionary *)params andResultBlock:(ImagesucessBlock) resultBlock andfail:(ImagefailBlock) failBlock{
    AFHTTPSessionManager *Manager = [AFHTTPSessionManager manager];
    Manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSLog(@"---%@,%@",urlString,VerifyImageUrl);
    [Manager GET:urlString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        UIImage *imagename = [UIImage imageWithData:responseObject];
        resultBlock(imagename);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[DataRequestServer getDataRequestServerData] requestImportWithUrl:urlString Error:error urlParams:params];
        failBlock();
    }];
}
@end

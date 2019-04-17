//
//  DataRequestServer.h
//  WTJR
//
//  Created by HM on 16/6/3.
//  Copyright © 2016年 HM. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^RequestBlock)(id result);
typedef void(^RequestLoginBlock)(NSString  *LoginState);

@interface DataRequestServer : NSObject

@property (nonatomic , assign) NSInteger maxRequest;

@property (nonatomic, strong) RequestBlock resultBlock;
@property (nonatomic, strong) RequestLoginBlock LoginBlock;

+(DataRequestServer*) getDataRequestServerData;

- (void)request:(NSString *)urlString  parameters:(NSMutableDictionary *) parameters result:(RequestBlock ) block;
- (void)requestLoginparameters:(NSMutableDictionary *) parameters result:(RequestBlock ) block;

- (void)requestLoginresult:(RequestLoginBlock)LoginBlock;
- (void)requestImportWithUrl:(NSString *)url Error:(NSError *)error urlParams:(NSMutableDictionary *)urlParams;

@end

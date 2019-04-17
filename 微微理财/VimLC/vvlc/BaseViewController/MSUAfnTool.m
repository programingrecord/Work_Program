//
//  MSUAfnTool.m
//  vvlc
//
//  Created by SuMo on 2018/8/7.
//  Copyright © 2018年 HM. All rights reserved.
//

#import "MSUAfnTool.h" 

@implementation MSUAfnTool

#pragma mark - 单例
/* 单例 */
+ (instancetype)sharedInstance{
    static MSUAfnTool *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] initWithBaseURL:[NSURL URLWithString:Base_url]];
        _instance.requestSerializer  = [AFHTTPRequestSerializer serializer];
        _instance.responseSerializer = [AFHTTPResponseSerializer serializer];
        [_instance.responseSerializer setNilValueForKey:@""];
        
        /// 请求超时时间
        _instance.requestSerializer.timeoutInterval = 20.0;
        /// 缓存策略
        _instance.requestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
        /// 支持类型
        _instance.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
        /// 是否允许访问证书过期的地址
        _instance.securityPolicy.allowInvalidCertificates = YES;
    });
    return _instance;
}

#pragma mark - 请求相关
/* POST请求 */
- (void)postRequestWithURL:(NSString *)url parameters:(id)paramObj withBlock:(resultObjectBlock)block{
    [self POST:url parameters:paramObj progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@====%@===%@",url,paramObj,dic);
        
        block(dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //        [self postRequestWithURL:(NSString *)url parameters:(id)paramObj withBlock:nil];//idfa 递归下
        block(@"44");
        NSLog(@"%@=%@",url,error);
        
    }];
}

/* POST外部接口请求 -- 0: UTF8 / 1: GBK */
- (void)postOutsideRequestWithURL:(NSString *)url typeSign:(NSInteger)typeSign parameters:(id)paramObj withBlock:(resultObjectBlock)block{
    /// 支持类型
    if (typeSign == 0) {
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
    } else if (typeSign == 1){
        self.responseSerializer.acceptableContentTypes = [self.responseSerializer.acceptableContentTypes setByAddingObject:@"application/x-javascript"];
    }
    
    [self POST:url parameters:paramObj progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        if (typeSign == 0) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            //            MSULog(@"%@=%@",url,dic);
            
            if ([url isEqualToString:@"http://vip.stock.finance.sina.com.cn/quotes_service/view/CN_TransListV2.php"]) {
                NSLog(@"%@=%@",url,dic);
                
            }
            
            block(dic);
        } else if (typeSign == 1){
            //GBK编码
            NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            NSString * encodeStr = [[NSString alloc] initWithBytes:[responseObject bytes] length:[responseObject length] encoding:enc];
            
            if ([url isEqualToString:@"http://vip.stock.finance.sina.com.cn/quotes_service/view/CN_TransListV2.php"]) {
                NSLog(@"%@=%@",url,encodeStr);
                
            }
            
            block(encodeStr);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //        [self postRequestWithURL:(NSString *)url parameters:(id)paramObj withBlock:nil];//idfa 递归下
        block(@"44");
        NSLog(@"%@=%@",url,error);
    }];
}

/* POST请求 视频 和 图片上传 */
- (void)postRequestUploadImageWithURL:(NSString *)url imaData:(NSData *)imaData videoData:(NSData *)videoData parameters:(id)paramObj withBlock:(resultObjectBlock)block{
    
    [self POST:url parameters:paramObj constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:imaData name:@"image" fileName:@"image.png" mimeType:@"image/png"];
        [formData appendPartWithFileData:videoData name:@"video" fileName:@"videoName.mp4" mimeType:@"video/mpeg"];
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@=%@",url,dic);
        block(dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(@"44");
        NSLog(@"%@=%@",url,error);
        
    }];
}

/* POST请求 多张图片上传 */
- (void)postMoreUploadImageWithURL:(NSString *)url imaDataArr:(NSMutableArray *)imaDataArr parameters:(id)paramObj withBlock:(resultObjectBlock)block{
    
    [self POST:url parameters:paramObj constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (NSInteger i = 0; i < imaDataArr.count; i++) {
            NSData *imaData = imaDataArr[i];
            [formData appendPartWithFileData:imaData name:[NSString stringWithFormat:@"image%ld",i] fileName:@"image.png" mimeType:@"image/png"];
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@=%@",url,dic);
        block(dic);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(@"44");
        NSLog(@"%@=%@",url,error);
        
        
    }];
}

/* GET请求 */
- (void)getRequestWithURL:(NSString *)url parameters:(id)paramObj withBlock:(resultObjectBlock)block{
    [self GET:url parameters:paramObj progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@=%@",url,dic);
        //        [manager.operationQueue cancelAllOperations];
        block(dic);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@=%@",url,error);
        
        block(@"44");
        
    }];
}

- (void)getOutsideRequestWithURL:(NSString *)url  typeSigh:(NSInteger)typeSign parameters:(id)paramObj withBlock:(resultObjectBlock)block{
    
    /// 支持类型
    if (typeSign == 0) {
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"application/javascript",  @"text/html", nil];
    } else if (typeSign == 1){
        self.responseSerializer.acceptableContentTypes = [self.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    }
    
    [self GET:url parameters:paramObj progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (typeSign == 0) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@=%@",url,dic);
            //            [manager.operationQueue cancelAllOperations];
            block(dic);
        } else if (typeSign == 1){
            //GBK编码
            NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            NSString * encodeStr = [[NSString alloc] initWithBytes:[responseObject bytes] length:[responseObject length] encoding:enc];
            NSLog(@"%@=%@",url,encodeStr);
            
            block(encodeStr);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@=%@",url,error);
        
        block(@"44");
        
    }];
    
}

#pragma mark - 统一 接口域名/IP版
- (void)loginWithRequest:(NSMutableDictionary *)prams whenComplete:(resultObjectBlock)block{
    //    [prams setObject:kAppDelegate.token forKey:@"token"];
    NSString *urlStr = [NSString stringWithFormat:@"%@/index/notice-me",Base_url];
    [self postRequestWithURL:urlStr parameters:prams withBlock:block];
}

@end

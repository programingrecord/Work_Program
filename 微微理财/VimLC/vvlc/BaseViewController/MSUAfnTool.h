//
//  MSUAfnTool.h
//  vvlc
//
//  Created by SuMo on 2018/8/7.
//  Copyright © 2018年 HM. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

typedef void(^resultObjectBlock)(id result);

@interface MSUAfnTool : AFHTTPSessionManager

/// 回调
@property (nonatomic , strong)resultObjectBlock resultblock;

/* 单例方法 */
+ (instancetype)sharedInstance;

/* POST 请求方法 */
- (void)postRequestWithURL:(NSString *)url parameters:(id)paramObj withBlock:(resultObjectBlock)block;

/* 外部接口请求 */
- (void)postOutsideRequestWithURL:(NSString *)url typeSign:(NSInteger)typeSign parameters:(id)paramObj withBlock:(resultObjectBlock)block;
- (void)getOutsideRequestWithURL:(NSString *)url  typeSigh:(NSInteger)typeSign parameters:(id)paramObj withBlock:(resultObjectBlock)block;

/* POST 请求照片 */
- (void)postRequestUploadImageWithURL:(NSString *)url imaData:(NSData *)imaData videoData:(NSData *)videoData parameters:(id)paramObj withBlock:(resultObjectBlock)block;

/* POST请求 多张图片上传 */
- (void)postMoreUploadImageWithURL:(NSString *)url imaDataArr:(NSMutableArray *)imaDataArr parameters:(id)paramObj withBlock:(resultObjectBlock)block;

/* GET 请求方法 */
- (void)getRequestWithURL:(NSString *)url parameters:(id)paramObj withBlock:(resultObjectBlock)block;

#pragma mark - 统一 接口域名/IP 版
/* 1 */
- (void)loginWithRequest:(NSMutableDictionary *)prams whenComplete:(resultObjectBlock)block;

@end

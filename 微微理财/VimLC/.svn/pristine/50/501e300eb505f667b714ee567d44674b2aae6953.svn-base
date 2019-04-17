//
//  LLBankPaySDK.h
//  LLBankPaySDK
//
//  Created by EvenLam on 2017/7/5.
//  Copyright © 2017年 LianLianPay Inc. All rights reserved.
//

#import "LLPaySDKConst.h"

@interface LLEBankPaySDK : NSObject

+ (instancetype)sharedSDK;

/** 代理 */
@property (nonatomic, assign) NSObject<LLPaySdkDelegate> *sdkDelegate;

- (void)llEBankPayInViewController: (UIViewController *)viewController andPaymentInfo:(NSDictionary *)paymentInfo;

+ (BOOL)handleOpenURL: (NSURL *)url;
+ (NSString *)getSDKVersion;
@end

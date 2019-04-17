//
//  LLPaySdk.h
//  LLPaySdk
//
//  Created by xuyf on 14-4-23.
//  Copyright (c) 2014年 LianLianPay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LLPaySDKConst.h"

typedef NS_ENUM(NSUInteger, LLPayType) {
    LLPayTypeQuick,     // 快捷
    LLPayTypeVerify,    // 认证
    LLPayTypePreAuth,   // 预授权
    LLPayTypeTravel,    // 游易付之随心付
    LLPayTypeRealName,  // 实名快捷支付
    LLPayTypeCar,       // 车易付
    LLPayTypeInstalments,//分期付
};

@interface LLPaySdk : NSObject

/**
 *  单例sdk add:20151106
 *
 *  @return 返回LLPaySdk的单例对象
 */
+ (LLPaySdk *)sharedSdk;

/** 代理 */
@property (nonatomic, assign) NSObject<LLPaySdkDelegate> *sdkDelegate;

/**
 *  连连支付 支付接口
 *
 *  @param viewController 推出连连支付支付界面的ViewController
 *  @param payType        连连支付类型:LLPayType
 *  @param traderInfo     交易信息
 */
- (void)presentLLPaySDKInViewController: (UIViewController *)viewController
                            withPayType: (LLPayType)payType
                          andTraderInfo: (NSDictionary *)traderInfo;

/**
 *  连连支付 签约接口
 *
 *  @param viewController 推出连连支付签约界面的ViewController
 *  @param payType        连连支付类型:LLPayType（签约支持认证签约、分期付签约）
 *  @param traderInfo     交易信息
 */
- (void)presentLLPaySignInViewController:(UIViewController *)viewController
                             withPayType:(LLPayType)payType
                           andTraderInfo:(NSDictionary *)traderInfo;

/**
 *  在sdk标题栏下面设定一个广告条或者操作指南bar
 *
 *  @param view 要显示的广告View
 */
+ (void)setADView:(UIView *)view;

+ (NSString *)getSDKVersion;

@end

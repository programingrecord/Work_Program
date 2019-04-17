//
//  LLPaySDKConst.h
//  LianLianPay
//
//  Created by EvenLam on 2017/8/16.
//  Copyright © 2017年 LianLianPay. All rights reserved.
//

#ifndef LLPaySDKConst_h
#define LLPaySDKConst_h


#endif /* LLPaySDKConst_h */

//@import Foundation;
//@import UIKit;
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum LLPayResult {
    kLLPayResultSuccess = 0,      // 支付成功
    kLLPayResultFail = 1,         // 支付失败
    kLLPayResultCancel = 2,       // 支付取消，用户行为
    kLLPayResultInitError,        // 支付初始化错误，订单信息有误，签名失败等
    kLLPayResultInitParamError,   // 支付订单参数有误，无法进行初始化，未传必要信息等
    kLLPayResultUnknow,           // 其他
    kLLPayResultRequestingCancel, // 授权支付后取消(支付请求已发送)
} LLPayResult;


@protocol LLPaySdkDelegate <NSObject>

@required

/**
 *  调用sdk以后的结果回调
 *
 *  @param resultCode 支付结果
 *  @param dic        回调的字典，参数中，ret_msg会有具体错误显示
 */
- (void)paymentEnd:(LLPayResult)resultCode withResultDic:(NSDictionary*)dic;

@end

//
//  UIAlertTool.h
//  ElectricBao
//
//  Created by HM on 2017/2/7.
//  Copyright © 2017年 HM. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^confirmBlock)();
typedef void(^cancleBlock)();



@interface UIAlertTool : NSObject

+(void)showAlertView:(UIViewController *)viewController
         TitleString:(NSString *)title
       MessageString:(NSString *)message
  CancelButtonString:(NSString *)cancelButtonTitle
   OhterButtonString:(NSString *)otherButtonTitle
        confirmBlock:(confirmBlock)confirm
         cancleBlock:(cancleBlock)cancle;

@end

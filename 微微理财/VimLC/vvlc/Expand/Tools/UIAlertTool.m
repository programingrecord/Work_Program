//
//  UIAlertTool.m
//  ElectricBao
//
//  Created by HM on 2017/2/7.
//  Copyright © 2017年 HM. All rights reserved.
//

#import "UIAlertTool.h"


#define IAIOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)


@interface UIAlertTool()

@end

@implementation UIAlertTool

+(void)showAlertView:(UIViewController *)viewController
         TitleString:(NSString *)title
       MessageString:(NSString *)message
  CancelButtonString:(NSString *)cancelButtonTitle
   OhterButtonString:(NSString *)otherButtonTitle
        confirmBlock:(confirmBlock)confirm
         cancleBlock:(cancleBlock)cancle{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    if (cancelButtonTitle && cancelButtonTitle.length>0) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            cancle();
        }];
        [alertController addAction:cancelAction];

    }
    if (otherButtonTitle && otherButtonTitle.length>0) {
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            confirm();
        }];
        
        [alertController addAction:otherAction];
    }
    
    [viewController presentViewController:alertController animated:YES completion:nil];
    
}

@end

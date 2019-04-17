//
//  MSUSetTradePWDController.h
//  vvlc
//
//  Created by 007 on 2018/4/23.
//  Copyright © 2018年 HM. All rights reserved.
//

#import "BaseViewController.h"
#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger,MSUPwdType){
    MSUSetPwd = 0,
    MSUResetPwd
};

@interface MSUSetTradePWDController : BaseViewController

@property (nonatomic , copy) NSString *signStr;
@property (nonatomic , copy) NSString *backStr;

@property (nonatomic , assign) MSUPwdType pwdType;

@end

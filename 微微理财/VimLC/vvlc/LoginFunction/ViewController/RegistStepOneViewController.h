//
//  RegistStepOneViewController.h
//  vvlc
//
//  Created by HM on 2017/7/26.
//  Copyright © 2017年 HM. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^RegistStepOneBlock)(NSString *PhoneStr);

@interface RegistStepOneViewController : BaseViewController

@property (nonatomic,copy)RegistStepOneBlock         RegistBlock;


@end

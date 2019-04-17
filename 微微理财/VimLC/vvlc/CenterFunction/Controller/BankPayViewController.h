//
//  ViewController.h
//  LLEBankPayDemo
//
//  Created by EvenLam on 2017/9/26.
//  Copyright © 2017年 LianLianPay Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

#define kWindowW [UIScreen mainScreen].bounds.size.width
#define kWindowH [UIScreen mainScreen].bounds.size.height

#define LLHexColor(rgbValue)[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface BankPayViewController : BaseViewController

@property (nonatomic , copy) NSString *moneyText;
@property (nonatomic , copy) NSString *bankName;

@end


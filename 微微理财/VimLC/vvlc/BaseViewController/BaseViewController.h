//
//  BaseViewController.h
//  SmallCat
//
//  Created by H on 2017/4/19.
//  Copyright © 2017年 HM. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger,LoginComeType) {
    logintypeHome,
    logintypePush,
    logintypeOutTime,
};

@interface BaseViewController : UIViewController

- (void)requestLogin:(LoginComeType) type;
- (void)BackViewController;

-(void)createLeftNavigationItem:(UIImage*) leftImage;
-(void)LeftNavigationButtonClick:(UIButton*) leftbtn;

@end

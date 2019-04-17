//
//  BaseViewController.m
//  SmallCat
//
//  Created by H on 2017/4/19.
//  Copyright © 2017年 HM. All rights reserved.
//

#import "BaseViewController.h"
#import "LoginViewController.h"

#import "LCTabBar.h"
@interface BaseViewController ()
{
    LCTabBar *lcTabBar;
}

@end

@implementation BaseViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0x333333],NSFontAttributeName: [UIFont systemFontOfSize:18]}];
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    for (UIView *child in self.tabBarController.tabBar.subviews) {
        if ([child isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [child removeFromSuperview];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (@available(iOS 11.0, *)){
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    } else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self createLeftNavigationItem:[UIImage imageNamed:@"nav_icon_back_nor"]];
    self.view.backgroundColor = [UIColor colorWithHex:0xf6f6f6];
    self.navigationController.navigationBar.translucent = NO;
}

-(void)createLeftNavigationItem:(UIImage*) leftImage;
{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(LeftNavigationButtonClick:) image:leftImage];
}

-(void)LeftNavigationButtonClick:(UIButton*) leftbtn
{
    NSArray *viewcontrollers=self.navigationController.viewControllers;
    if (viewcontrollers.count>1) {
        if ([viewcontrollers objectAtIndex:viewcontrollers.count-1]==self) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else{
        //present方式
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)BackViewController{
    NSArray *viewcontrollers=self.navigationController.viewControllers;
    if (viewcontrollers.count>1) {
        if ([viewcontrollers objectAtIndex:viewcontrollers.count-1]==self) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else{
        //present方式
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)requestLogin:(LoginComeType) type{
    if (type == logintypeOutTime) {
        [AddHudView addProgressView:self.view message:@"登录失效，请重新登录"];
        __weak typeof(self) weakSelf = self;

        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [CoreArchive removeNSUserDefaults];
            LoginViewController *loginVc= [[LoginViewController alloc] init];
            loginVc.hidesBottomBarWhenPushed = YES;
            loginVc.loginType=type;
            [weakSelf.navigationController pushViewController:loginVc animated:YES];
        });
    }else{
        [CoreArchive removeNSUserDefaults];
        LoginViewController *loginVc= [[LoginViewController alloc] init];
        loginVc.loginType=type;
        [self.navigationController pushViewController:loginVc animated:YES];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

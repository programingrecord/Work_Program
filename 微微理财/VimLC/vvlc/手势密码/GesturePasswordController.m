//
//  GesturePasswordController.m
//  GesturePassword
//
//  Created by hb on 14-8-23.
//  Copyright (c) 2014年 黑と白の印记. All rights reserved.
//

#import <Security/Security.h>
#import <CoreFoundation/CoreFoundation.h>

#import "GesturePasswordController.h"
#import "GesturePasswordButton.h"
#import "HomeViewController.h"
#import "AppDelegate.h"
@interface GesturePasswordController ()

@property (nonatomic,assign) NSInteger errorTimes;
@end

@implementation GesturePasswordController {
    NSString * previousString;
    NSString * password;
    NSMutableDictionary *dicTion;
}

@synthesize gesturePasswordView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    previousString = [NSString string];
    if (_gestureType == GestureVerify) {
        [self verify];
    }else if(_gestureType == GestureSet){
        [self reset];
    }else{
        [self verify];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - 验证手势密码
- (void)verify{
    gesturePasswordView = [[GesturePasswordView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [gesturePasswordView.tentacleView setRerificationDelegate:self];
    [gesturePasswordView.tentacleView setResetDelegate:self];

    [gesturePasswordView.tentacleView setStyle:1];
    if (self.gestureType == GestureVerify) {
        [gesturePasswordView.backbtn setHidden:YES];
        [gesturePasswordView.headNavview setHidden:YES];
        [gesturePasswordView.passButton setHidden:YES];
        [gesturePasswordView.useOtherButton setHidden:NO];
        gesturePasswordView.Daylable.hidden = NO;
        gesturePasswordView.Monthlable.hidden = NO;
        gesturePasswordView.Tiplable.hidden = NO;
    } else if (self.gestureType == GestureDelete){
        [gesturePasswordView.backbtn setHidden:NO];
        [gesturePasswordView.headNavview setHidden:NO];
        [gesturePasswordView.passButton setHidden:YES];
        [gesturePasswordView.useOtherButton setHidden:YES];
        gesturePasswordView.Daylable.hidden = NO;
        gesturePasswordView.Daylable.hidden = YES;
        gesturePasswordView.Monthlable.hidden = YES;
        gesturePasswordView.Tiplable.hidden = YES;
    } else{
        [gesturePasswordView.backbtn setHidden:NO];
        [gesturePasswordView.headNavview setHidden:NO];
        [gesturePasswordView.passButton setHidden:NO];
        [gesturePasswordView.useOtherButton setHidden:YES];
        [gesturePasswordView.state setText:@"请绘制旧的手势密码"];
        gesturePasswordView.Daylable.hidden = NO;
        gesturePasswordView.Daylable.hidden = YES;
        gesturePasswordView.Monthlable.hidden = YES;
        gesturePasswordView.Tiplable.hidden = YES;
    }
    [gesturePasswordView setGesturePasswordDelegate:self];
    _errorTimes = 5;

    [self.view addSubview:gesturePasswordView];
}

#pragma mark - 设置手势密码
- (void)reset{
    gesturePasswordView = [[GesturePasswordView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    gesturePasswordView.titleLabel.text = @"请设置手势密码";
    [gesturePasswordView.tentacleView setResetDelegate:self];
    [gesturePasswordView.tentacleView setStyle:2];
    [gesturePasswordView.state setTextColor:[UIColor colorWithRed:51/255.f green:51/255.f blue:51/255.f alpha:1]];
    [gesturePasswordView.state setText:@"绘制解锁图案"];
    [gesturePasswordView.backbtn setHidden:NO];

    [gesturePasswordView.forgetButton setHidden:YES];
    [gesturePasswordView.useOtherButton setHidden:YES];
    [gesturePasswordView.passButton setHidden:NO];
    [gesturePasswordView setGesturePasswordDelegate:self];

    gesturePasswordView.Daylable.hidden = YES;
    gesturePasswordView.Monthlable.hidden = YES;
    gesturePasswordView.Tiplable.hidden = YES;
    [self.view addSubview:gesturePasswordView];
}
#pragma mark - 设置

- (void)resetPassword:(NSString *)result{
    
    if ([previousString isEqualToString:@""]){
        if (result.length < 5) {
            [self postNotice];
            [AddHudView addProgressView:self.view message:@"密码太短，请最少连接6个点"];
            __weak typeof(self) weakSelf = self;
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                [weakSelf ComeBackNormol];
            });
            return;
        }
        previousString=result;
        
        [gesturePasswordView.state setTextColor:[UIColor colorWithRed:51/255.f green:51/255.f blue:51/255.f alpha:1]];
        [gesturePasswordView.state setText:@"请再次设置解锁图案"];

        __weak typeof(self) weakSelf = self;
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [weakSelf ComeBackNormol];
        });
    }
    else {
        if ([result isEqualToString:previousString]) {
            [self ComeBackNormol];
            NSMutableDictionary * parameters = [[NSMutableDictionary alloc] init];
            [parameters setObject:previousString forKey:@"previousString"];
            [[NSUserDefaults standardUserDefaults] setObject:parameters forKey:@"gestureWord"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [AddHudView addProgressView:self.view message:@"设置成功"];

            __weak typeof(self) weakSelf = self;
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//                [weakSelf backView];
                [CoreArchive setStr:@"1" key:@"passSet"];
                [self _showMainVC];
            });
        }
        else{
            [self postNotice];
            previousString =@"";
            [gesturePasswordView.state setTextColor:[UIColor redColor]];
            [gesturePasswordView.state setText:@"与上一次输入不一致，请重新设置"];
            __weak typeof(self) weakSelf = self;
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                [weakSelf ComeBackNormol];
            });
        }
    }
}

#pragma mark - 验证次数3次失败后返回H5登录
- (void)verification:(NSString *)result{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *passWordDic = [userDefaults objectForKey:@"gestureWord"];
    NSString *password = [passWordDic objectForKey:@"previousString"];
    if ([result isEqualToString:password]) {
        if (self.gestureType == GestureVerify) {
            [self.view removeFromSuperview];
            [CoreArchive setStr:@"1" key:@"passSet"];
        }else if(self.gestureType == GestureReSet){
            gesturePasswordView.state.text = @"请滑动设置新密码";
            [gesturePasswordView.state setTextColor:[UIColor colorWithRed:51/255.f green:51/255.f blue:51/255.f alpha:1]];

            [gesturePasswordView.tentacleView setStyle:2];
            previousString = [NSString string];
            [self ComeBackNormol];
        } else if (self.gestureType == GestureDelete){
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"gestureWord"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            AppDelegate *jj = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [jj loadMainView];
            [jj.mainVC setSelectedIndex:3];
        }
    }else{
        _errorTimes--;
        if (_errorTimes==0) {
            NSString *appDomainStr = [[NSBundle mainBundle] bundleIdentifier];
            [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomainStr];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [self _showMainVC];
            return;
        }else{
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSMutableDictionary *passWordDic = [userDefaults objectForKey:@"gestureWord"];
        }
        [self changeErrorNum:[NSString stringWithFormat:@"密码错误，还可以再输入%ld次",(long)_errorTimes]];
        
    }

}

- (void)changeErrorNum:(NSString *)errorMessage{
    [self postNotice];
    [gesturePasswordView.state setTextColor:[UIColor redColor]];
    [gesturePasswordView.state setText:errorMessage];
    __weak typeof(self) weakSelf = self;
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [weakSelf ComeBackNormol];
    });

}

- (void)handBackTaped{
    __weak typeof(self) weakSelf = self;
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [weakSelf backView];
    });
}

- (void)ComeBackNormol{
    
    [gesturePasswordView.tentacleView enterArgin];

}

- (void)backView{
    if (self.gestureType == GestureSet) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"HandPassWordBack" object:nil userInfo:nil];
    }

    [self removeNotice];
    [self.view removeFromSuperview];
}

#pragma mark - 通知手势密码按钮改变颜色壮态
- (void)postNotice{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeButtonColor" object:nil userInfo:@{@"isError":@"N"}];
}

- (void)removeNotice
{
    [[NSNotificationCenter defaultCenter] removeObserver:gesturePasswordView.tentacleView name:@"changeButtonColor" object:nil];

}
- (BOOL)isNullString:(NSString *)string{
    if ([string isEqual:[NSNull null]]) {
        return YES;
    }else{
        return NO;
    }
}

- (void)_showMainVC{
    AppDelegate *jj = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [jj loadMainView];
    [jj.mainVC setSelectedIndex:3];
}
- (void)useUMLogin{
    
    NSString *appDomainStr = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomainStr];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self _showMainVC];
}

- (void)passBtnClick{
    [self _showMainVC];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

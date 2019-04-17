//
//  AppDelegate.m
//  SmallCat
//
//  Created by H on 2017/4/19.
//  Copyright © 2017年 HM. All rights reserved.
//

#import "AppDelegate.h"
#import "GesturePasswordController.h"
#import "LCTabBarController.h"
#import "HomeViewController.h"
#import "LoginViewController.h"
#import "BaseNavigationViewController.h"
#import "CenterNewViewController.h"
#import <AdSupport/AdSupport.h>
#import "GuideViewController.h"
#import "UpgradeView.h"

#import "MSUCatchtExceptionHandler.h"

#import "LLEBankPaySDK.h"


#import "MSUFindController.h"
#import "MSUHomeNotifaController.h"

#import <UMCommon/UMCommon.h>
#import <UMAnalytics/MobClick.h>
#import "MSUStringTools.h"

/*  功能性页面都单独摘出来的有VIEW，简单的页面直接写在控制器中 */

// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate ()<WXApiDelegate,UIAlertViewDelegate,JPUSHRegisterDelegate>

@property (nonatomic,strong) GesturePasswordController *gesturePassWord;
@property (nonatomic,strong) NSString *downloadUrl;
@property (nonatomic,assign) BOOL isFourceUpdate;
@property (nonatomic , assign) NSInteger currentIndex;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [NSThread sleepForTimeInterval:1.0];//设置启动页面时间
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    self.window.backgroundColor = [UIColor whiteColor];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [TalkingData sessionStarted:@"EAAE19539DC54A4D9A8F6F9623E3E0FC" withChannelId:@"iOS_APPStore"];
    
    [UMConfigure setLogEnabled:YES];
    [MobClick setCrashReportEnabled:YES];
    [UMConfigure initWithAppkey:@"5acc5a298f4a9d52d1000034" channel:@"App Store"];
    
    // 极光推送
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    [JPUSHService setupWithOption:launchOptions appKey:@"ddc154b92746dd4cfdc32e62"
                          channel:@"App Store" //指明应用程序包的下载渠道，为方便分渠道统计，具体值由你自行定义，如：App Store。
                 apsForProduction:NO //0 (默认值)表示采用的是开发证书，1 表示采用生产证书发布应用。
            advertisingIdentifier:nil];

    //引导页
    [self loadMainView];

    // 上传IMEI号
    if ([self isFirstLoad] || ![CoreArchive isUPActivate]) {
        [self postCountData];
    }
    
    // 微信分享
    BOOL WX = [WXApi registerApp:@"wxb59d26cd7081005f"];
    if (WX) {
        NSLog(@"weixin注册成功");
    }else{
        NSLog(@"weixin注册失败");
    }
    
    //检查版本
    self.isFourceUpdate = NO;
    [self checkNew];

    MSUInstallUncaughtExceptionHandler();
    return YES;
}


- (void)loadMainView{
    _mainVC = [[LCTabBarController alloc] init];
    _mainVC.itemTitleFont =  TEXTFONT(13);
    
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    if (ENVIRENTMENT == 1) {
        homeVC.tabBarItem.title = @"首页";
    } else{
        homeVC.tabBarItem.title = @"内测";
    }
    homeVC.tabBarItem.image = [UIImage imageNamed:@"sy1_icon"]; // 新年版 shouye1_icon66
    homeVC.tabBarItem.selectedImage = [UIImage imageNamed:@"sy_icon"]; // 新年版 shouye_icon66
    BaseNavigationViewController *homeNav = [[BaseNavigationViewController alloc] initWithRootViewController:homeVC];
    
    MSUFindController *findVC = [[MSUFindController alloc] init];
    findVC.tabBarItem.title = @"发现";
    findVC.tabBarItem.image = [UIImage imageNamed:@"fx1_icon"]; // 新年版 faxian1_icon66
    findVC.tabBarItem.selectedImage = [UIImage imageNamed:@"fx_icon"]; // 新年版 faxian_icon66
    BaseNavigationViewController *findNav = [[BaseNavigationViewController alloc] initWithRootViewController:findVC];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [defaults objectForKey:@"registerData"];
    if ([dic objectForKey:@"UserName"]&&[dic objectForKey:@"PassWord"] ) {
        if ([[dic objectForKey:@"isActivelog"]isEqualToString:@"false"]) {
            LoginViewController *LoginVC = [[LoginViewController alloc] init];
            LoginVC.tabBarItem.title = @"我的";
            LoginVC.hidesBottomBarWhenPushed = YES;
            LoginVC.tabBarItem.image = [UIImage imageNamed:@"wd1_icon"]; // 新年版 wode1_icon66
            LoginVC.tabBarItem.selectedImage = [UIImage imageNamed:@"wd_icon"]; // 新年版 wode_icon66
            LoginVC.loginType = logintypeHome;
            BaseNavigationViewController *LoginNav = [[BaseNavigationViewController alloc] initWithRootViewController:LoginVC];
            _mainVC.viewControllers = @[homeNav,findNav,LoginNav];
        }else{
            CenterNewViewController *CenterVC = [[CenterNewViewController alloc] init];
            CenterVC.tabBarItem.title = @"我的";
            CenterVC.tabBarItem.image = [UIImage imageNamed:@"wd1_icon"];
            CenterVC.tabBarItem.selectedImage = [UIImage imageNamed:@"wd_icon"];
            BaseNavigationViewController *CenterNav = [[BaseNavigationViewController alloc] initWithRootViewController:CenterVC];
            _mainVC.viewControllers = @[homeNav,findNav,CenterNav];
        }
    }else{
        LoginViewController *LoginVC = [[LoginViewController alloc] init];
        LoginVC.tabBarItem.title = @"我的";
        LoginVC.tabBarItem.image = [UIImage imageNamed:@"wd1_icon"];
        LoginVC.tabBarItem.selectedImage = [UIImage imageNamed:@"wd_icon"];
        LoginVC.loginType = logintypeHome;
        BaseNavigationViewController *LoginNav = [[BaseNavigationViewController alloc] initWithRootViewController:LoginVC];
        _mainVC.viewControllers = @[homeNav,findNav,LoginNav];
    }
    _mainVC.tabBar.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = _mainVC;
    
}

- (BOOL) isFirstLoad{
    
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary]
                                objectForKey:@"CFBundleShortVersionString"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *lastRunVersion = [defaults objectForKey:@"last_run_version_of_application"];
    
    if (!lastRunVersion) {
        [defaults setObject:currentVersion forKey:@"last_run_version_of_application"];
        return YES;
    }
    else if (![lastRunVersion isEqualToString:currentVersion]) {
        [defaults setObject:currentVersion forKey:@"last_run_version_of_application"];
        return YES;
    }
    return NO;
}

- (void)postCountData{
    NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    NSLog(@"adId=%@",adId);
    NSLog(@"getDeviceID=%@",[TalkingData getDeviceID]);
    
    NSMutableDictionary *parms = [[NSMutableDictionary alloc] initWithDictionary:@{@"appCode":@"7",@"appImei":adId}];
    [[DataRequestServer getDataRequestServerData] request:@"LunaP2pAppActivateDataServlet" parameters:parms result:^(id result) {
        
        if ([result isKindOfClass:[NSString class]] &&  [result isEqualToString:@"44"]) {
            [CoreArchive isUPActivateData:NO];
        }else{
            int t = [[result objectForKey:@"success"] intValue];
            if ([[result objectForKey:@"errorlog"]isEqualToString:@""]&& t==1){
                [CoreArchive isUPActivateData:YES];
            }else{
                [CoreArchive isUPActivateData:NO];
            }
        }
    }];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    if (self.isFourceUpdate) {
        [self checkNew];
    };
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSUserDefaults *defaults= [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dic= [defaults objectForKey:@"gestureWord"];
    
    NSMutableDictionary *userinfoDic= [defaults objectForKey:@"userInfoDetial"];
    
    NSMutableDictionary *registerDic= [defaults objectForKey:@"registerData"];
    NSString *str = [CoreArchive strForKey:@"passSet"];
    if ([str isEqualToString:@"1"]) {
        self.currentIndex = 0;
    }
    MyLog(@"======%ld,%@",_currentIndex,str);
    if (userinfoDic && registerDic && [dic objectForKey:@"previousString"] && !_currentIndex) {
        _gesturePassWord = [[GesturePasswordController alloc] init];
        _gesturePassWord.gestureType = GestureVerify;
        [[UIApplication sharedApplication].keyWindow addSubview:_gesturePassWord.view];
        [CoreArchive setStr:@"0" key:@"passSet"];

    }
    self.currentIndex++;
}

#pragma mark -- 极光推送
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"远程推送接收失败: %@", error);
}

/* iOS 10 Support 显示弹窗  */
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        
        [CoreArchive isHasRecieveNoti:YES];
    }
    completionHandler(UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionBadge); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

/* iOS 10 Support 点击  */
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
//        MSUHomeNotifaController *noti = [[MSUHomeNotifaController alloc] init];
//        noti.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:noti animated:YES];
    }
    completionHandler();  // 系统要求执行这个方法
}

/*  iOS10以下 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"redCircle"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [LLEBankPaySDK handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    [WXApi handleOpenURL:url delegate:self];
    [LLEBankPaySDK handleOpenURL:url];

    return YES;
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [WXApi handleOpenURL:url delegate:self];
}
- (void)onResp:(BaseResp *)resp {
    SendMessageToWXResp *sendResp = (SendMessageToWXResp *)resp;
    NSString *TipStr;
    if (sendResp.errCode == WXSuccess) {
        TipStr = @"分享成功";
    }else if(sendResp.errCode == WXErrCodeUserCancel){
        TipStr = @"您已经取消了分享";
    }else{
        TipStr = @"分享失败";
    }
    UIAlertView *Alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:TipStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
    [Alert show];
}

- (void)checkNew{
    //apptype  1 普通版  2 存管版 
    NSMutableDictionary *parms = [[NSMutableDictionary alloc] initWithDictionary:@{@"apptype":@"1"}];
    [[DataRequestServer getDataRequestServerData] request:@"LunaP2pIosAppVersionServlet" parameters:parms result:^(id result) {

        if ([result isKindOfClass:[NSString class]] &&  [result isEqualToString:@"44"]) {
            
        }else{
            int t = [[result objectForKey:@"success"] intValue];
            if ([[result objectForKey:@"errorlog"]isEqualToString:@"noLogin"] && t==0){
                [self requestLogin];
            }
            else if ([[result objectForKey:@"errorlog"] isEqualToString:@""] && t==1){
                NSLog(@"result=%@",result);
                NSArray *arr = [result objectForKey:@"items"];
                if (arr.count>0) {
                    NSDictionary *Dic= (NSDictionary *)arr[0];
                    [self checkNewWithDic:Dic];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadHomeServer" object:nil];
            }else{
                
            }
        }
    }];
}

- (void)requestLogin{
    
    [[DataRequestServer getDataRequestServerData] requestLoginresult:^(NSString *LoginState) {
        if ([LoginState isEqualToString:@"true"]) {
            [self checkNew];
        }else{
//            [AddHudView addProgressView:self.window message:@"登录失效，请重新登录"];
            
//            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
//            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//                [CoreArchive removeNSUserDefaults];
//                [self loadMainView];
//            });
        }
    }];
}

- (void)checkNewWithDic:(NSDictionary *)dic{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    NSMutableArray* LocationArr = (NSMutableArray*) [appCurVersion componentsSeparatedByString: @"."];
    
    
    NSString *SeverVersion = [NSString stringWithFormat:@"%@",[dic objectForKey:@"iosVersion"]];
    NSMutableArray* SeverArr = (NSMutableArray*) [SeverVersion componentsSeparatedByString: @"."];
    
    while (LocationArr.count < SeverArr.count) { [LocationArr addObject: @"0"]; }
    while (SeverArr.count < LocationArr.count) { [SeverArr addObject: @"0"]; }
    NSInteger minArrayLength = MIN(LocationArr.count, SeverArr.count);
    
    BOOL needUpdate = NO;
    for(int i=0;i<minArrayLength;i++){//以最短的数组长度为遍历次数,防止数组越界
        NSString *localElement = LocationArr[i];
        NSString *appElement = SeverArr[i];
        NSInteger  localValue =  localElement.integerValue;
        NSInteger  appValue = appElement.integerValue;
        if(localValue<appValue) {
            needUpdate = YES;
            break;
        }else{
            needUpdate = NO;
        }
    }
    if (needUpdate) {
        self.downloadUrl = [dic objectForKey:@"downloadUrl"];
        NSString *isFourceUpdate = [NSString stringWithFormat:@"%@",[dic objectForKey:@"isFourceUpdate"]];
        UpgradeView *V = [[UpgradeView alloc] initWithFrame:CGRectZero];
        NSString *vierStr = [dic objectForKey:@"versionNote"];
        NSString *msg = [vierStr stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
        V.InfoLabel.text = msg;
        V.InfoLabel.frame = CGRectMake(0, 0, 230, [MSUStringTools danamicGetHeightFromText:msg WithWidth:230 font:15].size.height);
        V.scrollView.contentSize = CGSizeMake(0, [MSUStringTools danamicGetHeightFromText:msg WithWidth:230 font:15].size.height+20);
        if ([isFourceUpdate isEqualToString:@"1"]) {
            self.isFourceUpdate = YES;
            V.CloseButton.hidden = YES;
        }else{
            self.isFourceUpdate = NO;
            V.CloseButton.hidden = NO;
        }
        [V show];
        V.ButtonBlock = ^{
            NSString* encodedString = [self.downloadUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:encodedString]];
        };
    }
}
@end

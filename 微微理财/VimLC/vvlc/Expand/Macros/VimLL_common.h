//
//  VimLL_common.h
//  vvlc
//
//  Created by HM on 2017/7/25.
//  Copyright © 2017年 HM. All rights reserved.
//

#ifndef VimLL_common_h
#define VimLL_common_h

#define ENVIRENTMENT 0              // 环境总开关 0:测试 1:生产


#define WMUrl @"www.vimzx.com"//@"192.168.1.5:8080"

#if ENVIRENTMENT==1
//    #define   VerifyImageUrl    [NSString stringWithFormat:@"http://%@/vcode_image.do?c=",WMUrl]
//    #define   Base_url          [NSString stringWithFormat:@"http://%@/",WMUrl]
//    #define   login_url         [NSString stringWithFormat:@"http://%@/",WMUrl]

    #define   VerifyImageUrl    @"http://www.vimzx.com/vcode_image.do?c="
    #define   Base_url          @"http://www.vimzx.com/"//@"http://www.vimzx.com/"//
    #define   login_url         @"http://www.vimzx.com/login.do"
#else
    #define   VerifyImageUrl     @"http://192.168.1.57:8080/vcode_image.do?c="
    #define   Base_url           @"http://192.168.1.57:8080/"
    #define   login_url          @"http://192.168.1.57:8080/login.do"

//    #define   VerifyImageUrl     @"http://47.97.194.68/vcode_image.do?c="
//    #define   Base_url           @"http://47.97.194.68/"
//    #define   login_url          @"http://47.97.194.68/login.do"
#endif
                                                                                                                     
#ifdef DEBUG
#define MyLog(...)  NSLog(__VA_ARGS__)
#else
#define MyLog(...)
#endif
#define kDeviceHeightScale [UIScreen mainScreen].bounds.size.height/667
#define kDeviceWidthScale [UIScreen mainScreen].bounds.size.width/375

#define kDeviceWidth [UIScreen mainScreen].bounds.size.width
#define kDeviceHeight [UIScreen mainScreen].bounds.size.height
//#define kDeviceHeight  is_iPhoneX?:[UIScreen mainScreen].bounds.size.height-30:[UIScreen mainScreen].bounds.size.height
#define kTabBarHeight 49
#define kStatusBarHeight 20
#define kNavigationBarHeight 44

#define AESKey @"A-16-Byte-String"


#define kApplicationHeight    [[UIScreen mainScreen] applicationFrame].size.height//不包含状态bar的高度(e.g. 460)
#define kContentHeight        (kApplicationHeight - kNavigationBarHeight)

#define NUMBERS @”0123456789\n”
//系统
#define IOS7 ([[[UIDevice currentDevice] systemVersion]floatValue] >=7.0)
#define IOS8 ([[[UIDevice currentDevice] systemVersion]floatValue] >=8.0)
#define iOS11 @available(iOS 11.0, *)

//判断是iPhoneX 的宏
#define is_iPhoneX [UIScreen mainScreen].bounds.size.width == 375.0f && [UIScreen mainScreen].bounds.size.height == 812.0f

/// 定义颜色 RGB
#define RGBA(r,g,b,a)               [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:a]
/// 定义颜色 16进制
#define HEXCOLOR(rgbValue)      [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define TEXTFONT(a) [UIFont systemFontOfSize:(float)a]

/// 公共颜色
#define WhiteColor  HEXCOLOR(0xffffff)
#define BlackColor  HEXCOLOR(0x333333)

#define titBlackColor  HEXCOLOR(0x000000)
#define titBlackQianColor  HEXCOLOR(0x6e6e6e)
#define titOrangeColor  HEXCOLOR(0xff6339)
#define titRedColor  HEXCOLOR(0xff5a32)

#define TextOrangeColor  HEXCOLOR(0xbca08c)
#define lightOrangeColor  HEXCOLOR(0xffc039)
#define titLightColor  HEXCOLOR(0xb0b0b0)
#define titQianColor  HEXCOLOR(0x9b9b9b) 
#define deepOrange  HEXCOLOR(0xffaa92)

#define BGOrangeColor  HEXCOLOR(0xfffbf4)
#define BGBlueColor  HEXCOLOR(0x91bbf3)
#define BGWhiteColor  HEXCOLOR(0xE8E8E8)
#define BGRedColor  HEXCOLOR(0xffefeb)

#define LineColor  HEXCOLOR(0xefefef)


#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define SCREEN_MAX_LENGTH (MAX(kDeviceWidth, kDeviceHeight))

#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)

/// app delegate
#define MSUAppDelegate            ((AppDelegate *)[[UIApplication sharedApplication] delegate])
/// 根窗口
#define MSUMainWindow             [UIApplication sharedApplication].keyWindow
/// 偏好设置
#define MSUUserDefaults           [NSUserDefaults standardUserDefaults]
/// 通知中心
#define MSUNotificationCenter       [NSNotificationCenter defaultCenter]
/// 字符串拼接
#define MSUString(TYPE,STR) [NSString stringWithFormat:TYPE,STR]

#ifndef kSystemVersion
#define kSystemVersion [UIDevice systemVersion]
#endif

#ifndef kiOS6Later
#define kiOS6Later (kSystemVersion >= 6)
#endif

#ifndef kiOS7Later
#define kiOS7Later (kSystemVersion >= 7)
#endif

#ifndef kiOS8Later
#define kiOS8Later (kSystemVersion >= 8)
#endif

#ifndef kiOS9Later
#define kiOS9Later (kSystemVersion >= 9)
#endif

#define iOS10 ([[UIDevice currentDevice].systemVersion doubleValue] >= 10.0)



#endif /* VimLL_common_h */

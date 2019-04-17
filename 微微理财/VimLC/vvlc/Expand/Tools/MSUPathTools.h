//
//  MSUImageTools.h
//  XiuBei
//
//  Created by Zhuge_Su on 2017/5/31.
//  Copyright © 2017年 Zhuge_Su. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// 系统版本
#define iOS10 ([[UIDevice currentDevice].systemVersion doubleValue] >= 10.0)
#define iOS8 ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)

/// 完成回调
typedef void(^complementBlock)(NSString *message,NSInteger code);

/// 设置的url类型枚举
typedef NS_ENUM(NSInteger , MSUUrlType){
    MSUWIFI = 0,            //无线局域网
    MSUSIRI,                //Siri
    MSUBluetooth,           //蓝牙
    MSUCellularMobile,      //蜂窝移动网络
    MSUPersonalHotspot,     //个人热点
    MSUCarrier,             //运营商
    MSUNotification,        //通知
    MSUGeneral,             //通用
    MSUAbout,               //通用-关于本机
    MSUKeyboard,            //通用-键盘
    MSUSupport,             //通用-辅助功能
    MSULanguage,            //通用-语言与地区
    MSUReset,               //通用-还原
    MSUWallpaper,           //墙纸
    MSUPrivacy,             //隐私
    MSUSafari,              //Safari
    MSUMusic,               //音乐
    MSUEqualizer,           //音乐-均衡器
    MSUPhotos,              //照片与相机
    MSUFaceTime,            //FaceTime
    MSUAppAbout,            //APP本身相关
    MSUPhone                //电话号码
};

/// 设备相关信息
typedef NS_ENUM(NSInteger,MSUPhoneInfo){
    MSUPhoneUUID = 0,
    MSUPhoneName,
    MSUPhoneType,
    MSUPhoneSystemVersion,
    MSUPhoneAppVersion,
    MSUPhonePlatform  //手机规格
};

/// 文件路径枚举
typedef NS_ENUM(NSInteger , MSUFileType){
    MSUDocuments = 0,
    MSUAlbum
};

/// Document 类型枚举
typedef NS_ENUM(NSInteger , MSUDocumentsType){
    MSUString = 0,
    MSUComponent
};

@interface MSUPathTools : NSObject

/// 完成回调
@property (nonatomic , copy) complementBlock complementBlock;

/* NSBundle版 获取路径加载图片 */
+ (UIImage *)showImageWithContentOfFileByName:(NSString *)imageName;

/* Plist 获取路径 并获取 数据字典*/
+ (NSMutableArray *)getPlistPathWithName:(NSString *)name type:(NSString *)type;

/* Documents 文件路径 */
+ (NSString *)getDocumentsPathWithFileType:(MSUDocumentsType)type fileName:(NSString *)name;

/* 获取文件路径 */
-(NSString *)getAllFilePath;


/* App缓存大小 cache */
+ (CGFloat)cacheSizeInApp;

/* 清除 App缓存 cache */
+ (void)cleanCacheSizeInAppWithComplement:(complementBlock)block;

/* 画四周阴影 */
+ (UIBezierPath *)drawShadowAroundControls:(UIView *)view shadowHeight:(CGFloat)shadowHeight;

/* 颜色渐变 */
+ (void)drawGradientColorFromColorA:(UIColor *)ColorA toColorB:(UIColor *)ColorB withView:(UIView *)view isLeft:(BOOL)isLeft;

/* 获取手机版本 */
+ (NSString *)deviceVersion;

/* 获取手机相关信息  */
+ (NSString *)getInfoFromPhone:(MSUPhoneInfo)phoneInfo;

/* 更改图片背景颜色  */
+ (UIImage*)grayscale:(UIImage*)anImage type:(int)type;

/* 黑白化  */
+ (UIImage *)whiteBlackImageWithImage:(UIImage *)img;

/* 海报化  */
+ (UIImage *)GaussianSmoothImageWithImage:(UIImage *)img;

@end

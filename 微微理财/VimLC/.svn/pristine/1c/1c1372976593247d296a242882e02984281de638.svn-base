//
//  MSUCameraPhotoVc.h
//  XiuBei
//
//  Created by Zhuge_Su on 2017/7/7.
//  Copyright © 2017年 Zhuge_Su. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>

#import "BaseViewController.h"
@interface MSUCameraPhotoVc : BaseViewController

/*  选择视频 */
+ (void)pickedMediaWithObject:(id)obj;

/* 拍照和录视频 */
+ (void)takePictureAndCameraWithObject:(id)obj;

/* 获取视频宽和高 */
+ (CGSize)getVideoSizeWithURL:(NSURL *)url;

/* 获取视频大小 此方法可以获取文件的大小，返回的是单位是KB。 */
+ (CGFloat)getFileSize:(NSString *)path;

/* 获取视频时长 */
+ (CGFloat) getVideoDuration:(NSURL*)URL;

/* 获取视频总帧数 */
+ (NSInteger)getVideoFrameNumberWithUrl:(NSURL *)url;

/* 获取指定帧的图片 */
+ (UIImage *)getImageAtSomeFrame:(NSURL *)url videoTime:(NSInteger)videoTime;

/* 压缩视频  */
+ (void) convertVideoQuailtyWithInputURL:(NSURL*)inputURL
                               outputURL:(NSURL*)outputURL
                         completeHandler:(void (^)(AVAssetExportSession*))handler;

#pragma mark - 相册选择图片
/* 相册选择图片 */
+ (void)pickedPhontoWithObject:(id)obj;

@end

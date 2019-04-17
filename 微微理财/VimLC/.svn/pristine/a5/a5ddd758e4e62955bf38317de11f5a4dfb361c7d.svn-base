//
//  MSUCameraPhotoVc.m
//  XiuBei
//
//  Created by Zhuge_Su on 2017/7/7.
//  Copyright © 2017年 Zhuge_Su. All rights reserved.
//

#import "MSUCameraPhotoVc.h"

/* 工具类 */
#import "MSUPermissionTool.h"



@interface MSUCameraPhotoVc ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation MSUCameraPhotoVc

#pragma mark - 选择视频
/*  选择视频 */
+ (void)pickedMediaWithObject:(id)obj{
    // 1、 获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        [MSUPermissionTool getPhotosPermission:^(NSInteger authStatus) {
            if (authStatus == 1) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                    // 相册中视频也可显示和选择
                    
                    imagePicker.mediaTypes = @[(NSString *)kUTTypeMovie];
                    imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                    imagePicker.delegate = obj;
                    //                    imagePicker.allowsEditing = YES;
                    [obj presentViewController:imagePicker animated:YES completion:^{
                        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
                    }];
                     imagePicker.navigationBar.translucent = NO;
                });
                
            }else{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请去-> [设置 - 隐私 - 照片 - XiuBei] 打开访问开关" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    //确定按钮点击事件处理
                }]];
                [obj presentViewController:alert animated:YES completion:nil];
            }
        }];
    }
}

#pragma mark - 相册选择图片
/* 相册选择图片 */
+ (void)pickedPhontoWithObject:(id)obj{
    // 1、 获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        [MSUPermissionTool getPhotosPermission:^(NSInteger authStatus) {
            if (authStatus == 1) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                    // 相册中视频也可显示和选择
                    
                    //                    imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary; //（选择类型）表示仅仅从相册中选取照片
                    imagePicker.delegate = obj;
                    imagePicker.allowsEditing = YES;
                    imagePicker.navigationBar.translucent = NO;

                    [obj presentViewController:imagePicker animated:YES completion:^{
                        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
                    }];
                });
                
            }else{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请去-> [设置 - 隐私 - 照片 - XiuBei] 打开访问开关" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    //确定按钮点击事件处理
                }]];
                [obj presentViewController:alert animated:YES completion:nil];
            }
        }];
    }
    
    //内存相关
    /*
     dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
     // 栅栏函数
     dispatch_barrier_async(queue, ^{
     [self removeScanningView];
     });
     */
}


#pragma mark - 拍照和录视频 
/* 拍照和录视频 */
+ (void)takePictureAndCameraWithObject:(id)obj{
    [MSUPermissionTool getCamerasPermission:^(NSInteger authStatus) {
        if (authStatus == 1) {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIImagePickerController *picker = [[UIImagePickerController alloc]init];
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                picker.delegate = obj;
//                picker.navigationBar.translucent = NO;

                //                picker.allowsEditing = YES;/** 设置拍照后的图片可被编辑 */
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    //录制视频时长，默认10s
                    picker.videoMaximumDuration = 10;
                    //相机类型（拍照、录像...）字符串需要做相应的类型转换
                    picker.mediaTypes = @[(NSString *)kUTTypeImage];
//                    picker.videoQuality = UIImagePickerControllerQualityTypeHigh;
                    //设置摄像头模式（拍照，录制视频）为录像模式
//                    picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
                    //                    picker.showsCameraControls = NO;
                    //                    UIView *overView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
                    //                    UIButton *testBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    //                    testBtn.frame = CGRectMake(50, 50, 50, 50);
                    //                    testBtn.backgroundColor = [UIColor blueColor];
                    //                    [overView addSubview:testBtn];
                    //                    [testBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                    //                   picker.camer/aOverlayView = overView; // 自定义控件view
                });
                
                [obj presentViewController:picker animated:YES completion:^{
                    [UIApplication sharedApplication].statusBarHidden = YES;;
                }];
            }else{
                NSLog(@"模拟机无法打开照相机,请在真机使用");
            }
        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请去-> [设置 - 隐私 - 相机 - XiuBei] 打开访问开关" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //确定按钮点击事件处理
            }]];
            [obj presentViewController:alert animated:YES completion:nil];
        }
    }];
}


#pragma mark UIImagePickerControllerDelegate
//适用获取所有媒体资源，只需判断资源类型
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    //判断资源类型
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        //如果是图片
        UIImage *pickedImage = nil;
        if ([picker allowsEditing]) {
            pickedImage = info[UIImagePickerControllerEditedImage];
        }else{
            pickedImage = info[UIImagePickerControllerOriginalImage];
        }
        
        NSLog(@"图片是%@",pickedImage);
        //        self.imageView.image = info[UIImagePickerControllerEditedImage];
        //        //压缩图片
        //        NSData *fileData = UIImageJPEGRepresentation(self.imageView.image, 1.0);
        //        //保存图片至相册
        UIImageWriteToSavedPhotosAlbum(pickedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        //        //上传图片
        //        [self uploadImageWithData:fileData];
        
    }else{
        //如果是视频
        NSURL *url = info[UIImagePickerControllerMediaURL];
//        CGSize videoSize = [MSUCameraPhotoVc getVideoSizeWithURL:url];
        NSLog(@"视频链接是%@",url);
        //        //播放视频
        //        _moviePlayer.contentURL = url;
        //        [_moviePlayer play];
        //        //保存视频至相册（异步线程）
        //        NSString *urlStr = [url path];
        //
        //        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(urlStr)) {
        //
        //                UISaveVideoAtPathToSavedPhotosAlbum(urlStr, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
        //            }
        //        });
        //        NSData *videoData = [NSData dataWithContentsOfURL:url];
        //        //视频上传
        //        [self uploadVideoWithData:videoData];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

/** 取消按钮回调 */
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/* 图片保存完毕的回调 */
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInf{
    if (error) {
        NSLog(@"保存照片过程中发生错误，错误信息:%@",error.localizedDescription);
    }else{
        NSLog(@"照片保存成功.");
    }
}

/* 视频保存完毕的回调 */
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInf{
    if (error) {
        NSLog(@"保存视频过程中发生错误，错误信息:%@",error.localizedDescription);
    }else{
        NSLog(@"视频保存成功.");
    }
}

#pragma mark - 获取视频宽和高
/* 获取视频宽和高 */
+ (CGSize)getVideoSizeWithURL:(NSURL *)url{
    AVAsset *asset = [AVAsset assetWithURL:url];
    NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    AVAssetTrack *videoTrack;
    if([tracks count] > 0) {
        videoTrack = [tracks objectAtIndex:0];
//        CGAffineTransform t = videoTrack.preferredTransform;//这里的矩阵有旋转角度，转换一下即可
//        NSLog(@"=====hello  width:%f===height:%f",videoTrack.naturalSize.width,videoTrack.naturalSize.height);//宽高
    }
        return videoTrack.naturalSize;
}


/* 获取视频大小 此方法可以获取文件的大小，返回的是单位是KB。 */
+ (CGFloat)getFileSize:(NSString *)path
{
    NSLog(@"%@",path);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    float filesize = -1.0;
    if ([fileManager fileExistsAtPath:path]) {
        NSDictionary *fileDic = [fileManager attributesOfItemAtPath:path error:nil];//获取文件的属性
        unsigned long long size = [[fileDic objectForKey:NSFileSize] longLongValue];
        filesize = 1.0*size/1024;
    }else{
        NSLog(@"找不到文件");
    }
    return filesize;
}

/* 获取视频时长 */
+ (CGFloat) getVideoDuration:(NSURL*)URL
{
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                     forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:URL options:opts];
    float second = 0;
    second = urlAsset.duration.value/urlAsset.duration.timescale;
    return second;
}

/* 获取总帧数于帧率 */
+ (NSInteger)getVideoFrameNumberWithUrl:(NSURL *)url{
    //获取总帧数与帧率
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *myAsset = [[AVURLAsset alloc] initWithURL:url options:opts];
    CMTimeValue value = myAsset.duration.value;//总帧数
//    CMTimeScale  timeScale =   myAsset.duration.timescale; //timescale为帧率  fps

    return value;
}

/* 获取指定帧的图片 */
+ (UIImage *)getImageAtSomeFrame:(NSURL *)url videoTime:(NSInteger)videoTime{
    UIImage *image = nil;
    
    AVAsset *asset = [AVAsset assetWithURL:url];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    imageGenerator.appliesPreferredTrackTransform = YES;
    
    CMTime point = CMTimeMakeWithSeconds(videoTime, 600);
    NSError *error = nil;
    CMTime actualTime;
    
    CGImageRef FrameImage = [imageGenerator copyCGImageAtTime:point
                                                         actualTime:&actualTime
                                                              error:&error];
    
    if (FrameImage != NULL) {
        image = [[UIImage alloc] initWithCGImage:FrameImage];
        // Release the CFRetained image
        CGImageRelease(FrameImage);
    }
    
    return image;
}

/* http://blog.csdn.net/wzios/article/details/52100697 */
//NSDateFormatter *formater = [[NSDateFormatter alloc] init];//用时间给文件全名，以免重复，在测试的时候其实可以判断文件是否存在若存在，则删除，重新生成文件即可
//[formater setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
////一般.mp4
//NSURL *newVideoUrl  = [NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingFormat:@"/Documents/output-%@.mp4", [formater stringFromDate:[NSDate date]]]] ;//这个是保存在app自己的沙盒路径里，后面可以选择是否在上传后删除掉。我建议删除掉，免得占空间。
//[self convertVideoQuailtyWithInputURL:url outputURL:newVideoUrl completeHandler:nil];

+ (void) convertVideoQuailtyWithInputURL:(NSURL*)inputURL
                               outputURL:(NSURL*)outputURL
                         completeHandler:(void (^)(AVAssetExportSession*))handler
{
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:inputURL options:nil];

    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
    //  NSLog(resultPath);
    exportSession.outputURL = outputURL;
    exportSession.outputFileType = AVFileTypeMPEG4;
    exportSession.shouldOptimizeForNetworkUse= YES;
    [exportSession exportAsynchronouslyWithCompletionHandler:^(void)
     {
         switch (exportSession.status) {
             case AVAssetExportSessionStatusCancelled:
                 NSLog(@"AVAssetExportSessionStatusCancelled");
                 break;
             case AVAssetExportSessionStatusUnknown:
                 NSLog(@"AVAssetExportSessionStatusUnknown");
                 break;
             case AVAssetExportSessionStatusWaiting:
                 NSLog(@"AVAssetExportSessionStatusWaiting");
                 break;
             case AVAssetExportSessionStatusExporting:
                 NSLog(@"AVAssetExportSessionStatusExporting");
                 break;
             case AVAssetExportSessionStatusCompleted:
                 NSLog(@"AVAssetExportSessionStatusCompleted");
                 NSLog(@"%@",[NSString stringWithFormat:@"%f s", [MSUCameraPhotoVc getVideoDuration:outputURL]]);
                 NSLog(@"%@", [NSString stringWithFormat:@"%.2f kb", [MSUCameraPhotoVc getFileSize:[outputURL path]]]);
                 //UISaveVideoAtPathToSavedPhotosAlbum([outputURL path], self, nil, NULL);//这个是保存到手机相册

//                 [self alertUploadVideo:outputURL];
                 break;
             case AVAssetExportSessionStatusFailed:
                 NSLog(@"AVAssetExportSessionStatusFailed");
                 break;
         }

     }];
}


#pragma mark - 获取网络图片尺寸
- (CGSize)downloadImageSizeWithURL:(id)imageURL{
    
    NSURL* URL = nil;
    if([imageURL isKindOfClass:[NSURL class]]){
        URL = imageURL;
    }
    
    if([imageURL isKindOfClass:[NSString class]]){
        URL = [NSURL URLWithString:imageURL];
    }
    
    if(URL == nil)
        
        return CGSizeZero;
    
#ifdef dispatch_main_sync_safe
    
    if([[SDImageCache sharedImageCache] diskImageExistsWithKey:absoluteString]){
        
        UIImage* image = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:absoluteString];
        if(!image){
            
            NSData* data = [[SDImageCache sharedImageCache] performSelector:@selector(diskImageDataBySearchingAllPathsForKey:) withObject:URL.absoluteString];
            image = [UIImage imageWithData:data];
        }
        
        if(image){
            return image.size;
        }
    }
    
#endif
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:1];
    NSString* pathExtendsion = [URL.pathExtension lowercaseString];
    
    CGSize size = CGSizeZero;
    
    if ([pathExtendsion rangeOfString:@"png"].location != NSNotFound) {
        size =  [self downloadPNGImageSizeWithRequest:request];
    } else if([pathExtendsion rangeOfString:@"gif"].location != NSNotFound){
        size =  [self downloadGIFImageSizeWithRequest:request];
    }else{
        size = [self downloadJPGImageSizeWithRequest:request];
    }
    
    if(CGSizeEqualToSize(CGSizeZero, size)){
        
        NSData* data = [NSData dataWithContentsOfURL:URL];
        UIImage* image = [UIImage imageWithData:data];
        if(image){
            //如果未使用SDWebImage，则忽略；缓存该图片
#ifdef dispatch_main_sync_safe
            [[SDImageCache sharedImageCache] storeImage:image recalculateFromImage:YES imageData:data forKey:URL.absoluteString toDisk:YES];
#endif
            size = image.size;
        }
    }
    
    //过滤掉不符合大小的图片，大图太大浪费流量，用户体验不好
    if (size.height > 2048 || size.height <= 0 || size.width > 2048 || size.width <= 0 ) {
        return CGSizeZero;
    }
    
    else{
        return size;
    }
}

- (CGSize)downloadPNGImageSizeWithRequest:(NSMutableURLRequest*)request{
    
    [request setValue:@"bytes=16-23" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    if(data.length == 8)
    {
        int w1 = 0, w2 = 0, w3 = 0, w4 = 0;
        
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        
        [data getBytes:&w3 range:NSMakeRange(2, 1)];
        
        [data getBytes:&w4 range:NSMakeRange(3, 1)];
        
        int w = (w1 << 24) + (w2 << 16) + (w3 << 8) + w4;
        
        int h1 = 0, h2 = 0, h3 = 0, h4 = 0;
        
        [data getBytes:&h1 range:NSMakeRange(4, 1)];
        
        [data getBytes:&h2 range:NSMakeRange(5, 1)];
        
        [data getBytes:&h3 range:NSMakeRange(6, 1)];
        
        [data getBytes:&h4 range:NSMakeRange(7, 1)];
        
        int h = (h1 << 24) + (h2 << 16) + (h3 << 8) + h4;
        
        return CGSizeMake(w, h);
        
    }
    return CGSizeZero;
}

- (CGSize)downloadGIFImageSizeWithRequest:(NSMutableURLRequest*)request{
    [request setValue:@"bytes=6-9" forHTTPHeaderField:@"Range"];
    
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    if(data.length == 4)
        
    {
        
        short w1 = 0, w2 = 0;
        
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        
        short w = w1 + (w2 << 8);
        
        short h1 = 0, h2 = 0;
        
        [data getBytes:&h1 range:NSMakeRange(2, 1)];
        
        [data getBytes:&h2 range:NSMakeRange(3, 1)];
        
        short h = h1 + (h2 << 8);
        
        return CGSizeMake(w, h);
    }
    return CGSizeZero;
}

- (CGSize)downloadJPGImageSizeWithRequest:(NSMutableURLRequest*)request{
    
    [request setValue:@"bytes=0-209" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if ([data length] <= 0x58) {
        return CGSizeZero;
    }
    
    if ([data length] < 210) {// 肯定只有一个DQT字段
        short w1 = 0, w2 = 0;
        
        [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
        
        [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
        
        short w = (w1 << 8) + w2;
        
        short h1 = 0, h2 = 0;
        
        [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
        
        [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
        
        short h = (h1 << 8) + h2;
        
        return CGSizeMake(w, h);
        
    } else {
        short word = 0x0;
        
        [data getBytes:&word range:NSMakeRange(0x15, 0x1)];
        
        if (word == 0xdb) {
            [data getBytes:&word range:NSMakeRange(0x5a, 0x1)];
            if (word == 0xdb) {// 两个DQT字段
                
                short w1 = 0, w2 = 0;
                
                [data getBytes:&w1 range:NSMakeRange(0xa5, 0x1)];
                
                [data getBytes:&w2 range:NSMakeRange(0xa6, 0x1)];
                
                short w = (w1 << 8) + w2;
                
                short h1 = 0, h2 = 0;
                
                [data getBytes:&h1 range:NSMakeRange(0xa3, 0x1)];
                
                [data getBytes:&h2 range:NSMakeRange(0xa4, 0x1)];
                
                short h = (h1 << 8) + h2;
                
                return CGSizeMake(w, h);
            } else {// 一个DQT字段
                
                short w1 = 0, w2 = 0;
                
                [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
                
                short h = (h1 << 8) + h2;
                
                return CGSizeMake(w, h);
            }
        } else {
            return CGSizeZero;
        }
    }
}


@end

//
//  MSUImageTools.m
//  XiuBei
//
//  Created by Zhuge_Su on 2017/5/31.
//  Copyright © 2017年 Zhuge_Su. All rights reserved.
//

#import "MSUPathTools.h"
#import "sys/utsname.h"

/**
 *  文件后缀名
 */
NSString *const kFileDefaultPathExtension = @"cache";
/**
 *  默认文件名
 */
NSString *kFileDefaultFileName = @"defaultFile";

@implementation MSUPathTools

#pragma mark - 图片缓存相关
/* NSBundle版加载图片 */
+ (UIImage *)showImageWithContentOfFileByName:(NSString *)imageName {
    NSString *path = [NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] resourcePath],imageName ];
    return [UIImage imageWithContentsOfFile:path];
}

#pragma mark - 获取 Plist 文件路径和数据
/* Plist 获取路径 并获取 数据字典*/
+ (NSMutableArray *)getPlistPathWithName:(NSString *)name type:(NSString *)type{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:name ofType:type];
    NSMutableArray *dataDict = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
    return dataDict;
}

#pragma mark - 获取 Documents 文件路径
/* Documents 文件路径 */
+ (NSString *)getDocumentsPathWithFileType:(MSUDocumentsType)type fileName:(NSString *)name{
    // 获取根目录
//    NSString *home = NSHomeDirectory();
    // 查找Documents文件
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    // 拼接文件路径
    NSString *path;
    switch (type) {
        case MSUString:
        {
            path = [doc stringByAppendingString:name];
        }
            break;
        case MSUComponent:
        {
            path = [doc stringByAppendingPathComponent:name];
        }
            break;
            
        default:
            break;
    }
    
    // 调用writeToFile将数据写入文件
    //NSArray *arr = @[@"lnj", @"28"];
    //[arr writeToFile:path atomically:YES];

    // NSDictionary *dict = @{@"name": @"lnj", @"age":@"28"};
    // [dict writeToFile:path atomically:YES];
    
    // 读取数据
    // NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];

    return path;
}

/**
 *  获取文件路径
 *
 *  @return 返回文件路径
 */
- (NSString *)getAllFilePath
{
    NSString *paths = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *fileAllPath = [[paths stringByAppendingPathComponent:kFileDefaultFileName] stringByAppendingPathExtension:kFileDefaultPathExtension];
    return fileAllPath;
}


#pragma mark - 截屏 并保存
- (void)getScreenShotWithLayer:(UIView *)view saveToFile:(MSUFileType)type{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIGraphicsBeginImageContext(view.frame.size);
        [view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *shotImage = UIGraphicsGetImageFromCurrentImageContext();
        switch (type) {
            case MSUAlbum:
            {
                UIImageWriteToSavedPhotosAlbum(shotImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
            }
                break;
            case MSUDocuments:
            {
                NSString *path = [MSUPathTools getDocumentsPathWithFileType:MSUComponent fileName:@"abc.png"];
                NSData *data = UIImagePNGRepresentation(shotImage);
                [data writeToFile:path atomically:YES];
            }
                break;

            default:
                break;
        }
    });
    
//    UIGraphicsBeginImageContextWithOptions(CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds),CGRectGetHeight([UIScreen mainScreen].bounds)),NO,1);
//    
//    [[UIApplication sharedApplication].keyWindow drawViewHierarchyInRect:CGRectMake(0,0,CGRectGetWidth([UIScreen mainScreen].bounds),CGRectGetHeight([UIScreen mainScreen].bounds))afterScreenUpdates:NO];
//    
//    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
//    
//    //把出现错误的截图保存在本地
//    NSString * path1 = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"bug.jpg"];
//    [UIImageJPEGRepresentation(snapshot,1.0) writeToFile:path1 atomically:YES];
//    
//    UIGraphicsEndImageContext();
    
}

/// 方法
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (!error) {
        NSLog(@"保存成功");
    }else{
        NSLog(@"保存失败 %@",error);
    }
}

#pragma mark - App内缓存相关
/* App缓存大小 cache */
+ (CGFloat)cacheSizeInApp{
    CGFloat cacheSize = 0.0;
    
    // 获取路径
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    // 获取所有文件的数组
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachePath];
    NSLog(@"缓存文件数：%ld",(unsigned long)files.count);
    // 遍历缓存文件
    for (NSString *path in files) {
        NSString *filePath = [cachePath stringByAppendingString:[NSString stringWithFormat:@"/%@",path]];
        cacheSize += [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil].fileSize;
    }
    // 转换为M为单位
    CGFloat sizeM = cacheSize /1024.0 /1024.0;
    
    return sizeM;
}

/* 清除 App缓存 cache */
+ (void)cleanCacheSizeInAppWithComplement:(complementBlock)block{
    // 获取路径
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    // 获取所有文件的数组
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachePath];
    
    //删除 sd 图片缓存
    //先清除内存中的图片缓存
    [[SDImageCache sharedImageCache] clearMemory];
    //清除磁盘的缓存
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
    [[SDImageCache sharedImageCache] deleteOldFilesWithCompletionBlock:nil];
    
    // 遍历缓存文件
    for (NSString *path in files) {
        NSError *error;
        // 缓存文件中的具体文件的路径
        NSString *filePath = [cachePath stringByAppendingString:[NSString stringWithFormat:@"/%@",path]];
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            BOOL isRemove = [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
            if (isRemove) {
                // 清除成功
                block(@"清除成功",200);
            }else{
                // 清除失败
                block(@"清除失败",404);
            }
        }
    }
}



#pragma mark - 获取四大文件路径URL
+ (NSURL *)getDocumentURLWithPath:(NSString *)path{
     NSFileManager *manager = [NSFileManager defaultManager];
     NSURL *docuUrl = [[manager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
     NSURL *pathUrl = [docuUrl URLByAppendingPathComponent:path];
//     NSURL *path = [url URLByAppendingPathComponent:@"MyDocument"];
    return pathUrl;
}

#pragma mark - 画四周阴影
+ (UIBezierPath *)drawShadowAroundControls:(UIView *)view shadowHeight:(CGFloat)shadowHeight{
    UIBezierPath *path = [UIBezierPath bezierPath];
    float width = view.bounds.size.width;
    float height = view.bounds.size.height;
    
    [path moveToPoint:CGPointMake(-shadowHeight, -shadowHeight)];
    //添加直线
    [path addLineToPoint:CGPointMake(width/2, -shadowHeight)];
    [path addLineToPoint:CGPointMake(width + shadowHeight, -shadowHeight)];
    [path addLineToPoint:CGPointMake(width + shadowHeight, height/2)];
    [path addLineToPoint:CGPointMake(width + shadowHeight, height + shadowHeight)];
    [path addLineToPoint:CGPointMake(width/2, height + shadowHeight)];
    [path addLineToPoint:CGPointMake(-shadowHeight, height + shadowHeight )];
    [path addLineToPoint:CGPointMake(-shadowHeight, height/2)];
    [path addLineToPoint:CGPointMake(-shadowHeight, -shadowHeight)];
    
    return path;
}

#pragma mark - 颜色渐变
/* 颜色渐变 */
+ (void)drawGradientColorFromColorA:(UIColor *)ColorA toColorB:(UIColor *)ColorB withView:(UIView *)view isLeft:(BOOL)isLeft{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)ColorA.CGColor, (__bridge id)ColorB.CGColor];
//    gradientLayer.locations = @[@0.5, @0.5];
    if (isLeft) {
        gradientLayer.startPoint = CGPointMake(0, 0.0);
        gradientLayer.endPoint = CGPointMake(1.0, 0.0);
    }
    gradientLayer.frame = view.bounds;
    [view.layer addSublayer:gradientLayer];
}

/* 半边圆角  */
+ (void)halfCornerWithView:(UIView *)view corner:(NSInteger)corner{
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners: UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii: (CGSize){corner, corner}].CGPath;
    view.layer.masksToBounds = YES;
    view.layer.mask = maskLayer;
    
//    _bg1View.layer.shadowColor = HEXCOLOR(0xcccccc).CGColor;
//    _bg1View.layer.shadowOffset = CGSizeMake(0, 0);
//    _bg1View.layer.shadowRadius = 4;
//    _bg1View.layer.shadowOpacity = 1;
}

#pragma mark - 更改图片背景颜色
+ (UIImage*)grayscale:(UIImage*)anImage type:(int)type {
    CGImageRef imageRef = anImage.CGImage;
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    size_t bitsPerComponent = CGImageGetBitsPerComponent(imageRef);
    size_t bitsPerPixel = CGImageGetBitsPerPixel(imageRef);
    size_t bytesPerRow = CGImageGetBytesPerRow(imageRef);
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(imageRef);
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    bool shouldInterpolate = CGImageGetShouldInterpolate(imageRef);
    CGColorRenderingIntent intent = CGImageGetRenderingIntent(imageRef);
    CGDataProviderRef dataProvider = CGImageGetDataProvider(imageRef);
    CFDataRef data = CGDataProviderCopyData(dataProvider);
    UInt8 *buffer = (UInt8*)CFDataGetBytePtr(data);
    NSUInteger x, y;
    for (y = 0; y < height; y++) {
        for (x = 0; x < width; x++) {
            UInt8 *tmp;
            tmp = buffer + y * bytesPerRow + x * 4;
            UInt8 red,green,blue;
            red = *(tmp + 0);
            green = *(tmp + 1);
            blue = *(tmp + 2);
            UInt8 brightness;
            switch (type) {
                case 1:
                    brightness = (77 * red + 28 * green + 151 * blue) / 256;
                    *(tmp + 0) = brightness;
                    *(tmp + 1) = brightness;
                    *(tmp + 2) = brightness;
                break;
                case 2:
                    *(tmp + 0) = red;
                    *(tmp + 1) = green * 0.7;
                    *(tmp + 2) = blue * 0.4;
                break;
                case 3:
                    *(tmp + 0) = 255 - red;
                    *(tmp + 1) = 255 - green;
                    *(tmp + 2) = 255 - blue;
                break;
                default:
                    *(tmp + 0) = red;
                    *(tmp + 1) = green;
                    *(tmp + 2) = blue;
                break;
            }
        }
    }
    CFDataRef effectedData = CFDataCreate(NULL, buffer, CFDataGetLength(data));
    CGDataProviderRef effectedDataProvider = CGDataProviderCreateWithCFData(effectedData);
    CGImageRef effectedCgImage = CGImageCreate( width, height, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpace, bitmapInfo, effectedDataProvider, NULL, shouldInterpolate, intent);
    UIImage *effectedImage = [[UIImage alloc] initWithCGImage:effectedCgImage];
    CGImageRelease(effectedCgImage);
    CFRelease(effectedDataProvider);
    CFRelease(effectedData);
    CFRelease(data);
    return effectedImage;
}

/* 黑白化  */
+ (UIImage *)whiteBlackImageWithImage:(UIImage *)img{
    CGImageRef imImage = img.CGImage;
    CFDataRef mDataRef = CGDataProviderCopyData(CGImageGetDataProvider(imImage));
    UInt8 *mPixelBuf = (UInt8 *)CFDataGetBytePtr(mDataRef);
    CFIndex length = CFDataGetLength(mDataRef);
    
    for(int i=0;i<length;i+=4){
        int r = i;
        int g = i+1;
        int b = i+2;
        
        int red1   = mPixelBuf[r];
        int green1 = mPixelBuf[g];
        int blue1  = mPixelBuf[b];
        if (red1 < 120 || green1 < 120 || blue1 < 120) {
            mPixelBuf[r] = 156;
            mPixelBuf[g] = 156;
            mPixelBuf[b] = 156;
        }
        else{
            mPixelBuf[r] = 255;
            mPixelBuf[g] = 255;
            mPixelBuf[b] = 255;
        }
    }
    
    
    CGContextRef ctx = CGBitmapContextCreate(mPixelBuf,
                                             CGImageGetWidth(imImage),
                                             CGImageGetHeight(imImage),
                                             CGImageGetBitsPerComponent(imImage),
                                             CGImageGetBytesPerRow(imImage),
                                             CGImageGetColorSpace(imImage),
                                             CGImageGetBitmapInfo(imImage)
                                             );
    
    CGImageRef imageRef = CGBitmapContextCreateImage(ctx);
    CGContextRelease(ctx);
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CFRelease(mDataRef);
    return finalImage;
}

/* 海报化  */
+ (UIImage *)CBMPImageWithImage:(UIImage *)img{
    CGImageRef imImage = img.CGImage;
    CFDataRef mDataRef = CGDataProviderCopyData(CGImageGetDataProvider(imImage));
    UInt8 *mPixelBuf = (UInt8 *)CFDataGetBytePtr(mDataRef);
    CFIndex length = CFDataGetLength(mDataRef);
    
    for(int i=0;i<length;i+=4){
        int r = i;
        int g = i+1;
        int b = i+2;
        
        int red1   = mPixelBuf[r];
        int green1 = mPixelBuf[g];
        int blue1  = mPixelBuf[b];
        
        mPixelBuf[r] = red1&0xe0;
        mPixelBuf[g] = green1&0xe0;
        mPixelBuf[b] = blue1&0xe0;
    }
    
    
    CGContextRef ctx = CGBitmapContextCreate(mPixelBuf,
                                             CGImageGetWidth(imImage),
                                             CGImageGetHeight(imImage),
                                             CGImageGetBitsPerComponent(imImage),
                                             CGImageGetBytesPerRow(imImage),
                                             CGImageGetColorSpace(imImage),
                                             CGImageGetBitmapInfo(imImage)
                                             );
    
    CGImageRef imageRef = CGBitmapContextCreateImage(ctx);
    CGContextRelease(ctx);
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CFRelease(mDataRef);
    return finalImage;
}

/* 海报化  */
+ (UIImage *)GaussianSmoothImageWithImage:(UIImage *)img{
    CGImageRef imImage = img.CGImage;
    CFDataRef mDataRef = CGDataProviderCopyData(CGImageGetDataProvider(imImage));
    CFDataRef m_OutDataRef = CGDataProviderCopyData(CGImageGetDataProvider(imImage));
    UInt8 *mPixelBuf = (UInt8 *)CFDataGetBytePtr(mDataRef);
    UInt8 *mOutPixelBuf = (UInt8 *) CFDataGetBytePtr(m_OutDataRef);
    //CFIndex length = CFDataGetLength(mDataRef);
    
    int width  = (int)CGImageGetWidth(imImage);
    int height = (int)CGImageGetHeight(imImage);
    int templates[25] = {
        1, 4,  7,  4,  1,
        4, 16, 26, 16, 4,
        7, 26, 41, 26, 7,
        4, 16, 26, 16, 4,
        1, 4,  7,  4,  1 };
    int rSum,gSum,bSum;
    int index=0;
    for(int i= 2;i<height-2;i++){
        for(int j= 2;j<width-2;j++){
            rSum=0;
            gSum=0;
            bSum=0;
            index=0;
            for(int zi=i-2;zi<i+3;zi++){
                for(int zj=j-2;zj<j+3;zj++){
                    int s = templates[index++];
                    int tindex = zi*height*4+zj*4;
                    rSum += mPixelBuf[tindex]*s;
                    gSum += mPixelBuf[tindex+1]*s;
                    bSum += mPixelBuf[tindex+2]*s;
                }
            }
            rSum/=273;
            gSum/=273;
            bSum/=273;
            rSum = rSum>255?255:rSum;
            gSum = gSum>255?255:gSum;
            bSum = bSum>255?255:bSum;
            index = i*4*width+j*4;
            mOutPixelBuf[index]=rSum;
            mOutPixelBuf[index+1]=gSum;
            mOutPixelBuf[index+2]=bSum;
        }
    }
    
    CGContextRef ctx = CGBitmapContextCreate(mOutPixelBuf,
                                             CGImageGetWidth(imImage),
                                             CGImageGetHeight(imImage),
                                             CGImageGetBitsPerComponent(imImage),
                                             CGImageGetBytesPerRow(imImage),
                                             CGImageGetColorSpace(imImage),
                                             CGImageGetBitmapInfo(imImage)
                                             );
    
    CGImageRef imageRef = CGBitmapContextCreateImage(ctx);
    CGContextRelease(ctx);
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CFRelease(mDataRef);
    return finalImage;
}

#pragma mark - 获取手机版本
+ (NSString *)deviceVersion
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString * deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    //iPhone
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    
    return deviceString;
}

#pragma mark - 获取手机相关信息
+ (NSString *)getInfoFromPhone:(MSUPhoneInfo)phoneInfo{
    NSString *Info;
    switch (phoneInfo) {
        case MSUPhoneUUID:{
            Info = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        }
            break;
        case MSUPhoneName:{
            Info = [[UIDevice currentDevice] name]; ;
        }
            break;
        case MSUPhoneType:{
            Info = [[UIDevice currentDevice] systemName];
        }
            break;
        case MSUPhoneSystemVersion:{
            Info = [[UIDevice currentDevice] systemVersion];;
        }
            break;
        case MSUPhoneAppVersion:{
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            Info = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        }
            break;
        case MSUPhonePlatform:{
            Info = [self iphoneType];
        }
            break;
        default:
            break;
    }
    
    return Info;
}

+ (NSString*)iphoneType {
    
    //需要导入头文件：#import <sys/utsname.h>
    
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString*platform = [NSString stringWithCString: systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if([platform isEqualToString:@"iPhone1,1"])  return@"iPhone 2G";
    
    if([platform isEqualToString:@"iPhone1,2"])  return@"iPhone 3G";
    
    if([platform isEqualToString:@"iPhone2,1"])  return@"iPhone 3GS";
    
    if([platform isEqualToString:@"iPhone3,1"])  return@"iPhone 4";
    
    if([platform isEqualToString:@"iPhone3,2"])  return@"iPhone 4";
    
    if([platform isEqualToString:@"iPhone3,3"])  return@"iPhone 4";
    
    if([platform isEqualToString:@"iPhone4,1"])  return@"iPhone 4S";
    
    if([platform isEqualToString:@"iPhone5,1"])  return@"iPhone 5";
    
    if([platform isEqualToString:@"iPhone5,2"])  return@"iPhone 5";
    
    if([platform isEqualToString:@"iPhone5,3"])  return@"iPhone 5c";
    
    if([platform isEqualToString:@"iPhone5,4"])  return@"iPhone 5c";
    
    if([platform isEqualToString:@"iPhone6,1"])  return@"iPhone 5s";
    
    if([platform isEqualToString:@"iPhone6,2"])  return@"iPhone 5s";
    
    if([platform isEqualToString:@"iPhone7,1"])  return@"iPhone 6 Plus";
    
    if([platform isEqualToString:@"iPhone7,2"])  return@"iPhone 6";
    
    if([platform isEqualToString:@"iPhone8,1"])  return@"iPhone 6s";
    
    if([platform isEqualToString:@"iPhone8,2"])  return@"iPhone 6s Plus";
    
    if([platform isEqualToString:@"iPhone8,4"])  return@"iPhone SE";
    
    if([platform isEqualToString:@"iPhone9,1"])  return@"iPhone 7";
    
    if([platform isEqualToString:@"iPhone9,3"])  return@"iPhone 7";
    
    if([platform isEqualToString:@"iPhone9,2"])  return@"iPhone 7 Plus";
    
    if([platform isEqualToString:@"iPhone9,4"])  return@"iPhone 7 Plus";
    
    if([platform isEqualToString:@"iPhone10,1"]) return@"iPhone 8";
    
    if([platform isEqualToString:@"iPhone10,4"]) return@"iPhone 8";
    
    if([platform isEqualToString:@"iPhone10,2"]) return@"iPhone 8 Plus";
    
    if([platform isEqualToString:@"iPhone10,5"]) return@"iPhone 8 Plus";
    
    if([platform isEqualToString:@"iPhone10,3"]) return@"iPhone X";
    
    if([platform isEqualToString:@"iPhone10,6"]) return@"iPhone X";
    
    if([platform isEqualToString:@"iPod1,1"])  return@"iPod Touch 1G";
    
    if([platform isEqualToString:@"iPod2,1"])  return@"iPod Touch 2G";
    
    if([platform isEqualToString:@"iPod3,1"])  return@"iPod Touch 3G";
    
    if([platform isEqualToString:@"iPod4,1"])  return@"iPod Touch 4G";
    
    if([platform isEqualToString:@"iPod5,1"])  return@"iPod Touch 5G";
    
    if([platform isEqualToString:@"iPad1,1"])  return@"iPad 1G";
    
    if([platform isEqualToString:@"iPad2,1"])  return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,2"])  return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,3"])  return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,4"])  return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,5"])  return@"iPad Mini 1G";
    
    if([platform isEqualToString:@"iPad2,6"])  return@"iPad Mini 1G";
    
    if([platform isEqualToString:@"iPad2,7"])  return@"iPad Mini 1G";
    
    if([platform isEqualToString:@"iPad3,1"])  return@"iPad 3";
    
    if([platform isEqualToString:@"iPad3,2"])  return@"iPad 3";
    
    if([platform isEqualToString:@"iPad3,3"])  return@"iPad 3";
    
    if([platform isEqualToString:@"iPad3,4"])  return@"iPad 4";
    
    if([platform isEqualToString:@"iPad3,5"])  return@"iPad 4";
    
    if([platform isEqualToString:@"iPad3,6"])  return@"iPad 4";
    
    if([platform isEqualToString:@"iPad4,1"])  return@"iPad Air";
    
    if([platform isEqualToString:@"iPad4,2"])  return@"iPad Air";
    
    if([platform isEqualToString:@"iPad4,3"])  return@"iPad Air";
    
    if([platform isEqualToString:@"iPad4,4"])  return@"iPad Mini 2G";
    
    if([platform isEqualToString:@"iPad4,5"])  return@"iPad Mini 2G";
    
    if([platform isEqualToString:@"iPad4,6"])  return@"iPad Mini 2G";
    
    if([platform isEqualToString:@"iPad4,7"])  return@"iPad Mini 3";
    
    if([platform isEqualToString:@"iPad4,8"])  return@"iPad Mini 3";
    
    if([platform isEqualToString:@"iPad4,9"])  return@"iPad Mini 3";
    
    if([platform isEqualToString:@"iPad5,1"])  return@"iPad Mini 4";
    
    if([platform isEqualToString:@"iPad5,2"])  return@"iPad Mini 4";
    
    if([platform isEqualToString:@"iPad5,3"])  return@"iPad Air 2";
    
    if([platform isEqualToString:@"iPad5,4"])  return@"iPad Air 2";
    
    if([platform isEqualToString:@"iPad6,3"])  return@"iPad Pro 9.7";
    
    if([platform isEqualToString:@"iPad6,4"])  return@"iPad Pro 9.7";
    
    if([platform isEqualToString:@"iPad6,7"])  return@"iPad Pro 12.9";
    
    if([platform isEqualToString:@"iPad6,8"])  return@"iPad Pro 12.9";
    
    if([platform isEqualToString:@"i386"])  return@"iPhone Simulator";
    
    if([platform isEqualToString:@"x86_64"])  return@"iPhone Simulator";
    
    return platform;
    
}

@end

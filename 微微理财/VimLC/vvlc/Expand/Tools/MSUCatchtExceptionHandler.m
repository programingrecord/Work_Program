//
//  UncaughtExceptionHandler.m
//  MSU_TestDemo
//
//  Created by 007 on 2018/3/20.
//  Copyright © 2018年 007. All rights reserved.
//

#import "MSUCatchtExceptionHandler.h"
#include <libkern/OSAtomic.h>
#include <execinfo.h>
#import <UIKit/UIKit.h>
#import <AFNetworking.h>
#import "MSUPathTools.h"
#import "CoreArchive.h"

NSString * const MSUCatchtExceptionHandlerSignalExceptionName = @"MSUCatchtExceptionHandlerSignalExceptionName";
NSString * const MSUCatchtExceptionHandlerSignalKey = @"MSUCatchtExceptionHandlerSignalKey";
NSString * const MSUCatchtExceptionHandlerAddressesKey = @"MSUCatchtExceptionHandlerAddressesKey";

volatile int32_t UncaughtExceptionCount = 0;
const int32_t UncaughtExceptionMaximum = 10;

const NSInteger MSUCatchtExceptionHandlerSkipAddressCount = 4;
const NSInteger MSUCatchtExceptionHandlerReportAddressCount = 5;


void MSUInstallUncaughtExceptionHandler(void)
{
    NSSetUncaughtExceptionHandler(&HandleException);
    signal(SIGABRT, SignalHandler);
    signal(SIGILL, SignalHandler);
    signal(SIGSEGV, SignalHandler);
    signal(SIGFPE, SignalHandler);
    signal(SIGBUS, SignalHandler);
    signal(SIGPIPE, SignalHandler);
}

@implementation MSUCatchtExceptionHandler

+ (NSArray *)backtrace
{
    void* callstack[128];
    int frames = backtrace(callstack, 128);
    char **strs = backtrace_symbols(callstack, frames);
    
    int i;
    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
    for (
         i = MSUCatchtExceptionHandlerSkipAddressCount;
         i < MSUCatchtExceptionHandlerSkipAddressCount +
         MSUCatchtExceptionHandlerReportAddressCount;
         i++)
    {
        [backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
    }
    free(strs);
    
    return backtrace;
}

- (void)alertView:(UIAlertView *)anAlertView clickedButtonAtIndex:(NSInteger)anIndex
{
    dismissed = YES;

//    if (anIndex == 0)
//    {
//        dismissed = YES;
//    }else if (anIndex==1) {
//        NSLog(@"ssssssss");
//    }
//
}

#pragma mark -- 保存文件并发送崩溃日志
/* 保存文件  */ // 生产厂商 ： Manufacturer  手机型号 ：PhoneType  系统版本 ：SystemVersion  异常类型 ：ErrorType  异常原因 ：ErrorReason 异常堆栈 ：ErrorSignal
- (void)validateAndSaveCriticalApplicationDataWithException:(NSException *)exception{
    NSArray * arr = [exception callStackSymbols];
    NSString * reason = [exception reason];
    NSString * name = [exception name];
    NSString *urlStr = [CoreArchive strForKey:@"msuexception"];
    NSString * url = [NSString stringWithFormat:@"========异常错误报告========,\nManufacturer:%@\n,PhoneType:%@\n,SystemVersion:%@\n,ErrorType:%@,\nErrorReason:\n%@,ErrorUrl:%@,\nErrorSignal:%@\n,appidenty:%@\n,appversion:%@,\n",@"iPhone",[MSUPathTools getInfoFromPhone:MSUPhoneType],[MSUPathTools getInfoFromPhone:MSUPhoneSystemVersion],name,reason,urlStr,exception.userInfo,@"WeiMi",[MSUPathTools getInfoFromPhone:MSUPhoneAppVersion]];

    NSString * path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"Exception.txt"];
    [url writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    //    在出现错误的地方截图
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds),CGRectGetHeight([UIScreen mainScreen].bounds)),NO,1);
    
    [[UIApplication sharedApplication].keyWindow drawViewHierarchyInRect:CGRectMake(0,0,CGRectGetWidth([UIScreen mainScreen].bounds),CGRectGetHeight([UIScreen mainScreen].bounds))afterScreenUpdates:NO];
    
    UIImage *snapshot =UIGraphicsGetImageFromCurrentImageContext();
    
    //把出现错误的截图保存在本地
    [UIImageJPEGRepresentation(snapshot, 1.0) writeToFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingString:@"bug.jpg"] atomically:YES];
    //    [UIImageJPEGRepresentation(snapshot,1.0)writeToFile:[[NSString alloc] initWithFormat:@"%@/Documents/bug.jpg",NSHomeDirectory()] atomically:YES];
    
    UIGraphicsEndImageContext();
    
    // 发送崩溃日志
    NSString *path1 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dataPath = [path1 stringByAppendingPathComponent:@"Exception.txt"];
    NSString *dataImaPath = [path1 stringByAppendingPathComponent:@"bug.jpg"];
    
    NSData *data = [NSData dataWithContentsOfFile:dataPath];
    NSData *data1 = [NSData dataWithContentsOfFile:dataImaPath];
    
    if (data != nil) {
        NSLog(@"有文件");
        [self sendExceptionLogWithfileData:data imaData:data1 filePath:dataPath imagePath:dataImaPath];
    }
}

/* 发送数据  */
- (void)sendExceptionLogWithfileData:(NSData *)fileData imaData:(NSData *)imaData filePath:(NSString *)filePath imagePath:(NSString *)imagePath{
    
    NSDictionary *dic = @{@"ft":@"5",@"fileType":@"1"};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 5.0f;
    [manager.requestSerializer setValue:@"LUNA.APP.U.AGENT" forHTTPHeaderField:@"User-Agent"];

    //告诉AFN，支持接受 text/xml 的数据
    [AFJSONResponseSerializer serializer].acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    NSString *urlString = [NSString stringWithFormat:@"%@file_upload_errorlog.do",Base_url];
    
    
    [manager POST:urlString parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:fileData name:@"file" fileName:@"Exception.txt" mimeType:@"txt"];
//        [formData appendPartWithFileData:imaData name:@"image" fileName:@"bug.jpg" mimeType:@"image/jpg"];
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        MyLog(@"成功");
        // 删除文件
        NSFileManager *fileManger = [NSFileManager defaultManager];
        [fileManger removeItemAtPath:filePath error:nil];
        [fileManger removeItemAtPath:imagePath error:nil];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            dismissed = YES;
        });
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        MyLog(@"失败");
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            dismissed = YES;
        });
    }];
    
    
}

- (UIWindow *)lastWindow
{
    NSArray *windows = [UIApplication sharedApplication].windows;
    for(UIWindow *window in [windows reverseObjectEnumerator]) {
        
        if ([window isKindOfClass:[UIWindow class]] &&
            CGRectEqualToRect(window.bounds, [UIScreen mainScreen].bounds))
            
            return window;
    }
    
    return [UIApplication sharedApplication].keyWindow;
}

- (void)handleException:(NSException *)exception
{
    [self validateAndSaveCriticalApplicationDataWithException:exception];
    
    //[NSString stringWithFormat:NSLocalizedString(
//    @"如果点击继续，程序有可能会出现其他的问题，建议您还是点击退出按钮并重新打开\n\n"
//    @"异常原因如下:\n%@\n%@", nil),
//    [exception reason],
//    [[exception userInfo] objectForKey:MSUCatchtExceptionHandlerAddressesKey]]
    UIAlertView *alert =
    [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"抱歉，程序出现了异常", nil)
                               message:[NSString stringWithFormat:NSLocalizedString(
                                                                                    @"如果点击继续，程序有可能会出现其他的问题，建议您还是点击退出按钮并重新打开"
                                                                                    , nil)]
                              delegate:[self lastWindow]
                     cancelButtonTitle:NSLocalizedString(@"退出", nil)
                     otherButtonTitles:nil, nil];
    [alert show];
    
    [PAProgressView showInView:MSUMainWindow  contentString:@"抱歉，程序出现了异常！建议您关闭程序并重新打开"];

    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFArrayRef allModes = CFRunLoopCopyAllModes(runLoop);
    
    while (!dismissed)
    {
        for (NSString *mode in (__bridge NSArray *)allModes)
        {
            CFRunLoopRunInMode((CFStringRef)mode, 0.001, false);
        }
    }
    
    CFRelease(allModes);
    
    NSSetUncaughtExceptionHandler(NULL);
    signal(SIGABRT, SIG_DFL);
    signal(SIGILL, SIG_DFL);
    signal(SIGSEGV, SIG_DFL);
    signal(SIGFPE, SIG_DFL);
    signal(SIGBUS, SIG_DFL);
    signal(SIGPIPE, SIG_DFL);
    
    if ([[exception name] isEqual:MSUCatchtExceptionHandlerSignalExceptionName])
    {
        kill(getpid(), [[[exception userInfo] objectForKey:MSUCatchtExceptionHandlerSignalKey] intValue]);
    }
    else
    {
        [exception raise];
    }
}

@end

void HandleException(NSException *exception)
{
    int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
    if (exceptionCount > UncaughtExceptionMaximum)
    {
        return;
    }
    
    NSArray *callStack = [MSUCatchtExceptionHandler backtrace];
    NSMutableDictionary *userInfo =
    [NSMutableDictionary dictionaryWithDictionary:[exception userInfo]];
    [userInfo
     setObject:callStack
     forKey:MSUCatchtExceptionHandlerAddressesKey];
    
    [[[MSUCatchtExceptionHandler alloc] init]
     performSelectorOnMainThread:@selector(handleException:)
     withObject:
     [NSException
      exceptionWithName:[exception name]
      reason:[exception reason]
      userInfo:userInfo]
     waitUntilDone:YES];
}

void SignalHandler(int signal)
{
    int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
    if (exceptionCount > UncaughtExceptionMaximum)
    {
        return;
    }
    
    NSMutableDictionary *userInfo =
    [NSMutableDictionary
     dictionaryWithObject:[NSNumber numberWithInt:signal]
     forKey:MSUCatchtExceptionHandlerSignalKey];
    
    NSArray *callStack = [MSUCatchtExceptionHandler backtrace];
    [userInfo
     setObject:callStack
     forKey:MSUCatchtExceptionHandlerAddressesKey];
    
    [[[MSUCatchtExceptionHandler alloc] init]
     performSelectorOnMainThread:@selector(handleException:)
     withObject:
     [NSException
      exceptionWithName:MSUCatchtExceptionHandlerSignalExceptionName
      reason:
      [NSString stringWithFormat:
       NSLocalizedString(@"Signal %d was raised.", nil),
       signal]
      userInfo:
      [NSDictionary
       dictionaryWithObject:[NSNumber numberWithInt:signal]
       forKey:MSUCatchtExceptionHandlerSignalKey]]
     waitUntilDone:YES];
}


//
//  UncaughtExceptionHandler.h
//  MSU_TestDemo
//
//  Created by 007 on 2018/3/20.
//  Copyright © 2018年 007. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSUCatchtExceptionHandler : NSObject{
    BOOL dismissed;
}

@end

void HandleException(NSException *exception);
void SignalHandler(int signal);
void MSUInstallUncaughtExceptionHandler(void);

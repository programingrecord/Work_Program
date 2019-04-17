//
//  AlertView.m
//  IMAGE
//
//  Created by Mac on 14/10/30.
//  Copyright (c) 2014年 ___caffcoo leo__. All rights reserved.
//

#import "AlertView.h"

@implementation AlertView

+(void)showalertView:(NSString *)message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:message message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
}
@end

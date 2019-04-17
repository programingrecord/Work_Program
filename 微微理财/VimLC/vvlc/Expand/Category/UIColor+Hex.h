//
//  UIColor+UIColor_extra_h.h
//  PAChat
//
//  Created by xiao on 8/12/14.
//  Copyright (c) 2014 FreeDo. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UIColor (Hex)

+ (UIColor *)colorWithHex:(long)hexColor;
+ (UIColor *)colorWithHex:(long)hexColor alpha:(float)opacity;

@end
//
//  NSMutableAttributedString+TextAttriButedString.m
//  CollectShelling
//
//  Created by HM on 2017/7/5.
//  Copyright © 2017年 HM. All rights reserved.
//

#import "NSMutableAttributedString+TextAttriButedString.h"

@implementation NSMutableAttributedString (TextAttriButedString)


+ (NSMutableAttributedString *)setAttriButedString:(NSString *)string font:(UIFont *)font color:(UIColor *)color searchString:(NSString *)searchString font:(UIFont *)searchfont color:(UIColor *)searchcolor{
    NSRange range = NSMakeRange(0,string.length);
    
    NSRange range1= [string rangeOfString:searchString];
    
    NSMutableAttributedString *Astring = [[NSMutableAttributedString alloc] initWithString:string];
    [Astring addAttribute:NSFontAttributeName value:font  range:range];
    [Astring addAttribute:NSForegroundColorAttributeName value:color range:range];
    [Astring addAttribute:NSFontAttributeName value:searchfont range:range1];
    [Astring addAttribute:NSForegroundColorAttributeName value:searchcolor range:range1];
    return Astring;
}


@end

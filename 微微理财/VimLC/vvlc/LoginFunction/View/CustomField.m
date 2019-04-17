//
//  CustomField.m
//  项目开发
//
//  Created by H on 16/5/26.
//  Copyright © 2016年 姜国军. All rights reserved.
//

#import "CustomField.h"

@implementation CustomField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor colorWithHex:0xd8d8d8].CGColor);
    CGContextFillRect(context, CGRectMake(0, CGRectGetHeight(self.frame) - 0.5, CGRectGetWidth(self.frame), 0.5));
}

@end

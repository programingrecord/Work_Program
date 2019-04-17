//
//  UnderLineField.m
//  CollectShelling
//
//  Created by HM on 2017/5/16.
//  Copyright © 2017年 HM. All rights reserved.
//

#import "UnderLineField.h"

@implementation UnderLineField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor colorWithHex:0x000000 alpha:0.1].CGColor);
    CGContextFillRect(context,CGRectMake(0,CGRectGetHeight(self.frame)-0.5,CGRectGetWidth(self.frame),0.5));
}

- (void)deleteBackward{
    [super deleteBackward];
    
    if (self.msudelegate && [self.msudelegate respondsToSelector:@selector(deleteBtnClick:)]) {
        [self.msudelegate deleteBtnClick:self];
    }
    
}



@end

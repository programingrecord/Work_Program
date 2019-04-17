//
//  MSUCustomTF2.m
//  ZMLC
//
//  Created by 007 on 2018/2/27.
//  Copyright © 2018年 HM. All rights reserved.
//

#import "MSUCustomTF2.h"

@implementation MSUCustomTF2

//控制placeHolder的位置，左右缩20
-(CGRect)placeholderRectForBounds:(CGRect)bounds {
    //return CGRectInset(bounds, 20, 0);
    CGRect inset = CGRectMake(bounds.origin.x+30, bounds.origin.y, bounds.size.width -10, bounds.size.height);//更好理解些
    return inset;
    
}

- (CGRect)editingRectForBounds:(CGRect)bounds{
    CGRect inset = CGRectMake(bounds.origin.x+30, bounds.origin.y, bounds.size.width -10, bounds.size.height);//更好理解些
    return inset;
}

- (CGRect)textRectForBounds:(CGRect)bounds{
    CGRect inset = CGRectMake(bounds.origin.x+30, bounds.origin.y, bounds.size.width -10, bounds.size.height);//更好理解些
    return inset;
}

//- (void)deleteBackward{
//    [super deleteBackward];
//    
//    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteBtnClick:)]) {
//        [self.delegate deleteBtnClick:self];
//    }
//    
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

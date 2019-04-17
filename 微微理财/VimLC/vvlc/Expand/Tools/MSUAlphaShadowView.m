//
//  MSUAlphaShadowView.m
//  vvlc
//
//  Created by 007 on 2018/5/3.
//  Copyright © 2018年 HM. All rights reserved.
//

#import "MSUAlphaShadowView.h"

@implementation MSUAlphaShadowView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //    self.hidden = YES;
    for (UIView *view in self.subviews) {
        CGPoint point = [[touches anyObject] locationInView:view];
        if (![view.layer containsPoint:point]) {
            self.alpha = 0;
//            view.hidden = YES;
            
            // 支付页面 防止点击view移除键盘
            [self endEditing:YES];
        }
    }
}

@end

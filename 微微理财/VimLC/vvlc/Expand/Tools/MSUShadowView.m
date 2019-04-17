//
//  MSUShadowView.m
//  XiuBei
//
//  Created by Zhuge_Su on 2017/8/17.
//  Copyright © 2017年 Zhuge_Su. All rights reserved.
//

#import "MSUShadowView.h"

@implementation MSUShadowView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    self.hidden = YES;
    for (UIView *view in self.subviews) {
        CGPoint point = [[touches anyObject] locationInView:view];
        if (![view.layer containsPoint:point]) {
            self.hidden = YES;
            view.hidden = YES;
            
            // 支付页面 防止点击view移除键盘
            [self endEditing:YES];
        }
    }
}
@end

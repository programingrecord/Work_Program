//
//  MSUShadowInView.m
//  秀贝
//
//  Created by 何龙飞 on 2017/10/26.
//  Copyright © 2017年 Zhuge_Su. All rights reserved.
//

#import "MSUShadowInView.h"

@implementation MSUShadowInView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //    self.hidden = YES;
    for (UIView *view in self.subviews) {
        CGPoint point = [[touches anyObject] locationInView:view];
        if (![view.layer containsPoint:point]) {
            self.hidden = YES;
            view.hidden = YES;
            
        }
        
        // 支付页面 防止点击view移除键盘
        [self endEditing:YES];
    }
}

@end

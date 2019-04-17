//
//  CustomUIEdgeInsetLabel.m
//  ElectricBao
//
//  Created by HM on 2017/2/7.
//  Copyright © 2017年 HM. All rights reserved.
//

#import "CustomUIEdgeInsetLabel.h"

@implementation CustomUIEdgeInsetLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init {
    if (self = [super init]) {
        _textInsets = UIEdgeInsetsZero;
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _textInsets = UIEdgeInsetsZero;
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, _textInsets)];
}
@end

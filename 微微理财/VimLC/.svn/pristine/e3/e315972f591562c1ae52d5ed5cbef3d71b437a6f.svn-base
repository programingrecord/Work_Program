//
//  WebviewProgressLine.m
//  CollectShelling
//
//  Created by HM on 2017/8/21.
//  Copyright © 2017年 HM. All rights reserved.
//

#import "WebviewProgressLine.h"

@implementation WebviewProgressLine

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.hidden = YES;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)setLineColor:(UIColor *)lineColor{
    _lineColor = lineColor;
    self.backgroundColor = lineColor;
}

-(void)startLoadingAnimation{
    self.hidden = NO;
    self.width = 0.0;
    self.hidden = NO;

    __weak UIView *weakSelf = self;
    [UIView animateWithDuration:0.4 animations:^{
        weakSelf.width = kDeviceWidth * 0.4;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 animations:^{
            weakSelf.width = kDeviceWidth * 0.8;
        }];
    }];
    
    
}

-(void)endLoadingAnimation{
    __weak UIView *weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.width = kDeviceWidth;
    } completion:^(BOOL finished) {
        weakSelf.hidden = YES;
    }];
}

@end

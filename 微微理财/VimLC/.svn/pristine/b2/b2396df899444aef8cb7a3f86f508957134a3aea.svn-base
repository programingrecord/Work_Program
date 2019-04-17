//
//  TextFiledRightView.m
//  WTJR
//
//  Created by HM on 16/6/1.
//  Copyright © 2016年 HM. All rights reserved.
//

#import "TextFiledRightView.h"

@implementation TextFiledRightView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame
{
    self= [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
    
}
- (void)initUI{
    _RightImageView = [[UIImageView alloc] init];
    _RightImageView.frame = CGRectMake(60, 0, 80, 40);
    [self addSubview:_RightImageView];
    
    _Rightbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    _Rightbutton.frame = CGRectMake(0, 5, 60, 30);
    [_Rightbutton setTitle:@"点击刷新" forState:UIControlStateNormal];
    _Rightbutton.titleLabel.font = TEXTFONT(12.0);
    [_Rightbutton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_Rightbutton setBackgroundColor:[UIColor clearColor]];
    [self addSubview:_Rightbutton];

}

@end

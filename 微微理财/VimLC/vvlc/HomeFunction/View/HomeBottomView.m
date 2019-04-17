//
//  HomeBottomView.m
//  SmallCat
//
//  Created by H on 2017/5/23.
//  Copyright © 2017年 HM. All rights reserved.
//

#import "HomeBottomView.h"

@implementation HomeBottomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
         imageNamed:(NSString *)imageNamed
              title:(NSString *)title
         titleValue:(NSString *)titleValue{
    self = [super initWithFrame:frame];

    if (self) {
        
        
        UIImageView *imagev = [[UIImageView alloc] init];
        imagev.bounds = CGRectMake(0, 0, 25, 25);
        imagev.center = CGPointMake(25, self.height/2);
        imagev.contentMode = UIViewContentModeScaleAspectFit;
        imagev.image = [UIImage imageNamed:imageNamed];
        [self addSubview:imagev];
                
        UILabel *lable1 = [[UILabel alloc] initWithFrame:CGRectMake(imagev.right+5,0, self.width-imagev.right-5, self.height)];
        lable1.text = title;
        lable1.numberOfLines = 0;
        lable1.textAlignment = NSTextAlignmentLeft;
        lable1.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
        lable1.textColor = [UIColor colorWithHex:0x9b9b9b];
        [self addSubview:lable1];
    }
    return self;
}

@end

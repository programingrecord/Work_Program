//
//  CenterItem.m
//  WTJR
//
//  Created by HM on 16/6/2.
//  Copyright © 2016年 HM. All rights reserved.
//

#import "CenterItem.h"

@implementation CenterItem

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame
         imageNamed:(NSString *)imageNamed
         rightImage:(NSString *)rightImage
              title:(NSString *)title
         titleValue:(NSString *)titleValue{
     self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor =[UIColor whiteColor];
        [self imageHander:imageNamed rightImage:rightImage];
        [self textHander:title titleValue:titleValue];
    }
    return self;
}

-(void)imageHander:(NSString *)imageNamed rightImage:(NSString *)rightimage{
    _imageView=[[UIImageView alloc]init ];
    _imageView.center = CGPointMake(30,self.height/2),
    _imageView.bounds = CGRectMake(0, 0, 24, 24);
    _imageView.image=[UIImage imageNamed:imageNamed];
    [self addSubview:_imageView];
    
    if (rightimage.length>0) {
        _tailIcon=[[UIImageView alloc]init ];
        _tailIcon.center = CGPointMake(self.width-20,self.height/2),
        _tailIcon.bounds = CGRectMake(0, 0, 7, 12);
        _tailIcon.image=[UIImage imageNamed:rightimage];
        [self addSubview:_tailIcon];
    }
}

-(void)textHander:(NSString *)title titleValue:(NSString *)titleValue{
    _titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(50,0, 100, self.height)];
    _titleLabel.text=title;
    _titleLabel.font=[UIFont systemFontOfSize:16.0f];
    _titleLabel.textColor= RGBA(51, 51, 51, 1);

    [self addSubview:_titleLabel];
    if (titleValue.length>0) {
        _titleValueLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.width-235,self.height/2-15, 200, 30)];
        _titleValueLabel.text=titleValue;
        _titleValueLabel.font=[UIFont systemFontOfSize:13.0f];
        _titleValueLabel.textAlignment=NSTextAlignmentRight;
        _titleValueLabel.textColor= RGBA(127, 127, 127, 1);
        [self addSubview:_titleValueLabel];
    }
}

@end

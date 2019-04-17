//
//  MSUCustomTF1.m
//  vvlc
//
//  Created by 007 on 2018/4/26.
//  Copyright © 2018年 HM. All rights reserved.
//

#import "MSUCustomTF1.h"

@implementation MSUCustomTF1

//控制placeHolder的位置，左右缩20
-(CGRect)placeholderRectForBounds:(CGRect)bounds {
    //return CGRectInset(bounds, 20, 0);
    if (self.tfType == MSUTypeRightDown) {
        CGRect inset = CGRectMake(bounds.origin.x+30, bounds.origin.y + 15, bounds.size.width, bounds.size.height);//更好理解些
        return inset;
    } else if (self.tfType == MSUTypeRight){
        CGRect inset = CGRectMake(bounds.origin.x+20, bounds.origin.y + 5, bounds.size.width, bounds.size.height);//更好理解些
        return inset;
    } else if (self.tfType == MSUNone20){
        CGRect inset = CGRectMake(bounds.origin.x+20, bounds.origin.y, bounds.size.width, bounds.size.height);//更好理解些
        return inset;
    } else{
        CGRect inset = CGRectMake(bounds.origin.x+30, bounds.origin.y, bounds.size.width, bounds.size.height);//更好理解些
        return inset;
    }
    
}
@end

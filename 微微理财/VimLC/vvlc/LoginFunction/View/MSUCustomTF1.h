//
//  MSUCustomTF1.h
//  vvlc
//
//  Created by 007 on 2018/4/26.
//  Copyright © 2018年 HM. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,MSUType){
    MSUNone30,
    MSUNone20,
    MSUTypeRight,
    MSUTypeRightDown,
};

@interface MSUCustomTF1 : UITextField

@property (nonatomic , assign) MSUType tfType;

@end


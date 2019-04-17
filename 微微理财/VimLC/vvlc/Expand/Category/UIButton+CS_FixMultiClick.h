//
//  UIButton+CS_FixMultiClick.h
//  WTJR
//
//  Created by H on 2017/4/17.
//  Copyright © 2017年 HM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (CS_FixMultiClick)

@property(nonatomic,assign)NSTimeInterval uxy_acceptEventInterval;//可以用这个给重复点击加间隔
@property (nonatomic, assign) BOOL isIgnoreEvent;

@end

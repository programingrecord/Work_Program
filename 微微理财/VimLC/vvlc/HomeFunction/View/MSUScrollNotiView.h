//
//  MSUScrollNotiView.h
//  vvlc
//
//  Created by 007 on 2018/1/11.
//  Copyright © 2018年 HM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSUScrollNotiView : UIView

@property (nonatomic , strong) SDCycleScrollView *scrollView;

@property (nonatomic , strong) NSArray *textArr;
@property (nonatomic , strong) NSArray *tradeArr;


- (instancetype)initWithFrame:(CGRect)frame sign:(NSInteger)sign;

@end

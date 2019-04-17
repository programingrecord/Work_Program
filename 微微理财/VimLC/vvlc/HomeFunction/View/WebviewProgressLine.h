//
//  WebviewProgressLine.h
//  CollectShelling
//
//  Created by HM on 2017/8/21.
//  Copyright © 2017年 HM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebviewProgressLine : UIView

@property (nonatomic,strong) UIColor  *lineColor;

//开始加载
-(void)startLoadingAnimation;

//结束加载
-(void)endLoadingAnimation;

@end

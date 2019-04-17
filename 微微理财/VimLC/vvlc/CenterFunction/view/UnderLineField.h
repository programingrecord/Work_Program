//
//  UnderLineField.h
//  CollectShelling
//
//  Created by HM on 2017/5/16.
//  Copyright © 2017年 HM. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MSUTextFieldDelegate <NSObject>

- (void)deleteBtnClick:(UITextField *)textField;

@end

@interface UnderLineField : UITextField

@property (nonatomic , weak) id<MSUTextFieldDelegate> msudelegate;


@end

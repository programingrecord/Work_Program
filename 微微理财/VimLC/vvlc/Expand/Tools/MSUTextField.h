//
//  MSUTextField.h
//  XiuBei
//
//  Created by Zhuge_Su on 2017/8/25.
//  Copyright © 2017年 Zhuge_Su. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MSUTextFieldDelegate <NSObject>

- (void)deleteBtnClick:(UITextField *)textField;

@end

@interface MSUTextField : UITextField

@property (nonatomic , weak) id<MSUTextFieldDelegate> delegate;


@end

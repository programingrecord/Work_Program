//
//  MSUPwdView.h
//  vvlc
//
//  Created by 007 on 2018/4/26.
//  Copyright © 2018年 HM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSUTextField.h"

@interface MSUPwdView : UIView

@property (nonatomic , strong) MSUTextField *pwdTF;

@property (nonatomic , strong) NSMutableArray *pwdArr;

@property (nonatomic , strong) UIButton *closeBtn;

@end

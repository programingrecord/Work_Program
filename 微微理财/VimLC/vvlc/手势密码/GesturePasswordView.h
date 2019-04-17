//
//  GesturePasswordView.h
//  GesturePassword
//
//  Created by hb on 14-8-23.
//  Copyright (c) 2014年 黑と白の印记. All rights reserved.
//

@protocol GesturePasswordDelegate <NSObject>

- (void)useUMLogin;
- (void)handBackTaped;
- (void)passBtnClick;

@end

#import <UIKit/UIKit.h>
#import "TentacleView.h"

@interface GesturePasswordView : UIView<TouchBeginDelegate>

@property (nonatomic,strong) TentacleView * tentacleView;

@property (nonatomic,strong) UILabel * state;

@property (nonatomic,assign) id<GesturePasswordDelegate> gesturePasswordDelegate;

@property (nonatomic,strong) UILabel * nameLable;

@property (nonatomic,strong) UIButton * forgetButton;
@property (nonatomic,strong) UIButton * useOtherButton;
@property (nonatomic,strong) UIButton * passButton;

@property (nonatomic,strong) UIView *headNavview ;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIButton *backbtn;



@property (nonatomic,strong) UILabel *Daylable;
@property (nonatomic,strong) UILabel *Monthlable;

@property (nonatomic,strong) UILabel *Tiplable;






@end

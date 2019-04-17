//
//  GesturePasswordController.h
//  GesturePassword
//
//  Created by hb on 14-8-23.
//  Copyright (c) 2014年 黑と白の印记. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "TentacleView.h"
#import "GesturePasswordView.h"

typedef NS_ENUM(NSInteger,GestureType){
    GestureSet,
    GestureVerify,
    GestureReSet,
    GestureDelete
};
@interface GesturePasswordController : UIViewController <VerificationDelegate,ResetDelegate,GesturePasswordDelegate>

@property (nonatomic,strong) GesturePasswordView * gesturePasswordView;

@property (nonatomic,strong) NSString *SaveToken;
@property (nonatomic,assign) GestureType gestureType;

@end

//
//  AddHudView.m
//  ClassmateUnion
//
//  Created by HM on 16/7/19.
//  Copyright © 2016年 zhonghaicheng. All rights reserved.
//

#import "AddHudView.h"
#import "MBProgressHUD.h"

@implementation AddHudView
+ (void)addProgressView:(UIView *)showView message:(NSString *)message AutoRemove:(BOOL)AutoRemove{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:showView animated:YES];
    hud.detailsLabelText = message;
    hud.detailsLabelFont = TEXTFONT(15);
    hud.removeFromSuperViewOnHide = YES;
    hud.mode = MBProgressHUDModeText;

    if (AutoRemove) {
        [hud hide:YES afterDelay:1.5];
    }
}

+ (void)addProgressView:(UIView *)showView message:(NSString *)message{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:showView animated:YES];
    hud.detailsLabelText = message;
    hud.detailsLabelFont = TEXTFONT(15);
//    hud.yOffset = kDeviceHeight/4;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    hud.mode = MBProgressHUDModeText;
    [hud hide:YES afterDelay:1.5];

}
+ (void)removeProgressView:(UIView *)showView{
    [MBProgressHUD hideHUDForView:showView animated:YES];
}



@end

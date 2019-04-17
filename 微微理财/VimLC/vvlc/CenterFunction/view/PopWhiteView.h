//
//  PopWhiteView.h
//  vvlc
//
//  Created by 慧明 on 2017/11/30.
//  Copyright © 2017年 HM. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PopWhiteViewBlock)(NSString *phoneCode);


@interface PopWhiteView : UIView

@property (nonatomic,copy) PopWhiteViewBlock ButtonBlock;


- (void)show;
- (void)hide;

@end

//
//  UpgradeView.h
//  vvlc
//
//  Created by 慧明 on 2017/12/21.
//  Copyright © 2017年 HM. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^UpgradeViewBlock)(void);

@interface UpgradeView : UIView

@property (nonatomic,copy) UpgradeViewBlock ButtonBlock;
@property (nonatomic, strong)   UILabel        *InfoLabel;
@property (strong, nonatomic)   UIButton      *CloseButton;
@property (nonatomic , strong) UIScrollView *scrollView;

- (void)show;
- (void)hide;

@end

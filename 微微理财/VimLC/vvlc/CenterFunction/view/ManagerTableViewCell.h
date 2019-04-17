//
//  ManagerTableViewCell.h
//  vvlc
//
//  Created by HM on 2017/7/25.
//  Copyright © 2017年 HM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ManagerTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UISwitch *CellSwitch;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWidth;
@property (weak, nonatomic) IBOutlet UILabel *leftTitle;
@property (weak, nonatomic) IBOutlet UILabel *rightTltle;
@property (weak, nonatomic) IBOutlet UIImageView *rightImage;
@property (weak, nonatomic) IBOutlet UIView *TopLineview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *BottomLineViewLeft;
@end

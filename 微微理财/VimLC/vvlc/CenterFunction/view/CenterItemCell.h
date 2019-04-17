//
//  CenterItemCell.h
//  WTJR
//
//  Created by HM on 16/6/2.
//  Copyright © 2016年 HM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CenterModel.h"
@interface CenterItemCell : UITableViewCell
@property (nonatomic,strong) CenterModel *model;

@property (weak, nonatomic) IBOutlet UIView *TopLineview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *BottomLineViewLeft;

@property (weak, nonatomic) IBOutlet UILabel *leftTitle;
@property (weak, nonatomic) IBOutlet UILabel *rightTltle;
@property (weak, nonatomic) IBOutlet UIImageView *leftImage;

@end

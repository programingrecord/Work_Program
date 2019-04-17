//
//  CouponTableViewCell.h
//  vvlc
//
//  Created by 慧明 on 2017/11/7.
//  Copyright © 2017年 HM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CouponModel.h"

@interface CouponTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *ColorView;
@property (weak, nonatomic) IBOutlet UILabel *AmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *TypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *BidAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *TipLabel;
@property (weak, nonatomic) IBOutlet UILabel *DateLabel;
@property (weak, nonatomic) IBOutlet UILabel *StateLabel;
@property (strong, nonatomic)  CouponModel *model;

@end

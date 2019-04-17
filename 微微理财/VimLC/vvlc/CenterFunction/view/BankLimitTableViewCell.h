//
//  BankLimitTableViewCell.h
//  vvlc
//
//  Created by 慧明 on 2017/10/31.
//  Copyright © 2017年 HM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BankLimitModel.h"
@interface BankLimitTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *TitleValueLabel;
@property (strong, nonatomic) BankLimitModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *BankImage;

@end

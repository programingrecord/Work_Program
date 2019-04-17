//
//  InviteListTableViewCell.h
//  vvlc
//
//  Created by 慧明 on 2017/12/18.
//  Copyright © 2017年 HM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InviteListModel.h"

@interface InviteListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *LeftLabel;
@property (weak, nonatomic) IBOutlet UILabel *MinLabel;
@property (weak, nonatomic) IBOutlet UILabel *RightLabel;

@property (nonatomic,strong)InviteListModel *model;
@end

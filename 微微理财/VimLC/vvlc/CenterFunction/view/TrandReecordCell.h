//
//  TrandReecordCell.h
//  WTJR
//
//  Created by HM on 16/6/6.
//  Copyright © 2016年 HM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrandRecordModel.h"
@interface TrandReecordCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *TradeType;
@property (weak, nonatomic) IBOutlet UILabel *TradeDate;
@property (weak, nonatomic) IBOutlet UILabel *TradeAmount;
@property (weak, nonatomic) IBOutlet UILabel *TradeState;

@property (nonatomic,strong) TrandRecordModel *model;
@property (nonatomic , copy) NSString *titStr;

@end

//
//  TradeTypeViewController.h
//  SmallCat
//
//  Created by H on 2017/5/4.
//  Copyright © 2017年 HM. All rights reserved.
//

#import "BaseViewController.h"
#import "TradeRecordViewController.h"


typedef void(^CellClickBlock)(TrandeRecordType type , NSString *Title);


@interface TradeTypeViewController : BaseViewController

@property (nonatomic,copy) CellClickBlock Block;

@end

//
//  MSUMyBidController.h
//  vvlc
//
//  Created by 007 on 2018/4/24.
//  Copyright © 2018年 HM. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, MSUReceiptType) {
    MSUReceiptTypeCollect = 0,                         // no button type
    MSUReceiptTypeAlready,
};

@interface MSUMyBidController : BaseViewController

@property (nonatomic,assign) MSUReceiptType receiptType;


@end

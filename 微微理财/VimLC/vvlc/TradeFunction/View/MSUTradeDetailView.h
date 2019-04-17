//
//  MSUTradeDetailView.h
//  vvlc
//
//  Created by 007 on 2018/1/15.
//  Copyright © 2018年 HM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSUProgramDetailView.h"

typedef void(^selectIndexBlock)(NSString *signStr,NSInteger isEmpty);
typedef void(^questionViewHeight)(NSInteger aheight);

@interface MSUTradeDetailView : UIView

@property (nonatomic , strong) NSMutableArray *btnArr;
@property (nonatomic , strong) UIView *lineView;

@property (nonatomic , strong) NSArray *dataArr;
@property (nonatomic , strong) NSArray *dateArr;
@property (nonatomic , strong) NSArray *imaArr;

@property (nonatomic , strong) NSArray *recordArr;
@property (nonatomic , strong) NSArray *planArr;

@property (nonatomic , strong) NSDictionary *dataDic;

@property (nonatomic , strong) MSUProgramDetailView *programView;

@property (nonatomic , copy) selectIndexBlock indexBlock;
@property (nonatomic , copy) questionViewHeight heightBlock;


@end

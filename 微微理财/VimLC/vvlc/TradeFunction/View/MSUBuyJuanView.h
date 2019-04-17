//
//  MSUBuyJuanView.h
//  vvlc
//
//  Created by 007 on 2018/1/12.
//  Copyright © 2018年 HM. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MSUBuyJuanViewDelegate <NSObject>

-  (void)cellDidSelectWithDic:(NSDictionary *)dataDic;

@end

@interface MSUBuyJuanView : UIView

@property (nonatomic , weak) id<MSUBuyJuanViewDelegate> delegate;
@property (nonatomic , strong) UIButton *noUseABtn;
@property (nonatomic , strong) UILabel *centerLab;
@property (nonatomic , strong) UIButton *useABtn;
@property (nonatomic , strong) UIView *slideView;

@property (nonatomic,strong) NSMutableArray *dataArr;

@property (nonatomic , assign) NSInteger  priceNum;
@property (nonatomic , strong) UITableView *tableView;

@end

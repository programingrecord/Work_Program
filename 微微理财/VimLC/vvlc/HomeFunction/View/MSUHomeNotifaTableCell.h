//
//  MSUHomeNotifaTableCell.h
//  vvlc
//
//  Created by 007 on 2018/1/16.
//  Copyright © 2018年 HM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface MSUHomeNotifaTableCell : UITableViewCell

@property (nonatomic , copy) void(^bgViewHeightBlck)(CGFloat height);

@property (nonatomic , strong) UIView *bgView;

@property (nonatomic , strong) UILabel *titLab;

@property (nonatomic , strong) UILabel *dateLab;

@property (nonatomic , strong) UILabel *contentLab;
@property (nonatomic , strong) UIView *contentLineView;

@property (nonatomic , strong) NSDictionary *dataDic;
@property (nonatomic , assign) NSInteger signIndex;

@property (nonatomic , assign) NSInteger signView; // 0是喇叭页  1是首页

@end

//
//  MSUNotiDetailController.m
//  vvlc
//
//  Created by 007 on 2018/6/26.
//  Copyright © 2018年 HM. All rights reserved.
//

#import "MSUNotiDetailController.h"

#import "MSUHomeNotifaTableCell.h"

#import "MSUStringTools.h"

@interface MSUNotiDetailController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) UITableView *tableView;

@property (nonatomic , assign) NSInteger cellHeight;

@end

@implementation MSUNotiDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"消息";
    self.view.backgroundColor = HEXCOLOR(0xe8e8e8);
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-64) style:UITableViewStylePlain];
    _tableView.backgroundColor = BGWhiteColor;
    _tableView.scrollEnabled = YES;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.scrollEnabled = NO;
    [self.view addSubview:_tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.panGestureRecognizer.delaysTouchesBegan = self.tableView.delaysContentTouches;
    [_tableView registerClass:[MSUHomeNotifaTableCell class] forCellReuseIdentifier:@"MSUHomeNotifaTableCell"];
    if (iOS11) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.cellHeight > 0) {
        return self.cellHeight;
    } else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MSUHomeNotifaTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MSUHomeNotifaTableCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = BGWhiteColor;
    
    cell.bgViewHeightBlck = ^(CGFloat height) {
        self.cellHeight = height + 17*kDeviceHeightScale;
    };
    
    cell.signView = self.signView;
    cell.signIndex = 1;
    cell.dataDic = self.dataDic;
    
    return cell;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

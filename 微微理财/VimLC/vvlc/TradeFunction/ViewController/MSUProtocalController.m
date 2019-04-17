//
//  MSUProtocalController.m
//  vvlc
//
//  Created by 007 on 2018/6/5.
//  Copyright © 2018年 HM. All rights reserved.
//

#import "MSUProtocalController.h"
#import "WebViewController.h"
#import "MSUImageShowController.h"

#import "MSUProtocalCell.h"

@interface MSUProtocalController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) UITableView *tableView;

@end

@implementation MSUProtocalController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"借款协议";
    self.view.backgroundColor = HEXCOLOR(0xf3f3f3);
    
    
    [self createSubView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createSubView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 1, kDeviceWidth, kDeviceHeight) style:UITableViewStylePlain];
    _tableView.backgroundColor = HEXCOLOR(0xf3f3f3);
    _tableView.scrollEnabled = YES;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.panGestureRecognizer.delaysTouchesBegan = self.tableView.delaysContentTouches;
    _tableView.rowHeight = 50*kDeviceHeightScale;
    [_tableView registerClass:[MSUProtocalCell class] forCellReuseIdentifier:@"msuUITableViewCell"];
    if (iOS11) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count > 0 ?self.dataArr.count:1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MSUProtocalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"msuUITableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.titLab.text = [NSString stringWithFormat:@"合同%ld",indexPath.row+1];

//    cell.timeLab.text = @"2016-07-05";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    WebViewController *webVC = [[WebViewController alloc] init];
//    webVC.title = @"借款协议";
//    webVC.hidesBottomBarWhenPushed = YES;
//    webVC.UrlString = [NSString stringWithFormat:@"%@",self.dataArr[indexPath.row]];
//    [self.navigationController pushViewController:webVC animated:YES];
    

    
    MSUImageShowController *show = [[MSUImageShowController alloc] init];
    show.imaArr = self.dataArr[indexPath.row];
    show.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:show animated:YES];
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

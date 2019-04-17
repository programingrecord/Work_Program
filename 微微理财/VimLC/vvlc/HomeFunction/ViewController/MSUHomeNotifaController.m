//
//  MSUHomeNotifaController.m
//  vvlc
//
//  Created by 007 on 2018/1/16.
//  Copyright © 2018年 HM. All rights reserved.
//

#import "MSUHomeNotifaController.h"
#import "WebViewController.h"
#import "MSUNotiDetailController.h"

#import "MSUHomeNotifaTableCell.h"

#import "MSUStringTools.h"

@interface MSUHomeNotifaController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , strong) NSMutableArray *dataArr;

@property (nonatomic , assign) NSInteger cellHeight;
@property (nonatomic , assign) NSInteger currentIndex;


@end

@implementation MSUHomeNotifaController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"消息";
    self.view.backgroundColor = BGWhiteColor;
    
    self.dataArr = [NSMutableArray array];
    self.currentIndex = 1;

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-64) style:UITableViewStylePlain];
    _tableView.backgroundColor = BGWhiteColor;
    _tableView.scrollEnabled = YES;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    _tableView.emptyDataSetSource = self;
    _tableView.emptyDataSetDelegate = self;
    self.tableView.panGestureRecognizer.delaysTouchesBegan = self.tableView.delaysContentTouches;
    [_tableView registerClass:[MSUHomeNotifaTableCell class] forCellReuseIdentifier:@"MSUHomeNotifaTableCell"];
    if (iOS11) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    __weak typeof(self) weakSelf= self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong typeof(self) strongSelf= weakSelf;
        strongSelf.currentIndex = 1;
        [strongSelf getList:YES withIndex:strongSelf.currentIndex ishead:YES];
    }];
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        __strong typeof(self) strongSelf= weakSelf;
        [strongSelf getList:YES withIndex:strongSelf.currentIndex ishead:NO];
    }];
    [self getList:NO withIndex:self.currentIndex ishead:YES];
    
    [CoreArchive isHasRecieveNoti:NO];
}

#pragma mark - 获取数据
-(void)getList:(BOOL )isrefresh withIndex:(NSInteger)index ishead:(BOOL) ishead{
    NSString *url = @"LunaP2pAppAnnouceMessageListServlet";
    
    if (!isrefresh) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:[NSString stringWithFormat:@"%ld",(long)self.currentIndex] forKey:@"index"];
    
    [[DataRequestServer getDataRequestServerData] request:url parameters:param result:^(id result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (isrefresh) {
            if (ishead) {
                [_tableView.mj_header endRefreshing];
            }else{
                [_tableView.mj_footer endRefreshing];
            }
        }
        
        if ([result isKindOfClass:[NSString class]] &&  [result isEqualToString:@"44"]) {
            [AddHudView addProgressView:self.view message:@"网络错误，请稍后再试"];
        }else{
            int t = [[result objectForKey:@"success"] intValue];
            NSString *error=[result objectForKey:@"errorlog"];
            
            NSString *pageCount=[result objectForKey:@"pageCount"];
            if (self.currentIndex >= pageCount.integerValue) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.tableView.mj_footer resetNoMoreData];
            }
            
            if(t==1 && [error isEqualToString:@""]){
                if (ishead) {
                    if (self.dataArr.count>0) {
                        [self.dataArr removeAllObjects];
                    }
                }
                
                [_dataArr addObjectsFromArray:result[@"notiArr"]];
      
                [self.tableView reloadData];
                self.currentIndex++;
            }
        }
    }];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
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
    
    NSDictionary *dic = _dataArr[indexPath.row];
    cell.dataDic = dic;

    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = _dataArr[indexPath.row];
    NSString *str = dic[@"linkUrl"];
    if (str.length > 0) {
        WebViewController *webVC = [[WebViewController alloc] init];
        webVC.UrlString = str;
        webVC.title = @"消息";
        webVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webVC animated:YES];
    } else{
        MSUNotiDetailController *detail = [[MSUNotiDetailController alloc] init];
        detail.signView = 0;
        detail.dataDic = dic;
        detail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detail animated:YES];
    }
}


- (BOOL)emptyDataSetShouldBeForcedToDisplay:(UIScrollView *)scrollView{
    return NO;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
    return kDeviceWidth/4+28;
}

-(UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    return [UIImage imageNamed:@""];
}

-(NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *text = nil;
    UIFont *font = nil;
    UIColor *textColor = nil;
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    text = @"";
    font = [UIFont systemFontOfSize:13];
    textColor = [UIColor colorWithHex:0x333333];
    
    if (!text) {
        return nil;
    }
    if (font) {
        [attributes setObject:font forKey:NSFontAttributeName];
    }
    if (textColor) {
        [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    }
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView{
    return  YES;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view{
    [self.tableView.mj_header beginRefreshing];
}

@end

//
//  MSUFindController.m
//  vvlc
//
//  Created by 007 on 2018/1/12.
//  Copyright © 2018年 HM. All rights reserved.
//

#import "MSUFindController.h"
#import "WebViewController.h"

#import "MSUFindTableCell.h"


@interface MSUFindController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic,assign) NSInteger      currentIndex;
@property (nonatomic , strong) NSMutableArray *dataArr;


@end

@implementation MSUFindController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"发现";
    for (UIBarButtonItem *items in self.navigationItem.leftBarButtonItems) {
        items.customView.hidden = YES;
    }
    
    self.view.backgroundColor = BGWhiteColor;
    
    self.currentIndex = 1;
    [self afnRequestDataWithPrama:self.currentIndex isRefresh:NO ishead:YES];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-49-64) style:UITableViewStylePlain];
    if (is_iPhoneX) {
        self.tableView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-49-64-50);
    }
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
    _tableView.rowHeight = 215.8*kDeviceHeightScale;
    [_tableView registerClass:[MSUFindTableCell class] forCellReuseIdentifier:@"MSUFindTableCell"];
    if (iOS11) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.dataArr = [[NSMutableArray alloc] init];

    __weak typeof(self) weakSelf = self;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.currentIndex = 1;
        [strongSelf afnRequestDataWithPrama:self.currentIndex isRefresh:YES ishead:YES];
    }];
    
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf afnRequestDataWithPrama:self.currentIndex isRefresh:YES ishead:NO];
    }];
}

#pragma - 请求数据
- (void)afnRequestDataWithPrama:(NSInteger)index isRefresh:(BOOL)isRefresh ishead:(BOOL)ishead{
    NSString *url = @"LunaP2pAppActivityRunServlet";
    if (!isRefresh) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:[NSString stringWithFormat:@"%ld",(long)self.currentIndex] forKey:@"index"];
    
    [[DataRequestServer getDataRequestServerData] request:url parameters:param result:^(id result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (isRefresh) {
            if (ishead) {
                [_tableView.mj_header endRefreshing];
            }else{
                [_tableView.mj_footer endRefreshing];
            }
        }
        
        if ([result isKindOfClass:[NSString class]] &&  [result isEqualToString:@"44"]) {
            [PAProgressView showInView:self.view contentString:@"网络错误，请稍后再试"];
            NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"listHistory"];
            if (dic) {
                [self reloadUIWithResultDic:dic ishead:ishead];
            } else{
                NSString *filePath = [[NSBundle mainBundle] pathForResource:@"history" ofType:@"plist"];
                NSMutableArray *data1 = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
                NSDictionary *dic1 = data1[2];
                [self reloadUIWithResultDic:dic1 ishead:YES];
            }

        }else{
           
            [self reloadUIWithResultDic:result ishead:ishead];
        }
    }];
}

- (void)reloadUIWithResultDic:(NSDictionary *)result ishead:(BOOL)ishead{
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
        
        [self.dataArr addObjectsFromArray:[result objectForKey:@"activityRuns"]];
        
        [self.tableView reloadData];
        self.currentIndex++;
    }
}

#pragma - 代理相关
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MSUFindTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MSUFindTableCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    NSDictionary *dic = _dataArr[indexPath.row];
    cell.dataDic = dic;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = _dataArr[indexPath.row];
    WebViewController *webVC = [[WebViewController alloc] init];
    webVC.UrlString = dic[@"address"];
    webVC.title = dic[@"Title"];
    webVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webVC animated:YES];
}

-(UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    return [UIImage imageNamed:@"Date_Empty"];
}

-(NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *text = nil;
    UIFont *font = nil;
    UIColor *textColor = nil;
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    
    text = @"暂无数据";
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

//
//  MSUFooterListController.m
//  vvlc
//
//  Created by 007 on 2018/5/28.
//  Copyright © 2018年 HM. All rights reserved.
//

#import "MSUFooterListController.h"

#import "MSUTradeTableCell.h"

@interface MSUFooterListController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic,assign) NSInteger      currentIndex;
@property (nonatomic , strong) NSMutableArray *dataArr;

@end

@implementation MSUFooterListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = HEXCOLOR(0xe8e8e8);
    self.dataArr = [NSMutableArray array];
    self.currentIndex = 1;
    [self createCenterView];
    [self getList:NO withIndex:self.currentIndex ishead:YES];

    
}

- (void)createCenterView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, kDeviceWidth, kDeviceHeight-64) style:UITableViewStylePlain];
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
    _tableView.rowHeight = 130*kDeviceHeightScale;
    //    [_tableView registerClass:[MSUHotTableCell class] forCellReuseIdentifier:@"hotVideoCell"];
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)extracted:(BOOL)ishead isrefresh:(BOOL)isrefresh param:(NSMutableDictionary *)param url:(NSString *)url {
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
            [PAProgressView showInView:self.view contentString:@"网络错误，请稍后再试"];
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
                
                [self.dataArr addObjectsFromArray:[result objectForKey:@"mainShowArr"]];
                
                [self.tableView reloadData];
                self.currentIndex++;
            }
        }
    }];
}

-(void)getList:(BOOL )isrefresh withIndex:(NSInteger)index ishead:(BOOL) ishead{
    NSString *url = @"LunaP2pAppBidBorrowClassifyServlet";
    
    if (!isrefresh) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:[NSString stringWithFormat:@"%ld",(long)self.currentIndex] forKey:@"index"];
    if ([self.title isEqualToString:@"募集完成"]) {
        [param setObject:@"26" forKey:@"borrowStateInt"];
    } else{
        [param setObject:@"27" forKey:@"borrowStateInt"];
    }
    
    [self extracted:ishead isrefresh:isrefresh param:param url:url];
}

#pragma amrk - 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MSUTradeTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MSUHomeTableCellA"];
    cell.backgroundColor = HEXCOLOR(0xe8e8e8);
    if (!cell)
    {
        cell = [[MSUTradeTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MSUHomeTableCellA"];
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.bgImageView.hidden = YES;
    cell.dataDic = self.dataArr[indexPath.row];

    
    return cell;
}

-(UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"Date_Empty"];
}

-(NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
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


- (void)LeftNavigationButtonClick:(UIButton *)leftbtn{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end

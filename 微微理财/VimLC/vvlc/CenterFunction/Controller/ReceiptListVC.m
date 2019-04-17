//
//  ReceiptListVC.m
//  WTJR
//
//  Created by H on 16/6/18.
//  Copyright © 2016年 HM. All rights reserved.
//

#import "ReceiptListVC.h"
#import "ReceiptCell.h"
#import "LoginViewController.h"
#import "ReceiptModel.h"
@interface ReceiptListVC ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
{
    UITableView *ReceiptListTable;
    NSMutableArray *dataArr;
    NSInteger pageIndex;
    UIButton *CollectButton;//代收
    UIButton *AlreadyButton;//已收
}

@property (strong, nonatomic) UIView        *slideView;
@property (nonatomic,strong) UIView         *topMainView;
@property (strong, nonatomic) UIButton      *SelectButton;
@property (nonatomic,strong) NSArray        *headTitle;

@end

@implementation ReceiptListVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"回款查询";
    self.headTitle = @[@"待收",@"已收"];
    [self.view addSubview: self.topMainView];
    [self.topMainView addSubview: self.slideView];

    pageIndex=1;
//    self.view.backgroundColor = [UIColor colorWithHex:0xF5F5F9];
    dataArr = [[NSMutableArray alloc] init];
    [self addUI];
    [self requestData:NO ishead:NO index:pageIndex];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 页面初始化
- (void)addUI{
    ReceiptListTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, kDeviceWidth, kDeviceHeight-kNavigationBarHeight-kStatusBarHeight-40) style:UITableViewStylePlain];
    ReceiptListTable.backgroundColor = [UIColor clearColor];
    ReceiptListTable.delegate = self;
    ReceiptListTable.dataSource = self;
    ReceiptListTable.emptyDataSetSource = self;
    ReceiptListTable.emptyDataSetDelegate = self;
    ReceiptListTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:ReceiptListTable];
    
    ReceiptListTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pageIndex = 1;
        if (dataArr.count>0) {
            [dataArr removeAllObjects];
        }
        [self requestData:YES ishead:YES index:pageIndex];
    }];
    
    ReceiptListTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        pageIndex++;
        [self requestData:YES ishead:NO index:pageIndex];
    }];
}

- (UIView *)topMainView{
    if (!_topMainView) {
        CGFloat width =kDeviceWidth / self.headTitle.count;
        _topMainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,kDeviceWidth, 40)];
        _topMainView.backgroundColor = [UIColor whiteColor];
        for (int i =0 ; i<self.headTitle.count; i++) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(width*i,0 , width, 40)];
            button.tag = ReceiptTypeCollect +i;
            NSString *string = self.headTitle[i];
            NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:string];
            [attriString addAttribute:NSForegroundColorAttributeName value:RGBA(51, 51, 51, 1) range:NSMakeRange(0, string.length)];
            [attriString addAttribute:NSFontAttributeName value:TEXTFONT(12) range:NSMakeRange(0,string.length)];
            [button setAttributedTitle:attriString forState:UIControlStateNormal];
            
            NSMutableAttributedString *sel_attriString = [[NSMutableAttributedString alloc] initWithString:string];
            [sel_attriString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0xFB6337] range:NSMakeRange(0, string.length)];
            [sel_attriString addAttribute:NSFontAttributeName value:TEXTFONT(13) range:NSMakeRange(0,string.length)];
            [button setAttributedTitle:sel_attriString forState:UIControlStateSelected];
            if (i == 0) {
                button.selected = YES;
                self.SelectButton = button;
                self.receiptType = ReceiptTypeCollect;
            }else{
                button.selected = NO;
            }
            [button addTarget:self action:@selector(tabButton:) forControlEvents:UIControlEventTouchUpInside];
            [_topMainView addSubview:button];
        }
        UIView *LineView = [[UIView alloc] initWithFrame:CGRectMake(0, _topMainView.height-1, kDeviceWidth, 1)];
        LineView.backgroundColor = RGBA(222, 222, 222, 1);
        [_topMainView addSubview:LineView];
        
        UIView *LineView2 = [[UIView alloc] initWithFrame:CGRectMake(kDeviceWidth/2, 10, 1, 20)];
        LineView2.backgroundColor = RGBA(222, 222, 222, 1);
        [_topMainView addSubview:LineView2];
    }
    return _topMainView;
}

- (UIView *)slideView{
    if (!_slideView) {
        CGFloat width = kDeviceWidth / self.headTitle.count;
        _slideView = [[UIView alloc] initWithFrame:CGRectMake(width/2-30, 40-2, 60, 2)];
        [_slideView setBackgroundColor:[UIColor colorWithHex:0xFB6337]];
    }
    return _slideView;
}

#pragma mark - 点击事件
-(void)tabButton:(id)sender{
    UIButton *button = sender;
    self.receiptType = button.tag;
    if (self.SelectButton!= button) {
        self.SelectButton.selected = NO;
        button.selected = YES;
        CGFloat width = kDeviceWidth / self.headTitle.count;
        [UIView animateWithDuration:0.3 animations:^{
            [self.slideView setFrame:CGRectMake(width*(button.tag) +width/2-30,38, 60, 2)];
        }];
        self.SelectButton = button;
        pageIndex = 1;
        if (dataArr.count >0) {
            [dataArr removeAllObjects];
        }
        [ReceiptListTable reloadData];
        [self requestData:NO ishead:YES index:pageIndex];
    }
}

- (void)headButtonClick:(UIButton *)sender{
    if (dataArr.count >0) {
        [dataArr removeAllObjects];
    }
    pageIndex = 1;
    if (sender == CollectButton) {
        CollectButton.selected = YES;
        AlreadyButton.selected = NO;
        self.receiptType = ReceiptTypeCollect;
        
    }else{
        CollectButton.selected = NO;
        AlreadyButton.selected = YES;
        self.receiptType = ReceiptTypeAlready;
    }
    
    [self requestData:YES ishead:YES index:pageIndex];
}

#pragma mark - 数据请求
-(void)requestData:(BOOL )isrefresh ishead:(BOOL)ishead index:(NSInteger) index
{
    if (!isrefresh) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    if (self.receiptType == ReceiptTypeCollect) {
        [dic setObject:@"1" forKey:@"state"];
    }else{
        [dic setObject:@"2" forKey:@"state"];
    }
    [dic setObject:[NSString stringWithFormat:@"%ld",(long)index] forKey:@"index"];
    [[DataRequestServer getDataRequestServerData] request:@"LunaP2pAppReceiptListServlet" parameters:dic result:^(id result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        if (isrefresh) {
            if (ishead) {
                [ReceiptListTable.mj_header endRefreshing];
            }else{
                [ReceiptListTable.mj_footer endRefreshing];
            }
        }

        if ([result isKindOfClass:[NSString class]] &&  [result isEqualToString:@"44"]) {
            [AddHudView addProgressView:self.view message:@"网络错误，请稍后再试"];
        }else{
            int success = [[result objectForKey:@"success"]intValue];

            if (success==0 && [[result objectForKey:@"errorlog"]isEqualToString:@"noLogin"]) {
                [self requestLogin];
            }else if (success==1 && [[result objectForKey:@"errorlog"]isEqualToString:@""]){
                NSString *pageCount=[result objectForKey:@"pageCount"];
                if (pageIndex >= pageCount.integerValue) {
                    [ReceiptListTable.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [ReceiptListTable.mj_footer resetNoMoreData];
                }
                
                if (ishead) {
                    if (dataArr.count>0) {
                        [dataArr removeAllObjects];
                    }
                }
                NSArray *arr =[result objectForKey:@"items"];
                for (NSDictionary *dic in arr) {
                    ReceiptModel *model = [[ReceiptModel alloc] initWithContent:dic];
                    [dataArr addObject:model];
                }
                [ReceiptListTable reloadData];
            }else{
                [AddHudView addProgressView:self.view message:@"获取回款数据失败，请重新获取"];
            }
        }
    }];
}

- (void)requestLogin{
    [[DataRequestServer getDataRequestServerData] requestLoginresult:^(NSString *LoginState) {
        if ([LoginState isEqualToString:@"true"]) {
            pageIndex = 1;
            [self requestData:YES ishead:YES index:pageIndex];
        }else{
            [AddHudView addProgressView:self.view message:@"登录失效，请重新登录"];
            double delayInSeconds = 1.0;
            __block ReceiptListVC* BlockVC = self;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                LoginViewController *loginVc= [[LoginViewController alloc] init];
                loginVc.loginType = logintypeOutTime;
                loginVc.hidesBottomBarWhenPushed = YES;
                
                [BlockVC.navigationController pushViewController:loginVc animated:YES];
            });
        }
    }];
}

#pragma mark - 代理
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ReceiptCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ReceiptCell"];
    if (!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"ReceiptCell" bundle:nil] forCellReuseIdentifier:@"ReceiptCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"ReceiptCell"];
    }
    if (dataArr.count>=indexPath.row) {
        cell.receiptModel = [dataArr objectAtIndex:indexPath.row];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
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
    [ReceiptListTable.mj_header beginRefreshing];
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

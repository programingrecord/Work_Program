//
//  MSUMyBidController.m
//  vvlc
//
//  Created by 007 on 2018/4/24.
//  Copyright © 2018年 HM. All rights reserved.
//

#import "MSUMyBidController.h"
#import "MSURepaymentPlanController.h"
#import "WebViewController.h"
#import "MSUProtocalController.h"

#import "ReceiptCell.h"
#import "LoginViewController.h"
#import "ReceiptModel.h"
#import "MyBidModel.h"

#import "MSUTradeReeeTableCell.h"

@interface MSUMyBidController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
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
@property (nonatomic , assign) NSInteger cellHeight;
@property (nonatomic , copy) NSString *yqbHiden;

@end

@implementation MSUMyBidController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"投资记录";
    
    UIView *lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(0, 0, kDeviceWidth, 1);
    lineView.backgroundColor = HEXCOLOR(0xE8E8E8);
    [self.view addSubview:lineView];
    
    self.headTitle = @[@"持有中",@"已完成"];
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
    if (is_iPhoneX) {
        ReceiptListTable.frame = CGRectMake(0, 40, kDeviceWidth, kDeviceHeight-kNavigationBarHeight-kStatusBarHeight-40-44);
    }
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
        _topMainView = [[UIView alloc] initWithFrame:CGRectMake(0, 1 ,kDeviceWidth, 40)];
        _topMainView.backgroundColor = [UIColor whiteColor];
        for (int i =0 ; i<self.headTitle.count; i++) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(width*i,0 , width, 40)];
            button.tag = MSUReceiptTypeCollect +i;
            NSString *string = self.headTitle[i];
            NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:string];
            [attriString addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0x717273) range:NSMakeRange(0, string.length)];
            [attriString addAttribute:NSFontAttributeName value:TEXTFONT(14) range:NSMakeRange(0,string.length)];
            [button setAttributedTitle:attriString forState:UIControlStateNormal];
            
            NSMutableAttributedString *sel_attriString = [[NSMutableAttributedString alloc] initWithString:string];
            [sel_attriString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0xFB6337] range:NSMakeRange(0, string.length)];
            [sel_attriString addAttribute:NSFontAttributeName value:TEXTFONT(16) range:NSMakeRange(0,string.length)];
            [button setAttributedTitle:sel_attriString forState:UIControlStateSelected];
            if (i == 0) {
                button.selected = YES;
                self.SelectButton = button;
                self.receiptType = MSUReceiptTypeCollect;
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
//        if (dataArr.count >0) {
//            [dataArr removeAllObjects];
//        }
//        [ReceiptListTable reloadData];
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
        self.receiptType = MSUReceiptTypeCollect;
        
    }else{
        CollectButton.selected = NO;
        AlreadyButton.selected = YES;
        self.receiptType = MSUReceiptTypeAlready;
    }
    
    [self requestData:YES ishead:YES index:pageIndex];
}

#pragma mark - 数据请求
-(void)requestData:(BOOL )isrefresh ishead:(BOOL)ishead index:(NSInteger) index
{
    
}

- (void)requestLogin{
    [[DataRequestServer getDataRequestServerData] requestLoginresult:^(NSString *LoginState) {
        if ([LoginState isEqualToString:@"true"]) {
            pageIndex = 1;
            [self requestData:YES ishead:YES index:pageIndex];
        }else{
            [AddHudView addProgressView:self.view message:@"登录失效，请重新登录"];
            double delayInSeconds = 1.0;
            __block MSUMyBidController* BlockVC = self;
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
    MSUTradeReeeTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ReceiptCell"];
    if (!cell)
    {
        [tableView registerClass:[MSUTradeReeeTableCell class] forCellReuseIdentifier:@"ReceiptCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"ReceiptCell"];

    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = HEXCOLOR(0xf3f3f3);
    
    if (dataArr.count>=indexPath.row) {
        MyBidModel *model =  [dataArr objectAtIndex:indexPath.row];
        cell.titLab.text = model.borrowTitle;
        cell.signLab.text = model.borrowState;
        cell.moneyLab.text = [NSString stringWithFormat:@"%@元",model.amount];
        cell.dateLab.text = model.createDate;
        cell.planView.hidden = NO;
        cell.bgViewa.frame = CGRectMake(10, 10*kDeviceHeightScale, kDeviceWidth-20, 165*kDeviceHeightScale);
        self.cellHeight = 175*kDeviceHeightScale;
//        if ([cell.signLab.text isEqualToString:@"招标中"]) {
//            cell.signLab.text = [NSString stringWithFormat:@"%@",@"还款中"];
//        }

        if ([cell.signLab.text isEqualToString:@"招标中"]) {
            cell.signLab.backgroundColor = [UIColor redColor];
            cell.planView.hidden = YES;
            cell.bgViewa.frame = CGRectMake(10, 10*kDeviceHeightScale, kDeviceWidth-20, 120*kDeviceHeightScale);
            self.cellHeight = 130*kDeviceHeightScale;
        } else if ([cell.signLab.text isEqualToString:@"还款中"]){
            cell.signLab.backgroundColor = HEXCOLOR(0xFF6339);
         
        } else {
            cell.signLab.backgroundColor = HEXCOLOR(0xC6C6C6);
            if (![cell.signLab.text isEqualToString:@"已还清"]) {
                cell.planView.hidden = YES;
                self.cellHeight = 130*kDeviceHeightScale;
                cell.bgViewa.frame = CGRectMake(10, 10*kDeviceHeightScale, kDeviceWidth-20, 120*kDeviceHeightScale);
            } else{
                
            }
        }
        
        if ([_yqbHiden isEqualToString:@"1"]) {
            cell.planBtn.hidden = YES;
            cell.protocalBtn.enabled = NO;
            [cell.protocalBtn setTitle:@"还款计划" forState:UIControlStateNormal];
        } else {
            __weak typeof(self) weakSelf = self;
            cell.proBlock = ^(UIButton *btn) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                if (model.dealOneJpgs.count == 0) {
                    [PAProgressView showInView:self.view  contentString:@"无借款协议"];
                } else {
                    //                WebViewController *webVC = [[WebViewController alloc] init];
                    //                webVC.title = @"借款协议";
                    //                webVC.hidesBottomBarWhenPushed = YES;
                    //                webVC.UrlString = model.dealOne;
                    //                [self.navigationController pushViewController:webVC animated:YES];
                    MSUProtocalController *po = [[MSUProtocalController alloc] init];
                    po.dataArr = model.dealOneJpgs;
                    po.hidesBottomBarWhenPushed = YES;
                    [strongSelf.navigationController pushViewController:po animated:YES];
                }
            };
        }
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.cellHeight ? self.cellHeight : 2;//123
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MyBidModel *model =  [dataArr objectAtIndex:indexPath.row];
    if ([model.borrowState isEqualToString:@"还款中"] || [model.borrowState isEqualToString:@"已还清"]) {
        MSURepaymentPlanController *planVC = [[MSURepaymentPlanController alloc] init];
        planVC.bridStr = model.brid;
        [self.navigationController pushViewController:planVC animated:YES];
    }
    
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

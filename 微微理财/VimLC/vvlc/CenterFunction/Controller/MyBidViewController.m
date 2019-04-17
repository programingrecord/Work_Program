//
//  MyBidViewController.m
//  WTJR
//
//  Created by H on 16/8/10.
//  Copyright © 2016年 HM. All rights reserved.
//

#import "MyBidViewController.h"
#import "LoginViewController.h"
#import "MyBidModel.h"
#import "MybidTableViewCell.h"
#import "CustomButton.h"
@interface MyBidViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *MybidListTable;
    NSMutableArray *dataArr;
    NSInteger pageIndex;
    CustomButton * CustomB;
    UIView *ChoiceViews;
    NSMutableArray *TypeList;
}

@property (nonatomic,strong) NSArray *TypeArr;
@property (nonatomic,strong) UITableView *TypeTableView;

@end

@implementation MyBidViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    pageIndex=1;
    [self RequestTradeDataWithType:self.BidType isrefresh:NO ishead:YES];
    self.title = @"我的投资";
    self.view.backgroundColor = RGBA(245, 245, 245, 1);
    dataArr = [[NSMutableArray alloc] init];
    [self addUI];
    [self addNavigationItemTitleView];
    [self addTypeTableView];
}

- (void)addTypeTableView{
    self.TypeArr = @[@"全部",@"招标中",@"已撤销",@"流标",@"还款中",@"已还清",@"已逾期",@"坏账"];
    
    self.TypeTableView  = [[UITableView alloc] initWithFrame:CGRectMake(kDeviceWidth, 0, 200, kDeviceHeight) style:UITableViewStylePlain];
    self.TypeTableView.delegate = self;
    self.TypeTableView.dataSource = self;
    self.TypeTableView.backgroundColor = [UIColor whiteColor];
    self.TypeTableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:self.TypeTableView];
}

- (void)addNavigationItemTitleView{
    UIButton *listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [listButton setTitleColor:[UIColor colorWithHex:0x666666] forState:UIControlStateNormal];
    [listButton setTitle:@"筛选" forState:UIControlStateNormal];
    listButton.titleLabel.font = TEXTFONT(14);
    listButton.frame = CGRectMake(0, 0, 40, 30);
    [listButton addTarget:self action:@selector(listButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:listButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)listButtonClick{
    [UIView animateWithDuration:0.5 animations:^{
        if (self.TypeTableView.origin.x >= kDeviceWidth) {
            self.TypeTableView.frame = CGRectMake(kDeviceWidth-200, 0,200, kDeviceHeight);
        }else{
            self.TypeTableView.frame = CGRectMake(kDeviceWidth, 0,200, kDeviceHeight);
        }
    }];
}

-(void)RequestTradeDataWithType:(MybidType )type isrefresh:(BOOL)isrefresh ishead:(BOOL)ishead
{
    NSString *typeNum;

    switch (type) {
        case MybidTypeTypeAll:
            typeNum = @"";
            break;
        case MybidTypeZhaoBiao:
            typeNum = @"23";
            break;
        case MybidTypeCancel:
            typeNum = @"24";
            break;
        case MybidTypeLiubiao:
            typeNum = @"25";
            break;
        case MybidTypeHuankuan:
            typeNum = @"26";
            break;
        case MybidTypeHuanQing:
            typeNum = @"27";
            break;
        case MybidTypeYuQi:
            typeNum = @"28";
            break;
        case MybidTypeBadBid:
            typeNum = @"29";
            break;
            
        default:
            break;
    }

    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    [dic setObject:[NSString stringWithFormat:@"%d",pageIndex] forKey:@"index"];
    [dic setObject:typeNum forKey:@"bstate"];

    [[DataRequestServer getDataRequestServerData] request:@"LunaP2pAppMyBidServlet" parameters:dic result:^(id result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isrefresh) {
            if (ishead) {
                [MybidListTable.mj_header endRefreshing];
            }else{
                [MybidListTable.mj_footer endRefreshing];
            }
        }
 
        if ([result isKindOfClass:[NSString class]] &&  [result isEqualToString:@"44"]) {
            [AddHudView addProgressView:self.view message:@"网络错误，请稍后再试"];
        }else{
            int success = [[result objectForKey:@"success"]intValue];
            
            if (success==0 && [[result objectForKey:@"errorlog"]isEqualToString:@"noLogin"]) {
                [self requestLogin];
            }else if (success==1 && [[result objectForKey:@"errorlog"]isEqualToString:@""]){
                if (ishead) {
                    if (dataArr.count>0) {
                        [dataArr removeAllObjects];
                    }
                }
                NSInteger totalPage = [NSString stringWithFormat:@"%@",[result objectForKey:@"pageCount"]].integerValue;
                if (pageIndex >=totalPage) {
                    [MybidListTable.mj_footer endRefreshingWithNoMoreData];
                }
                if ([[NSString stringWithFormat:@"%@",[result objectForKey:@"totalCount"]] isEqualToString:@"0"]) {
                    [AddHudView addProgressView:self.view message:@"暂无该项投标数据"];
                }else{
                    NSArray *arr =[result objectForKey:@"items"];
                    if (arr.count == 0) {
                        [AddHudView addProgressView:self.view message:@"数据已全部加载"];
                    }else{
                        for (NSDictionary *dic in arr) {
                            MyBidModel *model = [[MyBidModel alloc] init];
                            model.borrowTitle = [dic objectForKey:@"borrowTitle"];
                            model.amount = [dic objectForKey:@"amount"];
                            model.borrowState = [dic objectForKey:@"borrowState"];
                            model.createDate = [dic objectForKey:@"createDate"];
                            [dataArr addObject:model];
                        }
                    }
                }
                [MybidListTable reloadData];
            }else{
                [AddHudView addProgressView:self.view message:@"获取投标记录失败，请重新获取"];
            }
        }
    }];
}

- (void)requestLogin{
    [[DataRequestServer getDataRequestServerData] requestLoginresult:^(NSString *LoginState) {
        if ([LoginState isEqualToString:@"true"]) {
            [self RequestTradeDataWithType:self.BidType isrefresh:NO ishead:YES];
        }else{
            [AddHudView addProgressView:self.view message:@"登录失效，请重新登录"];
            double delayInSeconds = 1.0;
            __block MyBidViewController* BlockVC = self;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                LoginViewController *loginVc= [[LoginViewController alloc] init];
                loginVc.loginType = logintypeOutTime;
                [BlockVC.navigationController pushViewController:loginVc animated:YES];
            });
        }
    }];
}

- (void)addUI{
    MybidListTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kNavigationBarHeight-kStatusBarHeight) style:UITableViewStylePlain];
    MybidListTable.backgroundColor = [UIColor clearColor];
    MybidListTable.delegate = self;
    MybidListTable.dataSource = self;
    MybidListTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:MybidListTable];
    
    MybidListTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (dataArr.count>0) {
            [dataArr removeAllObjects];
        }
        pageIndex = 1;
        [MybidListTable.mj_footer resetNoMoreData];
        [self RequestTradeDataWithType:self.BidType isrefresh:YES ishead:YES];
    }];
    MybidListTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        pageIndex++;
        [self RequestTradeDataWithType:self.BidType isrefresh:YES ishead:NO];
    }];
}

#pragma mark - 代理
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView ==  self.TypeTableView) {
        static NSString *indetifier = @"TYPECELL";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indetifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indetifier];
        }
        cell.textLabel.text = self.TypeArr[indexPath.row];
        cell.textLabel.font = TEXTFONT(15);
        cell.textLabel.textColor = [UIColor colorWithHex:0x333333];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        if (indexPath.row < self.TypeArr.count-1) {
            cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
        }else{
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        }
        return cell;
    }else{
        MybidTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MybidTableViewCell"];
        if (!cell)
        {
            [tableView registerNib:[UINib nibWithNibName:@"MybidTableViewCell" bundle:nil] forCellReuseIdentifier:@"MybidTableViewCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"MybidTableViewCell"];
        }
        if (dataArr.count>=indexPath.row) {
            cell.myBidModel = [dataArr objectAtIndex:indexPath.row];
        }
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.TypeTableView) {
        return self.TypeArr.count;
    }else{
        return dataArr.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.TypeTableView) {
        return 45;
        
    }else{
        return 60;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.TypeTableView) {
        [UIView animateWithDuration:0.5 animations:^{
            self.TypeTableView.frame = CGRectMake(kDeviceWidth, 0,200, kDeviceHeight);
        } completion:^(BOOL finished) {
            NSString *Title = self.TypeArr[indexPath.row];
            
            if ([Title isEqualToString:@"全部"]) {
                self.title = @"我的资产";
            }else{
                self.title = Title;
            }
            self.BidType = indexPath.row;
            [MybidListTable.mj_header beginRefreshing];
//            [self RequestTradeDataWithType:self.BidType isrefresh:NO ishead:YES];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)ShowOrHideChoiceView{
    [UIView animateWithDuration:1.0 animations:^{
        [ChoiceViews setHidden:!ChoiceViews.hidden];
    }];
    if (!ChoiceViews.hidden) {
        MybidListTable.userInteractionEnabled = NO;
    }else{
        MybidListTable.userInteractionEnabled = YES;
    }
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

//
//  InviteListViewController.m
//  vvlc
//
//  Created by 慧明 on 2017/12/18.
//  Copyright © 2017年 HM. All rights reserved.
//

#import "InviteListViewController.h"
#import "InviteListTableViewCell.h"
#import "WebViewController.h"

@interface InviteListViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic,strong) UITableView *ListTableView;
@property (nonatomic,strong) UILabel *InviteRewardLabel;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,assign) NSInteger currentIndex;

@end

@implementation InviteListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的奖励";
    self.currentIndex = 1;
    self.dataArray = [[NSMutableArray alloc] init];
    [self addTableView];
    [self getList:NO withIndex:self.currentIndex ishead:YES];
}

- (void)addTableView{
    self.ListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, kDeviceWidth, kDeviceHeight-kNavigationBarHeight-kStatusBarHeight) style:UITableViewStylePlain];
    
    self.ListTableView.dataSource = self;
    self.ListTableView.delegate = self;
    self.ListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.ListTableView.backgroundColor = [UIColor colorWithHex:0xF6F6F6];
    
    self.ListTableView.tableHeaderView = [self tableHeadView];
    self.ListTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    __weak typeof(self) weakSelf = self;
    self.ListTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.currentIndex = 1;
        [weakSelf getList:YES withIndex:weakSelf.currentIndex ishead:YES];
    }];
    [self.view addSubview:self.ListTableView];
    
    UIButton *listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [listButton setTitleColor:RGBA(255, 75, 31, 1) forState:UIControlStateNormal];
    [listButton setTitle:@"规则" forState:UIControlStateNormal];
    listButton.titleLabel.font = TEXTFONT(14);
    listButton.frame = CGRectMake(0, 0, 40, 30);
    [listButton addTarget:self action:@selector(RightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:listButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (UIView *)tableHeadView{
    UIView *View = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 230)];
    View.backgroundColor = [UIColor whiteColor];
    
    UILabel *TitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, kDeviceWidth, 20)];
    TitleLabel.font = TEXTFONT(16);
    TitleLabel.text = @"累计奖励";
    TitleLabel.textAlignment = NSTextAlignmentCenter;
    TitleLabel.textColor = RGBA(156, 156, 156, 1);
    [View addSubview:TitleLabel];
    
    self.InviteRewardLabel= [[UILabel alloc] initWithFrame:CGRectMake(0, TitleLabel.bottom+16, kDeviceWidth, 30)];
    self.InviteRewardLabel.font = TEXTFONT(30);
    self.InviteRewardLabel.text = @"--";
    self.InviteRewardLabel.textAlignment = NSTextAlignmentCenter;

    self.InviteRewardLabel.textColor = RGBA(69, 69, 69, 1);
    [View addSubview:self.InviteRewardLabel];
    
    UIView *ColorV =[[UIView alloc] initWithFrame:CGRectMake(0, self.InviteRewardLabel.bottom+40, kDeviceWidth, 12)];
    ColorV.backgroundColor = [UIColor colorWithHex:0xF6F6F6];
    [View addSubview:ColorV];
    
    UILabel *Title2Label = [[UILabel alloc] initWithFrame:CGRectMake(20, ColorV.bottom, kDeviceWidth-40, 50)];
    Title2Label.font = TEXTFONT(16);
    Title2Label.text = @"邀请记录";
    Title2Label.textColor = RGBA(63, 63, 63, 1);
    [View addSubview:Title2Label];
    
    NSArray *Arr= @[@"已邀请",@"邀请时间",@"奖励(元)"];
    for (NSUInteger i = 0; i<Arr.count; i++) {
        UILabel *Label = [[UILabel alloc] initWithFrame:CGRectMake(i*kDeviceWidth/Arr.count, Title2Label.bottom,kDeviceWidth/Arr.count, 36)];
        Label.backgroundColor = RGBA(255, 244, 241, 1);
        Label.font = TEXTFONT(16);
        Label.text = Arr[i];
        Label.textAlignment = NSTextAlignmentCenter;
        Label.textColor = RGBA(255, 75, 31, 1);
        [View addSubview:Label];
    }
    return View;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    InviteListTableViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:@"InviteListTableViewCell"];
    if (!Cell) {
        [tableView registerNib:[UINib nibWithNibName:@"InviteListTableViewCell" bundle:nil] forCellReuseIdentifier:@"InviteListTableViewCell"];
        Cell = [tableView dequeueReusableCellWithIdentifier:@"InviteListTableViewCell"];
    }
    InviteListModel *model = [self.dataArray objectAtIndex:indexPath.row];
    Cell.model = model;
    return Cell;

}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}


-(void)getList:(BOOL )isrefresh withIndex:(NSInteger)index ishead:(BOOL) ishead{
    
    if (!isrefresh) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:[NSString stringWithFormat:@"%d",self.currentIndex] forKey:@"index"];
    
    [[DataRequestServer getDataRequestServerData] request:@"LunaP2pAppReferrerAmountServlet" parameters:param result:^(id result) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
        if (isrefresh) {
            if (ishead) {
                [self.ListTableView.mj_header endRefreshing];
            }else{
                [self.ListTableView.mj_footer endRefreshing];
            }
        }
        
        if ([result isKindOfClass:[NSString class]] &&  [result isEqualToString:@"44"]) {
            [AddHudView addProgressView:self.view message:@"网络错误，请稍后再试"];
        }else{
            int t = [[result objectForKey:@"success"] intValue];
            MyLog(@"====%@",result);
            NSString *error=[result objectForKey:@"errorlog"];
            
            NSString *pageCount=[result objectForKey:@"pageCount"];
            if (self.currentIndex >= pageCount.integerValue) {
                [self.ListTableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.ListTableView.mj_footer resetNoMoreData];
            }
            if(t==1 && [error isEqualToString:@""]){
                if (ishead) {
                    if (self.dataArray.count >0 ) {
                        [self.dataArray removeAllObjects];
                    }
                }
                self.InviteRewardLabel.text = [NSString stringWithFormat:@"%@",[result objectForKey:@"sumAmount"]];
                NSArray *arr =[result objectForKey:@"items"];
                
                for (NSDictionary *Dic in arr) {
                    InviteListModel *model = [InviteListModel createInviteListModel:Dic];
                    [self.dataArray addObject:model];
                }
                [self.ListTableView reloadData];
                self.currentIndex++;
            }
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)RightButtonClick{
    WebViewController *webVC = [[WebViewController alloc] init];
    webVC.UrlString =[ NSString stringWithFormat:@"%@wap/activity/reffer/rule.htm",Base_url];
    webVC.title = @"规则";
    webVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webVC animated:YES];
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

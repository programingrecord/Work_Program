//
//  MSUExpireController.m
//  vvlc
//
//  Created by 007 on 2018/3/20.
//  Copyright © 2018年 HM. All rights reserved.
//

#import "MSUExpireController.h"

#import "MSUCuponTableCell.h"

#import "MSUPathTools.h"


@interface MSUExpireController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic,strong) UITableView *CouponListTable;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,assign) NSInteger pageIndex;
@property (nonatomic , strong) UIView *centerView;

@end

@implementation MSUExpireController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.pageIndex= 1;
    self.dataArr = [[NSMutableArray alloc] init];
    [self addUI];
    if (self.type == MSUCouponTypeHB) {
        self.title = @"过期红包";

        [self requestData:NO ishead:NO index:self.pageIndex baseState:@"1"];
    } else if(self.type == MSUCouponType_JX){
        self.title = @"过期加息券";

        [self requestData:NO ishead:NO index:self.pageIndex baseState:@"3"];
    } else{
        self.title = @"过期理财券";

        [self requestData:NO ishead:NO index:self.pageIndex baseState:@"5"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addUI{
    if (is_iPhoneX) {
        self.CouponListTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-64-30) style:UITableViewStylePlain];
    } else{
        self.CouponListTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-64) style:UITableViewStylePlain];
    }
    self.CouponListTable.backgroundColor = RGBA(235, 235, 235, 1);
    self.CouponListTable.delegate = self;
    self.CouponListTable.dataSource = self;
    self.CouponListTable.emptyDataSetSource = self;
    self.CouponListTable.emptyDataSetDelegate = self;
    //    self.CouponListTable.tableHeaderView = [self createHeadView];
//    self.CouponListTable.tableFooterView = [self createFootView];
    self.CouponListTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.CouponListTable];
    
    self.CouponListTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pageIndex = 1;
        if (self.dataArr.count>0) {
            [self.dataArr removeAllObjects];
        }
        
        if (self.type == MSUCouponTypeHB) {
            [self requestData:YES ishead:YES index:self.pageIndex baseState:@"1"];
        } else if(self.type == MSUCouponType_JX){
            [self requestData:YES ishead:YES index:self.pageIndex baseState:@"3"];
        } else{
            [self requestData:YES ishead:YES index:self.pageIndex baseState:@"5"];
        }
        
    }];
    
    self.CouponListTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.pageIndex ++;
        if (self.type == MSUCouponTypeHB) {
            [self requestData:YES ishead:NO index:self.pageIndex baseState:@"1"];
        } else if(self.type == MSUCouponType_JX){
            [self requestData:YES ishead:NO index:self.pageIndex baseState:@"3"];
        } else{
            [self requestData:YES ishead:NO index:self.pageIndex baseState:@"5"];
        }
    }];
}

-(void)requestData:(BOOL )isrefresh ishead:(BOOL)ishead index:(NSInteger)index baseState:(NSString *)baseState
{
//    if (self.type != MSUCouponTypeHB) {
//        if (isrefresh) {
//            if (ishead) {
//                [self.CouponListTable.mj_header endRefreshing];
//            }else{
//                [self.CouponListTable.mj_footer endRefreshing];
//            }
//        }
//        return;
//    }
    
    if (!isrefresh) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    //    if (self.receiptType == ReceiptTypeCollect) {
    //        [dic setObject:@"1" forKey:@"state"];
    //    }else{
    //        [dic setObject:@"2" forKey:@"state"];
    //    }
    [dic setObject:[NSString stringWithFormat:@"%ld",(long)index] forKey:@"index"];
    [dic setObject:[NSString stringWithFormat:@"%@",baseState] forKey:@"BaseState"];
    
    [[DataRequestServer getDataRequestServerData] request:@"LunaP2pAppHongBaoTicketServlet" parameters:dic result:^(id result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (isrefresh) {
            if (ishead) {
                [self.CouponListTable.mj_header endRefreshing];
            }else{
                [self.CouponListTable.mj_footer endRefreshing];
            }
        }
        
        if ([result isKindOfClass:[NSString class]] &&  [result isEqualToString:@"44"]) {
            [AddHudView addProgressView:self.view message:@"网络错误，请稍后再试"];
        }else{
            int success = [[result objectForKey:@"success"]intValue];
            
            if (success==0 && [[result objectForKey:@"errorlog"]isEqualToString:@"noLogin"]) {
                //                [self requestLogin];
            }else if (success==1 && [[result objectForKey:@"errorlog"]isEqualToString:@""]){
                
                NSString *pageCount=[result objectForKey:@"pageCount"];
                if (self.pageIndex >= pageCount.integerValue) {
                    [self.CouponListTable.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [self.CouponListTable.mj_footer resetNoMoreData];
                }
                
                if (ishead) {
                    if (self.dataArr.count>0) {
                        [self.dataArr removeAllObjects];
                    }
                }
                NSArray *arr =[result objectForKey:@"items"];
                for (NSDictionary *dic in arr) {
                    CouponModel *model = [CouponModel createCouponListModel:dic];
                    [self.dataArr addObject:model];
                }
                
                self.centerView.hidden = YES;
                if (self.dataArr.count == 0) {
                    self.centerView.hidden = NO;
                }
                
                [self.CouponListTable reloadData];
            }else{
                [AddHudView addProgressView:self.view message:@"获取优惠劵数据失败，请重新获取"];
            }
        }
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MSUCuponTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CouponTableViewCell"];
    if (!cell)
    {
        cell = [[MSUCuponTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CouponTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = RGBA(235, 235, 235, 1);
    }
    
    if (self.dataArr.count>=indexPath.row) {
        cell.useIndex = 1;
        cell.model = [self.dataArr objectAtIndex:indexPath.row];
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 93*kDeviceHeightScale+20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CouponModel *model = [self.dataArr objectAtIndex:indexPath.row];
    NSString *str = [NSString stringWithFormat:@"%@",model.bagState];
    if ([str isEqualToString:@"0"]) {
        AppDelegate *jj = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [jj loadMainView];
        [jj.mainVC setSelectedIndex:1];
    }
}

- (UIView *)centerView{
    if (!_centerView) {
        self.centerView = [[UIView alloc] initWithFrame:CGRectMake(0, kDeviceHeight*0.5-64-40, kDeviceWidth, 150)];
        [self.view addSubview:_centerView];
        
        UIImageView *imaView = [[UIImageView alloc] initWithFrame:CGRectMake(kDeviceWidth*0.5-125*0.5, 0, 125, 90)];
        imaView.image = [MSUPathTools showImageWithContentOfFileByName:@"yhq11"];
        [_centerView addSubview:imaView];
        
        UILabel *attentionLab = [[UILabel alloc] init];
        attentionLab.frame = CGRectMake(0, imaView.bottom + 20, kDeviceWidth, 20);
        attentionLab.text = @"您暂时没有过期的优惠券～";
        attentionLab.font = [UIFont systemFontOfSize:15];
        attentionLab.textAlignment = NSTextAlignmentCenter;
        attentionLab.textColor = HEXCOLOR(0x9B9B9B);
        [_centerView addSubview:attentionLab];
        
        
    }
    return _centerView;
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

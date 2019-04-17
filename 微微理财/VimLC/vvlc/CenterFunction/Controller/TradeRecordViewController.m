//
//  TradeRecordViewController.m
//  WTJR
//
//  Created by HM on 16/6/6.
//  Copyright © 2016年 HM. All rights reserved.
//

#import "TradeRecordViewController.h"
#import "CustomButton.h"
#import "TrandRecordModel.h"
#import "LoginViewController.h"
#import "TrandReecordCell.h"
#import "TradeTypeViewController.h"
#import "MSUTradeRecordCell.h"
#import "MSUFilterTableCell.h"
#import "MSUAlphaShadowView.h"

@interface TradeRecordViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
{
    NSInteger currentIndex;
    UIView *ChoiceViews;
}

@property (weak, nonatomic) IBOutlet UITableView *TradeRecordTableView;
@property (nonatomic,strong) NSMutableArray *dataSourceArray;
@property (nonatomic,strong) NSArray *TypeArr;
@property (nonatomic,strong) NSArray *styleArr;
@property (nonatomic , strong) MSUAlphaShadowView *shadowView;
@property (nonatomic,strong) UITableView *TypeTableView;

@property (nonatomic , strong) NSArray *headerArr;

@end

@implementation TradeRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEXCOLOR(0xe8e8e8);
    
    _dataSourceArray = [[NSMutableArray alloc] init];
    currentIndex = 1;
    
    self.headerArr = @[@"筛选",@"收入",@"其他"];

    __weak typeof(self) weakSelf = self;
    self.TradeRecordTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong typeof(self) strongSelf = weakSelf;
        [self.TradeRecordTableView.mj_footer resetNoMoreData];
        currentIndex = 1;
        if (self.TrandeFromType == TrandeRecordFromType_MLB) {
            [strongSelf RequestLingQianbaoDatarefreshView:YES ishead:YES];
        }else{
            [strongSelf RequestTradeDataWithType:strongSelf.TrandeType refreshView:YES ishead:YES];
        }
    }];
    self.TradeRecordTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        __strong typeof(self) strongSelf = weakSelf;
        if (self.TrandeFromType == TrandeRecordFromType_MLB) {
            [strongSelf RequestLingQianbaoDatarefreshView:YES ishead:NO];
        }else{
            [strongSelf RequestTradeDataWithType:strongSelf.TrandeType refreshView:YES ishead:NO];
        }
    }];
    
    self.TradeRecordTableView.emptyDataSetSource = self;
    self.TradeRecordTableView.emptyDataSetDelegate = self;
    self.TradeRecordTableView.backgroundColor = HEXCOLOR(0xe8e8e8);
    
    if (self.TrandeFromType == TrandeRecordFromType_MLB) {
        [self RequestLingQianbaoDatarefreshView:NO ishead:YES];
        self.title = @"微微宝记录";
    }else if(self.TrandeFromType == TrandeRecordFromType_ALL){
        [self addTypeTableView];
        [self addNavigationItemTitleView];
        [self RequestTradeDataWithType:self.TrandeType refreshView:NO ishead:YES];
        self.title = @"交易记录";
    }else if (self.TrandeFromType == TrandeRecordFromType_WITHDRAW){
        self.title = @"提现记录";
        [self RequestTradeDataWithType:self.TrandeType refreshView:NO ishead:YES];
    }else if (self.TrandeFromType == TrandeRecordFromType_TOPUP){
        self.title = @"充值记录";
        [self RequestTradeDataWithType:self.TrandeType refreshView:NO ishead:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI初始化
- (void)addTypeTableView{
    self.TypeArr = @[@[@"全部"],@[@"充值",@"还款",@"奖励"],@[@"投资",@"提现",@"其他"]];
    self.styleArr = @[@"全部",@"充值",@"还款",@"奖励",@"投资",@"提现",@"其他"];

    self.shadowView = [[MSUAlphaShadowView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    _shadowView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [MSUMainWindow addSubview:_shadowView];
    _shadowView.alpha = 0;

    self.TypeTableView  = [[UITableView alloc] initWithFrame:CGRectMake(kDeviceWidth, 0, 157, kDeviceHeight) style:UITableViewStylePlain];
    self.TypeTableView.delegate = self;
    self.TypeTableView.dataSource = self;
    self.TypeTableView.backgroundColor = [UIColor whiteColor];
    self.TypeTableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    self.TypeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_shadowView addSubview:self.TypeTableView];
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
    self.TypeTableView.frame = CGRectMake(kDeviceWidth, 0,157, kDeviceHeight);

    [UIView animateWithDuration:0.5 animations:^{
        if (self.TypeTableView.origin.x >= kDeviceWidth) {
            self.shadowView.alpha = 1;
            self.TypeTableView.frame = CGRectMake(kDeviceWidth-157, 0,157, kDeviceHeight);
        }
    }];
}

- (void)RequestTradeDataWithType:(TrandeRecordType)type refreshView:(BOOL )isrefresh ishead:(BOOL) ishead{
    NSString *typeNum;
    switch (type) {
        case TrandeRecordTypeAll:
            typeNum = @"";
            break;
        case TrandeRecordTypeRecharge:
            typeNum = @"1,2";
            break;
        case TrandeRecordTypeWithdrawals:
            typeNum = @"22,23,49";
            break;
        case TrandeRecordTypeBid:
            typeNum = @"15,50,51,52,32,53";
            break;
        case TrandeRecordTypeReceivables:
            typeNum = @"5,11,19,48";
            break;
        case TrandeRecordTypeBidAward:
            typeNum = @"3";
            break;
        case TrandeRecordTypeInterest:
            typeNum = @"4,6,7,8,9,10,12,13,14,16,17,18,20,21,24,25,26,27,28,29,30,31,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47";
            break;
        case TrandeRecordTypeRecommendAward:
            typeNum = @"7";
            break;
        case TrandeRecordTypeCurrentJoin:
            typeNum = @"48";
            break;
        case TrandeRecordTypeCurrentWithDraw:
            typeNum = @"49";
            break;
        case TrandeRecordTypeRegistCash:
            typeNum = @"50";
            break;
        default:
            break;
    }
//    if (!isrefresh) {
//        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    }

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[NSString stringWithFormat:@"%ld",currentIndex] forKey:@"index"];
    [params setObject:typeNum forKey:@"ptype"];

    [[DataRequestServer getDataRequestServerData] request:@"LunaP2pAppTallyServlet" parameters:params result:^(id result) {
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isrefresh) {
            if (ishead) {
                [self.TradeRecordTableView.mj_header endRefreshing];
            }else{
                [self.TradeRecordTableView.mj_footer endRefreshing];
            }
        }
        if ([result isKindOfClass:[NSString class]] &&  [result isEqualToString:@"44"]) {
            [AddHudView addProgressView:self.view message:@"网络错误，请稍后再试"];
        }else{
            int success = [[result objectForKey:@"success"]intValue];
            
            if ([[result objectForKey:@"errorlog"]isEqualToString:@"noLogin"]&& success==0) {
                [self requestLogin:logintypeHome];
            }else if(success==1 && [[result objectForKey:@"errorlog"]isEqualToString:@""]){
                if (ishead) {
                    if (self.dataSourceArray.count > 0) {
                        [self.dataSourceArray removeAllObjects];
                    }
                }
                NSString *pageCount = [NSString stringWithFormat:@"%@",[result objectForKey:@"pageCount"]];
                if (currentIndex >= pageCount.integerValue) {
                    [self.TradeRecordTableView.mj_footer endRefreshingWithNoMoreData];
                }
                
                NSArray *arr = [result objectForKey:@"items"];
                for (NSDictionary *dic in arr) {
                    TrandRecordModel *model = [[TrandRecordModel alloc] init];
                    model.incomeAmount = [dic objectForKey:@"incomeAmount"];
                    model.createDate = [dic objectForKey:@"createDate"];
                    model.tallyType = [dic objectForKey:@"tallyType"];
                    model.isIncome = [NSString stringWithFormat:@"%ld",[[dic objectForKey:@"isIncome"] integerValue]];
                    model.balance = [NSString stringWithFormat:@"余额：%@",[dic objectForKey:@"balance"]];
                    model.intro = [NSString stringWithFormat:@"[%@]",dic[@"reMark"]];
                    [_dataSourceArray addObject:model];
                }
                [_TradeRecordTableView reloadData];
                currentIndex ++;
            }
            else{
                [AddHudView addProgressView:self.view message:@"数据获取失败，请重新获取"];
            }
        }
    }];
}

- (void)RequestLingQianbaoDatarefreshView:(BOOL )isrefresh ishead:(BOOL) ishead{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[NSString stringWithFormat:@"%ld",currentIndex] forKey:@"index"];
    
    [[DataRequestServer getDataRequestServerData] request:@"LunaP2pAppCurrentTallyServlet" parameters:params result:^(id result) {
        if (isrefresh) {
            if (ishead) {
                [self.TradeRecordTableView.mj_header endRefreshing];
            }else{
                [self.TradeRecordTableView.mj_footer endRefreshing];
            }
        }
        
        if ([result isKindOfClass:[NSString class]] &&  [result isEqualToString:@"44"]) {
            [AddHudView addProgressView:self.view message:@"网络错误，请稍后再试"];
        }else{
            int success = [[result objectForKey:@"success"]intValue];
            
            if ([[result objectForKey:@"errorlog"]isEqualToString:@"noLogin"]&& success==0) {
                [self requestLogin:logintypeHome];
            }else if(success==1 && [[result objectForKey:@"errorlog"]isEqualToString:@""]){
                if (ishead) {
                    if (self.dataSourceArray.count > 0) {
                        [self.dataSourceArray removeAllObjects];
                    }
                }
                NSString *pageCount = [NSString stringWithFormat:@"%@",[result objectForKey:@"pageCount"]];
                if (currentIndex >= pageCount.integerValue) {
                    [self.TradeRecordTableView.mj_footer endRefreshingWithNoMoreData];
                }
                
                NSArray *arr = [result objectForKey:@"items"];
                for (NSDictionary *dic in arr) {
                    TrandRecordModel *model = [[TrandRecordModel alloc] init];
                    model.incomeAmount = [dic objectForKey:@"incomeAmount"];
                    model.createDate = [dic objectForKey:@"createDate"];
                    model.tallyType = [dic objectForKey:@"tallyType"];
                    model.isIncome = [NSString stringWithFormat:@"%ld",[[dic objectForKey:@"isIncome"] integerValue]];
                    model.balance = [NSString stringWithFormat:@"余额：%@",[dic objectForKey:@"balance"]];
                    model.intro = [NSString stringWithFormat:@"[%@]",dic[@"reMark"]];
                    [_dataSourceArray addObject:model];
                }
                [_TradeRecordTableView reloadData];
                currentIndex ++;
            }
            else{
                [AddHudView addProgressView:self.view message:@"数据获取失败，请重新获取"];
            }
        }
    }];
}

#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == self.TypeTableView) {
        return 3;
    } else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.TypeTableView) {
        NSArray *arr = self.TypeArr[section];
        return arr.count;
    }else{
        return _dataSourceArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.TypeTableView) {
        static NSString *indetifier = @"TYPECELL";
        MSUFilterTableCell *cell = [tableView dequeueReusableCellWithIdentifier:indetifier];
        if (!cell) {
            cell = [[MSUFilterTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indetifier];
        }
        cell.titLab.text = self.TypeArr[indexPath.section][indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.row == 0 && indexPath.section == 0) {
            cell.titLab.backgroundColor = HEXCOLOR(0xFF6339);
        } else{
            cell.titLab.backgroundColor = HEXCOLOR(0xEDEDED);
        }

//        if (indexPath.row < self.TypeArr.count-1) {
//            cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
//            
//        }else{
//            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
//        }
        return cell;
    }else{
        TrandReecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TrandReecordCell"];
        if (!cell)
        {
            [tableView registerNib:[UINib nibWithNibName:@"TrandReecordCell" bundle:nil] forCellReuseIdentifier:@"TrandReecordCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"TrandReecordCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (_dataSourceArray.count>=indexPath.row) {
            cell.titStr = self.title;
            cell.model = [_dataSourceArray objectAtIndex:indexPath.row];
        }
        return cell;
//        if ([self.title isEqualToString:@"交易记录"]) {
//            MSUTradeRecordCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MSUTradeRecordCell"];
//            if (!cell)
//            {
//                [tableView registerClass:[MSUTradeRecordCell class] forCellReuseIdentifier:@"MSUTradeRecordCell"];
//                cell = [tableView dequeueReusableCellWithIdentifier:@"MSUTradeRecordCell"];
//            }
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//
//            if (_dataSourceArray.count>=indexPath.row) {
//                cell.model = [_dataSourceArray objectAtIndex:indexPath.row];
//            }
//            return cell;
//        } else{
//            TrandReecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TrandReecordCell"];
//            if (!cell)
//            {
//                [tableView registerNib:[UINib nibWithNibName:@"TrandReecordCell" bundle:nil] forCellReuseIdentifier:@"TrandReecordCell"];
//                cell = [tableView dequeueReusableCellWithIdentifier:@"TrandReecordCell"];
//            }
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//
//            if (_dataSourceArray.count>=indexPath.row) {
//                cell.model = [_dataSourceArray objectAtIndex:indexPath.row];
//            }
//            return cell;
//        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.TypeTableView) {
        return 45;
    }else{
        return 74;

//        if ([self.title isEqualToString:@"交易记录"]) {
//            return 101*kDeviceHeightScale;
//        } else{
//            return 74;
//        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.TypeTableView) {
        MSUFilterTableCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.titLab.backgroundColor = HEXCOLOR(0xFF6339);
        if (!(indexPath.row == 0 && indexPath.section == 0)) {
            MSUFilterTableCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            cell.titLab.backgroundColor = HEXCOLOR(0xEDEDED);
        }
        
        [UIView animateWithDuration:0.5 animations:^{
            self.TypeTableView.frame = CGRectMake(kDeviceWidth, 0,157, kDeviceHeight);
            self.shadowView.alpha = 0;

        } completion:^(BOOL finished) {
            NSString *Title = self.TypeArr[indexPath.section][indexPath.row];

            if ([Title isEqualToString:@"全部"]) {
                self.title = @"交易记录";
            }else{
                self.title = Title;
            }
            
            for (NSInteger i = 0; i < self.styleArr.count; i++) {
                if ([Title isEqualToString:_styleArr[i]]) {
                    self.TrandeType = i;
                }
            }
            [_TradeRecordTableView.mj_header beginRefreshing];
        }];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.TypeTableView) {
        MSUFilterTableCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.titLab.backgroundColor = HEXCOLOR(0xEDEDED);
    }


}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == self.TypeTableView) {
        UIView *bgView = [[UIView alloc] init];
        bgView.frame = CGRectMake(0, 0, 157, 54.5);
        bgView.backgroundColor = HEXCOLOR(0xffffff);
        
        UILabel *attentionLab = [[UILabel alloc] init];
        attentionLab.frame = CGRectMake(0, 27, 157, 22.5);
        attentionLab.text = self.headerArr[section];
        attentionLab.font = [UIFont systemFontOfSize:16];
        attentionLab.textAlignment = NSTextAlignmentCenter;
        attentionLab.textColor = HEXCOLOR(0x4A4A4A);
        [bgView addSubview:attentionLab];
        
        if (section != 0) {
            UIView *lineView = [[UIView alloc] init];
            lineView.frame = CGRectMake(21, 13.5, 157-42, 0.5);
            lineView.backgroundColor = HEXCOLOR(0xE5E5E5);
            [bgView addSubview:lineView];
        }
        
        return bgView;
    } else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == self.TypeTableView) {
        return 54+22.5;
    } else{
        return 0;
    }
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

-(UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"Date_Empty"];
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView{
    return  YES;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view{
    [self.TradeRecordTableView.mj_header beginRefreshing];
}


@end

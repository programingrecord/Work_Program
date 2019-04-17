//
//  MSURepaymentPlanController.m
//  vvlc
//
//  Created by 007 on 2018/4/25.
//  Copyright © 2018年 HM. All rights reserved.
//

#import "MSURepaymentPlanController.h"
#import "MSURePlanCell.h"

@interface MSURepaymentPlanController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger currentIndex;
}

@property (nonatomic , strong) UILabel *titLab;
@property (nonatomic , strong) UILabel *signLab;
@property (nonatomic , strong) UILabel *yujiLab;
@property (nonatomic , strong) UILabel *incomeLab;
@property (nonatomic , strong) UILabel *tradeLab;
@property (nonatomic , strong) UILabel *endDateLab;

@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , strong) NSMutableArray *dataArr;

@property (nonatomic , copy) NSString *signIndex;

@end

@implementation MSURepaymentPlanController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"还款计划";
    self.view.backgroundColor = HEXCOLOR(0xe8e8e8);
    
    UIView *lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(0, 0, kDeviceWidth, 1);
    lineView.backgroundColor = HEXCOLOR(0xe8e8e8);
    [self.view addSubview:lineView];
    
    self.dataArr = [NSMutableArray array];
    [self createContentView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createContentView{
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(0, 1, kDeviceWidth, 162.5*kDeviceHeightScale);
    bgView.backgroundColor = HEXCOLOR(0xffffff);
    [self.view addSubview:bgView];
    
    self.titLab = [[UILabel alloc] init];
    _titLab.frame = CGRectMake(12, 12, kDeviceWidth*2/3, 22.5*kDeviceHeightScale);
    _titLab.text = @"--";
    _titLab.font = [UIFont systemFontOfSize:16];
    _titLab.textColor = HEXCOLOR(0x3B3D43);
    [bgView addSubview:_titLab];
    
    self.signLab = [[UILabel alloc] init];
    _signLab.backgroundColor = HEXCOLOR(0xFF6339);
    _signLab.frame = CGRectMake(kDeviceWidth-55, 13.5*kDeviceHeightScale, 55, 20*kDeviceHeightScale);
    _signLab.text = @"--";
    _signLab.font = [UIFont systemFontOfSize:12];
    _signLab.textColor = HEXCOLOR(0xffffff);
    _signLab.textAlignment = NSTextAlignmentCenter;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_signLab.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopLeft cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _signLab.bounds;
    maskLayer.path = maskPath.CGPath;
    _signLab.layer.mask = maskLayer;
    [bgView addSubview:_signLab];

    self.yujiLab = [[UILabel alloc] init];
    _yujiLab.frame = CGRectMake(0, _titLab.bottom + 16*kDeviceHeightScale, kDeviceWidth*0.5, 22*kDeviceHeightScale);
    _yujiLab.text = @"--";
    self.yujiLab.font = [UIFont fontWithName:@"DINAlternate-Bold" size:18];
    _yujiLab.textAlignment = NSTextAlignmentCenter;
    _yujiLab.textColor = HEXCOLOR(0xFF6339);
    [bgView addSubview:_yujiLab];
    
    UILabel *yuqiLab = [[UILabel alloc] init];
    yuqiLab.frame = CGRectMake(0, _yujiLab.bottom, kDeviceWidth*0.5, 22*kDeviceHeightScale);
    yuqiLab.text = @"预期收益(元)";
    yuqiLab.font = [UIFont systemFontOfSize:12];
    yuqiLab.textAlignment = NSTextAlignmentCenter;
    yuqiLab.textColor = HEXCOLOR(0xBABABA);
    [bgView addSubview:yuqiLab];
    
    self.tradeLab = [[UILabel alloc] init];
    _tradeLab.frame = CGRectMake(0, yuqiLab.bottom + 12*kDeviceHeightScale, kDeviceWidth*0.5, 22*kDeviceHeightScale);
    _tradeLab.text = @"--";
    self.tradeLab.font = [UIFont fontWithName:@"DINAlternate-Bold" size:18];
    _tradeLab.textAlignment = NSTextAlignmentCenter;
    _tradeLab.textColor = HEXCOLOR(0x6D6E6E);
    [bgView addSubview:_tradeLab];
    
    UILabel *tradeMLab = [[UILabel alloc] init];
    tradeMLab.frame = CGRectMake(0, _tradeLab.bottom, kDeviceWidth*0.5, 22*kDeviceHeightScale);
    tradeMLab.text = @"投资金额(元)";
    tradeMLab.font = [UIFont systemFontOfSize:12];
    tradeMLab.textAlignment = NSTextAlignmentCenter;
    tradeMLab.textColor = HEXCOLOR(0xBABABA);
    [bgView addSubview:tradeMLab];
    
    self.incomeLab = [[UILabel alloc] init];
    _incomeLab.frame = CGRectMake(kDeviceWidth*0.5, _titLab.bottom + 16*kDeviceHeightScale, kDeviceWidth*0.5, 22*kDeviceHeightScale);
    _incomeLab.text = @"--";
    self.incomeLab.font = [UIFont fontWithName:@"DINAlternate-Bold" size:18];
    _incomeLab.textAlignment = NSTextAlignmentCenter;
    _incomeLab.textColor = HEXCOLOR(0xFF6339);
    [bgView addSubview:_incomeLab];
    
    UILabel *alreadyLab = [[UILabel alloc] init];
    alreadyLab.frame = CGRectMake(kDeviceWidth*0.5, _incomeLab.bottom, kDeviceWidth*0.5, 22*kDeviceHeightScale);
    alreadyLab.text = @"已收益(元)";
    alreadyLab.font = [UIFont systemFontOfSize:12];
    alreadyLab.textAlignment = NSTextAlignmentCenter;
    alreadyLab.textColor = HEXCOLOR(0xBABABA);
    [bgView addSubview:alreadyLab];
    
    self.endDateLab = [[UILabel alloc] init];
    _endDateLab.frame = CGRectMake(kDeviceWidth*0.5, alreadyLab.bottom + 12*kDeviceHeightScale, kDeviceWidth*0.5, 22*kDeviceHeightScale);
    _endDateLab.text = @"--";
    self.endDateLab.font = [UIFont fontWithName:@"DINAlternate-Bold" size:18];
    _endDateLab.textAlignment = NSTextAlignmentCenter;
    _endDateLab.textColor = HEXCOLOR(0x6D6E6E);
    [bgView addSubview:_endDateLab];
    
    UILabel *endLab = [[UILabel alloc] init];
    endLab.frame = CGRectMake(kDeviceWidth*0.5, _endDateLab.bottom, kDeviceWidth*0.5, 22*kDeviceHeightScale);
    endLab.text = @"还款结束日";
    endLab.font = [UIFont systemFontOfSize:12];
    endLab.textAlignment = NSTextAlignmentCenter;
    endLab.textColor = HEXCOLOR(0xBABABA);
    [bgView addSubview:endLab];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(0,162.5*kDeviceHeightScale-1, kDeviceWidth, 1);
    lineView.backgroundColor = HEXCOLOR(0xe8e8e8);
    [bgView addSubview:lineView];
    
    UIView *line1View = [[UIView alloc] init];
    line1View.frame = CGRectMake(kDeviceWidth*0.5-0.5,_yujiLab.top +3, 1, 94*kDeviceHeightScale);
    line1View.backgroundColor = HEXCOLOR(0xe8e8e8);
    [bgView addSubview:line1View];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, bgView.bottom, kDeviceWidth, 0) style:UITableViewStylePlain];
    _tableView.backgroundColor = WhiteColor;
    _tableView.scrollEnabled = YES;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.panGestureRecognizer.delaysTouchesBegan = self.tableView.delaysContentTouches;
    _tableView.rowHeight = 71.2*kDeviceHeightScale;
    [_tableView registerClass:[MSURePlanCell class] forCellReuseIdentifier:@"MSURePlanCell"];
    if (iOS11) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    _tableView.scrollEnabled = NO;
    
    __weak typeof(self) weakSelf = self;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf RequestLingQianbaoDatarefreshView:YES ishead:YES];
    }];
    
    [self RequestLingQianbaoDatarefreshView:NO ishead:YES];

}

#pragma mark - 请求
- (void)RequestLingQianbaoDatarefreshView:(BOOL )isrefresh ishead:(BOOL) ishead{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:self.bridStr forKey:@"brid"];
    
    [[DataRequestServer getDataRequestServerData] request:@"LunaP2pAppMyBidDetailServlet" parameters:params result:^(id result) {
        if (isrefresh) {
            if (ishead) {
                [self.tableView.mj_header endRefreshing];
            }else{
                [self.tableView.mj_footer endRefreshing];
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
                    if (self.dataArr.count > 0) {
                        [self.dataArr removeAllObjects];
                    }
                }
                NSString *pageCount = [NSString stringWithFormat:@"%@",[result objectForKey:@"pageCount"]];
                if (currentIndex >= pageCount.integerValue) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                
                self.signIndex = [NSString stringWithFormat:@"%@",result[@"periods"]];
                [self refreshUIWithDataDic:result];
                self.dataArr = [[result objectForKey:@"items"] mutableCopy];
                
                self.tableView.frame = CGRectMake(0, 162.5*kDeviceHeightScale + 1, kDeviceWidth, 71.2*kDeviceHeightScale*self.dataArr.count);

                [_tableView reloadData];
                currentIndex ++;
            }
            else{
                [AddHudView addProgressView:self.view message:@"数据获取失败，请重新获取"];
            }
        }
    }];
}

- (void)refreshUIWithDataDic:(NSDictionary *)dic{
    self.titLab.text = [NSString stringWithFormat:@"%@",dic[@"borrowTitle"]];
    self.signLab.text = [NSString stringWithFormat:@"%@",dic[@"borrowState"]];
    if ([_signLab.text isEqualToString:@"已还清"]) {
        _signLab.backgroundColor = HEXCOLOR(0xC6C6C6);
    } else {
        _signLab.backgroundColor = HEXCOLOR(0xFF6339);
    }
    self.yujiLab.text = [NSString stringWithFormat:@"%.2f",[NSString stringWithFormat:@"%@",dic[@"totalInterest"]].doubleValue];
    self.incomeLab.text = [NSString stringWithFormat:@"%.2f",[NSString stringWithFormat:@"%@",dic[@"closeamount"]].doubleValue];
    self.tradeLab.text = [NSString stringWithFormat:@"%@",dic[@"amount"]];
    self.endDateLab.text = [[NSString stringWithFormat:@"%@",dic[@"closeDate"]] stringByReplacingOccurrencesOfString:@"-" withString:@"."];

}


#pragma mark - 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MSURePlanCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MSURePlanCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 0) {
        cell.lineTopView.hidden = YES;
    }
    
    if (indexPath.row == 4 && self.dataArr.count > 3) {
        cell.lineView.hidden = YES;
    }
    
    if (indexPath.row == 2 && self.dataArr.count <= 3) {
        cell.lineView.hidden = YES;
    }
    
    NSDictionary *dic = self.dataArr[indexPath.row];
    cell.titLab.text = [NSString stringWithFormat:@"%@",dic[@"stateleft"]];
    cell.moneyLab.text = [NSString stringWithFormat:@"%@元",dic[@"stagesInterest"]];
    cell.dateLab.text = [NSString stringWithFormat:@"%@",dic[@"layDate"]];
    cell.introLab.text = [NSString stringWithFormat:@"%@",dic[@"stateright"]];

    if (self.dataArr.count == 3 && [self.signIndex isEqualToString:@"1"]) {
        cell.gouImaView.highlighted = YES;
        cell.lineView.backgroundColor = HEXCOLOR(0x1FC69F);
        cell.lineTopView.backgroundColor = HEXCOLOR(0x1FC69F);;
        cell.titLab.highlighted = YES;
        cell.dateLab.highlighted = YES;
        cell.moneyLab.highlighted = YES;
    } else if (self.dataArr.count == 3 && [self.signIndex isEqualToString:@"0"]){
        if (indexPath.row == 0) {
            cell.gouImaView.highlighted = YES;
            cell.lineView.backgroundColor = HEXCOLOR(0x1FC69F);
            cell.lineTopView.backgroundColor = HEXCOLOR(0x1FC69F);;
            cell.titLab.highlighted = YES;
            cell.dateLab.highlighted = YES;
            cell.moneyLab.highlighted = YES;
        }
    }
    else if (self.dataArr.count == 5 && [self.signIndex isEqualToString:@"0"]){
        if (indexPath.row == 0) {
            cell.gouImaView.highlighted = YES;
            cell.lineView.backgroundColor = HEXCOLOR(0x1FC69F);
            cell.lineTopView.backgroundColor = HEXCOLOR(0x1FC69F);;
            cell.titLab.highlighted = YES;
            cell.dateLab.highlighted = YES;
            cell.moneyLab.highlighted = YES;
        }
    }
    else if (self.dataArr.count == 5 && [self.signIndex isEqualToString:@"1"]){
        if (indexPath.row < 2) {
            cell.gouImaView.highlighted = YES;
            cell.lineView.backgroundColor = HEXCOLOR(0x1FC69F);
            cell.lineTopView.backgroundColor = HEXCOLOR(0x1FC69F);;
            cell.titLab.highlighted = YES;
            cell.dateLab.highlighted = YES;
            cell.moneyLab.highlighted = YES;
        } else{
            cell.gouImaView.highlighted = NO;
            cell.lineView.backgroundColor = HEXCOLOR(0xD8D8D8);
            cell.lineTopView.backgroundColor = HEXCOLOR(0xD8D8D8);;
            cell.titLab.highlighted = NO;
            cell.dateLab.highlighted = NO;
            cell.moneyLab.highlighted = NO;
        }
    } else if (self.dataArr.count == 5 && [self.signIndex isEqualToString:@"2"]){
        if (indexPath.row < 3) {
            cell.gouImaView.highlighted = YES;
            cell.lineView.backgroundColor = HEXCOLOR(0x1FC69F);
            cell.lineTopView.backgroundColor = HEXCOLOR(0x1FC69F);;
            cell.titLab.highlighted = YES;
            cell.dateLab.highlighted = YES;
            cell.moneyLab.highlighted = YES;
        } else{
            cell.gouImaView.highlighted = NO;
            cell.lineView.backgroundColor = HEXCOLOR(0xD8D8D8);
            cell.lineTopView.backgroundColor = HEXCOLOR(0xD8D8D8);;
            cell.titLab.highlighted = NO;
            cell.dateLab.highlighted = NO;
            cell.moneyLab.highlighted = NO;
        }
    } else if ([self.signIndex isEqualToString:@"3"]){
        cell.gouImaView.highlighted = YES;
        cell.lineView.backgroundColor = HEXCOLOR(0x1FC69F);
        cell.lineTopView.backgroundColor = HEXCOLOR(0x1FC69F);;
        cell.titLab.highlighted = YES;
        cell.dateLab.highlighted = YES;
        cell.moneyLab.highlighted = YES;
    } else {
        cell.gouImaView.highlighted = NO;
        cell.lineView.backgroundColor = HEXCOLOR(0xD8D8D8);
        cell.lineTopView.backgroundColor = HEXCOLOR(0xD8D8D8);;
        cell.titLab.highlighted = NO;
        cell.dateLab.highlighted = NO;
        cell.moneyLab.highlighted = NO;
    }
    
    return cell;
}


@end

//
//  CouponViewController.m
//  vvlc
//
//  Created by 慧明 on 2017/11/7.
//  Copyright © 2017年 HM. All rights reserved.
//

#import "CouponViewController.h"
#import "CouponTableViewCell.h"
//#import "CouponModel.h"
#import "MSUCuponTableCell.h"
#import "MSUExpireController.h"
#import "MSUCuponRuleController.h"

#import "MSUShadowInView.h"
#import "MSUStringTools.h"
#import "MSUPathTools.h"

@interface CouponViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic,strong) UITableView *CouponListTable;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,assign) NSInteger *pageIndex;

@property (strong, nonatomic) UIView        *slideView;
@property (nonatomic,strong) UIView         *topMainView;
@property (strong, nonatomic) UIButton      *SelectButton;
@property (nonatomic,strong) NSArray        *headTitle;

@property (nonatomic , strong) MSUShadowInView *shareShadowView;
@property (nonatomic , strong) UIView *popView;
@property (nonatomic , strong) UILabel *ruleLab;
@property (nonatomic , strong) UILabel *ruleTitLab;

@property (nonatomic , strong)  UIButton *bottomBtn;
@property (nonatomic , strong) UIView *centerView;

@end

@implementation CouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的优惠劵";
    
    UIView *lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(0, 0, kDeviceWidth, 0.5);
    lineView.backgroundColor = HEXCOLOR(0xdedede);
    [self.view addSubview:lineView];
    
    self.headTitle = @[@"红包",@"理财劵",@"加息券"];
    [self.view addSubview: self.topMainView];
    [self.topMainView addSubview: self.slideView];
    self.type = CouponTypeHB;
    self.pageIndex= 1;
    self.dataArr = [[NSMutableArray alloc] init];
    [self addNavigationItemTitleView];
    [self addUI];
    [self requestData:NO ishead:NO index:self.pageIndex baseState:@"0"];
}

- (void)addNavigationItemTitleView{
    UIButton *listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [listButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [listButton setTitle:@"使用规则" forState:UIControlStateNormal];
    listButton.titleLabel.font = TEXTFONT(14);
    [listButton setTitleColor:HEXCOLOR(0x454545) forState:UIControlStateNormal];
    listButton.frame = CGRectMake(0, 0, 80, 30);
    listButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 15);
    [listButton addTarget:self action:@selector(listButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:listButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}

#pragma mark - 视图相关
- (UIView *)topMainView{
    if (!_topMainView) {
        CGFloat width =kDeviceWidth / self.headTitle.count;
        _topMainView = [[UIView alloc] initWithFrame:CGRectMake(0, 1,kDeviceWidth, 40)];
        _topMainView.backgroundColor = [UIColor whiteColor];
        for (int i =0 ; i<self.headTitle.count; i++) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(width*i,0 , width, 40)];
            button.tag = CouponTypeHB +i;
            NSString *string = self.headTitle[i];
            NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:string];
            [attriString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0xB0B0B0] range:NSMakeRange(0, string.length)];
            [attriString addAttribute:NSFontAttributeName value:TEXTFONT(15) range:NSMakeRange(0,string.length)];
            [button setAttributedTitle:attriString forState:UIControlStateNormal];
            
            NSMutableAttributedString *sel_attriString = [[NSMutableAttributedString alloc] initWithString:string];
            [sel_attriString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0xFB6339] range:NSMakeRange(0, string.length)];
            [sel_attriString addAttribute:NSFontAttributeName value:TEXTFONT(15) range:NSMakeRange(0,string.length)];
            [button setAttributedTitle:sel_attriString forState:UIControlStateSelected];
            if (i == 0) {
                button.selected = YES;
                self.SelectButton = button;
                self.type = CouponTypeHB;
            }else{
                button.selected = NO;
            }
            [button addTarget:self action:@selector(tabButton:) forControlEvents:UIControlEventTouchUpInside];
            [_topMainView addSubview:button];
        }
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

- (void)addUI{
    if (is_iPhoneX) {
        self.CouponListTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, kDeviceWidth, kDeviceHeight-kNavigationBarHeight-40-kStatusBarHeight-30) style:UITableViewStylePlain];
    } else {
        self.CouponListTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, kDeviceWidth, kDeviceHeight-kNavigationBarHeight-40-kStatusBarHeight) style:UITableViewStylePlain];
    }
    self.CouponListTable.backgroundColor = RGBA(235, 235, 235, 1);
    self.CouponListTable.delegate = self;
    self.CouponListTable.dataSource = self;
//    self.CouponListTable.emptyDataSetSource = self;
//    self.CouponListTable.emptyDataSetDelegate = self;
//    self.CouponListTable.tableHeaderView = [self createHeadView];
//    self.CouponListTable.tableFooterView = [self createFootViewWithTitle:@"查看已过期红包"];
    self.CouponListTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.CouponListTable];
    
    self.CouponListTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pageIndex = 1;
        if (self.dataArr.count>0) {
            [self.dataArr removeAllObjects];
        }
        
        if (self.type == CouponTypeHB) {
            [self requestData:YES ishead:YES index:self.pageIndex baseState:@"0"];
        } else if (self.type == CouponType_JX){
            [self requestData:YES ishead:YES index:self.pageIndex baseState:@"2"];
        } else if (self.type == CouponType_LC){
            [self requestData:YES ishead:YES index:self.pageIndex baseState:@"4"];
        }
        
    }];
    
    self.CouponListTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.pageIndex ++;
        if (self.type == CouponTypeHB) {
            [self requestData:YES ishead:NO index:self.pageIndex baseState:@"0"];
        } else if (self.type == CouponType_JX){
            [self requestData:YES ishead:NO index:self.pageIndex baseState:@"2"];
        } else if (self.type == CouponType_LC){
            [self requestData:YES ishead:NO index:self.pageIndex baseState:@"4"];
        }
    }];
}

- (UIView *)createHeadView{
    UIView *View = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 40)];
    
    UIView *ColorView = [[UIView alloc] initWithFrame:CGRectMake(0, 8, kDeviceWidth, 32)];
    ColorView.backgroundColor = [UIColor whiteColor];
    [View addSubview:ColorView];
    
    UILabel *label =[[UILabel alloc] initWithFrame:CGRectMake(20, 0, kDeviceWidth-40, 32)];
    label.textColor = [UIColor colorWithHex:0xFB6337];
    label.text = @"同一个标只能使用一个红包，按照满标后的投资总金额计算";
    label.font = TEXTFONT(12);
    label.adjustsFontSizeToFitWidth = YES;
    [ColorView addSubview:label];
    return View;
}

- (UIView *)createFootViewWithTitle:(NSString *)tit{
    UIView *View = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 95)];
    View.backgroundColor = RGBA(235, 235, 235, 1);
    
    UILabel *label =[[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth*0.5-166.5*0.5, 25, 166.5, 45)];
    label.clipsToBounds = YES;
    label.layer.cornerRadius = 45*0.5;
    label.layer.shouldRasterize = YES;
    label.layer.rasterizationScale = [UIScreen mainScreen].scale;
    label.backgroundColor = WhiteColor;
    label.textColor = [UIColor colorWithHex:0x9B9B9B];
    label.text = tit;
    label.font = TEXTFONT(14);
    label.adjustsFontSizeToFitWidth = YES;
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.borderWidth = 0.5;
    label.layer.borderColor = HEXCOLOR(0x979797).CGColor;
    [View addSubview:label];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 25, kDeviceWidth, 45);
    [View addSubview:btn];
    [btn addTarget:self action:@selector(footBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return View;
}
//
//- (MSUShadowInView *)shareShadowView{
//    if (!_shareShadowView) {
//        _shareShadowView = [[MSUShadowInView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
//        _shareShadowView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
//        [MSUMainWindow addSubview:_shareShadowView];
//        _shareShadowView.hidden = YES;
//    }
//    return _shareShadowView;
//}
//
//- (UIView *)popView{
//    if (!_popView) {
//        _popView = [[UIView alloc] initWithFrame:CGRectMake(25, (kDeviceHeight-290*kDeviceHeightScale)*0.5, kDeviceWidth-50, 290*kDeviceHeightScale)];
//        _popView.backgroundColor = WhiteColor;
//
//        self.ruleTitLab = [[UILabel alloc] init];
//        _ruleTitLab.frame = CGRectMake(20, 23*kDeviceHeightScale, kDeviceWidth-40, 22.5*kDeviceHeightScale);
//        _ruleTitLab.text = @"红包使用规则:";
//        _ruleTitLab.font = [UIFont systemFontOfSize:16];
//        _ruleTitLab.textColor = HEXCOLOR(0x2a2a2a);
//        [_popView addSubview:_ruleTitLab];
//
//        self.ruleLab = [[UILabel alloc] init];
//        _ruleLab.font = [UIFont systemFontOfSize:13];
//        _ruleLab.numberOfLines = 0;
//        _ruleLab.textColor = HEXCOLOR(0x959595);
//        [_popView addSubview:_ruleLab];
//
//        [self.shareShadowView addSubview:_popView];
//    }
//    return _popView;
//}

#pragma mark  - 点击
- (void)listButtonClick{
    MSUCuponRuleController *rule = [[MSUCuponRuleController alloc] init];
    [self.navigationController pushViewController:rule animated:YES];
    
//    self.shareShadowView.hidden = NO;
//    self.popView.hidden = NO;
//    if (self.type == CouponTypeHB) {
//        _ruleTitLab.text = [NSString stringWithFormat:@"%@",@"红包使用规则"];
//        _ruleLab.text = [NSString stringWithFormat:@"%@",@"1、红包在投资中不可抵用现金，每次投资只可使用一张券；\n2、红包一次性使用，不设找零；\n3、新手标不可使用红包；\n4、超过有效期的红包将不可使用；\n5、用户投资1000元理财产品，使用10元红包，到期后可与1000元本息一起提现。"];
//    } else if (self.type == CouponType_LC){
//        _ruleTitLab.text = [NSString stringWithFormat:@"%@",@"理财券使用规则"];
//        _ruleLab.text = [NSString stringWithFormat:@"%@", @"1、理财券在投资中可抵用现金，每次投资只可使用一张券；\n2、理财券一次性使用，不设找零；\n3、新手标不可使用理财券；\n4、超过有效期的理财券将不可使用；\n5、理财券所产生的利息可以提现，理财券本金不可提现。\n例如：用户投资1000元理财产品，其中使用100元的理财券，实际支付900元。到期后可获得900元本金加上1000元的利息。"];
//    } else{
//        _ruleTitLab.text = [NSString stringWithFormat:@"%@",@"加息券规则：定期理财项目(新手标除外)"];
//        _ruleLab.text = [NSString stringWithFormat:@"%@",@"1、红包在投资中不可抵用现金，每次投资只可使用一张券；\n2、红包一次性使用，不设找零；\n3、新手标不可使用红包；\n4、超过有效期的红包将不可使用；\n5、用户投资1000元理财产品，使用10元红包，到期后可与1000元本息一起提现。"];
//    }
//    CGRect recta = [MSUStringTools danamicGetHeightFromText:_ruleLab.text WithWidth:kDeviceWidth-50-40 font:13];
//    _ruleLab.frame = CGRectMake(20, 54*kDeviceHeightScale, kDeviceWidth-50-40, recta.size.height);
}

-(void)tabButton:(id)sender{
    UIButton *button = sender;
    self.type = button.tag;
    self.pageIndex = 1;

    if (self.SelectButton!= button) {
        self.SelectButton.selected = NO;
        button.selected = YES;
        CGFloat width = kDeviceWidth / self.headTitle.count;
        [UIView animateWithDuration:0.3 animations:^{
            [self.slideView setFrame:CGRectMake(width*(button.tag) +width/2-30,38, 60, 2)];
        }];
        self.SelectButton = button;
        
        if (self.dataArr.count >0) {
            [self.dataArr removeAllObjects];
        }
        [self.CouponListTable reloadData];
        self.CouponListTable.tableHeaderView = nil;
        self.CouponListTable.tableFooterView = nil;
        
        if (self.type == CouponTypeHB) {

      
            [self requestData:NO ishead:YES index:self.pageIndex baseState:@"0"];
            
            //            self.CouponListTable.tableHeaderView = [self createHeadView];
        }else{
     
            
            if (self.type == CouponType_LC) {
                [self requestData:NO ishead:YES index:self.pageIndex baseState:@"4"];
            } else if (self.type == CouponType_JX){
                [self requestData:NO ishead:YES index:self.pageIndex baseState:@"2"];
            }


        }
    }
}

- (void)footBtnClick:(UIButton *)sender{
    MSUExpireController *expire = [[MSUExpireController alloc] init];
    expire.hidesBottomBarWhenPushed = YES;
    if (self.type == CouponTypeHB) {
        expire.type = MSUCouponTypeHB;
    } else if (self.type == CouponType_JX){
        expire.type = MSUCouponType_JX;
    } else {
        expire.type = MSUCouponType_LC;
    }
    [self.navigationController pushViewController:expire animated:YES];
}


-(void)requestData:(BOOL )isrefresh ishead:(BOOL)ishead index:(NSInteger)index baseState:(NSString *)baseState
{

    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];

    [dic setObject:[NSString stringWithFormat:@"%ld",index] forKey:@"index"];
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
                
                self.bottomBtn.hidden = YES;
                self.centerView.hidden = YES;
//                self.CouponListTable.tableFooterView = nil;
                
                if (self.type == CouponTypeHB) {
                    if (self.dataArr.count > 0) {
                        self.CouponListTable.tableFooterView = [self createFootViewWithTitle:@"查看已过期红包"];
                    } else {
                        [self.bottomBtn setTitle:@"查看已过期红包" forState:UIControlStateNormal];
                        self.bottomBtn.hidden = NO;
                        self.centerView.hidden = NO;
                    }
                } else if (self.type == CouponType_LC) {
                    if (self.dataArr.count > 0) {
                        self.CouponListTable.tableFooterView = [self createFootViewWithTitle:@"查看已过期理财券"];
                    } else {
                        [self.bottomBtn setTitle:@"查看已过期理财券" forState:UIControlStateNormal];
                        self.bottomBtn.hidden = NO;
                        self.centerView.hidden = NO;
                    }
                } else if (self.type == CouponType_JX){
                    if (self.dataArr.count > 0) {
                        self.CouponListTable.tableFooterView = [self createFootViewWithTitle:@"查看已过期加息券"];
                    } else{
                        [self.bottomBtn setTitle:@"查看已过期加息券" forState:UIControlStateNormal];
                        self.bottomBtn.hidden = NO;
                        self.centerView.hidden = NO;
                    }
                }
                
                [self.CouponListTable reloadData];
            }else{
                [AddHudView addProgressView:self.view message:@"获取优惠劵数据失败，请重新获取"];
            }
        }
    }];
}

- (UIButton *)bottomBtn{
    if (!_bottomBtn) {
        self.bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomBtn.frame = CGRectMake(kDeviceWidth*0.5-166.5*0.5, kDeviceHeight-25-45-64, 166.5, 45);
        _bottomBtn.clipsToBounds = YES;
        _bottomBtn.layer.cornerRadius = 45*0.5;
        _bottomBtn.layer.shouldRasterize = YES;
        _bottomBtn.layer.rasterizationScale = [UIScreen mainScreen].scale;
        _bottomBtn.backgroundColor = WhiteColor;
        _bottomBtn.titleLabel.font = TEXTFONT(14);
        _bottomBtn.layer.borderWidth = 0.5;
        _bottomBtn.layer.borderColor = HEXCOLOR(0x979797).CGColor;
        [_bottomBtn setTitleColor:HEXCOLOR(0x9B9B9B) forState:UIControlStateNormal];
        [self.view addSubview:_bottomBtn];
        [_bottomBtn addTarget:self action:@selector(footBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomBtn;
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
        attentionLab.text = @"您暂时没有可用的优惠券～";
        attentionLab.font = [UIFont systemFontOfSize:15];
        attentionLab.textAlignment = NSTextAlignmentCenter;
        attentionLab.textColor = HEXCOLOR(0x9B9B9B);
        [_centerView addSubview:attentionLab];

        
    }
    return _centerView;
}


#pragma mark - 代理相关
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MSUCuponTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CouponTableViewCell"];
    if (!cell)
    {
        cell = [[MSUCuponTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CouponTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = RGBA(235, 235, 235, 1);
    }
    if (self.dataArr.count>=indexPath.row) {
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
    return 99*kDeviceHeightScale+13.5*kDeviceHeightScale;
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

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    UIView *view = [self createFootView];
//    return view;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 40;
//}

//-(UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
//{
//    return [UIImage imageNamed:@"yhq11"];
//}
//
//-(NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
//{
//    NSString *text = nil;
//    UIFont *font = nil;
//    UIColor *textColor = nil;
//    NSMutableDictionary *attributes = [NSMutableDictionary new];
//
//    text = @"您暂时没有可用的优惠券~";
//    font = [UIFont systemFontOfSize:13];
//    textColor = [UIColor colorWithHex:0x333333];
//
//    if (!text) {
//        return nil;
//    }
//    if (font) {
//        [attributes setObject:font forKey:NSFontAttributeName];
//    }
//    if (textColor) {
//        [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
//    }
//    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
//}
//
//- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
//    return YES;
//}
//
//- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView{
//    return  YES;
//}
//
//- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view{
//    [self.CouponListTable.mj_header beginRefreshing];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

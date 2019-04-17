//
//  MSUTradePWDController.m
//  vvlc
//
//  Created by 007 on 2018/6/25.
//  Copyright © 2018年 HM. All rights reserved.
//

#import "MSUTradePWDController.h"
#import "PasswordModifyVC.h"
#import "MSUSetTradePWDController.h"
#import "ForgotTradePassVC.h"

#import "ManagerTableViewCell.h"

@interface MSUTradePWDController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic,strong)NSArray *leftTitleArr;
@property (nonatomic,strong)NSArray *rightTitleArr;

@end

@implementation MSUTradePWDController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([CoreArchive isSetTradePass]) {
        self.leftTitleArr = @[@"修改交易密码",@"忘记交易密码"];
    } else{
        self.leftTitleArr = @[@"设置交易密码",@"忘记交易密码"];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"交易密码";
    self.view.backgroundColor = HEXCOLOR(0xe8e8e8);
    
    
    [self createCenterTab];
}

- (void)createCenterTab{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-49) style:UITableViewStylePlain];
    _tableView.backgroundColor = BGWhiteColor;
    _tableView.scrollEnabled = YES;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.scrollEnabled = NO;
    [self.view addSubview:_tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.panGestureRecognizer.delaysTouchesBegan = self.tableView.delaysContentTouches;
    _tableView.rowHeight = 45*kDeviceHeightScale;
    //    [_tableView registerClass:[MSUHotTableCell class] forCellReuseIdentifier:@"hotVideoCell"];
    if (iOS11) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _leftTitleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ManagerTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ManagerTableViewCell"];
    if (!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"ManagerTableViewCell" bundle:nil] forCellReuseIdentifier:@"ManagerTableViewCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"ManagerTableViewCell"];
    }
    //    cell.backgroundColor = WhiteColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.leftTitle.text = self.leftTitleArr[indexPath.row];
    if (indexPath.row == _leftTitleArr.count-1) {
        cell.BottomLineViewLeft.constant = 0;
    }else{
        cell.BottomLineViewLeft.constant = 10;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 13*kDeviceHeightScale;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *V= [[UIView alloc] init];
    V.backgroundColor = HEXCOLOR(0xe8e8e8);
    V.frame  = CGRectMake(0, 0, kDeviceWidth, 13*kDeviceHeightScale);
    
    return V;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
    if (indexPath.row == 0) {
        MSUSetTradePWDController *set = [[MSUSetTradePWDController alloc] init];

        if ([CoreArchive isSetTradePass]) {
            set.pwdType = MSUResetPwd;
        } else {
            set.signStr = @"account";
            set.pwdType = MSUSetPwd;
        }
        set.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:set animated:YES];

    } else if (indexPath.row == 1){
        ForgotTradePassVC *forgotVC = [[ForgotTradePassVC alloc] init];
        forgotVC.phoneStr = self.phoneStr;
        [self.navigationController pushViewController:forgotVC animated:YES];
    }
}

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

//
//  MSUManagerController.m
//  vvlc
//
//  Created by 007 on 2018/6/25.
//  Copyright © 2018年 HM. All rights reserved.
//

#import "MSUManagerController.h"

#import "ManagerTableViewCell.h"

#import "GesturePasswordController.h"
#import "MSUTradePWDController.h"
#import "MSUAboutController.h"
#import "PasswordModifyVC.h"
#import "MSUSystemController.h"

#import "MSUShadowView.h"
#import "MSUScoreView.h"
#import "MSUPathTools.h"

@interface MSUManagerController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic,strong)NSArray *leftTitleArr;
@property (nonatomic,strong)NSArray *rightTitleArr;
@property (nonatomic,strong)GesturePasswordController *gesturePassWord;
@property (nonatomic , strong) MSUShadowView *shadowView;
@property (nonatomic , strong) MSUScoreView *scoreView;

@property (nonatomic , strong) MSUShadowView *shadowClearView;
@property (nonatomic , strong) UIView *clearView;
@property (nonatomic , copy) NSString *memoryStr;

@end

@implementation MSUManagerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"设置";
    self.view.backgroundColor = HEXCOLOR(0xe8e8e8);
    
    [self createCenterView];
    
    [self getData];
}

- (void)getData{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *userinfoDic= [userDefaults objectForKey:@"userInfoDetial"];
    NSMutableDictionary *registerDic= [userDefaults objectForKey:@"registerData"];
    NSMutableDictionary *dic= [userDefaults objectForKey:@"gestureWord"];
    
    self.memoryStr = [NSString stringWithFormat:@"%.2fM",[MSUPathTools cacheSizeInApp]];
    if (userinfoDic && registerDic && [dic objectForKey:@"previousString"]) {
        self.leftTitleArr = @[@[@"交易密码",@"修改登录密码",@"手势密码",@"修改手势密码"],@[@"系统检测",@"清理缓存",@"给我鼓励",@"关于微米"]];
        self.rightTitleArr = @[@[@"",@"",@"",@""],@[@"",_memoryStr,@"",@""]];
    }else{
        self.leftTitleArr = @[@[@"交易密码",@"修改登录密码",@"手势密码"],@[@"系统检测",@"清理缓存",@"给我鼓励",@"关于微米"]];
        self.rightTitleArr = @[@[@"",@"",@""],@[@"",_memoryStr,@"",@""]];
    }
}

- (void)createCenterView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-49) style:UITableViewStylePlain];
    _tableView.backgroundColor = BGWhiteColor;
    _tableView.scrollEnabled = YES;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.panGestureRecognizer.delaysTouchesBegan = self.tableView.delaysContentTouches;
    _tableView.rowHeight = 45*kDeviceHeightScale;
//    [_tableView registerClass:[ManagerTableViewCell class] forCellReuseIdentifier:@"ManagerTableViewCell"];
    if (iOS11) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    UIButton *outBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    outBtn.frame = CGRectMake(0, kDeviceHeight-64*kDeviceHeightScale-52*kDeviceHeightScale, kDeviceWidth, 52*kDeviceHeightScale);
    outBtn.backgroundColor = WhiteColor;
    [outBtn setTitle:@"安全退出" forState:UIControlStateNormal];
    [outBtn setTitleColor:HEXCOLOR(0xff6339) forState:UIControlStateNormal];
    outBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:outBtn];
    [outBtn addTarget:self action:@selector(outBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.leftTitleArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = [self.leftTitleArr objectAtIndex:section];
    return arr.count;
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
    
    if ( (indexPath.section == 0 && indexPath.row ==2)) {
        cell.imageWidth.constant = 10;
        cell.rightImage.hidden = YES;
    }else{
        cell.imageWidth.constant = 30;
        cell.rightImage.hidden = NO;
    }
    
    if (indexPath.section == 0 && indexPath.row ==2) {
        cell.CellSwitch.hidden = NO;
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *passWordDic = [userDefaults objectForKey:@"gestureWord"];
        if (passWordDic != nil) {
            cell.CellSwitch.on = YES;
        }else{
            cell.CellSwitch.on = NO;
        }
        [cell.CellSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    }else{
        cell.CellSwitch.hidden = YES;
    }
    NSArray *TitleArr = [self.leftTitleArr objectAtIndex:indexPath.section];
    cell.leftTitle.text = [TitleArr objectAtIndex:indexPath.row];
    if (indexPath.row == TitleArr.count-1) {
        cell.BottomLineViewLeft.constant = 0;
    }else{
        cell.BottomLineViewLeft.constant = 10;
    }
    NSArray *RightTitleArr = [self.rightTitleArr objectAtIndex:indexPath.section];
    cell.rightTltle.text = [RightTitleArr objectAtIndex:indexPath.row];
    if (indexPath.section == 1 && indexPath.row == 1) {
        cell.rightTltle.font = [UIFont systemFontOfSize:11];
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
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            MSUTradePWDController *pwd = [[MSUTradePWDController alloc] init];
            pwd.phoneStr = self.phoneStr;
            pwd.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:pwd animated:YES];
        } else if (indexPath.row == 1){
            PasswordModifyVC *passWordVC = [[PasswordModifyVC alloc] init];
            [self.navigationController pushViewController:passWordVC animated:YES];
            passWordVC.title=@"修改登录密码";
        } else{
            _gesturePassWord = [[GesturePasswordController alloc] init];
            _gesturePassWord.gestureType = GestureReSet;
            [[UIApplication sharedApplication].keyWindow addSubview:_gesturePassWord.view];
        }
    } else if (indexPath.section == 1){
        switch (indexPath.row) {
            case 0:
            {
                MSUSystemController *systemVC = [[MSUSystemController alloc] init];
                systemVC.hidesBottomBarWhenPushed = YES;
                systemVC.registNum = self.registNum;
                [self.navigationController pushViewController:systemVC animated:YES];
            }
                break;
            case 1:
            {
//                [MSUPathTools cleanCacheSizeInAppWithComplement:^(NSString *message, NSInteger code) {
//                    [PAProgressView showInView:self.view contentString:@"清理成功"];
//                    [self getData];
//                    [_tableView reloadData];
//                }];
                self.shadowClearView.hidden = NO;
                self.clearView.hidden = NO;
            }
                break;
            case 2:
            {
                self.shadowView.hidden = NO;
                self.scoreView.hidden = NO;
            }
                break;
            case 3:
            {
                MSUAboutController *aboutVC = [[MSUAboutController alloc] init];
                aboutVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:aboutVC animated:YES];
            }
                break;
                
            default:
                break;
        }
    }
}

#pragma mark - 点击
- (void)switchAction:(UISwitch *)sender{
    UISwitch *switchButton = (UISwitch*)sender;
    if ([switchButton isOn]) {
        NSLog(@"no");
    }else{
        NSLog(@"yes");
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *passWordDic = [userDefaults objectForKey:@"registerData"];
    if (passWordDic == nil&&switchButton.on == YES) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请您先登录" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        return;
    }else{
        if (switchButton.on == YES) {
            _gesturePassWord = [[GesturePasswordController alloc] init];
            _gesturePassWord.gestureType = GestureSet;
            [[UIApplication sharedApplication].keyWindow addSubview:_gesturePassWord.view];
        }
        else{
            _gesturePassWord = [[GesturePasswordController alloc] init];
            _gesturePassWord.gestureType = GestureDelete;
            [[UIApplication sharedApplication].keyWindow addSubview:_gesturePassWord.view];
        }
    }
}

- (void)outBtnClick:(UIButton *)sender{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[DataRequestServer getDataRequestServerData] request:@"logout.do" parameters:nil result:^(id result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([result isKindOfClass:[NSString class]] &&  [result isEqualToString:@"44"]) {
            [AddHudView addProgressView:self.view message:@"网络错误，请稍后再试"];
        }else{
            MyLog(@"url= %@",result);
        }
    }];
    [CoreArchive removeNSUserDefaults];
    
    AppDelegate *jj = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [jj loadMainView];
    [jj.mainVC setSelectedIndex:0];
}

- (void)clickBtnClick:(UIButton *)sender{
    NSString* str = [NSString stringWithFormat:@"%@",@"http://itunes.apple.com/cn/app/id1265692681?mt=8"];
    NSURL *url = [NSURL URLWithString:str];
    if (iOS10) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
            if (success) {
                MyLog(@"hahah");
                
            } else{
                
            }
        }];
    }else{
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (void)bottomBtnClick:(UIButton *)sender{
    self.shadowClearView.hidden = YES;

    if (sender.tag == 1248) {

        [MSUPathTools cleanCacheSizeInAppWithComplement:^(NSString *message, NSInteger code) {
            [PAProgressView showInView:self.view contentString:@"清理成功"];
            [self getData];
            [_tableView reloadData];
        }];
        
    } 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 初始化
- (MSUShadowView *)shadowView{
    if (!_shadowView) {
        self.shadowView = [[MSUShadowView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
        _shadowView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [MSUMainWindow addSubview:_shadowView];
        _shadowView.hidden = YES;
    }
    return _shadowView;
}

- (MSUScoreView *)scoreView{
    if (!_scoreView) {
        self.scoreView = [[MSUScoreView alloc] initWithFrame:CGRectMake(50, kDeviceHeight*0.5-150*kDeviceHeightScale, kDeviceWidth-100, 300*kDeviceHeightScale)];
        [self.shadowView addSubview:_scoreView];
        [_scoreView.clickBtn addTarget:self action:@selector(clickBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _scoreView;
}

- (MSUShadowView *)shadowClearView{
    if (!_shadowClearView) {
        self.shadowClearView = [[MSUShadowView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
        _shadowClearView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [MSUMainWindow addSubview:_shadowClearView];
        _shadowClearView.hidden = YES;
    }
    return _shadowClearView;
}

- (UIView *)clearView{
    if (!_clearView) {
        self.clearView = [[UIView alloc] initWithFrame:CGRectMake(23, kDeviceHeight*0.5-88*kDeviceHeightScale, kDeviceWidth-56, 176*kDeviceHeightScale)];
        [_shadowClearView addSubview:_clearView];
        
        UIImageView *imaView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth-56, 176*kDeviceHeightScale)];
        imaView.image = [MSUPathTools showImageWithContentOfFileByName:@"MSUClear"];
        [_clearView addSubview:imaView];
        
        UILabel *centerLab = [[UILabel alloc] init];
        centerLab.frame = CGRectMake((kDeviceWidth-56)*0.5-95, 56*kDeviceHeightScale, 190, 37*kDeviceHeightScale);
        centerLab.text = [NSString stringWithFormat:@"您的缓存数据大小为%@，是否确定删除",self.memoryStr];
        centerLab.font = [UIFont systemFontOfSize:13];
        centerLab.numberOfLines = 0;
        centerLab.textAlignment = NSTextAlignmentCenter;
        centerLab.textColor = HEXCOLOR(0xffffff);
        [_clearView addSubview:centerLab];
        
        for (NSInteger i = 0; i < 2; i++) {
            UIButton *bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            bottomBtn.frame = CGRectMake(0+i*(kDeviceWidth-56)*0.5, 137*kDeviceHeightScale, (kDeviceWidth-56)*0.5, 39*kDeviceHeightScale);
            [_clearView addSubview:bottomBtn];
            bottomBtn.tag = 1247+i;
            [bottomBtn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        }
       
    }
    return _clearView;
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

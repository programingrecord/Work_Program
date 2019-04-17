//
//  ViewController.m
//  LLEBankPayDemo
//
//  Created by EvenLam on 2017/9/26.
//  Copyright © 2017年 LianLianPay Inc. All rights reserved.
//

#import "BankPayViewController.h"
#import "LLEBankPaySDK.h"
#import "LLPayUtil.h"

#import "LoginViewController.h"

static NSString *cellIdentifier = @"cellIdentifier";

@interface BankPayViewController () <UITableViewDataSource, UITableViewDelegate, LLPaySdkDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *bankArr;
@property (nonatomic, assign) NSUInteger index;

@end

@implementation BankPayViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    self.title = @"订单支付";
    self.index = 0;
    self.view.backgroundColor = LLHexColor(0xF2F2F2);
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - 手机银行APP支付方法

- (void)pay {
    if (self.index == 0 && [self.bankName isEqualToString:@"中国农业银行"]) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"bankabc://"]]){
            [self payOrderWithBankCode:self.bankArr[self.index][@"code"]];
        } else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"友情提醒" message:@"您尚未安装农业银行App,点击确定前往下载安装" preferredStyle:UIAlertControllerStyleAlert];
            // 添加按钮
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/id515651240?mt=8"]];
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                NSLog(@"点击了取消按钮");
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        }
      
    } else if (self.index == 1 && [self.bankName isEqualToString:@"中国建设银行"]){
        [self payOrderWithBankCode:self.bankArr[self.index][@"code"]];
    } else if (self.index == 2 && [self.bankName isEqualToString:@"中国工商银行"]){
        [self payOrderWithBankCode:self.bankArr[self.index][@"code"]];
    } else if (self.index == 3 && [self.bankName isEqualToString:@"招商银行"]){
        [self payOrderWithBankCode:self.bankArr[self.index][@"code"]];
    } else if (self.index == 4 && [self.bankName isEqualToString:@"中国银行"]){
        [self payOrderWithBankCode:self.bankArr[self.index][@"code"]];
    }
    else{
        [PAProgressView showInView:self.view contentString:@"您选择的银行不匹配，请重新选择"];
        return;
    }
    
    
    
}


- (void)requestLogin{
    [[DataRequestServer getDataRequestServerData] requestLoginresult:^(NSString *LoginState) {
        if ([LoginState isEqualToString:@"true"]) {
            
        }else{
            [AddHudView addProgressView:self.view message:@"登录失效，请重新登录"];
            double delayInSeconds = 1.0;
            __weak __block BankPayViewController* BlockVC = self;
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

/**
 根据bankCode调用不同的银行APP

 @param bankCode 银行BankCode
 */
- (void)payOrderWithBankCode: (NSString *)bankCode {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *param1 = [[NSMutableDictionary alloc] init];
    [param1 setObject:@"5" forKey:@"payConfigId"];
    [param1 setObject:[NSString stringWithFormat:@"%.02f",[self.moneyText floatValue]] forKey:@"rechargeAmount"];
    
    [[DataRequestServer getDataRequestServerData] request:@"LianLianSdkPayServlet" parameters:param1 result:^(id result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([result isKindOfClass:[NSString class]] &&  [result isEqualToString:@"44"]) {
            [AddHudView addProgressView:self.view message:@"网络错误，请稍后再试"];
        }else if([[result objectForKey:@"success"]intValue]==0 && [[result objectForKey:@"errorlog"]isEqualToString:@"noLogin"]){
            [self requestLogin];
        }else if([[result objectForKey:@"success"]intValue]==1 && [[result objectForKey:@"errorlog"]isEqualToString:@""]){
            // 进行签名
            NSMutableDictionary *signedOrder = [result mutableCopy];
            
            if ([signedOrder objectForKey:@"success"]) {
                [signedOrder removeObjectForKey:@"success"];
            }
            if ([signedOrder objectForKey:@"errorlog"]) {
                [signedOrder removeObjectForKey:@"errorlog"];
            }
            
            NSArray *risk_itemArr = [signedOrder objectForKey:@"risk_item_ios"];
            for (NSString *key in signedOrder.allKeys) {
                NSString *String = [NSString stringWithFormat:@"%@",[signedOrder objectForKey:key]];
                if (String != NULL && String.length>0) {
                    [signedOrder setObject:String forKey:key];
                }else{
                    [signedOrder removeObjectForKey:key];
                }
            }
            
            NSMutableString *mutStr = [[NSMutableString alloc] init];
            
            for (NSInteger i = 0; i<risk_itemArr.count; i++) {
                NSDictionary *Dic = [risk_itemArr objectAtIndex:i];
                if (Dic &&i == 0) {
                    for (NSString *key in Dic) {
                        [mutStr appendString:[NSString stringWithFormat:@"{\"%@\":\"%@\",",key,[NSString stringWithFormat:@"%@",[Dic objectForKey:key]]]];
                    }
                }else if (i == risk_itemArr.count-1){
                    for (NSString *key in Dic) {
                        [mutStr appendString:[NSString stringWithFormat:@"\"%@\":\"%@\"}",key,[NSString stringWithFormat:@"%@",[Dic objectForKey:key]]]];
                    }
                }else{
                    for (NSString *key in Dic) {
                        [mutStr appendString:[NSString stringWithFormat:@"\"%@\":\"%@\",",key,[NSString stringWithFormat:@"%@",[Dic objectForKey:key]]]];
                    }
                }
            }
            [signedOrder removeObjectForKey:@"risk_item_ios"];
            [signedOrder setObject:mutStr forKey:@"risk_item"];
            [signedOrder setObject:bankCode forKey:@"bank_code"];
            [signedOrder setObject:@"https://sdk.lianlianpay.com" forKey:@"return_url"];

            //设置SDK回调
            [LLEBankPaySDK sharedSDK].sdkDelegate = self;
            //调用银行APP支付SDK
            [[LLEBankPaySDK sharedSDK] llEBankPayInViewController:self andPaymentInfo:signedOrder];
          
        }
        else{
            [AddHudView addProgressView:self.view message:@"提交充值失败，请重新操作"];
        }
    }];
    MyLog(@"连连支付");
    
  
}

#pragma mark - SDKDelegate

- (void)paymentEnd:(LLPayResult)resultCode withResultDic:(NSDictionary *)dic {
    NSString *msg = @"支付异常";
    switch (resultCode) {
        case kLLPayResultSuccess: {
            msg = @"支付成功";
            break;
        }
        case kLLPayResultFail:
            msg = @"支付失败";
            break;
        case kLLPayResultCancel:
            msg = @"支付取消";
            break;
        case kLLPayResultInitError:
            msg = @"SDK初始化异常";
            break;
        case kLLPayResultInitParamError:
            msg = dic[@"ret_msg"];
            break;
        default:
            break;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:msg message:[LLPayUtil jsonStringOfObj:dic] preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
    
    if ([msg isEqualToString:@"支付成功"]) {
        AppDelegate *jj = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [jj loadMainView];
        [jj.mainVC setSelectedIndex:3];
    }
}

#pragma mark - Delegate

#pragma mark *** <UITableViewDataSource> ***

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.bankArr.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"   选择支付方式";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 59;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    NSString *bankName = self.bankArr[indexPath.row][@"name"];
    NSString *bankDetailName = self.bankArr[indexPath.row][@"detailName"];
    UIImage *image = [UIImage imageNamed:self.bankArr[indexPath.row][@"abbreviation"]];
    UIImage *bankImage = [UIImage imageWithData:UIImagePNGRepresentation(image) scale:2];
    cell.imageView.image = bankImage;
    
    cell.textLabel.text = bankName;
    cell.textLabel.textColor = LLHexColor(0x333333);
    cell.detailTextLabel.text = bankDetailName;
    cell.detailTextLabel.textColor = LLHexColor(0x999999);
    
    if (indexPath.row == 0) {
        UIImageView *recommendIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"recommend"]];
        recommendIV.contentMode = UIViewContentModeScaleAspectFit;
        recommendIV.frame = CGRectMake(150, 10, 30, 20);
        [cell.contentView addSubview:recommendIV];
    }
    
    BOOL isSelected = indexPath.row == self.index;
    
    cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:isSelected?@"checkbox_checked":@"checkbox_normal"]];
    
    return cell;
    
}

#pragma mark *** <UITableViewDelegate> ***

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.index = indexPath.row;
    [tableView reloadData];
}


#pragma mark - Private

- (UIView *)tableHeaderView {
    UIView *headerView = [UIView new];
    CGFloat height = 75;
    headerView.frame = CGRectMake(0, 0, kWindowW, height);
    headerView.backgroundColor = [UIColor whiteColor];
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.frame = CGRectMake(12, 0, kWindowW/2-12, height);
    nameLabel.numberOfLines = 0;
    nameLabel.text = @"商品价格:";
    nameLabel.font = [UIFont systemFontOfSize:15];
    nameLabel.textColor = LLHexColor(0x333333);
    [headerView addSubview:nameLabel];
    
    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(kWindowW/2, 0, kWindowW/2-12, height)];
    moneyLabel.font = [UIFont boldSystemFontOfSize:30];
    moneyLabel.textColor = LLHexColor(0x333333);
    moneyLabel.text = [NSString stringWithFormat:@"%@元",self.moneyText];
    moneyLabel.textAlignment = NSTextAlignmentRight;
    moneyLabel.adjustsFontSizeToFitWidth = YES;
    [headerView addSubview:moneyLabel];
    
    return headerView;
}

- (UIView *)tableFooterView {
    UIView *footerView = [UIView new];
    footerView.frame = CGRectMake(0, 0, self.view.frame.size.width, 100);
    footerView.backgroundColor = [UIColor clearColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(12, 20, self.tableView.frame.size.width - 24, 44);
    btn.backgroundColor = LLHexColor(0x00a0e9);
    [btn addTarget:self action:@selector(pay) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius = 5;
    [btn setTitle:@"立即支付" forState:UIControlStateNormal];
    [footerView addSubview:btn];
    
    return footerView;
}

#pragma mark - Getter/Setter

- (UITableView *)tableView {
    if (!_tableView ) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.tableFooterView = [self tableFooterView];
        _tableView.tableHeaderView = [self tableHeaderView];
    }
    return _tableView;
}

- (NSArray *)bankArr {
    if (!_bankArr) {
        NSString *bundlePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: @"walletResources.bundle"];
        NSBundle *sdkBundle = [NSBundle bundleWithPath: bundlePath];
        NSString *path = [sdkBundle pathForResource:@"LLBankList" ofType:@"plist"];
        _bankArr = [NSArray arrayWithContentsOfFile:path];
    }
    return _bankArr;
}



@end

//
//  MSUAboutController.m
//  vvlc
//
//  Created by 007 on 2018/4/19.
//  Copyright © 2018年 HM. All rights reserved.
//

#import "MSUAboutController.h"

#import "MSUPathTools.h"
#import "MSUAboutTableCell.h"
#import "MSUWebController.h"
#import "WebViewController.h"

@interface MSUAboutController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , strong) NSArray *dataArr;

@end

@implementation MSUAboutController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"关于我们";
    self.view.backgroundColor = HEXCOLOR(0xF0F0F0);
    self.dataArr = @[@"官方网站",@"了解微米",@"信息披露",@"客服热线"];
    
    [self creatCneterView];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 视图相关
- (void)creatCneterView{
    UIImageView *imaView = [[UIImageView alloc] initWithFrame:CGRectMake(kDeviceWidth*0.5-65*0.5, 35, 65, 65)];
    imaView.image = [UIImage imageNamed:@"centeriocn"];
    imaView.clipsToBounds = YES;
    imaView.layer.cornerRadius = 14.5;
    imaView.layer.shouldRasterize = YES;
    imaView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    [self.view addSubview:imaView];
    
    UILabel *styleLab = [[UILabel alloc] init];
    styleLab.frame = CGRectMake(0, imaView.bottom + 8, kDeviceWidth, 21);
    styleLab.text = @"千万级风投";
    styleLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    styleLab.textAlignment = NSTextAlignmentCenter;
    styleLab.textColor = HEXCOLOR(0x454545);
    [self.view addSubview:styleLab];
    
    UILabel *safeLab = [[UILabel alloc] init];
    safeLab.frame = CGRectMake(0, styleLab.bottom , kDeviceWidth, 21);
    safeLab.text = @"最安全的票据理财平台";
    safeLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    safeLab.textAlignment = NSTextAlignmentCenter;
    safeLab.textColor = HEXCOLOR(0x454545);
    [self.view addSubview:safeLab];
    
    UILabel *versionLab = [[UILabel alloc] init];
    versionLab.frame = CGRectMake(0, safeLab.bottom+8 , kDeviceWidth, 20);
    versionLab.text = [NSString stringWithFormat:@"版本号 V%@",[MSUPathTools getInfoFromPhone:MSUPhoneAppVersion]];
    versionLab.font = [UIFont systemFontOfSize:14];
    versionLab.textAlignment = NSTextAlignmentCenter;
    versionLab.textColor = HEXCOLOR(0x939393);
    [self.view addSubview:versionLab];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 213, kDeviceWidth, 220) style:UITableViewStylePlain];
    _tableView.backgroundColor = WhiteColor;
    _tableView.scrollEnabled = YES;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.scrollEnabled = NO;
    [self.view addSubview:_tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.panGestureRecognizer.delaysTouchesBegan = self.tableView.delaysContentTouches;
    _tableView.rowHeight = 55;
    [_tableView registerClass:[MSUAboutTableCell class] forCellReuseIdentifier:@"MSUAboutTableCell"];
    if (iOS11) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    

    
}

#pragma mark - 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MSUAboutTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MSUAboutTableCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.leftLab.text = self.dataArr[indexPath.row];
    cell.rightLab.hidden = YES;
    if (indexPath.row == 0) {
        cell.rightLab.hidden = NO;
        cell.rightLab.text = @"www.vimzx.com";
    } else if (indexPath.row == 3){
        cell.rightLab.hidden = NO;
        cell.rightLab.text = @"400-0571-115";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
//            NSString*url =@"http://www.vimzx.com";
////            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url]];
//            
//            WebViewController *webVC = [[WebViewController alloc] init];
//            webVC.UrlString = url;
//            webVC.title = @"官方网站";
//            webVC.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:webVC animated:YES];
        }
            break;
        case 1:
        {
            MSUWebController *web = [[MSUWebController alloc] init];
            web.hidesBottomBarWhenPushed = YES;
            web.titStr = @"了解微米";
            web.numStr = @"1";
            [self.navigationController pushViewController:web animated:YES];
        }
            break;
        case 2:
        {
            MSUWebController *web = [[MSUWebController alloc] init];
            web.hidesBottomBarWhenPushed = YES;
            web.titStr = @"信息披露";
            web.numStr = @"2";
            [self.navigationController pushViewController:web animated:YES];
        }
            break;
        case 3:
        {
            NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"400-0571-115"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
            break;
        default:
            break;
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

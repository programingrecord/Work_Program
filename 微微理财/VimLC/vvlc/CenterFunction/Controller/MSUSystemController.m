//
//  MSUSystemController.m
//  vvlc
//
//  Created by 007 on 2018/6/26.
//  Copyright © 2018年 HM. All rights reserved.
//

#import "MSUSystemController.h"

#import "ManagerTableViewCell.h"

#import "MSUStringTools.h"
#import "MSUPathTools.h"

@interface MSUSystemController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic,strong)NSArray *leftTitleArr;
@property (nonatomic,strong)NSArray *rightTitleArr;

@end

@implementation MSUSystemController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"系统检测";
    self.view.backgroundColor = HEXCOLOR(0xe8e8e8);
    
    [self getData];

    [self createCenterTab];
}

- (void)getData{
    self.leftTitleArr = @[@"注册编号",@"时间",@"版本号",@"屏幕分辨率",@"手机型号",@"操作版本"];
    
    if ([MSUStringTools isBlankString:self.registNum]) {
        self.registNum = [NSString stringWithFormat:@"%@",@"无"];
    }
    
    NSString *fenbian = [NSString stringWithFormat:@"%.0f*%.0f",kDeviceWidth,kDeviceHeight];
    
    self.rightTitleArr = @[self.registNum,[MSUStringTools getNDay:0],[MSUPathTools getInfoFromPhone:MSUPhoneAppVersion],fenbian,[MSUPathTools getInfoFromPhone:MSUPhonePlatform],[MSUPathTools getInfoFromPhone:MSUPhoneSystemVersion]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)createCenterTab{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 300*kDeviceHeightScale) style:UITableViewStylePlain];
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
    
    UILabel *phoneLab = [[UILabel alloc] init];
    phoneLab.frame = CGRectMake(0, _tableView.bottom + 112*kDeviceHeightScale, kDeviceWidth, 20*kDeviceHeightScale);
    phoneLab.text = @"温馨提示";
    phoneLab.font = [UIFont systemFontOfSize:16];
    phoneLab.textAlignment = NSTextAlignmentCenter;
    phoneLab.textColor = HEXCOLOR(0x939393);
    [self.view addSubview:phoneLab];
    
    UILabel *bottomLab = [[UILabel alloc] init];
    bottomLab.frame = CGRectMake(35, phoneLab.bottom + 10*kDeviceHeightScale, kDeviceWidth-70, 50*kDeviceHeightScale);
    bottomLab.text = @"当客户端出现问题，可将此界面截图发送客服。提供的信息有利于我们即时找到问题，感谢您的配合！";
    bottomLab.font = [UIFont systemFontOfSize:13];
    bottomLab.numberOfLines = 0;
    bottomLab.textAlignment = NSTextAlignmentCenter;
    bottomLab.textColor = HEXCOLOR(0x939393);
    [self.view addSubview:bottomLab];
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
    
    cell.rightImage.hidden = YES;
    cell.leftTitle.text = self.leftTitleArr[indexPath.row];
    if (indexPath.row == _leftTitleArr.count-1) {
        cell.BottomLineViewLeft.constant = 0;
    }else{
        cell.BottomLineViewLeft.constant = 10;
    }
    cell.rightTltle.text = self.rightTitleArr[indexPath.row];
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  MSUAddAdressController.m
//  vvlc
//
//  Created by 007 on 2018/6/26.
//  Copyright © 2018年 HM. All rights reserved.
//

#import "MSUAddAdressController.h"

#import "MSUAdressCell.h"

#import "MSUStringTools.h"

@interface MSUAddAdressController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) UITableView *tableView;

@end

@implementation MSUAddAdressController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"收货地址";
    self.view.backgroundColor = HEXCOLOR(0xe8e8e8);
    
    [self createCenterTable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createCenterTable{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-155*kDeviceHeightScale) style:UITableViewStylePlain];
    _tableView.backgroundColor = BGWhiteColor;
    _tableView.scrollEnabled = YES;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.panGestureRecognizer.delaysTouchesBegan = self.tableView.delaysContentTouches;
    _tableView.rowHeight = 107*kDeviceHeightScale;
    [_tableView registerClass:[MSUAdressCell class] forCellReuseIdentifier:@"MSUAdressCell"];
    if (iOS11) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(17,kDeviceHeight-145*kDeviceHeightScale, kDeviceWidth-34, 44*kDeviceHeightScale);
    addBtn.backgroundColor = HEXCOLOR(0xFF6339);
    addBtn.layer.cornerRadius = 4;
    addBtn.clipsToBounds = YES;
    addBtn.layer.shouldRasterize = YES;
    addBtn.layer.rasterizationScale = [UIScreen mainScreen].scale;
    [addBtn setTitle:@"╉ 添加新地址" forState:UIControlStateNormal];
    [addBtn setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
    addBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    [self.view addSubview:addBtn];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MSUAdressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MSUAdressCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.nameLab.text = @"纯白白白";
    cell.phoneLab.text = @"15088663580";
    cell.adressLab.text = @"浙江省杭州市西湖风景区美哉美城家园";
    CGRect recta = [MSUStringTools danamicGetHeightFromText:cell.adressLab.text WithWidth:238*kDeviceWidthScale font:14];
    cell.adressLab.frame = CGRectMake(15, 50*kDeviceHeightScale, 238*kDeviceWidthScale, recta.size.height);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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

//
//  MSUMessageController.m
//  vvlc
//
//  Created by 007 on 2018/5/29.
//  Copyright © 2018年 HM. All rights reserved.
//

#import "MSUMessageController.h"

#import "MSUMessageTableCell.h"
#import "MSUPathTools.h"

@interface MSUMessageController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic , strong) UIView *redView;

@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , strong) NSArray *dataArr;

@property (nonatomic , strong) UIView *centerView;


@end

@implementation MSUMessageController

- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = WhiteColor;
    
    [self createNaviView];
    [self createCenterView];
    
    self.centerView.hidden = YES;
    if (self.dataArr.count == 0) {
        self.centerView.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)createNaviView{
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(0, 20, kDeviceWidth, 44*kDeviceHeightScale);
    bgView.backgroundColor = HEXCOLOR(0xffffff);
    [self.view addSubview:bgView];
    
    NSArray *arr = @[@"提醒",@"平台公告"];
    for (NSInteger i = 0; i < arr.count; i++) {
        UIButton *naviBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        naviBtn.frame = CGRectMake(kDeviceWidth*0.5-72-20+112*i,20+ 8.5*kDeviceHeightScale, 72, 25*kDeviceHeightScale);
        [naviBtn setTitle:arr[i] forState:UIControlStateNormal];
        [naviBtn setTitleColor:HEXCOLOR(0x454545) forState:UIControlStateNormal];
        naviBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
        naviBtn.tag = 216+i;
        [self.view addSubview:naviBtn];
        [naviBtn addTarget:self action:@selector(naviBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    self.redView = [[UIView alloc] init];
    _redView.frame = CGRectMake(kDeviceWidth*0.5-20-72,20+ 41.5*kDeviceHeightScale, 72, 3);
    _redView.backgroundColor = HEXCOLOR(0xFF623F);
    [self.view addSubview:_redView];
    
    UIImageView *imaView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 11*kDeviceHeightScale, 20*kDeviceHeightScale, 20*kDeviceHeightScale)];
    imaView.image = [MSUPathTools showImageWithContentOfFileByName:@"nav_icon_back_nor"];
    imaView.contentMode = UIViewContentModeScaleAspectFit;
    [bgView addSubview:imaView];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 40, 44*kDeviceHeightScale);
    [bgView addSubview:btn];
    [btn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)createCenterView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20+44*kDeviceHeightScale, kDeviceWidth, kDeviceHeight) style:UITableViewStylePlain];
    _tableView.backgroundColor = HEXCOLOR(0xf3f3f3);
    _tableView.scrollEnabled = YES;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    _tableView.emptyDataSetSource = self;
    _tableView.emptyDataSetDelegate = self;
    self.tableView.panGestureRecognizer.delaysTouchesBegan = self.tableView.delaysContentTouches;
    _tableView.rowHeight = 130*kDeviceHeightScale;
    [_tableView registerClass:[MSUMessageTableCell class] forCellReuseIdentifier:@"MSUMessageTableCell"];
    if (iOS11) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

#pragma mark - 点击
- (void)naviBtnClick:(UIButton *)sender{
    [UIView animateWithDuration:0.25 animations:^{
        _redView.frame = CGRectMake(kDeviceWidth*0.5-20-72+112*(sender.tag-216),20 + 41.5*kDeviceHeightScale, 72, 3);
    }];
}

- (void)backBtnClick:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MSUMessageTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MSUMessageTableCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = HEXCOLOR(0xf3f3f3);
    
    cell.titLab.text = @"四月活动";
    cell.contentLab.text = @"微米在线叽里呱啦叽里呱啦叽里呱啦叽里呱啦微米在线叽里呱啦叽里呱啦叽里呱啦叽里呱啦叽里呱微米在线叽里呱啦叽里呱啦叽里呱啦叽里呱啦微米在线叽里呱啦叽里呱啦叽里呱啦叽里呱啦叽里呱里";
    cell.timeLab.text = @"2018.5.5  12:56";
    
    return cell;
}

- (UIView *)centerView{
    if (!_centerView) {
        self.centerView = [[UIView alloc] initWithFrame:CGRectMake(0, kDeviceHeight*0.5-64-40, kDeviceWidth, 150)];
        [self.view addSubview:_centerView];
        
        UIImageView *imaView = [[UIImageView alloc] initWithFrame:CGRectMake(kDeviceWidth*0.5-125*0.5, 0, 125, 90)];
        imaView.image = [MSUPathTools showImageWithContentOfFileByName:@"xx"];
        [_centerView addSubview:imaView];
        
        UILabel *attentionLab = [[UILabel alloc] init];
        attentionLab.frame = CGRectMake(0, imaView.bottom + 20, kDeviceWidth, 20);
        attentionLab.text = @"暂时还没有消息哦";
        attentionLab.font = [UIFont systemFontOfSize:15];
        attentionLab.textAlignment = NSTextAlignmentCenter;
        attentionLab.textColor = HEXCOLOR(0x9B9B9B);
        [_centerView addSubview:attentionLab];
        
        
    }
    return _centerView;
}

@end

//
//  MSUTestFirstController.m
//  vvlc
//
//  Created by 007 on 2018/2/5.
//  Copyright © 2018年 HM. All rights reserved.
//

#import "MSUTestFirstController.h"
#import "MSUTestSecondController.h"

#import "MSUTestAnswerTableCell.h"

#import "MSUStringTools.h"

@interface MSUTestFirstController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , strong) NSArray *dataArr;

//@property (nonatomic , strong) UILabel *topLab;

@property (nonatomic , assign) NSInteger index;

@end

@implementation MSUTestFirstController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"风险测评";
    self.view.backgroundColor = WhiteColor;
    
    self.index = 1;
    self.dataArr = @[@"A.18-30岁",@"B.31-50岁",@"C.51-65岁",@"D.高于65岁"];
    
    [self createCenterUI];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UI
- (void)createCenterUI{
    UILabel *_topLab = [[UILabel alloc] init];
    _topLab.frame = CGRectMake(kDeviceWidth*0.5-139*0.5, 20*kDeviceHeightScale, 139, 36);
    _topLab.text = @"基本信息";
    _topLab.backgroundColor = BGRedColor;
    _topLab.clipsToBounds = YES;
    _topLab.layer.cornerRadius = 17;
    _topLab.layer.shouldRasterize = YES;
    _topLab.layer.rasterizationScale = [UIScreen mainScreen].scale;
    _topLab.font = [UIFont systemFontOfSize:16];
    _topLab.textColor =titRedColor;
    _topLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_topLab];
    
    UILabel *titLab = [[UILabel alloc] init];
    titLab.frame = CGRectMake(36*kDeviceWidthScale,_topLab.bottom+ 23.5*kDeviceHeightScale, 100, 45);
    titLab.font = [UIFont systemFontOfSize:32];
    titLab.textColor = HEXCOLOR(0xff4b1f);
    titLab.attributedText = [MSUStringTools makeKeyWordAttributedWithSubText:@"/13" inOrigiText:@"1/13" font:12 color:HEXCOLOR(0xFFDCD2)];
    [self.view addSubview:titLab];
    
    UILabel *quesLab = [[UILabel alloc] init];
    quesLab.frame = CGRectMake(titLab.left,titLab.bottom + 5*kDeviceHeightScale, 200, 25);
    quesLab.text = @"您的年龄介于?";
    quesLab.font = [UIFont systemFontOfSize:18];
    quesLab.textColor = BlackColor;
    [self.view addSubview:quesLab];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,quesLab.bottom+ 20*kDeviceHeightScale, kDeviceWidth, 200) style:UITableViewStylePlain];
    _tableView.backgroundColor = BGWhiteColor;
    _tableView.scrollEnabled = YES;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.scrollEnabled = NO;
    [self.view addSubview:_tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.panGestureRecognizer.delaysTouchesBegan = self.tableView.delaysContentTouches;
    _tableView.rowHeight = 50;
    [_tableView registerClass:[MSUTestAnswerTableCell class] forCellReuseIdentifier:@"MSUTestAnswerTableCell"];
//    if (iOS11) {
//        _CenterTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    } else{
//        self.automaticallyAdjustsScrollViewInsets = NO;
//    }
    
//    UIButton *beforeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    beforeBtn.frame = CGRectMake(0, kDeviceHeight-34-49, kDeviceWidth, 49);
//    [beforeBtn setTitle:@"上一题" forState:UIControlStateNormal];
//    beforeBtn.backgroundColor = WhiteColor;
//    [beforeBtn setTitleColor:BGRedColor forState:UIControlStateNormal];
//    beforeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
//    [self.view addSubview:beforeBtn];
//    [beforeBtn addTarget:self action:@selector(beforeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MSUTestAnswerTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MSUTestAnswerTableCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = WhiteColor;

    cell.anwserLab.text = self.dataArr[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MSUTestAnswerTableCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = HEXCOLOR(0xffece7);
    
    MSUTestSecondController *second = [[MSUTestSecondController alloc] init];
    second.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:second animated:YES];
    
//    self.index++;
//    MyLog(@"----%ld",self.index);
//    
//    [UIView animateWithDuration:0.25 animations:^{
//        self.dataArr = @[@"高中及以下",@"中专或大专",@"本科",@"硕士及以上"];
//        [self.tableView reloadData];
//        cell.backgroundColor = WhiteColor;
//    }];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    MSUTestAnswerTableCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = WhiteColor;
}


#pragma mark - 点击事件
//- (void)beforeBtnClick:(UIButton *)sender{
//    self.index--;
//    self.dataArr = @[@"A.18-30岁",@"B.31-50岁",@"C.51-65岁",@"D.高于65岁"];
//    [self.tableView reloadData];
//
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

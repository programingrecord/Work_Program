//
//  MSUTestEightController.m
//  vvlc
//
//  Created by 007 on 2018/2/5.
//  Copyright © 2018年 HM. All rights reserved.
//

#import "MSUTestEightController.h"
#import "MSUTestNineController.h"

#import "MSUTestAnswerTableCell.h"

#import "MSUStringTools.h"

@interface MSUTestEightController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , strong) NSArray *dataArr;

@end

@implementation MSUTestEightController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"风险测评";
    self.view.backgroundColor = WhiteColor;
    
    self.dataArr = @[@"A.少于2年",@"B.2年-5年",@"C.5年-10年",@"D.10年以上"];
    
    [self createCenterUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UI
- (void)createCenterUI{
    
    UILabel *titLab = [[UILabel alloc] init];
    titLab.frame = CGRectMake(36*kDeviceWidthScale, 20*kDeviceHeightScale, 100, 45);
    titLab.font = [UIFont systemFontOfSize:32];
    titLab.textColor = HEXCOLOR(0xff4b1f);
    titLab.attributedText = [MSUStringTools makeKeyWordAttributedWithSubText:@"/13" inOrigiText:@"8/13" font:12 color:HEXCOLOR(0xFFDCD2)];
    [self.view addSubview:titLab];
    
    UILabel *quesLab = [[UILabel alloc] init];
    quesLab.text = @"您有多少年投资基金、股票、信托、私募证券或金融衍生产品等风险投资品的经验?";
    CGRect rectA = [MSUStringTools danamicGetHeightFromText:quesLab.text WithWidth:kDeviceWidth-72*kDeviceWidthScale font:18];
    quesLab.frame = CGRectMake(titLab.left,titLab.bottom + 5*kDeviceHeightScale, kDeviceWidth-72*kDeviceWidthScale, rectA.size.height);
    quesLab.numberOfLines = 0;
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
    
    UIButton *beforeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    beforeBtn.frame = CGRectMake(0, kDeviceHeight-34-22.5-64, kDeviceWidth, 22.5);
    [beforeBtn setTitle:@"上一题" forState:UIControlStateNormal];
    beforeBtn.backgroundColor = WhiteColor;
    [beforeBtn setTitleColor:HEXCOLOR(0xff4b1f) forState:UIControlStateNormal];
    beforeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:beforeBtn];
    [beforeBtn addTarget:self action:@selector(beforeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MSUTestAnswerTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MSUTestAnswerTableCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.anwserLab.text = self.dataArr[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MSUTestAnswerTableCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = HEXCOLOR(0xffece7);
    
    MSUTestNineController *second = [[MSUTestNineController alloc] init];
    second.hidesBottomBarWhenPushed = YES;
    second.answerCode = self.answerCode;
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
- (void)beforeBtnClick:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
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

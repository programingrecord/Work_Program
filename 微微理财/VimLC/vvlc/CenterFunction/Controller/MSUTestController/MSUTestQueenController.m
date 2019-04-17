//
//  MSUTestQueenController.m
//  vvlc
//
//  Created by 007 on 2018/2/5.
//  Copyright © 2018年 HM. All rights reserved.
//

#import "MSUTestQueenController.h"
#import "MSUTestJokerController.h"

#import "MSUTestAnswerTableCell.h"

#import "MSUStringTools.h"

@interface MSUTestQueenController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , strong) NSArray *dataArr;

@property (nonatomic , assign) CGFloat cellHeight;

@end

@implementation MSUTestQueenController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"风险测评";
    self.view.backgroundColor = WhiteColor;
    
    self.dataArr = @[@"A.全部投资于收益较小且风险较小的A",@"B同时投资于A和B，但是大部分资金投资于收益较小且风险较小的A",@"C.同时投资于A和B，但是大部分资金投资于收益较大且风险较大的B",@"D.全部投资于收益较大且风险较大的B"];
    
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
    titLab.attributedText = [MSUStringTools makeKeyWordAttributedWithSubText:@"/13" inOrigiText:@"12/13" font:12 color:HEXCOLOR(0xFFDCD2)];
    [self.view addSubview:titLab];
    
    UILabel *quesLab = [[UILabel alloc] init];
    quesLab.text = @"假设有两种投资：投资A预期获得10%的收益，可能承担的损失非常小；投资B预期获得30%的收益，但可能承担较大亏损。您会怎么支配您的投资：";
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.cellHeight > 0) {
        return self.cellHeight;
    } else{
        return 50;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MSUTestAnswerTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MSUTestAnswerTableCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.anwserLab.text = self.dataArr[indexPath.row];
    CGRect rectA = [MSUStringTools danamicGetHeightFromText:cell.anwserLab.text WithWidth:kDeviceWidth-72*kDeviceWidthScale font:18];
    cell.anwserLab.frame = CGRectMake(36*kDeviceWidthScale, 13.5, kDeviceWidth-72*kDeviceWidthScale, rectA.size.height);
    
    cell.lineView.frame = CGRectMake(cell.anwserLab.left, cell.anwserLab.bottom + 12.5, kDeviceWidth-72*kDeviceWidthScale, 1);
    
    
    self.cellHeight = cell.anwserLab.bottom + 13.5;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MSUTestAnswerTableCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = HEXCOLOR(0xffece7);
    
    MSUTestJokerController *second = [[MSUTestJokerController alloc] init];
    second.hidesBottomBarWhenPushed = YES;
    second.answerCode = self.answerCode + indexPath.row + 1;
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

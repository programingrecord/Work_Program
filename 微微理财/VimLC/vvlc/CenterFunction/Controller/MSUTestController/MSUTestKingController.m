//
//  MSUTestKingController.m
//  vvlc
//
//  Created by 007 on 2018/2/5.
//  Copyright © 2018年 HM. All rights reserved.
//

#import "MSUTestKingController.h"
#import "MSUTestQueenController.h"

#import "MSUTestAnswerTableCell.h"

#import "MSUStringTools.h"

@interface MSUTestKingController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , strong) NSArray *dataArr;

@property (nonatomic , assign) CGFloat cellHeight;


@end

@implementation MSUTestKingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"风险测评";
    self.view.backgroundColor = WhiteColor;
    
    self.dataArr = @[@"A.厌恶风险，不希望本金损失，希望获得稳定回报",@"B.保守投资，不希望本金损失，愿意承担一定幅度的收益波动",@"C.寻求资金的较高收益和成长性，愿意为此承担有限本金损失",@"D.希望赚取高回报，愿意为此承担较大本金损失"];
    
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
    _topLab.text = @"财务状况";
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
    titLab.attributedText = [MSUStringTools makeKeyWordAttributedWithSubText:@"/13" inOrigiText:@"11/13" font:12 color:HEXCOLOR(0xFFDCD2)];
    [self.view addSubview:titLab];
    
    UILabel *quesLab = [[UILabel alloc] init];
    quesLab.frame = CGRectMake(titLab.left,titLab.bottom + 5*kDeviceHeightScale, kDeviceWidth, 25);
    quesLab.text = @"以下哪项描述最符合您的投资态度？";
    quesLab.font = [UIFont systemFontOfSize:18];
    quesLab.textColor = BlackColor;
    [self.view addSubview:quesLab];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,quesLab.bottom+ 20*kDeviceHeightScale, kDeviceWidth, 300) style:UITableViewStylePlain];
    _tableView.backgroundColor = WhiteColor;
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
    return self.dataArr.count;
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
    
    MSUTestQueenController *second = [[MSUTestQueenController alloc] init];
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

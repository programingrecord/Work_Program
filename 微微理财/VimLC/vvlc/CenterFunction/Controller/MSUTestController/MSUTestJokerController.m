//
//  MSUTestJokerController.m
//  vvlc
//
//  Created by 007 on 2018/2/5.
//  Copyright © 2018年 HM. All rights reserved.
//

#import "MSUTestJokerController.h"
#import "MSUTestCompleteController.h"

#import "MSUTestAnswerTableCell.h"

#import "MSUStringTools.h"

@interface MSUTestJokerController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , strong) NSArray *dataArr;

@property (nonatomic , assign) NSInteger finalCode;


@end

@implementation MSUTestJokerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"风险测评";
    self.view.backgroundColor = WhiteColor;
    
    self.dataArr = @[@"A.10%以内",@"B.10%-30%",@"C.30%-50%",@"D.超过50%"];
    
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
    titLab.attributedText = [MSUStringTools makeKeyWordAttributedWithSubText:@"/13" inOrigiText:@"13/13" font:12 color:HEXCOLOR(0xFFDCD2)];
    [self.view addSubview:titLab];
    
    UILabel *quesLab = [[UILabel alloc] init];
    quesLab.text = @"您认为自己能承受的最大投资损失是多少？";
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
    
    UILabel *shengLab = [[UILabel alloc] init];
    shengLab.text = @"声明:本人已如实填写《投资者风险问卷调查》，并了解自己的风险承受类型和适合的产品类型";
    CGRect rectB = [MSUStringTools danamicGetHeightFromText:shengLab.text WithWidth:kDeviceWidth-72*kDeviceWidthScale font:12];
    shengLab.frame = CGRectMake(titLab.left,_tableView.bottom + 31.5*kDeviceHeightScale, kDeviceWidth-72*kDeviceWidthScale, rectB.size.height);
    shengLab.numberOfLines = 0;
    shengLab.font = [UIFont systemFontOfSize:12];
    shengLab.textColor = HEXCOLOR(0xfe9a80);
    [MSUStringTools changeLineSpaceForLabel:shengLab WithSpace:5];
    [self.view addSubview:shengLab];
    
    UIButton *pushBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    pushBtn.frame = CGRectMake(36*kDeviceWidthScale, kDeviceHeight-22-49-64, kDeviceWidth-72*kDeviceWidthScale, 49);
    pushBtn.clipsToBounds = YES;
    pushBtn.layer.cornerRadius = 49*0.5;
    pushBtn.layer.shouldRasterize = YES;
    pushBtn.layer.rasterizationScale = [UIScreen mainScreen].scale;
    pushBtn.backgroundColor = HEXCOLOR(0xfb6337);
    [pushBtn setTitle:@"提交" forState:UIControlStateNormal];
    [pushBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
    pushBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:pushBtn];
    [pushBtn addTarget:self action:@selector(pushBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *beforeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    beforeBtn.frame = CGRectMake(0, pushBtn.top-20-22.5, kDeviceWidth, 22.5);
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
    
    self.finalCode = self.answerCode + indexPath.row + 1;

    
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

- (void)pushBtnClick:(UIButton *)sender{
    if (self.finalCode > 0) {
        MSUTestCompleteController *com = [[MSUTestCompleteController alloc] init];
        com.answerCode = self.finalCode;
        com.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:com animated:YES];
    } else{
        [AddHudView addProgressView:self.view message:@"您尚未选择答案,请选择您的答案"];
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

//
//  TradeTypeViewController.m
//  SmallCat
//
//  Created by H on 2017/5/4.
//  Copyright © 2017年 HM. All rights reserved.
//

#import "TradeTypeViewController.h"

@interface TradeTypeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSArray *TypeArr;
@property (nonatomic,strong) UITableView *TypeTableView;
@end

@implementation TradeTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"交易类型";
    self.TypeArr = @[@"全部",@"线上充值",@"提现",@"投标成功",@"收款",@"投标奖励",@"利息管理费",@"推荐奖励"];
    [self addUIView];
}

- (void)addUIView{
    self.view.backgroundColor = [UIColor colorWithHex:0xF5F5F9];
    self.TypeTableView  = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kNavigationBarHeight-kStatusBarHeight) style:UITableViewStylePlain];
    self.TypeTableView.delegate = self;
    self.TypeTableView.dataSource = self;
    self.TypeTableView.backgroundColor = [UIColor clearColor];
    self.TypeTableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:self.TypeTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.TypeArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indetifier = @"TYPECELL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indetifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indetifier];
    }
    cell.textLabel.text = self.TypeArr[indexPath.row];
    cell.textLabel.font = TEXTFONT(15);
    cell.textLabel.textColor = [UIColor colorWithHex:0x333333];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    if (indexPath.row < self.TypeArr.count-1) {
        cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    }else{
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.Block) {
        self.Block(indexPath.row,self.TypeArr[indexPath.row]);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

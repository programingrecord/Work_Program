//
//  WelfareViewController.m
//  SmallCat
//
//  Created by H on 2017/6/6.
//  Copyright © 2017年 HM. All rights reserved.
//

#import "WelfareViewController.h"
#import "WelfareTableViewCell.h"
#import "WebViewController.h"


@interface WelfareViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *WelfareListView;
@property (nonatomic,strong) NSMutableArray *DataListArr;
@end

@implementation WelfareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"福利";
    
    UITapGestureRecognizer *oneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    oneTap.delegate = self;
    oneTap.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:oneTap];
    
    
    self.DataListArr = [[NSMutableArray alloc] init];
    self.WelfareListView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getDataRefresh:YES];
    }];
    self.WelfareListView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    
    [self getDataRefresh:NO];
}

#pragma mark - 请求数据
- (void)getDataRefresh:(BOOL)isRefresh{
    
    if (!isRefresh) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    [[DataRequestServer getDataRequestServerData] request:@"LunaP2pAppActivityServlet" parameters:nil result:^(id result) {
        if (isRefresh) {
            [self.WelfareListView.mj_header endRefreshing];
            
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
        
        if ([result isKindOfClass:[NSString class]] &&  [result isEqualToString:@"44"]) {
            [AddHudView addProgressView:self.view message:@"网络错误，请稍后再试"];
        }else{
            
            int success = [[result objectForKey:@"success"]intValue];

            if ([[result objectForKey:@"error"]isEqualToString:@""]&& success==1)
            {
                if (self.DataListArr.count >0 ) {
                    [self.DataListArr removeAllObjects];
                }
                
                NSArray *array = [[NSArray alloc] initWithArray:result[@"items"]];
                for (int i = 0; i<array.count; i++) {
                    NSDictionary *dict = [array objectAtIndex:i];
                    
                    WelfareModel *model =[[WelfareModel alloc] init];
                    model.imageAddress =[NSString stringWithFormat:@"%@",[dict objectForKey:@"imageAddress"]];
                    model.imageUrl =[NSString stringWithFormat:@"%@",[dict objectForKey:@"imageUrl"]];
                    
                    [self.DataListArr addObject:model];
                }
                [self.WelfareListView reloadData];

            }else{
                [AddHudView addProgressView:self.view message:@"获取数据失败，请稍后再试"];
            }
        }
    }];
}

#pragma mark - 代理
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.DataListArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WelfareTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"WelfareTableViewCell"];
    if (!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"WelfareTableViewCell" bundle:nil] forCellReuseIdentifier:@"WelfareTableViewCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"WelfareTableViewCell"];
    }
    
    
    WelfareModel *model =[self.DataListArr objectAtIndex:indexPath.row];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WelfareModel *model =[self.DataListArr objectAtIndex:indexPath.row];
    WebViewController *VC= [[WebViewController alloc] init];
    VC.UrlString = model.imageAddress;
    VC.title = @"福利";
    [self.navigationController pushViewController:VC animated:YES];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kDeviceWidth*3/5;
}

-(UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    return [UIImage imageNamed:@"Date_Empty"];
}

-(NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *text = nil;
    UIFont *font = nil;
    UIColor *textColor = nil;
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    
    text = @"暂时木有福利呀~~";
    font = [UIFont systemFontOfSize:16];
    textColor = [UIColor colorWithHex:0xb0b0b0];
    
    if (!text) {
        return nil;
    }
    if (font) {
        [attributes setObject:font forKey:NSFontAttributeName];
    }
    if (textColor) {
        [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    }
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView{
    return  YES;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view{
    [self.WelfareListView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}

- (void)hideKeyBoard{
    
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

@implementation WelfareModel



@end

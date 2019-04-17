//
//  BankLimitViewController.m
//  vvlc
//
//  Created by 慧明 on 2017/10/31.
//  Copyright © 2017年 HM. All rights reserved.
//

#import "BankLimitViewController.h"
#import "BankLimitTableViewCell.h"
#import "BankLimitModel.h"
#import "MSUBankLimitTableCell.h"

#import "AddCardViewController.h"

#import "MSUStringTools.h"

@interface BankLimitViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *TableView;
@property (strong, nonatomic)  NSMutableArray *DataArr;

@property (strong, nonatomic)  NSMutableArray *nameArr;;
@property (nonatomic , strong) NSArray *bankArr;

@end

@implementation BankLimitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支持银行";
    self.DataArr = [[NSMutableArray alloc] init];
    self.nameArr = [[NSMutableArray alloc] init];
    self.bankArr = @[@"中国工商银行",@"中国农业银行",@"中国建设银行",@"招商银行"];
    
    [self requestBankLimitData];
    self.TableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestBankLimitData];
    }];
    self.TableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.TableView.tableHeaderView = [self createHeadView];
}

- (UIView *)createHeadView{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth,12)];
    
//    UILabel *TipLable = [[UILabel alloc] initWithFrame:CGRectMake(12,0, kDeviceWidth-24, 32)];
//    TipLable.font = TEXTFONT(12);
//    TipLable.text = @"限额仅供参考";
//    TipLable.adjustsFontSizeToFitWidth = YES;
//    TipLable.textColor = [UIColor colorWithHex:0x727272];
//    [headView addSubview:TipLable];
    return headView;
}

- (void)requestBankLimitData{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"1" forKey:@"FuYouType"];
    
    [[DataRequestServer getDataRequestServerData] request:@"LunaP2pAppBankLimitServlet" parameters:dic result:^(id result) {
        [self.TableView.mj_header endRefreshing];
        if ([result isKindOfClass:[NSString class]] &&  [result isEqualToString:@"44"]) {
            [AddHudView addProgressView:self.view message:@"获取银行卡限额失败，请重新刷新"];
        }else if ([[result objectForKey:@"success"]intValue]==1 && [[result objectForKey:@"errorlog"]isEqualToString:@""]){
        
            if (self.DataArr.count>0) {
                [self.DataArr removeAllObjects];
            }
            
            if (self.nameArr.count > 0) {
                [self.nameArr removeAllObjects];
            }

//            NSArray *arr1 =[result objectForKey:@"items"];
//            for (NSDictionary *dic in arr1) {
//                BankLimitModel *model = [[BankLimitModel alloc] initWithContent:dic];
//                [self.DataArr addObject:model];
//            }
            
            NSMutableArray *arr =[[result objectForKey:@"items"] mutableCopy];
            
            for (NSInteger i = 0; i < arr.count; i++) {
                NSDictionary *dic = arr[i];
                NSString *iBankStr = [NSString stringWithFormat:@"%@",dic[@"bankName"]] ;
                
                if (![self.nameArr containsObject:iBankStr]) {
                    NSMutableDictionary *finalDic = [NSMutableDictionary dictionary];
                    for (NSInteger j = i + 1; j < arr.count ; j++) {
                        NSDictionary *jDic = arr[j];
                        NSString *jBankStr = [NSString stringWithFormat:@"%@",jDic[@"bankName"]] ;
                        
                        [finalDic setObject:dic[@"bankCode"] forKey:@"bankCode"];
                        [finalDic setObject:dic[@"bankIcon"] forKey:@"bankIcon"];
                        [finalDic setObject:dic[@"bankName"] forKey:@"bankName"];
                        
                        NSString *llStr;
                        NSString *fyStr;
                        
                        if ([iBankStr isEqualToString:jBankStr]) {
                            if ([[NSString stringWithFormat:@"%@",dic[@"disburse"]] isEqualToString:@"0"]) {
                                if ([[NSString stringWithFormat:@"%@",jDic[@"disburse"]] isEqualToString:@"0"]) {
                                    llStr = [NSString stringWithFormat:@"单笔%@万元,单日%@万元,单月%@万元(连连支付)",dic[@"singleAmt"],dic[@"dayAmt"],dic[@"monthAmt"]];
                                    fyStr = @"";
                                } else{
                                    llStr = [NSString stringWithFormat:@"单笔%@万元,单日%@万元,单月%@万元(连连支付)",dic[@"singleAmt"],dic[@"dayAmt"],dic[@"monthAmt"]];
                                    fyStr = [NSString stringWithFormat:@"单笔%@万元,单日%@万元,单月%@万元(富友支付)",jDic[@"singleAmt"],jDic[@"dayAmt"],jDic[@"monthAmt"]];
                                    
                                }
                               
                            } else{
                                if ([[NSString stringWithFormat:@"%@",jDic[@"disburse"]] isEqualToString:@"0"]) {
                                    fyStr = [NSString stringWithFormat:@"单笔%@万元,单日%@万元,单月%@万元(富友支付)",dic[@"singleAmt"],dic[@"dayAmt"],dic[@"monthAmt"]];
                                    llStr = [NSString stringWithFormat:@"单笔%@万元,单日%@万元,单月%@万元(连连支付)",jDic[@"singleAmt"],jDic[@"dayAmt"],jDic[@"monthAmt"]];
                                } else{
                                    llStr = [NSString stringWithFormat:@"单笔%@万元,单日%@万元,单月%@万元(富友支付)",jDic[@"singleAmt"],jDic[@"dayAmt"],jDic[@"monthAmt"]];
                                    fyStr = @"";
                                }
                                
                                
                            }
                            
                            [finalDic setObject:llStr forKey:@"llStr"];
                            [finalDic setObject:fyStr forKey:@"fyStr"];
                            
                            break;
                        } else{
                            if ([[NSString stringWithFormat:@"%@",dic[@"disburse"]] isEqualToString:@"0"]) {
                                llStr = [NSString stringWithFormat:@"单笔%@万元,单日%@万元,单月%@万元(连连支付)",dic[@"singleAmt"],dic[@"dayAmt"],dic[@"monthAmt"]];
                                fyStr = @"";
                            } else{
                                fyStr = [NSString stringWithFormat:@"单笔%@万元,单日%@万元,单月%@万元(富友支付)",dic[@"singleAmt"],dic[@"dayAmt"],dic[@"monthAmt"]];
                                llStr = @"";
                            }
                            [finalDic setObject:llStr forKey:@"llStr"];
                            [finalDic setObject:fyStr forKey:@"fyStr"];
                        }
                        
                    }
                    
                    [self.DataArr addObject:finalDic];
                    [self.nameArr addObject:iBankStr];
                }
                
            }
            [self.TableView reloadData];
        }else{
            [AddHudView addProgressView:self.view message:@"获取银行卡限额信息失败，请重新刷新"];
        }
    }];
}

#pragma mark - delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MSUBankLimitTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MSUBankLimitTableCell"];
    if (!cell)
    {
        cell = [[MSUBankLimitTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MSUBankLimitTableCell"];
        cell.selectionStyle = UITableViewCellEditingStyleNone;
    }
    NSDictionary *dic = self.DataArr[indexPath.row];
    
    cell.bankLab.text = [NSString stringWithFormat:@"%@",dic[@"bankName"]];
    CGSize sizea = [MSUStringTools danamicGetWidthFromText:cell.bankLab.text WithFont:16];
    cell.bankLab.frame = CGRectMake(44,17*kDeviceHeightScale, sizea.width, 15*kDeviceHeightScale);
    cell.signLab.frame = CGRectMake(cell.bankLab.right+8,17*kDeviceHeightScale, 95, 15*kDeviceHeightScale);

    if ([self.bankArr containsObject:cell.bankLab.text]) {
        cell.signLab.hidden = NO;
    } else{
        cell.signLab.hidden = YES;
    }
    [cell.bankImage sd_setImageWithURL:[NSURL URLWithString:dic[@"bankIcon"]] placeholderImage:[UIImage imageNamed:@"image_empty"]];
    
    NSString *str1 = dic[@"llStr"];
    NSString *str = dic[@"fyStr"];

    if (str1.length > 0) {
        if (str.length > 0) {
            cell.introLLLab.attributedText = [MSUStringTools makeKeyWordAttributedWithSubText:@"(连连支付)" inOrigiText:dic[@"llStr"] font:12 color:HEXCOLOR(0xFF9578)];
            cell.introFYLab.hidden = NO;
            cell.introFYLab.attributedText = [MSUStringTools makeKeyWordAttributedWithSubText:@"(富友支付)" inOrigiText:dic[@"fyStr"] font:12 color:HEXCOLOR(0x91AAD5)];
        } else{
            cell.introLLLab.attributedText = [MSUStringTools makeKeyWordAttributedWithSubText:@"(连连支付)" inOrigiText:dic[@"llStr"] font:12 color:HEXCOLOR(0xFF9578)];
            cell.introFYLab.hidden = YES;
        }
    } else if (str1.length == 0 && str.length > 0){
        cell.introLLLab.attributedText = [MSUStringTools makeKeyWordAttributedWithSubText:@"(富友支付)" inOrigiText:dic[@"fyStr"] font:12 color:HEXCOLOR(0x91AAD5)];
        cell.introFYLab.hidden = YES;
    }
    //    CGRect recta = [MSUStringTools danamicGetHeightFromText:_dic[@"llStr"] WithWidth:kDeviceWidth-88 font:12];
    //    _introLLLab.frame = CGRectMake(44, _bankLab.bottom + 8*kDeviceHeightScale, kDeviceWidth-60, recta.size.height);

    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.DataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 82*kDeviceHeightScale;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.DataArr[indexPath.row];

    MyLog(@"===%@",[NSThread currentThread]);
    dispatch_async(dispatch_get_main_queue(), ^{
        AddCardViewController *AddCardVC =[[AddCardViewController alloc] init];
        //    AddCardVC.hidesBottomBarWhenPushed =  YES;
        AddCardVC.bankStr = [NSString stringWithFormat:@"%@",dic[@"bankName"]];
        AddCardVC.isSetPWD = self.isSetPWD;
        [self.navigationController pushViewController:AddCardVC animated:YES];
    });
}

-(UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"Date_Empty"];
}

-(NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = nil;
    UIFont *font = nil;
    UIColor *textColor = nil;
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    
    text = @"暂无数据";
    font = [UIFont systemFontOfSize:13];
    textColor = [UIColor colorWithHex:0x333333];
    
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
    [self.TableView.mj_header beginRefreshing];
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

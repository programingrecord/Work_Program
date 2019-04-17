//
//  MSUCuponRuleController.m
//  vvlc
//
//  Created by 007 on 2018/5/24.
//  Copyright © 2018年 HM. All rights reserved.
//

#import "MSUCuponRuleController.h"

#import "MSUStringTools.h"

@interface MSUCuponRuleController ()<UIScrollViewDelegate>

@property (nonatomic , strong) UIScrollView *scrollView;

@end

@implementation MSUCuponRuleController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"使用规则";
    self.view.backgroundColor = HEXCOLOR(0xF6F6F6);
    
    [self createCenterView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createCenterView{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    _scrollView.backgroundColor  = HEXCOLOR(0xF6F6F6);
    _scrollView.scrollEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:_scrollView];
    if (iOS11) {
        _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    UIView *cuponView = [[UIView alloc] init];
    cuponView.frame = CGRectMake(10, 10, kDeviceWidth-20, 91.5);
    cuponView.backgroundColor = HEXCOLOR(0xffffff);
    [_scrollView addSubview:cuponView];
    
    UILabel *topLab = [[UILabel alloc] init];
    topLab.frame = CGRectMake(10, 19.5, kDeviceWidth-40, 21);
    topLab.text = @"【微米在线平台有哪些券】";
    topLab.font = [UIFont systemFontOfSize:15];
    topLab.textColor = HEXCOLOR(0xE85935);
    [cuponView addSubview:topLab];
    
    NSArray *arr = @[@"1.红包券",@"2.理财券",@"3.加息券"];
    for (NSInteger i = 0; i < arr.count; i++) {
        UILabel *listLab = [[UILabel alloc] init];
        listLab.frame = CGRectMake(16+(55+50)*i,topLab.bottom + 10, 55, 20);
        listLab.text = arr[i];
        listLab.font = [UIFont systemFontOfSize:14];
        listLab.textColor = HEXCOLOR(0x454545);
        [cuponView addSubview:listLab];
    }
    
    
    // 红包使用规则
    NSString *str =@"1、投资满足条件后，红包立即返现至你的账户余额；\n2、单笔投资只能使用一个红包；\n3、红包一次性使用，不可找零；\n4、超过有效期的红包将不可使用；\n例如：用户投资1月标5000元，选择使用30元红包，则投资后立即返还30元至你的账户余额";
    CGRect rect = [MSUStringTools danamicGetHeightFromText:str WithWidth:kDeviceWidth-20-32 font:14];

    UIView *centerView = [[UIView alloc] init];
    centerView.frame = CGRectMake(10,cuponView.bottom + 10, kDeviceWidth-20, 44.5+rect.size.height+20);
    centerView.backgroundColor = HEXCOLOR(0xffffff);
    [_scrollView addSubview:centerView];
    
    UILabel *centerLab = [[UILabel alloc] init];
    centerLab.frame = CGRectMake(10, 23.5, kDeviceWidth-40, 21);
    centerLab.text = @"【红包使用规则】";
    centerLab.font = [UIFont systemFontOfSize:15];
    centerLab.textColor = HEXCOLOR(0xE85935);
    [centerView addSubview:centerLab];
    
    UILabel *centerIntroLab = [[UILabel alloc] init];
    centerIntroLab.text = str;
    centerIntroLab.frame = CGRectMake(16,centerLab.bottom + 10, kDeviceWidth-20-32, rect.size.height);
    centerIntroLab.font = [UIFont systemFontOfSize:14];
    centerIntroLab.numberOfLines = 0;
    centerIntroLab.textColor = HEXCOLOR(0x454545);
    [centerView addSubview:centerIntroLab];
    
    
    // 理财券使用规则
    NSString *str1 = @"1、理财券在投资中可抵用现金，每次投资只可使用一张券；\n2、理财券一次性使用，不设找零；\n3、新手标不可使用理财券；\n4、超过有效期的理财券将不可使用；\n5、理财券所产生的利息可以提现，理财券本金不可提现。\n例如：用户投资1000元理财产品，其中使用100元的理财券，实际支付900元。到期后可获得900元本金加上1000元的利息。";
    CGRect rect1 = [MSUStringTools danamicGetHeightFromText:str1 WithWidth:kDeviceWidth-20-32 font:14];
    
    UIView *lcView = [[UIView alloc] init];
    lcView.frame = CGRectMake(10,centerView.bottom + 10, kDeviceWidth-20, 44.5+rect1.size.height+20);
    lcView.backgroundColor = HEXCOLOR(0xffffff);
    [_scrollView addSubview:lcView];
    
    UILabel *lcLab = [[UILabel alloc] init];
    lcLab.frame = CGRectMake(10, 23.5, kDeviceWidth-40, 21);
    lcLab.text = @"【理财券使用规则】";
    lcLab.font = [UIFont systemFontOfSize:15];
    lcLab.textColor = HEXCOLOR(0xE85935);
    [lcView addSubview:lcLab];
    
    UILabel *lcIntroLab = [[UILabel alloc] init];
    lcIntroLab.text = str1;
    lcIntroLab.frame = CGRectMake(16,lcLab.bottom + 10, kDeviceWidth-20-32, rect1.size.height);
    lcIntroLab.font = [UIFont systemFontOfSize:14];
    lcIntroLab.numberOfLines = 0;
    lcIntroLab.textColor = HEXCOLOR(0x454545);
    [lcView addSubview:lcIntroLab];
    
    // 加息券使用规则
    NSString *str2 = @"加息券是用户投资时使用，在原有的项目的利息上进行加息，产生额外收益，如12%年化收益使用2%加息券后，变为14%年化收益。";
    CGRect rect2 = [MSUStringTools danamicGetHeightFromText:str2 WithWidth:kDeviceWidth-20-32 font:14];
    
    UIView *jxView = [[UIView alloc] init];
    jxView.frame = CGRectMake(10,lcView.bottom + 10, kDeviceWidth-20, 44.5+rect2.size.height+20);
    jxView.backgroundColor = HEXCOLOR(0xffffff);
    [_scrollView addSubview:jxView];
    
    UILabel *jxLab = [[UILabel alloc] init];
    jxLab.frame = CGRectMake(10, 23.5, kDeviceWidth-40, 21);
    jxLab.text = @"【加息券使用规则】";
    jxLab.font = [UIFont systemFontOfSize:15];
    jxLab.textColor = HEXCOLOR(0xE85935);
    [jxView addSubview:jxLab];
    
    UILabel *jxIntroLab = [[UILabel alloc] init];
    jxIntroLab.text = str2;
    jxIntroLab.frame = CGRectMake(16,jxLab.bottom + 10, kDeviceWidth-20-32, rect2.size.height);
    jxIntroLab.font = [UIFont systemFontOfSize:14];
    jxIntroLab.numberOfLines = 0;
    jxIntroLab.textColor = HEXCOLOR(0x454545);
    [jxView addSubview:jxIntroLab];
    
    _scrollView.contentSize = CGSizeMake(kDeviceWidth, jxView.bottom+100);
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

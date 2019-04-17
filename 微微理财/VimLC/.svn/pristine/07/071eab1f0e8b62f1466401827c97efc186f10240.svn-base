//
//  RealViewController.m
//  WTJR
//
//  Created by HM on 16/8/16.
//  Copyright © 2016年 HM. All rights reserved.
//

#import "RealViewController.h"
#import "CustomField.h"

@interface RealViewController ()<UITextFieldDelegate>

@property (strong, nonatomic)  UITextField *RealName;
@property (strong, nonatomic)  UITextField *PersonNum;
@property (nonatomic,strong) NSMutableDictionary *infoDic;

@end

@implementation RealViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self buildUI];
    // Do any additional setup after loading the view.
}

- (void)buildUI{
    self.title = @"实名认证";
    self.view.backgroundColor = [UIColor colorWithHex:0xF5F5F9];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.infoDic= [[defaults objectForKey:@"userInfoDetial"] mutableCopy];
    
    self.RealName = [[CustomField alloc] initWithFrame:CGRectMake(0, 10, kDeviceWidth, 44)];
    self.RealName.delegate = self;
    self.RealName.backgroundColor = [UIColor whiteColor];
    self.RealName.placeholder = @"请输入真实姓名";
    self.RealName.textColor = RGBA(51, 51, 51, 1);
    self.RealName.font = TEXTFONT(15);
    self.RealName.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:self.RealName];
    
    UIView *space1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, self.RealName.height)];
    self.RealName.leftView = space1;
    self.RealName.leftViewMode = UITextFieldViewModeAlways;
    
    self.PersonNum = [[UITextField alloc] initWithFrame:CGRectMake(0, self.RealName.bottom, kDeviceWidth, 44)];
    self.PersonNum.backgroundColor = [UIColor whiteColor];
    self.PersonNum.delegate = self;
    self.PersonNum.placeholder = @"请输入身份证号";
    self.PersonNum.textColor = RGBA(51, 51, 51, 1);
    self.PersonNum.font = TEXTFONT(15);
    self.PersonNum.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:self.PersonNum];
    
    UIView *space2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, self.RealName.height)];
    self.PersonNum.leftView = space2;
    self.PersonNum.leftViewMode = UITextFieldViewModeAlways;
    
    UIButton *lockButton = [UIButton buttonWithType:UIButtonTypeCustom];
    lockButton.backgroundColor = [UIColor colorWithHex:0xFB6337];
    lockButton.frame = CGRectMake(10, self.PersonNum.bottom + 10, kDeviceWidth-20, 44);
    [lockButton setTitle:@"确 认" forState:UIControlStateNormal];
    lockButton.titleLabel.font = TEXTFONT(16);
    lockButton.layer.cornerRadius = 5;
    [lockButton addTarget:self action:@selector(lockNameClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:lockButton];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyBoard:)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)lockNameClick{
    [self KeyboardresignFirstResponder];
    if (self.RealName.text.length >0 && self.PersonNum.text.length >0) {
        NSMutableDictionary *parms= [[NSMutableDictionary alloc] initWithCapacity:0];
        [parms setObject:_RealName.text forKey:@"realName"];
        [parms setObject:_PersonNum.text forKey:@"idNumber"];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[DataRequestServer getDataRequestServerData] request:@"LunaP2pAppIdentityServlet" parameters:parms result:^(id result) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            if ([result isKindOfClass:[NSString class]] &&  [result isEqualToString:@"44"]) {
                [AddHudView addProgressView:self.view message:@"网络错误，请稍后再试"];
            }else if([[result objectForKey:@"success"]intValue]==1 && [[result objectForKey:@"errorlog"]isEqualToString:@""]){
                [self.infoDic setObject:@"1" forKey:@"isIdentity"];
                [[NSUserDefaults standardUserDefaults] setObject:self.infoDic forKey:@"userInfoDetial"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [AddHudView addProgressView:self.view message:@"实名认证成功"];
               
                __weak typeof(self) weakSelf = self;
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    [weakSelf BackViewController];
                });
            }
            else{
                [AddHudView addProgressView:self.view message:@"认证失败，请重新操作"];
            }
        }];
    }else{
        [AddHudView addProgressView:self.view message:@"请输入姓名跟身份证号码"];
    }
}

- (void)resignKeyBoard:(UITapGestureRecognizer *)tap{
    [self KeyboardresignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self KeyboardresignFirstResponder];
    return YES;
}

- (void)KeyboardresignFirstResponder
{
    if ([_RealName isFirstResponder])//判断是否是第一响应
    {
        [_RealName resignFirstResponder];
    }
    
    if ([_PersonNum isFirstResponder])//判断是否是第一响应
    {
        [_PersonNum resignFirstResponder];
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

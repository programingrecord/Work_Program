//
//  LockNameViewController.m
//  WTJR
//
//  Created by H on 16/8/13.
//  Copyright © 2016年 HM. All rights reserved.
//

#import "LockNameViewController.h"
#import "CustomField.h"

@interface LockNameViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet CustomField *NameText;
@property (weak, nonatomic) IBOutlet CustomField *VerifyText;
@property (nonatomic,strong) UIButton *Rightbutton;
@property (nonatomic,strong) NSMutableDictionary *userInfoDic;

@end

@implementation LockNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"绑定姓名";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    UIView *rightView=[[UIView alloc] init];
    rightView.frame = CGRectMake(_VerifyText.width-130, 2, 110, 45);
    _VerifyText.rightView = rightView;
    _VerifyText.rightViewMode = UITextFieldViewModeAlways;

    self.userInfoDic = [[userDefaults objectForKey:@"userInfoDetial"] mutableCopy];
    
    self.Rightbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.Rightbutton.frame = CGRectMake(10, 7, 100, 30);
    [self.Rightbutton setTitle:@"发送验证码" forState:UIControlStateNormal];
    self.Rightbutton.titleLabel.font = TEXTFONT(12.0);
    [self.Rightbutton setTitleColor:[UIColor colorWithHex:0xFB6337] forState:UIControlStateNormal];
    [self.Rightbutton setBackgroundColor:[UIColor clearColor]];
    [self.Rightbutton addTarget:self action:@selector(VerifyButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:self.Rightbutton];

    UIView *lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(10, 15,1, 15);
    lineView.backgroundColor = RGBA(229, 229, 229, 1);
    [rightView addSubview:lineView];

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyBoard:)];
    [self.view addGestureRecognizer:tapGesture];
    
    UIView *nameSpaceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 45)];
    self.NameText.leftView = nameSpaceView;
    self.NameText.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *VerifySpaceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 45)];
    self.VerifyText.leftView = VerifySpaceView;
    self.VerifyText.leftViewMode = UITextFieldViewModeAlways;

    // Do any additional setup after loading the view from its nib.
}

- (void)VerifyButtonClick{
    [self KeyboardresignFirstResponder];
    [self timeCount];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"1" forKey:@"type"];
    [params setObject:@"vcodephone" forKey:@"hkey"];
    [params setObject:@"WeiMi" forKey:@"appIdenty"];
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary]
                                objectForKey:@"CFBundleShortVersionString"];
    [params setObject:currentVersion forKey:@"appVersion"];
    
    NSString *UrlString = [NSString stringWithFormat:@"%@luna_ajax.do", Base_url];
    
    AFHTTPSessionManager *manage = [AFHTTPSessionManager manager];
    manage.requestSerializer = [AFHTTPRequestSerializer serializer];
    manage.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manage.requestSerializer setValue:@"LUNA.APP.U.AGENT" forHTTPHeaderField:@"User-Agent"];
    
    [manage GET:UrlString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        MyLog(@"luna_ajax.do%@",result);
        
        if([[result objectForKey:@"success"]isEqualToString:@"true"] &&[[result objectForKey:@"errorlog"]isEqualToString:@""]){
            [AddHudView addProgressView:self.view message:@"短信验证码已发送，请注意查收"];
        }else if([[result objectForKey:@"errorlog"]isEqualToString:@"1"] && [[result objectForKey:@"success"]isEqualToString:@"false"]){
            [AddHudView addProgressView:self.view message:@"获取短信数量已达到单日短信发送上限"];
            return;
        }else{
           [AddHudView addProgressView:self.view message:@"获取激活码失败，您可以重新获取"];
            return;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [AddHudView addProgressView:self.view message:@"网络错误，请稍后再试"];
        [[DataRequestServer getDataRequestServerData] requestImportWithUrl:UrlString Error:error urlParams:params];

    }];
}

- (void)timeCount{
    __block int timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.Rightbutton setTitle:@"发送验证码" forState:UIControlStateNormal];

                self.Rightbutton.enabled = YES;
            });
        }else{
            NSString *starTime = [NSString stringWithFormat:@"%d秒后获取",timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.Rightbutton setTitle:starTime forState:UIControlStateNormal];
                self.Rightbutton.enabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

- (void)KeyboardresignFirstResponder
{
    if ([_NameText isFirstResponder])//判断是否是第一响应
    {
        [_NameText resignFirstResponder];
    }
    
    if ([_VerifyText isFirstResponder])//判断是否是第一响应
    {
        [_VerifyText resignFirstResponder];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self KeyboardresignFirstResponder];
    return YES;
}

- (void)resignKeyBoard:(UITapGestureRecognizer *)tap{
    [self KeyboardresignFirstResponder];
}

- (IBAction)LockName:(id)sender {
    [self KeyboardresignFirstResponder];
    if (_NameText.text.length<=0) {
        [AddHudView addProgressView:self.view message:@"请输入您的真实姓名"];
    }
    if (_VerifyText.text.length<=0) {
        [AddHudView addProgressView:self.view message:@"请输入短信验证码"];
    }
    NSMutableDictionary *parms= [[NSMutableDictionary alloc] initWithCapacity:0];
    [parms setObject:_NameText.text forKey:@"realName"];
    [parms setObject:_VerifyText.text forKey:@"vcodePhone"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[DataRequestServer getDataRequestServerData] request:@"LunaP2pAppLockNameServlet" parameters:parms result:^(id result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([result isKindOfClass:[NSString class]] &&  [result isEqualToString:@"44"]) {
            
            [AddHudView addProgressView:self.view message:@"网络错误，请稍后再试"];
        }else if([[result objectForKey:@"success"]intValue]==1 && [[result objectForKey:@"errorlog"]isEqualToString:@""]){
            [AddHudView addProgressView:self.view message:@"绑定姓名成功"];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [self.userInfoDic setObject:@"1" forKey:@"isLockedRealName"];
            [userDefaults synchronize];
            __weak typeof(self) weakSelf = self;
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                [weakSelf BackViewController];
            });
        }else if([[result objectForKey:@"errorlog"]isEqualToString:@"vcodePhoneFailed"]){
            [AddHudView addProgressView:self.view message:@"验证码失效，请重新获取"];

        }else if([[result objectForKey:@"errorlog"]isEqualToString:@"realNameNotChinese2_20"]){
            [AddHudView addProgressView:self.view message:@"请输入正确的中文姓名"];
        }
        else{
            [AddHudView addProgressView:self.view message:@"绑定姓名失败，请重新操作"];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated{
    
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

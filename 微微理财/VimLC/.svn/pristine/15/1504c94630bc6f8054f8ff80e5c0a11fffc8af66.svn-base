//
//  PasswordModifyVC.m
//  WTJR
//
//  Created by HM on 16/6/16.
//  Copyright © 2016年 HM. All rights reserved.
//

#import "PasswordModifyVC.h"
#import "LoginViewController.h"
#import "ForgotTradePassVC.h"
#import "CustomField.h"
@interface PasswordModifyVC ()

@property (nonatomic,strong) UIButton *getVerifyButton;
@property (weak, nonatomic) IBOutlet CustomField *VerifyText;
@property (weak, nonatomic) IBOutlet CustomField *oldPassWord;
@property (weak, nonatomic) IBOutlet CustomField *NewPassWord;
@property (weak, nonatomic) IBOutlet CustomField *reNewPassWord;
@property (weak, nonatomic) IBOutlet UIButton *resureChange;
@property (weak, nonatomic) IBOutlet UIButton *ForgotTradeButton;
@property (weak, nonatomic) IBOutlet UILabel *setPwdLab;

@end

@implementation PasswordModifyVC

#pragma mark - UI设置
- (void)viewDidLoad {
    [super viewDidLoad];
    [self BuildUI];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view from its nib.
}

- (void)BuildUI{
    UIButton *passWordRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    passWordRightButton.frame = CGRectMake(0, 0, 40, 30);
    passWordRightButton.selected = NO;
    [passWordRightButton addTarget:self action:@selector(oldPassWordRightButtonclick:) forControlEvents:UIControlEventTouchUpInside];
    [passWordRightButton setImage:[UIImage imageNamed:@"login_pass_right"] forState:UIControlStateNormal];
    [passWordRightButton setImage:[UIImage imageNamed:@"login_pass_right_open"] forState:UIControlStateSelected];
    self.oldPassWord.rightView=passWordRightButton;
    self.oldPassWord.rightViewMode = UITextFieldViewModeAlways;
    [self.oldPassWord addTarget:self action:@selector(UITextFieldChange:) forControlEvents:UIControlEventAllEditingEvents];
    
    UIView *SpaceOld = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 45)];
    self.oldPassWord.leftView = SpaceOld;
    self.oldPassWord.leftViewMode = UITextFieldViewModeAlways;
    
    UIButton *passWordRightButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    passWordRightButton2.frame = CGRectMake(0, 0, 40, 30);
    passWordRightButton2.selected = NO;
    [passWordRightButton2 addTarget:self action:@selector(NewpassWordRightButtonclick:) forControlEvents:UIControlEventTouchUpInside];
    [passWordRightButton2 setImage:[UIImage imageNamed:@"login_pass_right"] forState:UIControlStateNormal];
    [passWordRightButton2 setImage:[UIImage imageNamed:@"login_pass_right_open"] forState:UIControlStateSelected];
    self.NewPassWord.rightView=passWordRightButton2;
    self.NewPassWord.rightViewMode = UITextFieldViewModeAlways;
    [self.NewPassWord addTarget:self action:@selector(UITextFieldChange:) forControlEvents:UIControlEventAllEditingEvents];
    
    UIView *SpaceNew = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 45)];
    self.NewPassWord.leftView = SpaceNew;
    self.NewPassWord.leftViewMode = UITextFieldViewModeAlways;
    
    UIButton *passWordRightButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
    passWordRightButton3.frame = CGRectMake(0, 0, 40, 30);
    passWordRightButton3.selected = NO;
    [passWordRightButton3 addTarget:self action:@selector(reNewpassWordRightButtonclick:) forControlEvents:UIControlEventTouchUpInside];
    [passWordRightButton3 setImage:[UIImage imageNamed:@"login_pass_right"] forState:UIControlStateNormal];
    [passWordRightButton3 setImage:[UIImage imageNamed:@"login_pass_right_open"] forState:UIControlStateSelected];
    self.reNewPassWord.rightView=passWordRightButton3;
    self.reNewPassWord.rightViewMode = UITextFieldViewModeAlways;
    [self.reNewPassWord addTarget:self action:@selector(UITextFieldChange:) forControlEvents:UIControlEventAllEditingEvents];
    
    UIView *reNewSpace = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 45)];
    self.reNewPassWord.leftView = reNewSpace;
    self.reNewPassWord.leftViewMode = UITextFieldViewModeAlways;
    
    if ([self.title isEqualToString:@"修改交易密码"]) {
        self.NewPassWord.keyboardType = UIKeyboardTypeNumberPad;
        self.reNewPassWord.keyboardType = UIKeyboardTypeNumberPad;
    }
    
    [self.VerifyText addTarget:self action:@selector(UITextFieldChange:) forControlEvents:UIControlEventAllEditingEvents];
    
    UIView *VerifySpace = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 45)];
    self.VerifyText.leftView = VerifySpace;
    self.VerifyText.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *rightView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 110, 45)];
    self.VerifyText.rightView = rightView;
    self.VerifyText.rightViewMode = UITextFieldViewModeAlways;
    
    self.getVerifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.getVerifyButton.frame = CGRectMake(10, 10, 100, 25);
    [self.getVerifyButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    self.getVerifyButton.titleLabel.font = TEXTFONT(14.0);
    [self.getVerifyButton setTitleColor:[UIColor colorWithHex:0x5381ff] forState:UIControlStateNormal];
    [self.getVerifyButton setBackgroundColor:[UIColor whiteColor]];
    [self.getVerifyButton addTarget:self action:@selector(VerifyButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:self.getVerifyButton];

    UIView *lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(10, 15,1, 15);
    lineView.backgroundColor = RGBA(229, 229, 229, 1);
    [rightView addSubview:lineView];
    
    if ([self.title isEqualToString:@"修改登录密码"]){
        self.ForgotTradeButton.hidden = YES;
        _oldPassWord.placeholder=@"请输入原登录密码";
    }else{
        self.setPwdLab.text = @"设置新密码（密码类型为6位数字）";
        if ([CoreArchive isSetTradePass]) {
            _oldPassWord.placeholder=@"请输入原交易密码";
            self.ForgotTradeButton.hidden = NO;
        }else{
            _oldPassWord.placeholder=@"请输入原登录密码";
            self.ForgotTradeButton.hidden = YES;
        }
    }

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyBoard:)];
    [self.view addGestureRecognizer:tapGesture];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - 按钮事件
- (void)oldPassWordRightButtonclick:(UIButton *)sender{
    sender.selected = !sender.selected;
    self.oldPassWord.secureTextEntry = !sender.selected;
}

- (void)reNewpassWordRightButtonclick:(UIButton *)sender{
    sender.selected = !sender.selected;
    self.reNewPassWord.secureTextEntry = !sender.selected;
}

- (void)NewpassWordRightButtonclick:(UIButton *)sender{
    sender.selected = !sender.selected;
    self.NewPassWord.secureTextEntry = !sender.selected;
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

- (BOOL)isNum:(NSString *)checkedNumString {
    checkedNumString = [checkedNumString stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(checkedNumString.length > 0) {
        return NO;
    }
    return YES;
    
}



- (IBAction)ChangeClick:(id)sender {
    [self KeyboardresignFirstResponder];
    

    if (_oldPassWord.text.length == 0) {
        [AddHudView addProgressView:self.view message:@"请输入原始密码"];
        return;
    }
    if ([self.title isEqualToString:@"修改交易密码"]) {
        if (_NewPassWord.text.length != 6) {
            [AddHudView addProgressView:self.view message:@"密码长度有误，请您设置6位数字密码"];
            return;
        }
        
        //正则表达式
        NSString *regex = @"[0-9]*";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        BOOL isMatch = [pred evaluateWithObject:_NewPassWord.text];
        if (!isMatch) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"密码必须为六位数字" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
            return;

        }
    } else{
        if (_NewPassWord.text.length < 6 || _NewPassWord.text.length > 20) {
            [AddHudView addProgressView:self.view message:@"请您设置6-20位的密码"];
            return;
        }
    }


    if (![_NewPassWord.text isEqualToString:_reNewPassWord.text]) {
        _reNewPassWord.text = nil;
        [AddHudView addProgressView:self.view message:@"前后两次输入的密码不一致"];
        return;
    }
    if (_VerifyText.text.length == 0) {
        [AddHudView addProgressView:self.view message:@"请输入正确的验证码"];
        return;
    }
    NSMutableDictionary *parms= [[NSMutableDictionary alloc] initWithCapacity:0];
    
    [parms setObject:_oldPassWord.text forKey:@"originalPassowrd"];
    [parms setObject:_NewPassWord.text forKey:@"newPassowrd"];
    [parms setObject:_reNewPassWord.text forKey:@"confirmPassowrd"];
    [parms setObject:_VerifyText.text forKey:@"vcodePhone"];
    if ([self.title isEqualToString:@"修改登录密码"]) {
        [parms setObject:@"true" forKey:@"isLoginPassword"];//有交易密码
    }else{
        [parms setObject:@"false" forKey:@"isLoginPassword"];//没有交易密码
    }

    [[DataRequestServer getDataRequestServerData] request:@"LunaP2pAppPasswordServlet" parameters:parms result:^(id result) {
        if ([result isKindOfClass:[NSString class]] &&  [result isEqualToString:@"44"]) {
            [AddHudView addProgressView:self.view message:@"网络错误，请稍后再试"];
        }else{
            if ([[result objectForKey:@"success"]intValue]==1 && [[result objectForKey:@"errorlog"]isEqualToString:@""]) {
                [AddHudView addProgressView:self.view message:@"新密码设置成功"];
                
                if (![self.title isEqualToString:@"修改交易密码"]) {
                    [CoreArchive isSetTradePassWord:YES];
                }
                __weak typeof(self) weakSelf = self;
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    if ([self.title isEqualToString:@"修改登录密码"]) {
                        [[DataRequestServer getDataRequestServerData] request:@"logout.do" parameters:nil result:^(id result) {
                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                            if ([result isKindOfClass:[NSString class]] &&  [result isEqualToString:@"44"]) {
                                [AddHudView addProgressView:self.view message:@"网络错误，请稍后再试"];
                            }else{
                                MyLog(@"url= %@",result);
                            }
                        }];
                        [CoreArchive removeNSUserDefaults];
                        
                        AppDelegate *jj = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                        [jj loadMainView];
                        [jj.mainVC setSelectedIndex:3];
                    } else {
                        [weakSelf BackViewController];
                    }
                });
            }else if([[result objectForKey:@"errorlog"]isEqualToString:@"noLogin"]&& [[result objectForKey:@"success"]intValue]==0){//要加上未登录的判断
                [self requestLogin];
            }
            else if ([[result objectForKey:@"success"]intValue]==0 && [[result objectForKey:@"errorlog"]isEqualToString:@"originalPassowrdIncorrect"]){
                [AddHudView addProgressView:self.view message:@"原始密码输入错误"];
            }else if ([[result objectForKey:@"success"]intValue]==0 && [[result objectForKey:@"errorlog"]isEqualToString:@"vcodePhoneFailed"]){
                [AddHudView addProgressView:self.view message:@"您输入的验证码有误"];
            }else if ([[result objectForKey:@"success"]intValue]==0 && [[result objectForKey:@"errorlog"]isEqualToString:@"1"]){
                [AddHudView addProgressView:self.view message:@"当日获取短信数量已达到上限"];
            }
            else{
                [AddHudView addProgressView:self.view message:@"修改密码失败，请重新操作"];
            }
        }
    }];
}

- (void)requestLogin{
    [[DataRequestServer getDataRequestServerData] requestLoginresult:^(NSString *LoginState) {
        if ([LoginState isEqualToString:@"true"]) {
            [self ChangeClick:nil];
        }else{
            [AddHudView addProgressView:self.view message:@"登录失效，请重新登录"];
            double delayInSeconds = 1.0;
            __block PasswordModifyVC* BlockVC = self;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                LoginViewController *loginVc= [[LoginViewController alloc] init];
                loginVc.loginType = logintypeOutTime;
                loginVc.hidesBottomBarWhenPushed = YES;

                [BlockVC.navigationController pushViewController:loginVc animated:YES];
            });
        }
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
                [self.getVerifyButton setTitle:@"获取验证码" forState:UIControlStateNormal];
                self.getVerifyButton.enabled = YES;
            });
        }else{
            NSString *starTime = [NSString stringWithFormat:@"%d秒后获取",timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.getVerifyButton setTitle:starTime forState:UIControlStateNormal];
                self.getVerifyButton.enabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

#pragma mark - 代理
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self KeyboardresignFirstResponder];
    return YES;
}

- (void)resignKeyBoard:(UITapGestureRecognizer *)tap{
    [self KeyboardresignFirstResponder];
}

- (void)KeyboardresignFirstResponder{
    if ([_oldPassWord isFirstResponder])//判断是否是第一响应
    {
        [_oldPassWord resignFirstResponder];
    }
    
    if ([_NewPassWord isFirstResponder])//判断是否是第一响应
    {
        [_NewPassWord resignFirstResponder];
    }
    
    if ([_reNewPassWord isFirstResponder])//判断是否是第一响应
    {
        [_reNewPassWord resignFirstResponder];
    }
    if ([_VerifyText isFirstResponder])//判断是否是第一响应
    {
        [_VerifyText resignFirstResponder];
    }
}

#pragma mark - keyboard events -
///键盘显示事件
- (void) keyboardWillShow:(NSNotification *)notification {
    if ([_VerifyText isFirstResponder]) {
        //获取键盘高度，在不同设备上，以及中英文下是不同的
        CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
        
        //计算出键盘顶端到inputTextView panel底端的距离(加上自定义的缓冲距离INTERVAL_KEYBOARD)
        CGFloat offset = (_VerifyText.frame.origin.y+_VerifyText.frame.size.height+10) - (self.view.frame.size.height - kbHeight);
        
        // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
        double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        NSLog(@"%@",NSStringFromCGRect(self.view.frame));
        //将视图上移计算好的偏移
        if(offset > 0) {
            [UIView animateWithDuration:duration animations:^{
                self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
            }];
        }
    }
}

///键盘消失事件
- (void) keyboardWillHide:(NSNotification *)notify {
    // 键盘动画时间
    if ([_VerifyText isFirstResponder]){
        double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        NSLog(@"%@",NSStringFromCGRect(self.view.frame));
        
        //视图下沉恢复原状
        [UIView animateWithDuration:duration animations:^{
            self.view.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)UITextFieldChange:(UITextField *)sender{
    if (self.NewPassWord.text.length > 6 && [self.title isEqualToString:@"修改交易密码"]) {
        self.NewPassWord.text = [sender.text substringToIndex:6];;
    }
    
    if ([self.NewPassWord.text isEqualToString:@"123456"] || [self.NewPassWord.text isEqualToString:@"234567"] || [self.NewPassWord.text isEqualToString:@"345678"] || [self.NewPassWord.text isEqualToString:@"456789"] || [self.NewPassWord.text isEqualToString:@"012345"] || [self.NewPassWord.text isEqualToString:@"543210"] || [self.NewPassWord.text isEqualToString:@"654321"] || [self.NewPassWord.text isEqualToString:@"765432"] || [self.NewPassWord.text isEqualToString:@"876543"] || [self.NewPassWord.text isEqualToString:@"987654"]) {
        [PAProgressView showInView:self.view contentString:@"交易密码不得为6位连续数字"];
        self.NewPassWord.text = @"";
    } else if ([self.NewPassWord.text isEqualToString:@"000000"] || [self.NewPassWord.text isEqualToString:@"111111"] || [self.NewPassWord.text isEqualToString:@"222222"] || [self.NewPassWord.text isEqualToString:@"333333"] || [self.NewPassWord.text isEqualToString:@"444444"] || [self.NewPassWord.text isEqualToString:@"555555"] || [self.NewPassWord.text isEqualToString:@"666666"] || [self.NewPassWord.text isEqualToString:@"777777"] || [self.NewPassWord.text isEqualToString:@"888888"] || [self.NewPassWord.text isEqualToString:@"999999"]){
        
        [PAProgressView showInView:self.view contentString:@"交易密码不得为6位重复数字"];
        self.NewPassWord.text = @"";
    }
    
    if (self.reNewPassWord.text.length > 6 && [self.title isEqualToString:@"修改交易密码"]) {
        self.reNewPassWord.text = [sender.text substringToIndex:6];;
    }
    
    if (self.oldPassWord.text.length>0 && self.NewPassWord.text.length >0 &&self.reNewPassWord.text.length >0&&self.VerifyText.text.length >0) {
        [self.resureChange setBackgroundColor:[UIColor colorWithHex:0xFB6337]];
        self.resureChange.enabled = YES;
    }else{
        [self.resureChange setBackgroundColor:RGBA(228, 228, 228, 1)];
        self.resureChange.enabled = NO;
    }
}

- (IBAction)forgotTradePassWord:(id)sender {
    ForgotTradePassVC *forgotVC = [[ForgotTradePassVC alloc] init];
    [self.navigationController pushViewController:forgotVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

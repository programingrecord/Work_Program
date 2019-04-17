//
//  LoginViewController.m
//  WTJR
//
//  Created by HM on 16/5/31.
//  Copyright © 2016年 HM. All rights reserved.
//

#import "LoginViewController.h"
#import "CustomField.h"
#import "ForgetViewController.h"
#import "RegistStepOneViewController.h"
#import "RegistStepTwoViewController.h"

#import "MSUPathTools.h"
@interface LoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet CustomField *userName;
@property (weak, nonatomic) IBOutlet CustomField *passWord;
@property (weak, nonatomic) IBOutlet CustomField *Verify;
@property (weak, nonatomic) IBOutlet UIButton *registButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *VerifyHeight;
@property (weak, nonatomic) IBOutlet UIButton *LoginButton;

@property (nonatomic,strong) UIButton *VerifyRightButton;
@property (strong, nonatomic)  CustomField *userNameField;

@property (nonatomic,strong) NSString       *previousTextFieldContent;
@property (nonatomic,strong) UITextRange    *previousSelection;

@end

@implementation LoginViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHex:0xFB6337]];
    self.VerifyHeight.constant = 0;
    self.tabBarController.tabBar.hidden = YES;
    [self addNoticeForKeyboard];
    
    self.Verify.hidden = YES;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *strUs = [defaults objectForKey:@"MSUUserName"];
    if (strUs.length > 0) {
        self.userName.text = strUs;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self CreateUI];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.userName.borderStyle = UITextBorderStyleNone;
    self.passWord.borderStyle = UITextBorderStyleNone;
    self.Verify.borderStyle = UITextBorderStyleNone;
    self.LoginButton.enabled = NO;
    self.LoginButton.backgroundColor = [UIColor colorWithHex:0xFB6337 alpha:0.5];
    self.userName.inputAccessoryView = [self addToolbar];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.userName becomeFirstResponder];
    });
    
    self.userName.tintColor = titOrangeColor;
    self.passWord.tintColor = titOrangeColor;
    
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(0, 0, 33, 30);
    bgView.backgroundColor = HEXCOLOR(0xffffff);
    
    UIImageView *imaView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 4, 20, 20)];
    imaView.image = [MSUPathTools showImageWithContentOfFileByName:@"yhm_icon"];
    imaView.backgroundColor = titQianColor;
    [bgView addSubview:imaView];
    
    UIView *bg1View = [[UIView alloc] init];
    bg1View.frame = CGRectMake(0, 0, 33, 30);
    bg1View.backgroundColor = HEXCOLOR(0xffffff);
    
    UIImageView *ima1View = [[UIImageView alloc] initWithFrame:CGRectMake(5, 4, 20, 20)];
    ima1View.image = [MSUPathTools showImageWithContentOfFileByName:@"mm_icon"];
    ima1View.backgroundColor = titQianColor;
    [bg1View addSubview:ima1View];
    
    UIView *bg2View = [[UIView alloc] init];
    bg2View.frame = CGRectMake(0, 0, 33, 30);
    bg2View.backgroundColor = HEXCOLOR(0xffffff);
    
    UIImageView *ima2View = [[UIImageView alloc] initWithFrame:CGRectMake(5, 4, 20, 20)];
    ima2View.image = [MSUPathTools showImageWithContentOfFileByName:@"yzm_icon"];
    ima2View.backgroundColor = titQianColor; 
    [bg2View addSubview:ima2View];
    
    
    self.userName.leftView = bgView;
    self.userName.leftViewMode = UITextFieldViewModeAlways;
    
    self.passWord.leftView = bg1View;
    self.passWord.leftViewMode = UITextFieldViewModeAlways;
    
    self.Verify.leftView = bg2View;
    self.Verify.leftViewMode = UITextFieldViewModeAlways;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(phoneStrNoti:) name:@"phoneMsuStr" object:nil];
}


- (void)phoneStrNoti:(NSNotification *)noti{
    self.userName.text = noti.userInfo[@"phoneStr"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark - 创建视图
- (void)CreateUI{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0x222222],NSFontAttributeName: [UIFont systemFontOfSize:18]}];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self createLeftNavigationItem:[UIImage imageNamed:@"nav_icon_back_white"]];
    
    [self.userName addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    UIButton *passWordRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    passWordRightButton.frame = CGRectMake(0, 0, 40, 30);
    passWordRightButton.selected = NO;
    
    [passWordRightButton addTarget:self action:@selector(passWordRightButtonclick:) forControlEvents:UIControlEventTouchUpInside];
    [passWordRightButton setImage:[UIImage imageNamed:@"login_pass_right"] forState:UIControlStateNormal];
    [passWordRightButton setImage:[UIImage imageNamed:@"login_pass_right_open"] forState:UIControlStateSelected];
    
    self.passWord.rightView=passWordRightButton;
    self.passWord.rightViewMode = UITextFieldViewModeAlways;
    [self.passWord addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    [self.Verify addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyBoard:)];
    [self.view addGestureRecognizer:tapGesture];
    
    self.VerifyRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.VerifyRightButton.frame = CGRectMake(0, 0, 80, 30);
    [self.VerifyRightButton addTarget:self action:@selector(getImage) forControlEvents:UIControlEventTouchUpInside];
    [self.VerifyRightButton setAdjustsImageWhenHighlighted:NO];
    self.Verify.rightView=self.VerifyRightButton;
    self.Verify.rightViewMode = UITextFieldViewModeAlways;
    
    self.registButton.layer.borderWidth = 1;
    self.registButton.layer.borderColor = [UIColor colorWithHex:0xFB6337].CGColor;
    self.backView.layer.cornerRadius = 250;
}

- (UIToolbar *)addToolbar {
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 40)];
    toolbar.tintColor = [UIColor colorWithHex:0x4A90E2];
    toolbar.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *flbSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"完成",nil) style:UIBarButtonItemStylePlain target:self action:@selector(textFieldDone)];
    toolbar.items = @[flbSpace,doneItem];
    return toolbar;
}

#pragma mark - 点击事件
- (void)textFieldDone{
    [self.view endEditing:YES];
}

- (void)passWordRightButtonclick:(UIButton *)sender{
    sender.selected = !sender.selected;
    self.passWord.secureTextEntry = !sender.selected;
}

- (IBAction)LoginButtonClick:(id)sender {
    [self KeyboardresignFirstResponder];
    
    NSString* phoneStr = [self.userName.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (phoneStr.length == 0) {
        [PAProgressView showInView:self.view  contentString:@"请输入手机号码"];
        return;
    }
    if (_passWord.text.length == 0) {
        [PAProgressView showInView:self.view  contentString:@"请输入密码"];
        return;
    }
    if (![VerifyRegexTool checkTelNumber:phoneStr]) {
        [PAProgressView showInView:self.view  contentString:@"请输入正确的手机号"];
        return;
    }
    NSMutableDictionary *prams = [[NSMutableDictionary alloc] init];
    [prams setObject:phoneStr forKey:@"username"];
    [prams setObject:_passWord.text forKey:@"password"];
    if (!_Verify.hidden &&_Verify.text.length >0) {
        [prams setObject:_Verify.text forKey:@"vcodeImage"];
    }

    //跳转到个人中心
    NSDictionary *registerData = [NSDictionary dictionaryWithObjectsAndKeys:phoneStr,@"UserName",_passWord.text,@"PassWord",@"true",@"isActivelog", nil];
    [[NSUserDefaults standardUserDefaults] setObject:registerData forKey:@"registerData"];
    [[NSUserDefaults standardUserDefaults] setObject:_userName.text forKey:@"MSUUserName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (self.loginType == logintypeHome)
    {
        AppDelegate *jj = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [jj loadMainView];
        [jj.mainVC setSelectedIndex:2];
    }else
    {
        NSArray *viewcontrollers=self.navigationController.viewControllers;
        if (viewcontrollers.count>1) {
            if ([viewcontrollers objectAtIndex:viewcontrollers.count-1]==self) {
                //push方式
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        else{
            //present方式
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

- (void)getImage{
    [self KeyboardresignFirstResponder];

    [NetworkTools GetImageFromUrlString:VerifyImageUrl withParams:nil andResultBlock:^(UIImage *imageData) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.VerifyRightButton setImage:imageData forState:UIControlStateNormal];
        });
    } andfail:^{
        [AddHudView addProgressView:self.view message:@"网络错误，请重新刷新"];
    }];
}

- (void)RequestUserInfo{
    [[DataRequestServer getDataRequestServerData] request:@"LunaP2pAppAccountServlet" parameters:nil result:^(id result) {
        if ([result isKindOfClass:[NSString class]] &&  [result isEqualToString:@"44"]) {
            [AddHudView addProgressView:self.view message:@"网络错误，请稍后再试"];
        }else{
            int success = [[result objectForKey:@"success"]intValue];
            if ([[result objectForKey:@"errorlog"]isEqualToString:@"noLogin"]&& success==0)
            {
                
            }else if([[result objectForKey:@"errorlog"]isEqualToString:@""]&& success==1)
            {
                NSDictionary *userInfo=[[result objectForKey:@"items"]objectAtIndex:0];
                [CoreArchive setDictionary:userInfo key:@"userInfoDetial"];
                
                int isLockedBank=[[userInfo objectForKey:@"isLockedBank"]intValue];

                if (isLockedBank == 1) {
                    [CoreArchive ishasLockedBank:YES];
                }else{
                    [CoreArchive ishasLockedBank:NO];
                }
                [[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:@"userInfoDetial"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
            }else
            {
                [AddHudView addProgressView:self.view message:@"数据获取失败，请重新获取"];
            }
        }
    }];
}

- (IBAction)ForgotButttonClick:(id)sender {
    [self KeyboardresignFirstResponder];
    ForgetViewController *forgetView = [[ForgetViewController alloc] init];
    [self.navigationController pushViewController:forgetView animated:YES];
}
- (IBAction)registButtonClick:(id)sender {
    [self KeyboardresignFirstResponder];

    RegistStepOneViewController *VC =[[RegistStepOneViewController alloc] init];
    __weak typeof(self) weakSelf = self;
    VC.RegistBlock = ^(NSString *PhoneStr) {
        weakSelf.userName.text = PhoneStr;
        [weakSelf.passWord becomeFirstResponder];
    };
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)LeftNavigationButtonClick:(UIButton *)leftbtn{
    [self KeyboardresignFirstResponder];
    
    if (self.loginType == logintypeHome || self.loginType == logintypeOutTime) {
        AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appdelegate loadMainView];
        appdelegate.mainVC.selectedIndex = 0;
        appdelegate.mainVC.tabBar.hidden = NO;
    }else{
        NSArray *viewcontrollers=self.navigationController.viewControllers;
        if (viewcontrollers.count>1) {
            if ([viewcontrollers objectAtIndex:viewcontrollers.count-1]==self) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        else{
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

- (IBAction)BackButtonClick:(id)sender {
    [self KeyboardresignFirstResponder];
    
    if (self.loginType == logintypeHome || self.loginType == logintypeOutTime) {
        AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appdelegate loadMainView];
        appdelegate.mainVC.selectedIndex = 0;
        appdelegate.mainVC.tabBar.hidden = NO;
    }else{
        NSArray *viewcontrollers=self.navigationController.viewControllers;
        if (viewcontrollers.count>1) {
            if ([viewcontrollers objectAtIndex:viewcontrollers.count-1]==self) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        else{
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
        
    }
}

#pragma mark - 代理相关
- (void)textFieldDidChange:(UITextField *)filed{
    if (filed ==  self.userName) {
        if (filed.text.length > 13) {
            filed.text = [filed.text substringToIndex:13];
        }
        NSUInteger targetCursorPosition = [filed offsetFromPosition:filed.beginningOfDocument toPosition:filed.selectedTextRange.start];
        
        NSString* nStr = [filed.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString* preTxt = [self.previousTextFieldContent stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        
        char editFlag = 0;// 正在执行删除操作时为0，否则为1
        if (nStr.length <= preTxt.length) {
            editFlag = 0;
        }else{
            editFlag = 1;
        }
        
        NSString* spaceStr = @" ";
        NSMutableString *mStrTemp = [NSMutableString string];
        
        int spaceCount = 0;
        if (nStr.length < 3 && nStr.length > -1) {
            spaceCount = 0;
        }else if (nStr.length < 7&& nStr.length > 2){
            spaceCount = 1;
        }else if (nStr.length < 12&& nStr.length > 6){
            spaceCount = 2;
        }
        for (int i = 0; i < spaceCount; i++){
            if (i == 0) {
                [mStrTemp appendFormat:@"%@%@", [nStr substringWithRange:NSMakeRange(0, 3)],spaceStr];
            }else if (i == 1){
                [mStrTemp appendFormat:@"%@%@", [nStr substringWithRange:NSMakeRange(3, 4)], spaceStr];
            }else if (i == 2){
                [mStrTemp appendFormat:@"%@%@", [nStr substringWithRange:NSMakeRange(7, 4)], spaceStr];
            }
        }
        
        if (nStr.length == 11){
            [mStrTemp appendFormat:@"%@%@", [nStr substringWithRange:NSMakeRange(7, 4)], spaceStr];
        }
        
        if (nStr.length < 4) {
            [mStrTemp appendString:[nStr substringWithRange:NSMakeRange(nStr.length - nStr.length % 3, nStr.length % 3)]];
        }else if(nStr.length > 3 && nStr.length <12) {
            NSString *str = [nStr substringFromIndex:3];
            [mStrTemp appendString:[str substringWithRange:NSMakeRange(str.length - str.length % 4, str.length % 4)]];
            if (nStr.length == 11) {
                [mStrTemp deleteCharactersInRange:NSMakeRange(13, 1)];
            }
        }
        filed.text = mStrTemp;
        NSUInteger curTargetCursorPosition = targetCursorPosition;// 当前光标的偏移位置
        if (editFlag == 0){
            //删除
            if (targetCursorPosition == 9 || targetCursorPosition == 4){
                curTargetCursorPosition = targetCursorPosition - 1;
            }
        }
        else {
            //添加
            if (nStr.length == 8 || nStr.length == 4){
                curTargetCursorPosition = targetCursorPosition + 1;
            }
        }
        
        UITextPosition *targetPosition = [filed positionFromPosition:filed.beginningOfDocument offset:curTargetCursorPosition];
        [filed setSelectedTextRange:[filed textRangeFromPosition:targetPosition toPosition :targetPosition]];
    }
    
    if (self.userName.text.length ==13 && self.passWord.text.length >5) {
        self.LoginButton.enabled = YES;
        self.LoginButton.backgroundColor = [UIColor colorWithHex:0xFB6337 alpha:1];
    }else{
        self.LoginButton.enabled = NO;
        self.LoginButton.backgroundColor = [UIColor colorWithHex:0xFB6337 alpha:0.5];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self KeyboardresignFirstResponder];
    return YES;
}

- (void)resignKeyBoard:(UITapGestureRecognizer *)tap{
    [self KeyboardresignFirstResponder];
}

- (void)KeyboardresignFirstResponder
{
    if ([_userName isFirstResponder])//判断是否是第一响应
    {
        [_userName resignFirstResponder];
    }
    
    if ([_passWord isFirstResponder])//判断是否是第一响应
    {
        [_passWord resignFirstResponder];
    }
    
    if ([_Verify isFirstResponder])//判断是否是第一响应
    {
        [_Verify resignFirstResponder];
    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == self.userName) {
        self.previousTextFieldContent = textField.text;
        self.previousSelection = textField.selectedTextRange;
    }
    return YES;
}


#pragma mark - 键盘通知
- (void)addNoticeForKeyboard {
    
    //注册键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    //注册键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

///键盘显示事件
- (void) keyboardWillShow:(NSNotification *)notification {
    //获取键盘高度，在不同设备上，以及中英文下是不同的
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    //计算出键盘顶端到inputTextView panel底端的距离(加上自定义的缓冲距离INTERVAL_KEYBOARD)
    CGFloat offset = (self.registButton.bottom) - (kDeviceHeight - kbHeight);
    
    // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //将视图上移计算好的偏移
    if(offset > 0) {
        [UIView animateWithDuration:duration animations:^{
            self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
}

///键盘消失事件
- (void) keyboardWillHide:(NSNotification *)notify {
    // 键盘动画时间
    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //视图下沉恢复原状
    [UIView animateWithDuration:duration animations:^{
        if (is_iPhoneX) {
            self.view.frame = CGRectMake(0,64+24,kDeviceWidth, kDeviceHeight-64-24);
        } else {
            self.view.frame = CGRectMake(0,64,kDeviceWidth, kDeviceHeight-64);
        }
    }];
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

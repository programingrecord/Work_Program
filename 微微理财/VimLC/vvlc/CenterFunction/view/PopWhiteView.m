//
//  PopWhiteView.m
//  vvlc
//
//  Created by 慧明 on 2017/11/30.
//  Copyright © 2017年 HM. All rights reserved.
//

#import "PopWhiteView.h"



#define  alertViewWidth  20


@interface PopWhiteView()

@property (strong, nonatomic)   UIView        *backgroundView;
@property (nonatomic, strong)   UILabel        *TitleLabel;
@property (strong, nonatomic)   UITextField   *VerifyField;
@property (strong, nonatomic)   UIButton      *FinishButton;
@property (strong, nonatomic)   UIButton      *GetVerifyButton;
@property (strong, nonatomic)   UIButton      *CloseButton;


@end


@implementation PopWhiteView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor whiteColor];
        [self.backgroundView addSubview:self];
        [self addSubview:self.TitleLabel];
        [self addSubview:self.VerifyField];
        [self addSubview:self.CloseButton];
        
        self.VerifyField.rightView  = self.GetVerifyButton;
        [self.VerifyField becomeFirstResponder];
        self.VerifyField.rightViewMode = UITextFieldViewModeAlways;
        [self addSubview:self.FinishButton];
        self.frame = CGRectMake(alertViewWidth,120,
                                _backgroundView.frame.size.width -2* alertViewWidth,
                                220);
        self.layer.cornerRadius = 8;
    }
    return self;
}

- (UIView *)backgroundView
{
    if (_backgroundView == nil)
    {
        _backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        _backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        _backgroundView.layer.masksToBounds = YES;
    }
    return _backgroundView;
}

- (UILabel *)TitleLabel{
    if (!_TitleLabel) {
        _TitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 20, kDeviceWidth-100, 25)];
        _TitleLabel.textAlignment = NSTextAlignmentCenter;
        _TitleLabel.font = TEXTFONT(18);
        _TitleLabel.text = @"请输入短信验证码";
        _TitleLabel.textColor = [UIColor colorWithHex:0x000000];
    }
    return _TitleLabel;
}

- (UITextField *)VerifyField{
    if (!_VerifyField) {
        _VerifyField = [[UITextField alloc] init];
        _VerifyField.frame = CGRectMake(20, _TitleLabel.bottom+20,kDeviceWidth-80 , 50);
        _VerifyField.layer.borderWidth = 0.5;
        _VerifyField.layer.cornerRadius = 5;
        _VerifyField.keyboardType = UIKeyboardTypeNumberPad;
        _VerifyField.layer.borderColor = [UIColor colorWithHex:0xd8d8d8].CGColor;
        _VerifyField.inputAccessoryView = [self addToolbar];
    }
    return _VerifyField;
}

- (UIToolbar *)addToolbar {
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 40)];
    toolbar.tintColor = [UIColor colorWithHex:0x4A90E2];
    toolbar.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *flbSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"完成",nil) style:UIBarButtonItemStylePlain target:self action:@selector(textFieldDone)];
    toolbar.items = @[flbSpace,doneItem];
    return toolbar;
}

- (void)textFieldDone{
    [self endEditing:YES];
}

- (UIButton *)GetVerifyButton{
    if (!_GetVerifyButton) {
        _GetVerifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _GetVerifyButton.frame = CGRectMake(10, 0, 100, 45);
        [_GetVerifyButton setTitle:@"发送验证码" forState:UIControlStateNormal];
        _GetVerifyButton.titleLabel.font = TEXTFONT(12.0);
        [_GetVerifyButton setTitleColor:[UIColor colorWithHex:0xFB6337] forState:UIControlStateNormal];
        [_GetVerifyButton setBackgroundColor:[UIColor clearColor]];
        [_GetVerifyButton addTarget:self action:@selector(getVerifyButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _GetVerifyButton;
}

- (UIButton *)FinishButton{
    if (!_FinishButton) {
        _FinishButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _FinishButton.frame = CGRectMake(20,_VerifyField.bottom+30,kDeviceWidth-80, 50);
        [_FinishButton setTitle:@"完成" forState:UIControlStateNormal];
        _FinishButton.titleLabel.font = TEXTFONT(16.0);
        [_FinishButton setTitleColor:[UIColor colorWithHex:0xFFFFFF] forState:UIControlStateNormal];
        [_FinishButton setBackgroundColor:[UIColor colorWithHex:0xFB6337]];
        [_FinishButton addTarget:self action:@selector(finishButtonclick) forControlEvents:UIControlEventTouchUpInside];
        _FinishButton.layer.cornerRadius = 5;
        _FinishButton.clipsToBounds = YES;
    }
    return _FinishButton;
}

- (UIButton *)CloseButton{
    if (!_CloseButton) {
        _CloseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _CloseButton.contentMode = UIViewContentModeCenter;
        _CloseButton.frame = CGRectMake(_backgroundView.frame.size.width -2* alertViewWidth-40,7,40, 40);
        [_CloseButton setImage:[UIImage imageNamed:@"icon-close"] forState:UIControlStateNormal];
        [_CloseButton addTarget:self action:@selector(CloseButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _CloseButton;
}

- (void)show
{
    [[UIApplication sharedApplication].delegate.window addSubview:self.backgroundView];
    
    [UIView animateWithDuration:0.1 animations:^{
        _backgroundView.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.5];
    } completion:nil];
}

- (void)hide{
    [UIView animateWithDuration:0.1 animations:^{
        _backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    } completion:^(BOOL finished) {
        [self.backgroundView removeFromSuperview];
    }];
}

- (void)getVerifyButtonClick{
    [self endEditing:YES];
    __block int timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                self.GetVerifyButton.enabled = YES;
            });
        }else{
            NSString *starTime = [NSString stringWithFormat:@"%d秒后获取",timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.GetVerifyButton.enabled = NO;
                [self.GetVerifyButton setTitle:starTime forState:UIControlStateNormal];

            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    
    [MBProgressHUD showHUDAddedTo:self.backgroundView animated:YES];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:@"1" forKey:@"type"];
    [param setObject:@"vcodephone" forKey:@"hkey"];
    [param setObject:@"WeiMi" forKey:@"appIdenty"];
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary]
                                objectForKey:@"CFBundleShortVersionString"];
    [param setObject:currentVersion forKey:@"appVersion"];
    
    NSString *UrlString = [NSString stringWithFormat:@"%@luna_ajax.do", Base_url];
    
    AFHTTPSessionManager *manage = [AFHTTPSessionManager manager];
    manage.requestSerializer = [AFHTTPRequestSerializer serializer];
    manage.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manage.requestSerializer setValue:@"LUNA.APP.U.AGENT" forHTTPHeaderField:@"User-Agent"];
    
    [manage GET:UrlString parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:self.backgroundView animated:YES];
        
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        MyLog(@"luna_ajax.do%@",result);
        if([[result objectForKey:@"success"]isEqualToString:@"true"] &&[[result objectForKey:@"errorlog"]isEqualToString:@""]){
            [AddHudView addProgressView:self.backgroundView message:@"短信验证码已发送，请注意查收"];
        }else if([[result objectForKey:@"errorlog"]isEqualToString:@"1"] && [[result objectForKey:@"success"]isEqualToString:@"false"]){
            [AddHudView addProgressView:self.backgroundView message:@"获取短信数量已达到单日短信发送上限"];
            return;
        }else{
            [AddHudView addProgressView:self.backgroundView message:@"获取激活码失败，您可以重新获取"];
            return;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [AddHudView addProgressView:self.backgroundView message:@"网络错误，请稍后再试"];
        [[DataRequestServer getDataRequestServerData] requestImportWithUrl:UrlString Error:error urlParams:param];
    }];
}

- (void)finishButtonclick{
    [self endEditing:YES];
    
    if (self.VerifyField.text ==nil || self.VerifyField.text.length<4) {
        [AddHudView addProgressView:self.backgroundView message:@"请输入正确的短信验证码"];
        return;
    }
    [self hide];
    if (self.ButtonBlock) {
        self.ButtonBlock(self.VerifyField.text);
    }
}

- (void)CloseButtonClick{
    [self hide];
}

@end

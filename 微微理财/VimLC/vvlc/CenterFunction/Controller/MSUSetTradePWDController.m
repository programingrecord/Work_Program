//
//  MSUSetTradePWDController.m
//  vvlc
//
//  Created by 007 on 2018/4/23.
//  Copyright © 2018年 HM. All rights reserved.
//

#import "MSUSetTradePWDController.h"
#import "MSUSureTradePWDController.h"
#import "MSUTopUpController.h"

#import "MSUTextField.h"

@interface MSUSetTradePWDController ()<MSUTextFieldDelegate>

@property (nonatomic , strong) UIView *pwdView;

@property (nonatomic , strong) MSUTextField *pwdTF;
@property (nonatomic , strong) NSMutableArray *pwdBtnArr;

@property (nonatomic , copy) NSString *pwdStr;

@property (nonatomic , strong) UIButton *nextBtn;

@property (nonatomic , strong) UILabel *topLab;

@end

@implementation MSUSetTradePWDController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.pwdTF) {
        [_pwdTF becomeFirstResponder];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.pwdType == MSUSetPwd) {
        self.title = @"输入交易密码";
    } else if ( self.pwdType == MSUResetPwd){
        self.title = @"修改交易密码";
    }
    
    self.view.backgroundColor = HEXCOLOR(0xffffff);
    
    UIView *lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(0, 0, kDeviceWidth, 1);
    lineView.backgroundColor = HEXCOLOR(0xe4e4e4);
    [self.view addSubview:lineView];
    
    [self createTradeView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createTradeView{
    self.pwdView.hidden = NO;
    
    self.nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextBtn.frame = CGRectMake(17, 143, kDeviceWidth-34, 49*kDeviceHeightScale);
    _nextBtn.backgroundColor = HEXCOLOR(0xe8e8e8);
    [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [_nextBtn setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
    _nextBtn.enabled = NO;
    _nextBtn.clipsToBounds = YES;
    _nextBtn.layer.cornerRadius = 4;
    _nextBtn.layer.shouldRasterize = YES;
    _nextBtn.layer.rasterizationScale = [UIScreen mainScreen].scale;
    _nextBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:_nextBtn];
    [_nextBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (UIView *)pwdView{
    if (!_pwdView) {
        self.pwdView = [[UIView alloc] initWithFrame:CGRectMake(0, 1, kDeviceWidth, 98)];
        _pwdView.backgroundColor = HEXCOLOR(0xffffff);
        [self.view addSubview:_pwdView];
        
        self.topLab = [[UILabel alloc] init];
        _topLab.frame = CGRectMake(20, 26, kDeviceWidth*0.5, 20);
        if (self.pwdType == MSUSetPwd) {
            _topLab.text = @"设置6位数字交易密码";
        } else if ( self.pwdType == MSUResetPwd){
            _topLab.text = @"请输入旧密码";
        }
        _topLab.textColor = HEXCOLOR(0x1f2425);
        _topLab.font = [UIFont systemFontOfSize:14];
        [_pwdView addSubview:_topLab];
        
        self.pwdTF = [[MSUTextField alloc] init];
        //    _pwdTF.backgroundColor  = [UIColor clearColor];
        _pwdTF.frame = CGRectMake(_topLab.left, _topLab.bottom + 12, kDeviceWidth-40, 49*kDeviceHeightScale);
        _pwdTF.textColor = HEXCOLOR(0xf4f4f4);
        _pwdTF.keyboardType = UIKeyboardTypeNumberPad;
        _pwdTF.delegate = self;
        [_pwdView addSubview:_pwdTF];
        [_pwdTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [_pwdTF becomeFirstResponder];
        
        //    MSUTextField *msu = [[MSUTextField alloc] init];
        //    msu.delegate = self;
        
        UIView *fuView = [[UIView alloc] init];
        fuView.frame = CGRectMake(_topLab.left-1, _topLab.bottom + 12, kDeviceWidth-40, 49*kDeviceHeightScale);
        fuView.backgroundColor = HEXCOLOR(0xffffff);
        [_pwdView addSubview:fuView];
        fuView.layer.borderWidth = 0.5;
        fuView.layer.borderColor = HEXCOLOR(0xe4e4e4).CGColor;
        
        CGFloat wid = (kDeviceWidth-40)/6;
        for (NSInteger i = 0; i < 6; i++) {
            UILabel *pwdLab = [[UILabel alloc] init];
            pwdLab.frame = CGRectMake(wid*i, 0, wid, 49*kDeviceHeightScale);
            pwdLab.textAlignment = NSTextAlignmentCenter;
//            pwdLab.backgroundColor = HEXCOLOR(0xffffff);
//            pwdLab.layer.borderWidth = 1;
//            pwdLab.layer.borderColor = HEXCOLOR(0x979797).CGColor;
            pwdLab.textColor = HEXCOLOR(0x333333);
            pwdLab.font = [UIFont systemFontOfSize:14];
            [fuView addSubview:pwdLab];
            [self.pwdBtnArr addObject:pwdLab];
        }
        
        for (NSInteger i = 0; i < 5; i++) {
            UIView *lineView = [[UIView alloc] init];
            lineView.frame = CGRectMake(wid+wid*i, 0, 0.5, 49*kDeviceHeightScale);
            lineView.backgroundColor = HEXCOLOR(0xe4e4e4);
            [fuView addSubview:lineView];
        }
        
        _pwdView.hidden = YES;
        
    }
    return _pwdView;
}

- (NSMutableArray *)pwdBtnArr{
    if (!_pwdBtnArr) {
        self.pwdBtnArr = [NSMutableArray array];
    }
    return _pwdBtnArr;
}

#pragma mark - 交互
- (void)LeftNavigationButtonClick:(UIButton *)leftbtn{
    NSArray *viewcontrollers=self.navigationController.viewControllers;

    if ([self.backStr isEqualToString:@"original"]) {
        for (UIViewController *vc in viewcontrollers) {
            if ([vc isKindOfClass:[MSUTopUpController class]]) {
                [self.navigationController popToViewController:vc animated:YES];
            }
        }
    } else {
        if (viewcontrollers.count>1) {
            if ([viewcontrollers objectAtIndex:viewcontrollers.count-1]==self) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        else{
            //present方式
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

- (void)textFieldDidChange:(UITextField *)textField{
    if (textField == self.pwdTF) {
        if (textField.text.length > 0 && textField.text.length < 7) {
            UILabel *label = self.pwdBtnArr[textField.text.length-1];
            if (self.pwdStr.length > textField.text.length) {
                label.text = @"●";
            } else {
                label.text = [textField.text substringWithRange:NSMakeRange(textField.text.length-1, 1)];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    label.text = @"●";
                });
            }
          
            self.pwdStr = textField.text;
            if (self.pwdStr.length == 6) {
                if (self.pwdType == MSUSetPwd) {
                    if ([self.pwdStr isEqualToString:@"123456"] || [self.pwdStr isEqualToString:@"234567"] || [self.pwdStr isEqualToString:@"345678"] || [self.pwdStr isEqualToString:@"456789"] || [self.pwdStr isEqualToString:@"012345"] || [self.pwdStr isEqualToString:@"543210"] || [self.pwdStr isEqualToString:@"654321"] || [self.pwdStr isEqualToString:@"765432"] || [self.pwdStr isEqualToString:@"876543"] || [self.pwdStr isEqualToString:@"987654"]) {
                        //                    [PAProgressView showInView:self.view contentString:@"交易密码不得为6位连续数字"];
                        _topLab.text = @"交易密码不得为6位连续数字";
                        _topLab.textColor = HEXCOLOR(0xea1d27);
                        [self clearTradePWD];
                    }
                    else if ([self.pwdStr isEqualToString:@"000000"] || [self.pwdStr isEqualToString:@"111111"] || [self.pwdStr isEqualToString:@"222222"] || [self.pwdStr isEqualToString:@"333333"] || [self.pwdStr isEqualToString:@"444444"] || [self.pwdStr isEqualToString:@"555555"] || [self.pwdStr isEqualToString:@"666666"] || [self.pwdStr isEqualToString:@"777777"] || [self.pwdStr isEqualToString:@"888888"] || [self.pwdStr isEqualToString:@"999999"]){
                        
                        //                    [PAProgressView showInView:self.view contentString:@"交易密码不得为6位重复数字"];
                        _topLab.text = @"交易密码不得为6位重复数字";
                        _topLab.textColor = HEXCOLOR(0xea1d27);
                        [self clearTradePWD];
                    } else {
                        //                    [_nextBtn setTitleColor:HEXCOLOR(0xFB6337) forState:UIControlStateNormal];
                        _nextBtn.backgroundColor = HEXCOLOR(0xff6339);
                        _nextBtn.enabled = YES;
                    }
                } else if (self.pwdType == MSUResetPwd){
                    NSString *oldPwd = [CoreArchive strForKey:@"MSUTradePwd"];
                    if ([oldPwd isEqualToString:self.pwdStr]) {
                        _nextBtn.backgroundColor = HEXCOLOR(0xff6339);
                        _nextBtn.enabled = YES;
                    }else{
                        _topLab.text = @"旧密码输入错误";
                        _topLab.textColor = HEXCOLOR(0xea1d27);
                        [self clearTradePWD];

                    }
                }
            }
        }
    }
}

- (void)clearTradePWD{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.pwdStr = @"";
        _pwdTF.text = @"";
        for (UILabel *lab in self.pwdBtnArr) {
            lab.text = @"";
        }
    });
    
}

-(void)nextBtnClick:(UIButton *)sender{
    if (self.pwdType == MSUSetPwd) {
        MSUSureTradePWDController *sure = [[MSUSureTradePWDController alloc] init];
        sure.hidesBottomBarWhenPushed = YES;
        sure.pwdOrigilStr = self.pwdStr;
        sure.signStr = self.signStr;
        [self.navigationController pushViewController:sure animated:YES];
    } else if (self.pwdType == MSUResetPwd){
        MSUSetTradePWDController *set = [[MSUSetTradePWDController alloc] init];
        set.signStr = @"account";
        set.pwdType = MSUSetPwd;
        [self.navigationController pushViewController:set animated:YES];
    }
}

- (void)deleteBtnClick:(UITextField *)textField{
    if (textField == self.pwdTF) {
        if (textField.text.length > 5) {
            textField.text = [textField.text substringToIndex:5];
        }
        NSLog(@"text  -- %@",textField.text);

        if ((textField.text.length > 0 && textField.text.length < 6)|| textField.text.length == 0) {
            UILabel *label = self.pwdBtnArr[textField.text.length];
            label.text = @"";

            for (NSInteger i = textField.text.length; i<6; i++) {
                UILabel *label1 = self.pwdBtnArr[i];
                label1.text = @"";
            }
            
            self.pwdStr = textField.text;
//            [_nextBtn setTitleColor:HEXCOLOR(0x939393) forState:UIControlStateNormal];
            _nextBtn.backgroundColor = HEXCOLOR(0xe8e8e8);
            _nextBtn.enabled = NO;
        }
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

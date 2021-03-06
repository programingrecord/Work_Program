//
//  CurrentOutViewController.m
//  SmallCat
//
//  Created by H on 2017/6/6.
//  Copyright © 2017年 HM. All rights reserved.
//

#import "CurrentOutViewController.h"

@interface CurrentOutViewController ()<UITextFieldDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *AmountTextField;
@property (weak, nonatomic) IBOutlet UIButton *SureButton;

@end

@implementation CurrentOutViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUI];
    // Do any additional setup after loading the view from its nib.
}

- (void)setUI{
    self.title = @"转出到余额";
    
    self.SureButton.layer.cornerRadius = 4;
    self.AmountTextField.placeholder = [NSString stringWithFormat:@"本次最多可转出 %@ 元",self.AmountStr];
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 45)];
    lable.text= @"金额";
    lable.font = TEXTFONT(16);
    lable.textColor = [UIColor colorWithHex:0x666666];
    lable.textAlignment = NSTextAlignmentCenter;
    self.AmountTextField.leftView= lable;
    self.AmountTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.AmountTextField addTarget:self action:@selector(textChangeAction:) forControlEvents:UIControlEventEditingChanged];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyBoard:)];
    [self.view addGestureRecognizer:tapGesture];
}

#pragma mark- delegate
- (IBAction)SureButtonClick:(id)sender {
    [self KeyboardresignFirstResponder];

    NSNumber *a=[NSNumber numberWithFloat:self.AmountTextField.text.floatValue];
    NSNumber *b=[NSNumber numberWithFloat:self.AmountStr.floatValue];
    if ([b compare:a]==NSOrderedAscending)
    {
        [AddHudView addProgressView:self.view message:@"输入金额大于可转出金额"];
        return;
    }
   
    UIAlertView *Alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"确定要赎回吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定赎回", nil];
    [Alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSMutableDictionary *Dic = [[NSMutableDictionary alloc] init];
        [Dic setObject:self.AmountTextField.text forKey:@"redeemAmount"];
        
        [[DataRequestServer getDataRequestServerData] request:@"LunaP2pAppCurrentWithdrawAmountServlet" parameters:Dic result:^(id result) {
            if ([result isKindOfClass:[NSString class]] &&  [result isEqualToString:@"44"]) {
                [AddHudView addProgressView:self.view message:@"转出到余额失败，请稍后再试"];
            }else{
                int t = [[result objectForKey:@"success"] intValue];
                if ([[result objectForKey:@"errorlog"]isEqualToString:@"noLogin"]&& t==0){//要加上未登录的判断
                    [self requestLogin:logintypeOutTime];
                    
                }else if ([[result objectForKey:@"errorlog"]isEqualToString:@""]&& t==1){
                    [AddHudView addProgressView:self.view message:@"恭喜你，转出成功"];
                    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
                    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                }else{
                    [AddHudView addProgressView:self.view message:@"转出到余额失败，请稍后再试"];
                }
            }
        }];
    }
}

- (void) textChangeAction:(id) sender {
    if (self.AmountTextField.text.length>0) {
        [self.SureButton setBackgroundColor:[UIColor colorWithHex:0xFB6337]];
        self.SureButton.enabled = YES;
    }else{
        self.SureButton.enabled = NO;
        [self.SureButton setBackgroundColor:[UIColor colorWithHex:0xDEDEDE]];
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
    if ([_AmountTextField isFirstResponder])//判断是否是第一响应
    {
        [_AmountTextField resignFirstResponder];
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

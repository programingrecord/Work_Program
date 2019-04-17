//
//  MSUCurrentOutController.m
//  vvlc
//
//  Created by 007 on 2018/5/3.
//  Copyright © 2018年 HM. All rights reserved.
//

#import "MSUCurrentOutController.h"

#import "MSUPathTools.h"
#import "MSUCustomTF1.h"
#import "MSUStringTools.h"

@interface MSUCurrentOutController ()<UITextFieldDelegate,UIAlertViewDelegate>

@property (nonatomic , strong) MSUCustomTF1 *moneyTF;

@property (nonatomic , strong) UIButton *sureBtn;


@end

@implementation MSUCurrentOutController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"转出到余额";
    self.view.backgroundColor = HEXCOLOR(0xE8E8E8);
    
    [self createSubView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createSubView{
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(0, 13, kDeviceWidth, 190);
    bgView.backgroundColor = HEXCOLOR(0xffffff);
    [self.view addSubview:bgView];
    
    UIImageView *imaView = [[UIImageView alloc] initWithFrame:CGRectMake(16.5, 13.5, 24, 24)];
    imaView.image = [MSUPathTools showImageWithContentOfFileByName:@"ye_icon"];
    [bgView addSubview:imaView];
    
    UILabel *titLab = [[UILabel alloc] init];
    titLab.frame = CGRectMake(imaView.right + 10.5, 13.5, 90, 22.5);
    titLab.text = @"转出到余额";
    titLab.font = [UIFont systemFontOfSize:16];
    titLab.textColor = HEXCOLOR(0x757575);
    [bgView addSubview:titLab];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(0, titLab.bottom + 12, kDeviceWidth, 0.5);
    lineView.backgroundColor = HEXCOLOR(0xD1D1D1);
    [bgView addSubview:lineView];
    
    UILabel *subTitLab = [[UILabel alloc] init];
    subTitLab.frame = CGRectMake(15, lineView.bottom + 11, 200, 21);
    subTitLab.text = @"转出金额（元）";
    subTitLab.font = [UIFont systemFontOfSize:16];
    subTitLab.textColor = HEXCOLOR(0x757575);
    [bgView addSubview:subTitLab];
    
    self.moneyTF = [[MSUCustomTF1 alloc] init];
    _moneyTF.font = [UIFont systemFontOfSize:24];
    if (iOS11) {
        _moneyTF.tfType = MSUNone20;
    } else{
        _moneyTF.tfType = MSUTypeRight;
    }
    _moneyTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入金额" attributes:@{NSForegroundColorAttributeName: HEXCOLOR(0xCFCFCF),NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    _moneyTF.frame = CGRectMake(12, subTitLab.bottom + 25, kDeviceWidth-24, 28);
    _moneyTF.textColor = HEXCOLOR(0x333333);
    //        _shopTF = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 30)];
    //        _shopTF = UITextFieldViewModeAlways;
    _moneyTF.keyboardType = UIKeyboardTypeDecimalPad;
    _moneyTF.delegate = self;
    [bgView addSubview:_moneyTF];
    
    UILabel *symbolLab = [[UILabel alloc] init];
    symbolLab.frame = CGRectMake(0, 0, 20, 28*kDeviceHeightScale);
    symbolLab.text = @"¥";
    symbolLab.font = [UIFont systemFontOfSize:24];
    symbolLab.textColor = HEXCOLOR(0x4A4A4A);
    _moneyTF.leftView = symbolLab;
    _moneyTF.leftViewMode = UITextFieldViewModeAlways;
    
    _moneyTF.inputAccessoryView = [self addToolbar];
    
    UIView *line1View = [[UIView alloc] init];
    line1View.frame = CGRectMake(17, _moneyTF.bottom + 11, kDeviceWidth-17, 0.5);
    line1View.backgroundColor = HEXCOLOR(0xD1D1D1);
    [bgView addSubview:line1View];
    
    UILabel *outLab = [[UILabel alloc] init];
    outLab.frame = CGRectMake(15, line1View.bottom + 12, kDeviceWidth, 20);
    outLab.font = [UIFont systemFontOfSize:16];
    outLab.textColor = HEXCOLOR(0x757575);
    outLab.attributedText = [MSUStringTools makeKeyWordAttributedWithSubText:self.AmountStr inOrigiText:[NSString stringWithFormat:@"可转出金额：%@元",self.AmountStr] font:16 color:HEXCOLOR(0xFB6337)];
    [bgView addSubview:outLab];
    
    self.sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _sureBtn.frame = CGRectMake(22, bgView.bottom + 45, kDeviceWidth-44, 49);
    _sureBtn.backgroundColor = HEXCOLOR(0xFB6337);
    _sureBtn.layer.cornerRadius = 4;
    _sureBtn.clipsToBounds = YES;
    _sureBtn.layer.shouldRasterize = YES;
    _sureBtn.layer.rasterizationScale = [UIScreen mainScreen].scale;
    [_sureBtn setTitle:@"确认转出" forState:UIControlStateNormal];
    [_sureBtn setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
    _sureBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:_sureBtn];
    [_sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
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

- (void)textFieldDone{
    [self.view endEditing:YES];
}

- (void)sureBtnClick:(UIButton *)sender{
    [self KeyboardresignFirstResponder];
    
    NSNumber *a=[NSNumber numberWithFloat:self.moneyTF.text.floatValue];
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
        [Dic setObject:self.moneyTF.text forKey:@"redeemAmount"];
        
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
    if (self.moneyTF.text.length>0) {
        [self.sureBtn setBackgroundColor:[UIColor colorWithHex:0xFB6337]];
        self.sureBtn.enabled = YES;
    }else{
        self.sureBtn.enabled = NO;
        [self.sureBtn setBackgroundColor:[UIColor colorWithHex:0xDEDEDE]];
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
    if ([_moneyTF isFirstResponder])//判断是否是第一响应
    {
        [_moneyTF resignFirstResponder];
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

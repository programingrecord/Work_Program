//
//  AddCardViewController.m
//  WTJR
//
//  Created by H on 16/6/5.
//  Copyright © 2016年 HM. All rights reserved.
//

#import "AddCardViewController.h"
#import "PickerChoiceView.h"
#import "LoginViewController.h"
#import "UnderLineField.h"
#import "CustomUIEdgeInsetLabel.h"
#import "MSUSetTradePWDController.h"

#import "MSUStringTools.h"

@interface AddCardViewController ()<UITextFieldDelegate,UIGestureRecognizerDelegate,PickerChoiceDelegate,MSUTextFieldDelegate>

{
    NSString                        *bankIdStr;
    
}
//@property (weak, nonatomic) IBOutlet UnderLineField *UserCardID;
//@property (weak, nonatomic) IBOutlet UnderLineField *CardOwn;
//@property (weak, nonatomic) IBOutlet UnderLineField *CardNum;
//@property (weak, nonatomic) IBOutlet UnderLineField *CardBankChose;
//@property (weak, nonatomic) IBOutlet UIButton *TipButton;

@property (nonatomic,strong) NSMutableArray *bankArr;
@property (nonatomic,strong) NSMutableArray *provinceArr;
@property (nonatomic,strong) NSMutableArray *CityArr;

@property (nonatomic,strong) UnderLineField *UserCardID;
@property (nonatomic,strong) UnderLineField *CardOwn;
@property (nonatomic,strong) UnderLineField *CardNum;
@property (nonatomic,strong) UnderLineField *CardBankChose;
@property (nonatomic , strong) UIButton *TipButton;

@property (nonatomic,strong) NSMutableDictionary *infoDic;


@property (strong, nonatomic) UITextField *EditTextField;
@property (nonatomic , assign) BOOL isNoXinyong;
@property (nonatomic , strong) NSDictionary *bankDic;


@end

@implementation AddCardViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"添加银行卡";
    self.view.backgroundColor = HEXCOLOR(0xf0f0f0);
    
    self.bankDic = @{@"SRCB": @"深圳农村商业银行", @"BGB": @"广西北部湾银行", @"SHRCB": @"上海农村商业银行", @"BJBANK": @"北京银行", @"WHCCB": @"威海市商业银行", @"BOZK": @"周口银行", @"KORLABANK": @"库尔勒市商业银行", @"SPABANK": @"平安银行", @"SDEB": @"顺德农商银行", @"HURCB": @"湖北省农村信用社", @"WRCB": @"无锡农村商业银行", @"BOCY": @"朝阳银行", @"CZBANK": @"浙商银行", @"HDBANK": @"邯郸银行", @"BOC": @"中国银行", @"BOD": @"东莞银行", @"CCB": @"中国建设银行", @"ZYCBANK": @"遵义市商业银行", @"SXCB": @"绍兴银行", @"GZRCU": @"贵州省农村信用社", @"ZJKCCB": @"张家口市商业银行", @"BOJZ": @"锦州银行", @"BOP": @"平顶山银行", @"HKB": @"汉口银行",  @"NXRCU": @"宁夏黄河农村商业银行", @"NYNB": @"广东南粤银行", @"GRCB": @"广州农商银行", @"BOSZ": @"苏州银行", @"HZCB": @"杭州银行", @"HSBK": @"衡水银行", @"HBC": @"湖北银行", @"JXBANK": @"嘉兴银行", @"HRXJB": @"华融湘江银行", @"BODD": @"丹东银行", @"AYCB": @"安阳银行", @"EGBANK": @"恒丰银行", @"CDB": @"国家开发银行", @"TCRCB": @"江苏太仓农村商业银行", @"NJCB": @"南京银行", @"ZZBANK": @"郑州银行", @"DYCB": @"德阳商业银行", @"YBCCB": @"宜宾市商业银行", @"SCRCU": @"四川省农村信用", @"KLB": @"昆仑银行", @"LSBANK": @"莱商银行", @"YDRCB": @"尧都农商行", @"CCQTGB": @"重庆三峡银行", @"FDB": @"富滇银行", @"JSRCU": @"江苏省农村信用联合社", @"JNBANK": @"济宁银行", @"CMB": @"招商银行", @"JINCHB": @"晋城银行JCBANK", @"FXCB": @"阜新银行", @"WHRCB": @"武汉农村商业银行", @"HBYCBANK": @"湖北银行宜昌分行", @"TZCB": @"台州银行", @"TACCB": @"泰安市商业银行", @"XCYH": @"许昌银行", @"CEB": @"中国光大银行", @"NXBANK": @"宁夏银行", @"HSBANK": @"徽商银行", @"JJBANK": @"九江银行", @"NHQS": @"农信银清算中心", @"MTBANK": @"浙江民泰商业银行", @"LANGFB":@"廊坊银行", @"ASCB": @"鞍山银行", @"KSRB": @"昆山农村商业银行", @"YXCCB": @"玉溪市商业银行", @"DLB": @"大连银行", @"DRCBCL": @"东莞农村商业银行", @"GCB": @"广州银行", @"NBBANK": @"宁波银行", @"BOYK": @"营口银行", @"SXRCCU": @"陕西信合", @"GLBANK": @"桂林银行", @"BOQH": @"青海银行", @"CDRCB": @"成都农商银行", @"QDCCB": @"青岛银行", @"HKBEA": @"东亚银行", @"HBHSBANK": @"湖北银行黄石分行", @"WZCB": @"温州银行", @"TRCB": @"天津农商银行", @"QLBANK": @"齐鲁银行", @"GDRCC": @"广东省农村信用社联合社", @"ZJTLCB": @"浙江泰隆商业银行", @"GZB": @"赣州银行", @"GYCB": @"贵阳市商业银行", @"CQBANK": @"重庆银行", @"DAQINGB": @"龙江银行", @"CGNB": @"南充市商业银行", @"SCCB": @"三门峡银行", @"CSRCB": @"常熟农村商业银行", @"SHBANK": @"上海银行", @"JLBANK": @"吉林银行", @"CZRCB": @"常州农村信用联社", @"BANKWF": @"潍坊银行", @"ZRCBANK": @"张家港农村商业银行", @"FJHXBC": @"福建海峡银行", @"ZJNX": @"浙江省农村信用社联合社", @"LZYH": @"兰州银行", @"JSB": @"晋商银行", @"BOHAIB": @"渤海银行", @"CZCB": @"浙江稠州商业银行", @"YQCCB": @"阳泉银行", @"SJBANK": @"盛京银行", @"XABANK": @"西安银行", @"BSB": @"包商银行", @"JSBANK": @"江苏银行", @"FSCB": @"抚顺银行", @"HNRCU": @"河南省农村信用",@"COMM": @"交通银行", @"XTB": @"邢台银行", @"CITIC": @"中信银行", @"HXBANK": @"华夏银行", @"HNRCC": @"湖南省农村信用社", @"DYCCB": @"东营市商业银行", @"ORBANK": @"鄂尔多斯银行", @"BJRCB": @"北京农村商业银行", @"XYBANK": @"信阳银行", @"ZGCCB": @"自贡市商业银行", @"CDCB": @"成都银行", @"HANABANK": @"韩亚银行", @"CMBC": @"中国民生银行", @"LYBANK": @"洛阳银行", @"ZBCB": @"齐商银行", @"CBKF": @"开封市商业银行", @"H3CB": @"内蒙古银行", @"CIB": @"兴业银行", @"CRCBANK": @"重庆农村商业银行", @"SZSBK": @"石嘴山银行", @"DZBANK": @"德州银行", @"SRBANK": @"上饶银行", @"LSCCB": @"乐山市商业银行", @"JXRCU": @"江西省农村信用", @"ICBC": @"中国工商银行", @"JZBANK": @"晋中市商业银行", @"HZCCB": @"湖州市商业银行", @"NHB": @"南海农村信用联社", @"XXBANK": @"新乡银行", @"JRCB": @"江苏江阴农村商业银行", @"YNRCC": @"云南省农村信用社", @"ABC": @"中国农业银行", @"GXRCU": @"广西省农村信用", @"PSBC": @"中国邮政储蓄银行", @"BZMD": @"驻马店银行", @"ARCU": @"安徽省农村信用社", @"GSRCU": @"甘肃省农村信用", @"LYCB": @"辽阳市商业银行", @"JLRCU": @"吉林农信", @"URMQCCB": @"乌鲁木齐市商业银行", @"XLBANK": @"中山小榄村镇银行", @"CSCB": @"长沙银行", @"JHBANK": @"金华银行", @"BHB": @"河北银行", @"NBYZ": @"鄞州银行", @"LSBC": @"临商银行", @"BOCD": @"承德银行", @"SDRCU": @"山东农信", @"NCB": @"南昌银行", @"TCCB": @"天津银行", @"WJRCB": @"吴江农商银行", @"CBBQS": @"城市商业银行资金清算中心", @"HBRCU": @"河北省农村信用社",@"SDB":@"深圳发展银行",@"GDB":@"广发银行",@"SPDB":@"浦发银行",@"XINHE":@"中国信合"};
    
    [self createUI];
    [self registNSNotification];
    
    if (self.signIndex == 1) {
        _CardOwn.text = self.realName;
        _UserCardID.text = self.idNum;
    }
 
}

- (void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)registNSNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
//    [self getBankList];
}

- (void)createUI{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.infoDic= [[defaults objectForKey:@"userInfoDetial"] mutableCopy];
//    self.TipButton.titleLabel.numberOfLines = 0;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyBoard:)];
    [self.view addGestureRecognizer:tapGesture];
    
    self.CardOwn = [[UnderLineField alloc] init];
    _CardOwn.backgroundColor = WhiteColor;
    _CardOwn.placeholder = @"请输入本人真实姓名";
    _CardOwn.frame = CGRectMake(0, 12, kDeviceWidth, 50);
    _CardOwn.font = [UIFont systemFontOfSize:16];
    _CardOwn.textColor = HEXCOLOR(0x333333);
    _CardOwn.delegate = self;
    [self.view addSubview:_CardOwn];
    
    CustomUIEdgeInsetLabel *nameSpace = [[CustomUIEdgeInsetLabel alloc] initWithFrame:CGRectMake(0, 0, 90, 50)];
    nameSpace.textInsets = UIEdgeInsetsMake(-3, 10, 0, 0);
    nameSpace.text = @"真实姓名";
    nameSpace.font = TEXTFONT(16);
    nameSpace.textColor = [UIColor colorWithHex:0x666666];
    self.CardOwn.leftView = nameSpace;
    self.CardOwn.leftViewMode = UITextFieldViewModeAlways;

    self.UserCardID = [[UnderLineField alloc] init];
    _UserCardID.backgroundColor = WhiteColor;
    _UserCardID.placeholder = @"请输入18位身份证号码";
    _UserCardID.frame = CGRectMake(0, _CardOwn.bottom, kDeviceWidth, 50);
    _UserCardID.font = [UIFont systemFontOfSize:16];
    _UserCardID.textColor = HEXCOLOR(0x333333);
    _UserCardID.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _UserCardID.delegate = self;
    [self.view addSubview:_UserCardID];
    
    CustomUIEdgeInsetLabel *UserCardIDSpace = [[CustomUIEdgeInsetLabel alloc] initWithFrame:CGRectMake(0, 0, 90, 50)];
    UserCardIDSpace.textInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    UserCardIDSpace.text = @"身份证号";
    UserCardIDSpace.font = TEXTFONT(16);
    UserCardIDSpace.textColor = [UIColor colorWithHex:0x666666];
    self.UserCardID.leftView = UserCardIDSpace;
    self.UserCardID.leftViewMode = UITextFieldViewModeAlways;

    self.CardNum = [[UnderLineField alloc] init];
    _CardNum.backgroundColor = WhiteColor;
    _CardNum.placeholder = @"请输入银行卡号";
    _CardNum.frame = CGRectMake(0, _UserCardID.bottom+12, kDeviceWidth, 50);
    _CardNum.font = [UIFont systemFontOfSize:16];
    _CardNum.textColor = HEXCOLOR(0x333333);
    _CardNum.keyboardType = UIKeyboardTypeDecimalPad;
    _CardNum.delegate = self;
    [self.view addSubview:_CardNum];
    
    CustomUIEdgeInsetLabel *CardNumSpace = [[CustomUIEdgeInsetLabel alloc] initWithFrame:CGRectMake(0, 0, 90, 50)];
    CardNumSpace.textInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    CardNumSpace.text = @"银行卡号";
    CardNumSpace.font = TEXTFONT(16);
    CardNumSpace.textColor = [UIColor colorWithHex:0x666666];
    self.CardNum.leftView = CardNumSpace;
    self.CardNum.leftViewMode = UITextFieldViewModeAlways;
    self.CardNum.clearButtonMode = UITextFieldViewModeNever;
    self.CardNum.msudelegate = self;

    self.CardBankChose = [[UnderLineField alloc] init];
    _CardBankChose.backgroundColor = WhiteColor;
    _CardBankChose.placeholder = @"请选择支持的银行卡";
    _CardBankChose.frame = CGRectMake(0, _CardNum.bottom, kDeviceWidth, 50);
    _CardBankChose.font = [UIFont systemFontOfSize:16];
    _CardBankChose.textColor = HEXCOLOR(0x333333);
    _CardBankChose.delegate = self;
    [self.view addSubview:_CardBankChose];
    
    CustomUIEdgeInsetLabel *CardBankChoseSpace = [[CustomUIEdgeInsetLabel alloc] initWithFrame:CGRectMake(0, 0, 90, 50)];
    CardBankChoseSpace.textInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    CardBankChoseSpace.text = @"发卡银行";
    CardBankChoseSpace.font = TEXTFONT(16);
    CardBankChoseSpace.textColor = [UIColor colorWithHex:0x666666];
    self.CardBankChose.leftView = CardBankChoseSpace;
    self.CardBankChose.leftViewMode = UITextFieldViewModeAlways;

    UIImageView *BankTypeRight = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 50)];
    BankTypeRight.contentMode = UIViewContentModeCenter;
    BankTypeRight.image = [UIImage imageNamed:@"icon_arrow_right"];
    self.CardBankChose.rightView = BankTypeRight;
    self.CardBankChose.rightViewMode = UITextFieldViewModeAlways;
    
    if (self.bankStr.length > 0) {
        self.CardBankChose.text = self.bankStr;
    }
    
    self.TipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _TipButton.frame = CGRectMake(22, _CardBankChose.bottom + 26, kDeviceWidth-44, 49);
    _TipButton.backgroundColor = HEXCOLOR(0xFB6337);
    _TipButton.layer.cornerRadius = 4;
    _TipButton.clipsToBounds = YES;
    _TipButton.layer.shouldRasterize = YES;
    _TipButton.layer.rasterizationScale = [UIScreen mainScreen].scale;
    [_TipButton setTitle:@"提交" forState:UIControlStateNormal];
    [_TipButton setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
    _TipButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:_TipButton];
    [_TipButton addTarget:self action:@selector(TipButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *tishiLab = [[UILabel alloc] init];
    tishiLab.frame = CGRectMake(25, _TipButton.bottom + 16, kDeviceWidth-50, 20);
    tishiLab.text = @"温馨提示";
    tishiLab.font = [UIFont systemFontOfSize:14];
    tishiLab.textColor = HEXCOLOR(0x818181);
    [self.view addSubview:tishiLab];
    
    NSString *str = @"1、为保障账户安全，目前只支持绑定一张银行卡，充值提现同卡进出\n2、如遇到绑卡问题，请联系客服";
    CGRect recta = [MSUStringTools danamicGetHeightFromText:str WithWidth:kDeviceWidth-50 font:13];
    UILabel *introLab = [[UILabel alloc] init];
    introLab.frame = CGRectMake(25, tishiLab.bottom + 5, kDeviceWidth-50, recta.size.height);
    introLab.text = str;
    introLab.font = [UIFont systemFontOfSize:13];
    introLab.textColor = HEXCOLOR(0xA4A4A4);
    introLab.numberOfLines = 0;
    [self.view addSubview:introLab];
    
    UILabel *kefuLab = [[UILabel alloc] init];
    kefuLab.frame = CGRectMake(0, kDeviceHeight-64-55-19, kDeviceWidth, 19);
    kefuLab.text = @"--- 客服热线 ---";
    kefuLab.font = [UIFont systemFontOfSize:13];
    kefuLab.textAlignment = NSTextAlignmentCenter;
    kefuLab.textColor = HEXCOLOR(0x939393);
    [self.view addSubview:kefuLab];
    
    UILabel *phoneLab = [[UILabel alloc] init];
    phoneLab.frame = CGRectMake(0, kefuLab.bottom + 1, kDeviceWidth, 30);
    phoneLab.text = @"400-0571-115";
    phoneLab.font = [UIFont systemFontOfSize:16];
    phoneLab.textAlignment = NSTextAlignmentCenter;
    phoneLab.textColor = HEXCOLOR(0x939393);
    [self.view addSubview:phoneLab];
    
    UIButton *tapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tapBtn.frame = CGRectMake(0, kefuLab.bottom + 3, kDeviceWidth, 30);
    [self.view addSubview:tapBtn];
    [tapBtn addTarget:self action:@selector(tapBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)deleteBtnClick:(UITextField *)textField{
    self.CardBankChose.text = @"";
}

#pragma mark - 数据请求
- (void)getBankList{
    _bankArr = [[NSMutableArray alloc] init];
    [[DataRequestServer getDataRequestServerData] request:@"LunaP2pAppBankTypeServlet" parameters:nil result:^(id result) {
        if ([result isKindOfClass:[NSString class]] &&  [result isEqualToString:@"44"]) {
            [AddHudView addProgressView:self.view message:@"网络错误，请稍后再试"];
        }else{
            int success = [[result objectForKey:@"success"]intValue];
            
            if ([[result objectForKey:@"errorlog"]isEqualToString:@""]&& success==1)
            {
                _bankArr = [[result objectForKey:@"items"] mutableCopy];;
            }
            MyLog(@"LunaP2pAppBankTypeServlet= %@",result);
        }
    }];
}

- (void)getprovinceList{
    _provinceArr = [[NSMutableArray alloc] init];
    [[DataRequestServer getDataRequestServerData] request:@"LunaP2pAppProvinceServlet" parameters:nil result:^(id result) {
        if ([result isKindOfClass:[NSString class]] &&  [result isEqualToString:@"44"]) {
            [AddHudView addProgressView:self.view message:@"网络错误，请稍后再试"];
        }else{
            int success = [[result objectForKey:@"success"]intValue];
            
            if ([[result objectForKey:@"errorlog"]isEqualToString:@""]&& success==1)
            {
                _provinceArr = [[result objectForKey:@"items"] mutableCopy];;
            }
            MyLog(@"LunaP2pAppProvinceServlet= %@",result);
        }
    }];
}

- (void)getcityListSetwithID:(NSString *)ProvinceID{
    NSMutableDictionary *dic= [[NSMutableDictionary alloc] init];
    [dic setObject:ProvinceID forKey:@"province"];
    
    [[DataRequestServer getDataRequestServerData] request:@"LunaP2pAppCityServlet" parameters:dic result:^(id result) {
        if ([result isKindOfClass:[NSString class]] &&  [result isEqualToString:@"44"]) {
            [AddHudView addProgressView:self.view message:@"网络错误，请稍后再试"];
        }else{
            int success = [[result objectForKey:@"success"]intValue];
            
            if ([[result objectForKey:@"errorlog"]isEqualToString:@""]&& success==1)
            {
                _CityArr = [[result objectForKey:@"items"] mutableCopy];;
            }
            MyLog(@"city= %@",result);
        }
    }];
}

- (void)requestLogin{
    [[DataRequestServer getDataRequestServerData] requestLoginresult:^(NSString *LoginState) {
        if ([LoginState isEqualToString:@"true"]) {
            [self TipButtonClick:nil];
        }else{
            [AddHudView addProgressView:self.view message:@"登录失效，请重新登录"];
            double delayInSeconds = 1.0;
            __block AddCardViewController* BlockVC = self;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                LoginViewController *loginVc= [[LoginViewController alloc] init];
                loginVc.loginType = logintypeOutTime;
                [BlockVC.navigationController pushViewController:loginVc animated:YES];
            });
        }
    }];
}

#pragma mark - 点击事件和代理相关
- (void)PickerChoice:(NSInteger)index type:(PickerChoiceViewType)choiceType
{
    switch (choiceType) {
        case  PickerBankType:
        {
            NSMutableDictionary *dic = [_bankArr objectAtIndex:index];
            _CardBankChose.text = [dic objectForKey:@"bankType"];
            bankIdStr =[dic objectForKey:@"bankId"];
        }
            break;
        case  PickerProvinceType:{
           
        }
            break;
        case  PickerCityType:{
           
        }
            break;
        default:
            break;
    }
}

- (void)TipButtonClick:(UIButton *)sender{
    [self KeyboardresignFirstResponder];
    
    [self checkBankNumIsBelongWithStr:@"1"];
    
}

- (void)uploadCardInfo{
    if (_CardOwn.text == nil|| [_CardOwn.text isEqualToString:@""]) {
        [AddHudView addProgressView:self.view message:@"请输入持卡人姓名"];
        return;
    }
    
    NSString *UserCardIDStr = [self.UserCardID.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (UserCardIDStr == nil|| UserCardIDStr.length<18 ) {
        [AddHudView addProgressView:self.view message:@"请输入持卡人身份证号"];
        return;
    }
    
    if (_CardNum.text == nil|| [_CardNum.text isEqualToString:@""]) {
        [AddHudView addProgressView:self.view message:@"请输入需要绑定的银行卡号"];
        return;
    }
    //    if ( bankIdStr == nil) {
    //        [AddHudView addProgressView:self.view message:@"请选择发卡银行"];
    //        return;
    //    }
    
    if (self.CardBankChose.text.length == 0) {
        [PAProgressView showInView:self.view contentString:@"您输入的银行卡暂不支持，请绑定其他银行卡"];
        return;
    }
    
    if (!self.isNoXinyong) {
        [PAProgressView showInView:self.view contentString:@"信用卡账号不支持"];
        return;
    }
    
    NSString *CardNumStr = [self.CardNum.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *cardBanksTR = [self.CardBankChose.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"" forKey:@"bankId"];
    [params setObject:cardBanksTR forKey:@"bankType"];
    [params setObject:CardNumStr forKey:@"accountNumber"];
    [params setObject:UserCardIDStr forKey:@"idNumber"];
    [params setObject:_CardOwn.text forKey:@"realName"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[DataRequestServer getDataRequestServerData] request:@"LunaP2pAppAddBankServlet?add=true" parameters:params result:^(id result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([result isKindOfClass:[NSString class]] &&  [result isEqualToString:@"44"]) {
            
            [AddHudView addProgressView:self.view message:@"网络错误，请稍后再试"];
        }else if([[result objectForKey:@"success"]intValue]==1 && [[result objectForKey:@"errorlog"]isEqualToString:@""]){
            
            [TalkingData trackEvent:@"绑定银行卡" label:@"绑定成功"];
            
            [CoreArchive ishasLockedBank:YES];
            
            [AddHudView addProgressView:self.view message:@"绑定银行卡成功"];
            __weak typeof(self) weakSelf = self;
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                //                [weakSelf BackViewController];
                if ([self.isSetPWD isEqualToString:@"0"]) {
                    MSUSetTradePWDController *set = [[MSUSetTradePWDController alloc] init];
                    set.signStr = @"account";
                    set.backStr = @"original";
                    set.hidesBottomBarWhenPushed = YES;
                    [weakSelf.navigationController pushViewController:set animated:YES];
                } else{
//                    [weakSelf BackViewController];
                    AppDelegate *jj = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                    [jj loadMainView];
                    [jj.mainVC setSelectedIndex:3];
                }
                
            });
            
        }else if([[result objectForKey:@"errorlog"]isEqualToString:@"noLogin"]&& [[result objectForKey:@"success"]intValue]==1)
        {
            [self requestLogin];
        }else if([[result objectForKey:@"errorlog"]isEqualToString:@"idNumberIllegal"]&& [[result objectForKey:@"success"]intValue]==0)
        {
            [AddHudView addProgressView:self.view message:@"身份证件号码错误，长度不为8-50"];
            
        }else if([[result objectForKey:@"errorlog"]isEqualToString:@"idNumberMustUnique"]&& [[result objectForKey:@"success"]intValue]==0)
        {
            [AddHudView addProgressView:self.view message:@"证件号码已被其他账户绑定"];
        }else if([[result objectForKey:@"errorlog"]isEqualToString:@"identityCannotApplyCauseAuthed"]&& [[result objectForKey:@"success"]intValue]==0)
        {
            [AddHudView addProgressView:self.view message:@"已通过身份认证不能再次申请"];
        }else if([[result objectForKey:@"errorlog"]isEqualToString:@"bankTypeError"]&& [[result objectForKey:@"success"]intValue]==0)
        {
            [AddHudView addProgressView:self.view message:@"你输入的银行暂不支持"];
        }else if([[result objectForKey:@"errorlog"]isEqualToString:@"accountNumberError"]&& [[result objectForKey:@"success"]intValue]==0)
        {
            [AddHudView addProgressView:self.view message:@"银行卡信息输入有误"];
        }else if([[result objectForKey:@"errorlog"]isEqualToString:@"bankCountLimitError"]&& [[result objectForKey:@"success"]intValue]==0)
        {
            [AddHudView addProgressView:self.view message:@"绑定银行卡数量已达上限，无法再次添加"];
        }else if([[result objectForKey:@"errorlog"]isEqualToString:@"identityFaild"]&& [[result objectForKey:@"success"]intValue]==0)
        {
            [AddHudView addProgressView:self.view message:@"用户信息输入有误"];
        }
        else if([[result objectForKey:@"errorlog"]isEqualToString:@"bankError"]&& [[result objectForKey:@"success"]intValue]==0)
        {
            [AddHudView addProgressView:self.view message:@"你输入的银行暂不支持"];
        }
        else{
            [AddHudView addProgressView:self.view message:@"绑卡失败，请检查资料是否正确"];
        }
    }];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == self.UserCardID) {
        BOOL returnValue = YES;
        NSMutableString* newText = [NSMutableString stringWithCapacity:0];
        [newText appendString:textField.text];// 拿到原有text,根据下面判断可能给它添加" "(空格);
        NSString * noBlankStr = [textField.text stringByReplacingOccurrencesOfString:@" "withString:@""];
        NSInteger textLength = [noBlankStr length];
        
        if (string.length) {
            if (textLength < 18) {//这个20是控制实际字符串长度,比如银行卡号长度
                if (textLength > 0 && textLength %4 == 0) {
                    newText = [NSMutableString stringWithString:[newText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
                    [newText appendString:@" "];
                    [newText appendString:string];
                    textField.text = newText;
                    returnValue = NO;//为什么return NO?因为textField.text = newText;text已经被我们替换好了,那么就不需要系统帮我们添加了,如果你ruturnYES的话,你会发现会多出一个字符串
                }else {
                    [newText appendString:string];
                }
            }else {
                return NO;
            }
        }else { // 如果输入为空,该怎么地怎么地
            [newText replaceCharactersInRange:range withString:string];
        }
        return returnValue;
    }else if (textField == self.CardNum){
        BOOL returnValue = YES;
        NSMutableString* newText = [NSMutableString stringWithCapacity:0];
        [newText appendString:textField.text];// 拿到原有text,根据下面判断可能给它添加" "(空格);
        NSString * noBlankStr = [textField.text stringByReplacingOccurrencesOfString:@" "withString:@""];
        NSInteger textLength = [noBlankStr length];
        
        if (string.length) {
            if (textLength < 30) {//这个30是控制实际字符串长度,比如银行卡号长度
                if (textLength > 0 && textLength %4 == 0) {
                    newText = [NSMutableString stringWithString:[newText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
                    [newText appendString:@" "];
                    [newText appendString:string];
                    textField.text = newText;
                    returnValue = NO;//为什么return NO?因为textField.text = newText;text已经被我们替换好了,那么就不需要系统帮我们添加了,如果你ruturnYES的话,你会发现会多出一个字符串
                }else {
                    [newText appendString:string];
                }
            }else {
                return NO;
            }
        }else { // 如果输入为空,该怎么地怎么地
            [newText replaceCharactersInRange:range withString:string];
            self.CardBankChose.text = @"";

        }
        return returnValue;
    }
    return YES;
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
    if ([_CardNum isFirstResponder])//判断是否是第一响应
    {
        [_CardNum resignFirstResponder];
    }
    
    if ([_CardOwn isFirstResponder])//判断是否是第一响应
    {
        [_CardOwn resignFirstResponder];
    }
    
    if ([_UserCardID isFirstResponder]) {
        [_UserCardID resignFirstResponder];
    }
}

#pragma mark - keyboard events -
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == self.CardBankChose) {

//        PickerChoiceView *picker = [[PickerChoiceView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-64)DataArr:_bankArr];
//        picker.ChoiceType = PickerBankType;
//        picker.delegate = self;
//        [self.view addSubview:picker];
//        [self KeyboardresignFirstResponder];
        [self checkBankNumIsBelongWithStr:@"0"];
        
        return NO;
    }else{
        return YES;
    }
}

- (void)checkBankNumIsBelongWithStr:(NSString *)str{
    if (self.CardNum.text.length == 0) {
        [PAProgressView showInView:self.view contentString:@"请输入银行卡号"];
    } else{
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer.timeoutInterval = 5.0f;
        [manager.requestSerializer setValue:@"LUNA.APP.U.AGENT" forHTTPHeaderField:@"User-Agent"];
        
        //告诉AFN，支持接受 text/xml 的数据
        [AFJSONResponseSerializer serializer].acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
        NSString *urlString = [NSString stringWithFormat:@"%@",@"https://ccdcapi.alipay.com/validateAndCacheCardInfo.json?_input_charset=utf-8"];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:[self.CardNum.text stringByReplacingOccurrencesOfString:@" " withString:@""] forKey:@"cardNo"];
        [dict setObject:@"true" forKey:@"cardBinCheck"];
        
        [manager POST:urlString parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            MyLog(@"成功---%@",dic);
            
            NSString *validatedStr = [NSString stringWithFormat:@"%@",dic[@"validated"]];
            NSString *cardType = [NSString stringWithFormat:@"%@",dic[@"cardType"]];
            if ([validatedStr isEqualToString:@"1"]) {
                if ([cardType isEqualToString:@"DC"]) {
                    NSArray *arr = self.bankDic.allKeys;
                    NSString *bank = dic[@"bank"];
                    
                    if ([arr containsObject:bank]) {
                        self.CardBankChose.text = self.bankDic[bank];
                        self.isNoXinyong = YES;
                        if ([str isEqualToString:@"1"]) {
                            [self uploadCardInfo];
                        }
                    } else {
                        [PAProgressView showInView:self.view contentString:@"你输入的银行暂不支持，请更换银行卡号"];
                    }
                } else if ([cardType isEqualToString:@"CC"]){
                    [PAProgressView showInView:self.view contentString:@"信用卡账号不支持"];
                    self.isNoXinyong = NO;
                } else{
                    [PAProgressView showInView:self.view contentString:@"银行卡号暂不支持，请更换银行卡号"];
                    self.isNoXinyong = NO;
                }
            } else {
                [PAProgressView showInView:self.view contentString:@"银行账号不可用"];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            MyLog(@"失败");
            [[DataRequestServer getDataRequestServerData] requestImportWithUrl:urlString Error:error urlParams:dict];
        }];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    self.EditTextField = textField;
}

///键盘显示事件
- (void) keyboardWillShow:(NSNotification *)notification {
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    CGRect rect = [self.EditTextField.superview convertRect:self.EditTextField.frame toView:self.view];
    
    //计算出键盘顶端到inputTextView panel底端的距离(加上自定义的缓冲距离INTERVAL_KEYBOARD)
    CGFloat offset = (rect.origin.y+rect.size.height) - (kDeviceHeight-kNavigationBarHeight - kbHeight);
    
    // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //将视图上移计算好的偏移
    if(offset > 0) {
        [UIView animateWithDuration:duration animations:^{
            self.view.frame = CGRectMake(0.0f, -offset, kDeviceWidth, kDeviceHeight-kNavigationBarHeight);
        }];
    }
}

///键盘消失事件
- (void) keyboardWillHide:(NSNotification *)notify {
    // 键盘动画时间
    
    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        self.view.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height);
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
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}


- (void)tapBtnClick:(UIButton *)sender{
    sender.enabled = NO;
    NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"tel://%@",@"400-0571-115"];
    //    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    
    NSURL *url = [NSURL URLWithString:str];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        if (iOS10) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                if (success) {
                    MyLog(@"hahah");
                    sender.enabled = YES;
                } else{
                    sender.enabled = YES;
                }
            }];
        }else{
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}


@end

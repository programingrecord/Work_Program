//
//  PersonalInfoVC.m
//  WTJR
//
//  Created by H on 16/6/18.
//  Copyright © 2016年 HM. All rights reserved.
//

#import "PersonalInfoVC.h"
#import "UIImageView+WebCache.h"
@interface PersonalInfoVC ()
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userId;
@property (weak, nonatomic) IBOutlet UIView *headView;

@end

@implementation PersonalInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息";
    [self addUIView];
}

-(void)addUIView{
    NSUserDefaults *defaults= [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dic =[defaults objectForKey:@"userInfoDetial"];
    
    _userName.text = [dic objectForKey:@"realName"];
    _userId.text = [NSString stringWithFormat:@"用户ID：%@",[dic objectForKey:@"realName"]];
    
    [_headImage sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"userImage"]] placeholderImage:nil];
    
    NSString *username = [dic objectForKey:@"username"];

    NSArray *leftarr = @[@"VIP",@"账户名",@"手机号码",@"邮箱"];
    
    NSString *isvip = ([[dic objectForKey:@"isVip"]intValue] ==0) ? @"暂时还不是VIP":[dic objectForKey:@"vipEndDate"];

    NSArray *rightarr = @[isvip,@"username",@"手机号码",@"生日"];

    for (int i = 0; i< leftarr.count; i++) {
        float height;
        if (i==0) {
            height = _headView.bottom;
        }else{
            height = _headView.bottom+20;
        }
        UIView *bgview = [[UIView alloc] init];
        bgview.frame = CGRectMake(0, height+55*i, kDeviceWidth, 55);
        bgview.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:bgview];
        
        UILabel *lable =[[UILabel alloc] initWithFrame:CGRectMake(20, 10, kDeviceWidth/2, 35)];
        lable.text = leftarr[i];
        lable.font = [UIFont systemFontOfSize:16];
        lable.textColor = RGBA(51, 51, 51, 1);
        [bgview addSubview:lable];
        if (i!=0) {
            UIView *line= [[UIView alloc] initWithFrame:CGRectMake(0, 54, bgview.width, 1)];
            line.backgroundColor =RGBA(222,222,222, 1);
            [bgview addSubview:line];
        }
    }
}

- (IBAction)safeLoginOut:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[DataRequestServer getDataRequestServerData] request:@"logout.do" parameters:nil result:^(id result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([result isKindOfClass:[NSString class]] &&  [result isEqualToString:@"44"]) {
            [AddHudView addProgressView:self.view message:@"网络错误，请稍后再试"];
        }else{
            MyLog(@"url= %@",result);
        }
    }];
   
    [CoreArchive removeNSUserDefaults];
    //返回首页
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

//
//  InviteViewController.m
//  SmallCat
//
//  Created by H on 2017/6/6.
//  Copyright © 2017年 HM. All rights reserved.
//

#import "InviteViewController.h"

@interface InviteViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *PicView;
@property (weak, nonatomic) IBOutlet UIView *BGView;
@property (strong, nonatomic) NSString *shareUrl;
@property (strong, nonatomic) NSString *shareTitle;
@property (strong, nonatomic) NSString *shareInfo;

@end

@implementation InviteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的邀请";
    self.BGView.layer.cornerRadius = 5;
    self.BGView.layer.borderWidth = 4;
    self.BGView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.BGView.layer.borderWidth = 1;
    self.BGView.layer.borderColor = [UIColor colorWithHex:0xEE4A29].CGColor;

    [self getData];
}

- (IBAction)WechatFriendClick:(id)sender {
    if ([WXApi isWXAppInstalled]) {
        SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
        sendReq.bText = NO;//不使用文本信息
        //创建分享内容对象
        WXMediaMessage *urlMessage = [WXMediaMessage message];
        urlMessage.title = self.shareTitle;//分享标题
        urlMessage.description = self.shareInfo;//分享描述
        [urlMessage setThumbImage:[UIImage imageNamed:@"login_icon_1024"]];//分享图片,使用SDK的setThumbImage方法可压缩图片大小
        //创建多媒体对象
        WXWebpageObject *webObj = [WXWebpageObject object];
        webObj.webpageUrl = self.shareUrl;//分享链接
        //完成发送对象实例
        urlMessage.mediaObject = webObj;
        sendReq.message = urlMessage;
        sendReq.scene = 0;//0 = 好友列表 1 = 朋友圈 2 = 收藏
        [WXApi sendReq:sendReq];
    }else{
        [PAProgressView showInView:self.view  contentString:@"您还未安装微信，请选择其它方式进行分享"];
    }
}

- (IBAction)WechatQuanClick:(id)sender {
    if ([WXApi isWXAppInstalled]) {
        SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
        sendReq.bText = NO;//不使用文本信息
        //创建分享内容对象
        WXMediaMessage *urlMessage = [WXMediaMessage message];
        urlMessage.title = self.shareTitle;//分享标题
        urlMessage.description = self.shareInfo;//分享描述
        [urlMessage setThumbImage:[UIImage imageNamed:@"login_icon_1024"]];//分享图片,使用SDK的setThumbImage方法可压缩图片大小
        //创建多媒体对象
        WXWebpageObject *webObj = [WXWebpageObject object];
        webObj.webpageUrl = self.shareUrl;//分享链接
        //完成发送对象实例
        urlMessage.mediaObject = webObj;
        sendReq.message = urlMessage;
        sendReq.scene = 1;//0 = 好友列表 1 = 朋友圈 2 = 收藏
        [WXApi sendReq:sendReq];
        
    }else{
        [PAProgressView showInView:self.view  contentString:@"您还未安装微信，请选择其它方式进行分享"];
    }
}

- (void)getData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[DataRequestServer getDataRequestServerData] request:@"LunaP2pAppWxShareServlet" parameters:nil result:^(id result) {
        
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([result isKindOfClass:[NSString class]] &&  [result isEqualToString:@"44"]) {
            [AddHudView addProgressView:self.view message:@"网络错误，请稍后再试"];
        }else{
            int success = [[result objectForKey:@"success"]intValue];
            if ([[result objectForKey:@"errorlog"]isEqualToString:@""]&& success==1)
            {
                self.shareTitle = [NSString stringWithFormat:@"%@",[result objectForKey:@"wxShareTitle"]];
                self.shareInfo = [NSString stringWithFormat:@"%@",[result objectForKey:@"wxShareContent"]];
                self.shareUrl = [NSString stringWithFormat:@"%@",[result objectForKey:@"wxShareUrl"]];

                self.PicView.image =[self encodeQRImageWithContent:[NSString stringWithFormat:@"%@",[result objectForKey:@"wxShareUrl"]] size:CGSizeMake(kDeviceWidth-180, kDeviceWidth-180)];
            }else if ([[result objectForKey:@"errorlog"]isEqualToString:@"noLogin"]&& success==0){
                [self requestLogin:logintypeOutTime];
            }else{
                [AddHudView addProgressView:self.view message:@"获取数据失败，请稍后再试"];
            }
        }
    }];
}

- (UIImage *)encodeQRImageWithContent:(NSString *)content size:(CGSize)size {
    UIImage *codeImage = nil;
    NSData *stringData = [content dataUsingEncoding: NSUTF8StringEncoding];
    
    //生成
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    
    UIColor *onColor = [UIColor blackColor];
    UIColor *offColor = [UIColor whiteColor];
    
    //上色
    CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor"
                                       keysAndValues:
                             @"inputImage",qrFilter.outputImage,
                             @"inputColor0",[CIColor colorWithCGColor:onColor.CGColor],
                             @"inputColor1",[CIColor colorWithCGColor:offColor.CGColor],
                             nil];
    
    CIImage *qrImage = colorFilter.outputImage;
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:qrImage fromRect:qrImage.extent];
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    codeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRelease(cgImage);
    return codeImage;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];    
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

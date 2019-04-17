//
//  MangerViewController.m
//  WTJR
//
//  Created by H on 16/6/9.
//  Copyright © 2016年 HM. All rights reserved.
//

#import "MangerViewController.h"
#import "CenterItem.h"
#import "PasswordModifyVC.h"
#import "GesturePasswordController.h"
#import "RealViewController.h"
#import "LockNameViewController.h"
#import "RealViewController.h"
#import "ManagerTableViewCell.h"
#import "MSUAboutController.h"
#import "MSUSetTradePWDController.h"
#import "MSUCardController.h"
#import "MSUAddAdressController.h"

#import "MSUTestController.h"
#import "MSUTestCompleteController.h"

#import "MSUPathTools.h"
#import "MSUCameraPhotoVc.h"
#import "MSUStringTools.h"

@interface MangerViewController ()<UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (strong, nonatomic) UITableView *MangerViewTableview;
@property (nonatomic,strong)GesturePasswordController *gesturePassWord;
@property (nonatomic,strong)NSArray *leftTitleArr;
@property (nonatomic,strong)NSArray *rightTitleArr;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstant;
@property (weak, nonatomic) IBOutlet UIButton *setOutBtn;

@property (nonatomic , strong) UIImageView *imaIconView;

@end

@implementation MangerViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInfoDetial = [userDefaults objectForKey:@"userInfoDetial"];

    NSString *bankStr;
    if ([CoreArchive isLockedBank]) {
        bankStr = [NSString stringWithFormat:@"%@",@"已绑定"];
    } else{
        bankStr = [NSString stringWithFormat:@"%@",@"未绑定"];
    }
    
    self.leftTitleArr = @[@[@"手机认证",@"银行卡",@"风险测评"]];

    NSString *typeStr = @"未测评";
    if (_testCode == 1) {
        typeStr = [NSString stringWithFormat:@"%@",@"保守型"];
    } else if (_testCode == 2){
        typeStr = [NSString stringWithFormat:@"%@",@"稳健型"];
    } else if (_testCode == 3){
        typeStr = [NSString stringWithFormat:@"%@",@"理性型"];
    } else if (_testCode == 4){
        typeStr = [NSString stringWithFormat:@"%@",@"冒险型"];
    }
    self.rightTitleArr = @[@[[NSString stringWithFormat:@"*** **** %@",[userInfoDetial objectForKey:@"phone"]],bankStr,@"",typeStr]];


}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人中心";
    
    self.view.backgroundColor = RGBA(245, 245, 245, 1);
    
    UIView *lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(0, 0, kDeviceWidth, 1);
    lineView.backgroundColor = HEXCOLOR(0xDBDBDB);
    [self.view addSubview:lineView];

    
    self.MangerViewTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 1, kDeviceWidth, kDeviceHeight) style:UITableViewStyleGrouped];
    self.MangerViewTableview.delegate = self;
    self.MangerViewTableview.dataSource = self;
    self.MangerViewTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.MangerViewTableview];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(receiveNotificiation:) name:@"HandPassWordBack" object:nil];
    
    if (iOS11) {
//        self.setOutBtn.height = 50;
        self.bottomConstant.constant = 20;
        [self.view bringSubviewToFront:self.setOutBtn];
    }
}

#pragma mark - 点击事件
- (IBAction)LoginOut:(id)sender {
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
    
    AppDelegate *jj = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [jj loadMainView];
    [jj.mainVC setSelectedIndex:0];
}

- (void)photoBtnClick:(UIButton *)sender{
     UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"更换头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选择", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    //显示
    [actionSheet showInView:self.view];
    actionSheet.delegate = self;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        NSLog(@"拍照");
        [MSUCameraPhotoVc takePictureAndCameraWithObject:self];
    }
    else if (buttonIndex == 1) {
        NSLog(@"相册");
//        [MSUPickImageOrVideoController pickedPhontoWithObject:self];
        [MSUCameraPhotoVc pickedPhontoWithObject:self];
    }
}

#pragma mark UIImagePickerControllerDelegate
//适用获取所有媒体资源，只需判断资源类型
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    //判断资源类型
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        //如果是图片
        UIImage *pickedImage = nil;
        if ([picker allowsEditing]) {
            pickedImage = info[UIImagePickerControllerEditedImage];
        }else{
            pickedImage = info[UIImagePickerControllerOriginalImage];
        }
        
        NSLog(@"图片是%@",pickedImage);
        //        self.imageView.image = info[UIImagePickerControllerEditedImage];
        //        //压缩图片
        //        NSData *fileData = UIImageJPEGRepresentation(self.imageView.image, 1.0);
        //        //保存图片至相册
        UIImageWriteToSavedPhotosAlbum(pickedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        //        //上传图片
        //        [self uploadImageWithData:fileData];
        
        NSData *imaData = [MSUStringTools compressOriginalImage:pickedImage withScale:0.1];
        
        NSDictionary *dic = @{@"ft":@"1"};
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer.timeoutInterval = 5.0f;
        [manager.requestSerializer setValue:@"LUNA.APP.U.AGENT" forHTTPHeaderField:@"User-Agent"];
        
        //告诉AFN，支持接受 text/xml 的数据
        [AFJSONResponseSerializer serializer].acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
        NSString *urlString = [NSString stringWithFormat:@"%@file_upload.do",Base_url];
        
        
        [manager POST:urlString parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            [formData appendPartWithFileData:imaData name:@"image" fileName:@"icon.png" mimeType:@"image/jpg"];
            //        [formData appendPartWithFileData:imaData name:@"image" fileName:@"bug.jpg" mimeType:@"image/jpg"];
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            MyLog(@"成功%@",dic);

            _imaIconView.image = pickedImage;

            // 删除文件
//            NSFileManager *fileManger = [NSFileManager defaultManager];
//            [fileManger removeItemAtPath:filePath error:nil];
//            [fileManger removeItemAtPath:imagePath error:nil];
//
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                dismissed = YES;
//            });
            
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            MyLog(@"失败");
            [PAProgressView showInView:self.view contentString:@"头像上传失败"];
            
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                dismissed = YES;
//            });
        }];
        
        
    }else{
        //如果是视频
        NSURL *url = info[UIImagePickerControllerMediaURL];
        //        CGSize videoSize = [MSUCameraPhotoVc getVideoSizeWithURL:url];
        NSLog(@"视频链接是%@",url);
        //        //播放视频
        //        _moviePlayer.contentURL = url;
        //        [_moviePlayer play];
        //        //保存视频至相册（异步线程）
        //        NSString *urlStr = [url path];
        //
        //        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(urlStr)) {
        //
        //                UISaveVideoAtPathToSavedPhotosAlbum(urlStr, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
        //            }
        //        });
        //        NSData *videoData = [NSData dataWithContentsOfURL:url];
        //        //视频上传
        //        [self uploadVideoWithData:videoData];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

/** 取消按钮回调 */
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/* 图片保存完毕的回调 */
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInf{
    if (error) {
        NSLog(@"保存照片过程中发生错误，错误信息:%@",error.localizedDescription);
    }else{
        NSLog(@"照片保存成功.");
    }
}

/* 视频保存完毕的回调 */
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInf{
    if (error) {
        NSLog(@"保存视频过程中发生错误，错误信息:%@",error.localizedDescription);
    }else{
        NSLog(@"视频保存成功.");
    }
}



#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.leftTitleArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr= [self.leftTitleArr objectAtIndex:section];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ManagerTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ManagerTableViewCell"];
    if (!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"ManagerTableViewCell" bundle:nil] forCellReuseIdentifier:@"ManagerTableViewCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"ManagerTableViewCell"];
    }
    

    if (indexPath.section == 0 && indexPath.row==1) {
        if ([CoreArchive isLockedBank]) {
            cell.rightTltle.textColor = HEXCOLOR(0x999999);
        }else {
            cell.rightTltle.textColor = HEXCOLOR(0xFF613D);
        }
    }
    
    if (indexPath.section == 0 && indexPath.row == 3) {
        if (_testCode > 0) {
            cell.rightTltle.textColor = HEXCOLOR(0x999999);
        } else{
            cell.rightTltle.textColor = HEXCOLOR(0xFF613D);
        }
    }

    NSArray *TitleArr = [self.leftTitleArr objectAtIndex:indexPath.section];
    cell.leftTitle.text = [TitleArr objectAtIndex:indexPath.row];
    if (indexPath.row == TitleArr.count-1) {
        cell.BottomLineViewLeft.constant = 0;
    }else{
        cell.BottomLineViewLeft.constant = 10;
    }
    NSArray *RightTitleArr = [self.rightTitleArr objectAtIndex:indexPath.section];
    cell.rightTltle.text = [RightTitleArr objectAtIndex:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 121;
    } else{
        return 20;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *V= [[UIView alloc] initWithFrame:CGRectZero];
    return V;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *V= [[UIView alloc] init];
    V.backgroundColor = [UIColor clearColor];

    if (section==0) {
        V.frame = CGRectMake(0, 0, kDeviceWidth, 121);

        UIView *bgView = [[UIView alloc] init];
        bgView.frame = CGRectMake(0, 0, kDeviceWidth, 109);
        bgView.backgroundColor = HEXCOLOR(0xffffff);
        [V addSubview:bgView];
        
        UILabel *topLab = [[UILabel alloc] init];
        topLab.frame = CGRectMake(20, 25, 50, 35);
        topLab.text = @"您好";
        topLab.font = [UIFont fontWithName:@"PingFangTC-Medium" size:25];
        topLab.textColor = HEXCOLOR(0x454545);
        [bgView addSubview:topLab];
        
        UILabel *bottomLab = [[UILabel alloc] init];
        bottomLab.frame = CGRectMake(20, topLab.bottom+5, 210, 21);
        bottomLab.text = @"在这里上传/修改您的个性头像";
        bottomLab.font = [UIFont fontWithName:@"PingFangTC-Medium" size:15];
        bottomLab.textColor = HEXCOLOR(0xAFAFAF);
        [bgView addSubview:bottomLab];
        
        self.imaIconView = [[UIImageView alloc] initWithFrame:CGRectMake(kDeviceWidth-30-48, 38,48, 48)];
        [_imaIconView sd_setImageWithURL:[NSURL URLWithString:self.iconUlrStr] placeholderImage: [MSUPathTools showImageWithContentOfFileByName:@"Group"]];
        _imaIconView.contentMode = UIViewContentModeScaleAspectFit;
        _imaIconView.clipsToBounds = YES;
        _imaIconView.layer.cornerRadius = 24;
        _imaIconView.layer.shouldRasterize = YES;
        _imaIconView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        [bgView addSubview:_imaIconView];
        
        UIButton *photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        photoBtn.frame = CGRectMake(0, 0, kDeviceWidth, 109);
        [photoBtn addTarget:self action:@selector(photoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:photoBtn];
        
    } else{
        V.frame = CGRectMake(0, 0, kDeviceWidth, 20);
    }
    
    return V;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 1:
        {
            MSUCardController *cardVC = [[MSUCardController alloc] init];
            cardVC.hidesBottomBarWhenPushed =  YES;
            [self.navigationController pushViewController:cardVC animated:YES];
        }
            break;
        case 3:
        {
            MSUAddAdressController *cardVC = [[MSUAddAdressController alloc] init];
            cardVC.hidesBottomBarWhenPushed =  YES;
            [self.navigationController pushViewController:cardVC animated:YES];
        }
            break;
        case 2:
        {
            if (_testCode > 0) {
                MSUTestCompleteController *com = [[MSUTestCompleteController alloc] init];
                com.codeSign = _testCode;
                com.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:com animated:YES];
            } else{
                MSUTestController *test = [[MSUTestController alloc] init];
                test.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:test animated:YES];
            }
        }
            break;
            
            
        default:
            break;
    }
}

- (void)receiveNotificiation:(NSNotification*)sender{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.MangerViewTableview reloadData];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

//
//  MSUImageShowController.m
//  vvlc
//
//  Created by 007 on 2018/6/15.
//  Copyright © 2018年 HM. All rights reserved.
//

#import "MSUImageShowController.h"

@interface MSUImageShowController ()

@property (nonatomic , strong) UIScrollView *scrollView;

@end

@implementation MSUImageShowController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.signInteger == 2) {
        self.title = @"担保函通用条款";
    } else{
        self.title = @"借款协议";
    }
    self.view.backgroundColor = HEXCOLOR(0xf3f3f3);
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-64*kDeviceHeightScale)];
    _scrollView.backgroundColor  = HEXCOLOR(0xf3f3f3);
    _scrollView.scrollEnabled = YES;
//    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    if (iOS11) {
        _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    for (NSInteger i = 0; i < self.imaArr.count; i++) {
        UIImageView *imaView = [[UIImageView alloc] init];
        imaView.backgroundColor = WhiteColor;
        [imaView sd_setImageWithURL:[NSURL URLWithString:self.imaArr[i]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            CGSize size = image.size;
            MyLog(@"-------=====%f,%f",size.width*0.5,size.height*0.5);
            imaView.frame = CGRectMake(14, 6+(size.height*0.5+2)*i, kDeviceWidth-28, size.height*0.5);
            _scrollView.contentSize = CGSizeMake(0, (size.height*0.5+2)*self.imaArr.count);

        }];
        imaView.contentMode = UIViewContentModeScaleAspectFit;
        [_scrollView addSubview:imaView];

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

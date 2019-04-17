//
//  GuideViewController.m
//  项目开发
//
//  Created by 姜国军 on 14-4-15.
//  Copyright (c) 2014年 姜国军. All rights reserved.
//

#import "GuideViewController.h"

@interface GuideViewController ()<SDCycleScrollViewDelegate>

@property (nonatomic,strong) SDCycleScrollView *BannerView;


@end

@implementation GuideViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.BannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0,kDeviceWidth,kDeviceHeight) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.BannerView.autoScroll = NO;
    self.BannerView.backgroundColor = [UIColor whiteColor];
    self.BannerView.showPageControl = NO;
    self.BannerView.infiniteLoop = NO;
    self.BannerView.localizationImageNamesGroup = @[@"guide_icon_one.jpg",@"guide_icon_two.jpg",@"guide_icon_three.jpg",@"guide_icon_four.jpg"];
    [self.view addSubview:self.BannerView];
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    if (index == 3) {
        AppDelegate *jj = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [jj loadMainView];
        [jj.mainVC setSelectedIndex:0];
    }
}

#pragma mark -  ScrollerViewDelegate



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end


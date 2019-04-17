//
//  UpgradeView.m
//  vvlc
//
//  Created by 慧明 on 2017/12/21.
//  Copyright © 2017年 HM. All rights reserved.
//

#import "UpgradeView.h"

@interface UpgradeView()


@property (strong, nonatomic)   UIView        *backgroundView;
@property (strong, nonatomic)   UIImageView    *BackImageView;

@property (nonatomic, strong)   UILabel        *TitleLabel;

@property (strong, nonatomic)   UIButton      *FinishButton;



@end

@implementation UpgradeView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor clearColor];
        [self.backgroundView addSubview:self];
        self.frame = CGRectMake((_backgroundView.width-280)/2,(_backgroundView.height-380)/2,280,380);
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(25, self.TitleLabel.bottom+4,self.width-50, 95)];
        _scrollView.backgroundColor  = HEXCOLOR(0xffffff);
        _scrollView.scrollEnabled = YES;
//        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(0, 150);
        if (iOS11) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else{

        }


        [self addSubview:self.BackImageView];
        [self addSubview:self.TitleLabel];
        [self addSubview:_scrollView];

        [_scrollView addSubview:self.InfoLabel];
        [self addSubview:self.CloseButton];
        [self addSubview:self.FinishButton];
        self.layer.cornerRadius = 8;
    }
    return self;
}

- (UIView *)backgroundView
{
    if (_backgroundView == nil)
    {
        _backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        _backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        _backgroundView.layer.masksToBounds = YES;
    }
    return _backgroundView;
}

- (UIImageView *)BackImageView{
    if (!_BackImageView) {
        _BackImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,50,280, 330)];
        _BackImageView.image = [UIImage imageNamed:@"Upgrade_icon"];
    }
    return _BackImageView;
}

- (UILabel *)TitleLabel{
    if (!_TitleLabel) {
        _TitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 180,self.width, 25)];
        _TitleLabel.textAlignment = NSTextAlignmentCenter;
        _TitleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18];
        _TitleLabel.text = @"发现新版本";
        _TitleLabel.textColor = [UIColor colorWithHex:0x2A2A2A];
    }
    return _TitleLabel;
}

- (UILabel *)InfoLabel{
    if (!_InfoLabel) {
        _InfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,self.width-50, 95)];
        _InfoLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _InfoLabel.numberOfLines = 0;
        _InfoLabel.textColor = [UIColor colorWithHex:0x646464];
    }
    return _InfoLabel;
}

- (UIButton *)FinishButton{
    if (!_FinishButton) {
        _FinishButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _FinishButton.frame = CGRectMake(20,self.scrollView.bottom+15,self.width-40, 44);
        [_FinishButton setTitle:@"立即升级" forState:UIControlStateNormal];
        _FinishButton.titleLabel.font =[UIFont fontWithName:@"PingFangSC-Regular" size:16];
        [_FinishButton setTitleColor:[UIColor colorWithHex:0xFFFFFF] forState:UIControlStateNormal];
        [_FinishButton setBackgroundColor:[UIColor colorWithHex:0xFF795C ]];
        [_FinishButton addTarget:self action:@selector(finishButtonclick) forControlEvents:UIControlEventTouchUpInside];
        _FinishButton.layer.cornerRadius = 22;
        _FinishButton.clipsToBounds = YES;
    }
    return _FinishButton;
}

- (UIButton *)CloseButton{
    if (!_CloseButton) {
        _CloseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _CloseButton.contentMode = UIViewContentModeCenter;
        _CloseButton.frame = CGRectMake(self.width-50,0,40, 50);
        [_CloseButton setImage:[UIImage imageNamed:@"upgrade_close"] forState:UIControlStateNormal];
        [_CloseButton addTarget:self action:@selector(CloseButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _CloseButton;
}

- (void)show
{
//    [[UIApplication sharedApplication].delegate.window addSubview:self.backgroundView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.backgroundView];
    
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

- (void)finishButtonclick{
    [self hide];
    if (self.ButtonBlock) {
        self.ButtonBlock();
    }
}

- (void)CloseButtonClick{
    [self hide];
}


@end

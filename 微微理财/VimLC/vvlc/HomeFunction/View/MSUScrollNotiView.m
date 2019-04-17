//
//  MSUScrollNotiView.m
//  vvlc
//
//  Created by 007 on 2018/1/11.
//  Copyright © 2018年 HM. All rights reserved.
//

#import "MSUScrollNotiView.h"
#import "MSUPathTools.h"

@interface MSUScrollNotiView ()<SDCycleScrollViewDelegate>

@end

@implementation MSUScrollNotiView

- (instancetype)initWithFrame:(CGRect)frame sign:(NSInteger)sign
{
    if (self = [super initWithFrame:frame]) {
        
        [self createViewWithSign:sign];
    }
    return self;
}


- (void)createViewWithSign:(NSInteger)sign{
    UIImageView *imaView = [[UIImageView alloc] initWithFrame:CGRectMake(10*kDeviceWidthScale, 9.5*kDeviceHeightScale, 15*kDeviceWidthScale, 15*kDeviceHeightScale)];
    if (sign == 1) {
        imaView.image = [MSUPathTools showImageWithContentOfFileByName:@"trade_laba"];
    } else{
        imaView.image = [MSUPathTools showImageWithContentOfFileByName:@"gonggao"];
    }
    [self addSubview:imaView];
    
    self.scrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake((10+15)*kDeviceWidthScale, 0,kDeviceWidth-44*kDeviceWidthScale,34*kDeviceHeightScale) imageNamesGroup:@[@"",@""]];
    _scrollView.backgroundColor = HEXCOLOR(0xfef3df);
    self.scrollView.autoScrollTimeInterval = 2.0;
    _scrollView.showPageControl = NO;
    _scrollView.onlyDisplayText = YES;
//    _scrollView.titlesGroup = @[@"1",@"2",@"3"];
    _scrollView.scrollDirection = UICollectionViewScrollDirectionVertical;
    _scrollView.titleLabelTextColor = TextOrangeColor;
    _scrollView.titleLabelBackgroundColor = HEXCOLOR(0xfef3df);
    _scrollView.titleLabelTextFont = TEXTFONT(12);
    self.scrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    [self addSubview:self.scrollView];
    [_scrollView disableScrollGesture];
    
}

- (void)setTextArr:(NSArray *)textArr{
    _textArr = textArr;
    NSMutableArray *titArr = [NSMutableArray array];
    for (NSDictionary *dic in _textArr) {
        [titArr addObject:[NSString stringWithFormat:@"%@",dic[@"title"]]];
    }
    
    _scrollView.titlesGroup = titArr;
}

- (void)setTradeArr:(NSArray *)tradeArr{
    _tradeArr = tradeArr;
    NSMutableArray *licaiArr = [NSMutableArray array];
    for (NSDictionary *dic in _tradeArr) {
        NSString *nam = [NSString stringWithFormat:@"%@",dic[@"username"]];
        NSString *style = [NSString stringWithFormat:@"%@",dic[@"timeCount"]];
        NSString *styleStr;
        if ([style isEqualToString:@"0"]) {
            styleStr = @"微微宝";
        } else if ([style isEqualToString:@"1"]){
            styleStr = @"一月标";
        } else if ([style isEqualToString:@"3"]){
            styleStr = @"三月标";
        } else if ([style isEqualToString:@"7"]){
            styleStr = @"七天标";
        }
        NSString *nameStr;
        if (nam.length > 0) {
            nameStr = [nam stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        } else{
            nameStr = nam;
        }
        NSString *str = [NSString stringWithFormat:@"恭喜%@成功购买%@%@元",nameStr,styleStr,dic[@"investMoney"]];
        [licaiArr addObject:str];
    }
    
    _scrollView.titlesGroup = licaiArr;

}


@end

//
//  MSUBuyJuanView.m
//  vvlc
//
//  Created by 007 on 2018/1/12.
//  Copyright © 2018年 HM. All rights reserved.
//

#import "MSUBuyJuanView.h"

#import "MSUJuanTableCell.h"
#import "MSUPathTools.h"
#import "MSUStringTools.h"

@interface MSUBuyJuanView()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic,assign) NSInteger      currentIndex;
@property (nonatomic,strong) NSMutableArray *jiaxiArr;
@property (nonatomic,strong) NSMutableArray *cuponeArr;
@property (nonatomic , assign) NSInteger clickIndex;
@property (nonatomic , strong) NSDictionary *selectDic;


@end

@implementation MSUBuyJuanView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        

        
        self.clickIndex = 0;

        [self createView];
        
    }
    return self;
}


- (void)setDataArr:(NSMutableArray *)dataArr{
    _dataArr = [dataArr mutableCopy];
    
    self.jiaxiArr = [NSMutableArray array];
    self.cuponeArr = [NSMutableArray array];
    self.selectDic = [NSDictionary dictionary];
    
    for (NSDictionary *dic in _dataArr) {
        NSString *str = [NSString stringWithFormat:@"%@",dic[@"couponType"]];
        if ([str containsString:@"1"]) {
            [self.cuponeArr addObject:dic];
        }
        if ([str containsString:@"0"]) {
            [self.jiaxiArr addObject:dic];
        }
    }
    
    if (self.cuponeArr.count == 0 && self.jiaxiArr.count > 0) {
        [self jiaxiBtnClick:nil];
    }
    
    [self.tableView reloadData];
}

- (void)createView{
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(0, 0, kDeviceWidth, 97*kDeviceHeightScale);
    bgView.backgroundColor = HEXCOLOR(0xf6f6f6);
    [self addSubview:bgView];
    
//    UILabel *attentionLab = [[UILabel alloc] init];
//    attentionLab.frame = CGRectMake(20*kDeviceWidthScale, 16.5*kDeviceHeightScale, kDeviceWidth*0.5, 16*kDeviceHeightScale);
//    attentionLab.text = @"请选择优惠劵";
//    attentionLab.font = [UIFont systemFontOfSize:16];
//    attentionLab.textColor = HEXCOLOR(0x2a2a2a);
//    [bgView addSubview:attentionLab];

    UILabel *nouseLab = [[UILabel alloc] init];
    nouseLab.frame = CGRectMake(15*kDeviceWidthScale, 14*kDeviceHeightScale, 40, 21*kDeviceHeightScale);
    nouseLab.text = @"取消";
    nouseLab.font = [UIFont systemFontOfSize:15];
    nouseLab.textColor = HEXCOLOR(0x4A4A4A);
    [bgView addSubview:nouseLab];

    self.noUseABtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _noUseABtn.frame = CGRectMake(0, 14*kDeviceHeightScale, 80*kDeviceWidthScale, 21*kDeviceHeightScale);
    [bgView addSubview:_noUseABtn];
    
    self.centerLab = [[UILabel alloc] init];
    _centerLab.frame = CGRectMake(kDeviceWidth*0.5-170*0.5, 15.5*kDeviceHeightScale, 170, 18.5*kDeviceHeightScale);
    _centerLab.text = @"每个订单只能使用一个红包";
    _centerLab.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:13];
    _centerLab.textColor = HEXCOLOR(0xEA6543);
    [bgView addSubview:_centerLab];
    
    UILabel *useLab = [[UILabel alloc] init];
    useLab.frame = CGRectMake(kDeviceWidth-15-40, 14*kDeviceHeightScale, 40, 21*kDeviceHeightScale);
    useLab.text = @"确定";
    useLab.textAlignment = NSTextAlignmentRight;
    useLab.font = [UIFont systemFontOfSize:15];
    useLab.textColor = HEXCOLOR(0x4A4A4A);
    [bgView addSubview:useLab];
    
    self.useABtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _useABtn.frame = CGRectMake(kDeviceWidth-100*kDeviceWidthScale, 16.5*kDeviceHeightScale, 100*kDeviceWidthScale, 16*kDeviceHeightScale);
    [_useABtn addTarget:self action:@selector(useABtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:_useABtn];
    
    
    UIButton *cuponBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cuponBtn.frame = CGRectMake(0, nouseLab.bottom+25.5*kDeviceHeightScale, 97, 21*kDeviceHeightScale);
    [cuponBtn setTitle:@"红包" forState:UIControlStateNormal];
    [cuponBtn setTitleColor:HEXCOLOR(0x4A4A4A) forState:UIControlStateNormal];
    cuponBtn.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Bold" size:15];
    [bgView addSubview:cuponBtn];
    [cuponBtn addTarget:self action:@selector(cuponBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *jiaxiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    jiaxiBtn.frame = CGRectMake(cuponBtn.right, nouseLab.bottom+25.5*kDeviceHeightScale, 97, 21*kDeviceHeightScale);
    [jiaxiBtn setTitle:@"加息券" forState:UIControlStateNormal];
    [jiaxiBtn setTitleColor:HEXCOLOR(0x4A4A4A) forState:UIControlStateNormal];
    jiaxiBtn.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Bold" size:15];
    [bgView addSubview:jiaxiBtn];
    [jiaxiBtn addTarget:self action:@selector(jiaxiBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.slideView = [[UIView alloc] initWithFrame:CGRectMake(97/2-30, 97*kDeviceHeightScale-2, 60, 2)];
    [_slideView setBackgroundColor:[UIColor colorWithHex:0xE85935]];
    [bgView addSubview:_slideView];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, bgView.bottom, kDeviceWidth, 265*kDeviceHeightScale) style:UITableViewStylePlain];
    _tableView.backgroundColor = BGWhiteColor;
    _tableView.scrollEnabled = YES;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _tableView.showsVerticalScrollIndicator = NO;
    [self addSubview:_tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    _tableView.emptyDataSetSource = self;
    _tableView.emptyDataSetDelegate = self;
    self.tableView.panGestureRecognizer.delaysTouchesBegan = self.tableView.delaysContentTouches;
    _tableView.rowHeight = 110*kDeviceHeightScale;
    [_tableView registerClass:[MSUJuanTableCell class] forCellReuseIdentifier:@"MSUJuanTableCell"];
    if (iOS11) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
//    __weak typeof(self) weakSelf= self;
    
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        __strong typeof(self) strongSelf= weakSelf;
//        strongSelf.currentIndex = 1;
//        [strongSelf getList:YES withIndex:strongSelf.currentIndex ishead:YES];
//    }];
//    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        __strong typeof(self) strongSelf= weakSelf;
//        [strongSelf getList:YES withIndex:strongSelf.currentIndex ishead:NO];
//    }];
}

#pragma mark - 请求
-(void)getList:(BOOL )isrefresh withIndex:(NSInteger)index ishead:(BOOL) ishead{
    NSString *url = @"LunaP2pAppAllcouponServlet";
    
    if (!isrefresh) {
        [MBProgressHUD showHUDAddedTo:self animated:YES];
    }
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:[NSString stringWithFormat:@"%ld",self.currentIndex] forKey:@"index"];
    
    [[DataRequestServer getDataRequestServerData] request:url parameters:param result:^(id result) {
        [MBProgressHUD hideHUDForView:self animated:YES];
        
        if (isrefresh) {
            if (ishead) {
                [_tableView.mj_header endRefreshing];
            }else{
                [_tableView.mj_footer endRefreshing];
            }
        }
        
        if ([result isKindOfClass:[NSString class]] &&  [result isEqualToString:@"44"]) {
            [AddHudView addProgressView:self message:@"网络错误，请稍后再试"];
        }else{
            int t = [[result objectForKey:@"success"] intValue];
            NSString *error=[result objectForKey:@"errorlog"];
            
            NSString *pageCount=[result objectForKey:@"pageCount"];
            if (self.currentIndex >= pageCount.integerValue) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.tableView.mj_footer resetNoMoreData];
            }
            
            if(t==1 && [error isEqualToString:@""]){
                if (ishead) {
                    if (self.dataArr.count>0) {
                        [self.dataArr removeAllObjects];
                    }
                    
                    if (self.jiaxiArr.count > 0) {
                        [self.jiaxiArr removeAllObjects];
                    }
                }
                
                self.dataArr = [result objectForKey:@"couponArr"];
                self.jiaxiArr = [result objectForKey:@"addArr"];

                [self.tableView reloadData];
                self.currentIndex++;
            }
        }
    }];
}

- (void)cuponBtnClick:(UIButton *)sender{
    self.clickIndex = 0;

    [UIView animateWithDuration:0.25 animations:^{
        _centerLab.text = @"每个订单只能使用一个红包";

        self.slideView.frame = CGRectMake(97/2-30, 97*kDeviceHeightScale-2, 60, 2);
    }];
    [self.tableView reloadData];
}

- (void)jiaxiBtnClick:(UIButton *)sender{
    self.clickIndex = 1;

    [UIView animateWithDuration:0.25 animations:^{
        _centerLab.text = @"每个订单只能使用一个加息券";

        self.slideView.frame = CGRectMake(97+97/2-30, 97*kDeviceHeightScale-2, 60, 2);
    }];
    
    [self.tableView reloadData];
}

- (void)useABtnClick:(UIButton *)sender{
    NSString *priStr = self.selectDic[@"useRule"];
    NSString *aaaStr = [[priStr substringToIndex:[priStr rangeOfString:@"."].location] substringFromIndex:1];
    
    if (aaaStr.integerValue <= self.priceNum && self.selectDic.allKeys.count > 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(cellDidSelectWithDic:)]) {
            [self.delegate cellDidSelectWithDic:self.selectDic];
        }
    } else {
        [PAProgressView showInView:MSUMainWindow contentString:@"尚未选择相关优惠券"];
    }
}

#pragma mark - 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.clickIndex == 0) {
        return self.cuponeArr.count;
    } else if (self.clickIndex == 1){
        return self.jiaxiArr.count;
    } else{
        return 0;
    }
}

- (NSMutableAttributedString *)setAttriButedString:(NSString *)string font:(UIFont *)font color:(UIColor *)color searchString:(NSString *)searchString font:(UIFont *)searchfont color:(UIColor *)searchcolor {
    NSRange range = NSMakeRange(0,string.length);
    
    NSRange range1= [string rangeOfString:searchString];
    
    NSMutableAttributedString *Astring = [[NSMutableAttributedString alloc] initWithString:string];
    [Astring addAttribute:NSFontAttributeName value:font  range:range];
    [Astring addAttribute:NSForegroundColorAttributeName value:color range:range1];
    
    [Astring addAttribute:NSFontAttributeName value:searchfont range:range1];
    [Astring addAttribute:NSForegroundColorAttributeName value:searchcolor range:range1];
    return Astring;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MSUJuanTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MSUJuanTableCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = BGWhiteColor;
    
    NSDictionary *dic ;
    if (self.clickIndex == 0) {
        dic = self.cuponeArr[indexPath.row];
    } else if (self.clickIndex == 1){
        dic = self.jiaxiArr[indexPath.row];
    }
    
    NSString *str =  dic[@"price"];
    NSString *finaStr;
    if ([str  containsString:@"."]) {
        finaStr = [str substringToIndex:[str rangeOfString:@"."].location];
    } else{
        finaStr = str;
    }
    
    cell.priceLab.text = str;
    cell.introLab.text = dic[@"name"];
    NSString *cuponType = [NSString stringWithFormat:@"%@",dic[@"couponType"]];
    if ([cuponType isEqualToString:@"1"]) {
        cell.imaView.image = [MSUPathTools showImageWithContentOfFileByName:@"hb_bg"];
    } else if ([cuponType isEqualToString:@"0"]){
        cell.imaView.image = [MSUPathTools showImageWithContentOfFileByName:@"hb_bg1"];
    }
    
    NSString *priStr = dic[@"useRule"];
    NSString *ruleStr;
    if ([priStr containsString:@"."]) {
        ruleStr = [NSString stringWithFormat:@"%@使用",[priStr substringToIndex:[priStr rangeOfString:@"."].location]];
    } else{
        ruleStr = priStr;
    }
    
    NSInteger manIndex = 0;
    NSInteger useIndex = 0;
    if ([ruleStr containsString:@"满"] && [ruleStr containsString:@"使"]) {
        for (NSInteger i = 0; i < ruleStr.length; i++) {
            NSString *liStr = [ruleStr substringWithRange:NSMakeRange(i, 1)];
            if ([liStr isEqualToString:@"满"]) {
                manIndex = i;
            }
            if ([liStr isEqualToString:@"使"]) {
                useIndex = i;
            }
        }
        
        NSMutableAttributedString *UserstringAtt = [self setAttriButedString:ruleStr font:TEXTFONT(16) color:[UIColor colorWithHex:0x454545] searchString:[ruleStr substringWithRange:NSMakeRange(manIndex+1, useIndex-manIndex-1)] font:[UIFont fontWithName:@"DINAlternate-Bold" size:16] color:[UIColor colorWithHex:0x454545]];
        
        cell.priLimitLab.attributedText = UserstringAtt;
    } else {
        cell.priLimitLab.text = ruleStr;
    }
    
    NSString *aaaStr = [[priStr substringToIndex:[priStr rangeOfString:@"."].location] substringFromIndex:1];
    if (aaaStr.integerValue <= self.priceNum) {
        cell.whiteView.hidden = YES;
    }  else {
        cell.whiteView.hidden = NO;
    }
    
    cell.infoLab.text = dic[@"bidNewName"];
    cell.timeLab.text = dic[@"expiresDate"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.clickIndex == 0) {
        self.selectDic = self.cuponeArr[indexPath.row];
     
    } else if (self.clickIndex == 1){
        self.selectDic = self.jiaxiArr[indexPath.row];
    }
    
    NSDictionary *dic ;
    if (self.clickIndex == 0) {
        dic = self.cuponeArr[indexPath.row];
    } else if (self.clickIndex == 1){
        dic = self.jiaxiArr[indexPath.row];
    }
    NSString *priStr = dic[@"useRule"];
    NSString *aaaStr = [[priStr substringToIndex:[priStr rangeOfString:@"."].location] substringFromIndex:1];
    if (aaaStr.integerValue <= self.priceNum) {
        MSUJuanTableCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.selectImaView.highlighted = YES;
    } else {
        [PAProgressView showInView:MSUMainWindow contentString:@"投资金额小于使用条件"];
    }

}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    MSUJuanTableCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectImaView.highlighted = NO;
}




- (BOOL)emptyDataSetShouldBeForcedToDisplay:(UIScrollView *)scrollView{
    return NO;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
    return 0;
}

-(UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"Date_Empty"];
}

-(NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = nil;
    UIFont *font = nil;
    UIColor *textColor = nil;
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    if (self.clickIndex == 0) {
        text = @"暂无可用的返现红包";
    } else if (self.clickIndex == 1){
        text = @"暂无可用的加息券";
    } else{
        text = @"暂无可用的优惠券";
    }
    font = [UIFont systemFontOfSize:16];
    textColor = [UIColor colorWithHex:0xbababa];
    
    if (!text) {
        return nil;
    }
    if (font) {
        [attributes setObject:font forKey:NSFontAttributeName];
    }
    if (textColor) {
        [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    }
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView{
    return  YES;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view{
    [self.tableView.mj_header beginRefreshing];
}

@end

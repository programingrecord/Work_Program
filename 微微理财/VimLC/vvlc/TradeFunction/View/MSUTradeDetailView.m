//
//  MSUTradeDetailView.m
//  vvlc
//
//  Created by 007 on 2018/1/15.
//  Copyright © 2018年 HM. All rights reserved.
//

#import "MSUTradeDetailView.h"
#import "MSUQuestionView.h"

#import "MSUTradePlanTableCell.h"
#import "MSUTradeRecordTableCell.h"

#import "MSUStringTools.h"
#import "MSUPathTools.h"

@interface MSUTradeDetailView()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic,strong) UITableView *planTableView;
@property (nonatomic,strong) UITableView *recordTableView;
@property (nonatomic , strong) MSUQuestionView *questionView;


@end

@implementation MSUTradeDetailView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {

        self.btnArr = [NSMutableArray array];
        [self createView];
        
    }
    return self;
}


- (void)createView{
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(0, 0, kDeviceWidth, 47*kDeviceHeightScale);
    bgView.backgroundColor = HEXCOLOR(0xffffff);
    [self addSubview:bgView];

    
    NSArray *arr = @[@"项目详情",@"常见问题",@"投标记录"];//,@"还款预估"
    for (NSInteger i = 0; i < arr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(kDeviceWidth/3*i, 13*kDeviceHeightScale, kDeviceWidth/3, 20*kDeviceHeightScale);//CGRectMake(kDeviceWidth/3*i, 13*kDeviceHeightScale, kDeviceWidth/3, 20*kDeviceHeightScale)
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        [btn setTitleColor:HEXCOLOR(0x4a4a4a) forState:UIControlStateNormal];
        [btn setTitleColor:titOrangeColor forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:btn];
        [btn addTarget:self action:@selector(iconBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnArr addObject:btn];
        
        if (i == 0) {
            btn.selected = YES;
        }
    }
    
    self.lineView = [[UIView alloc] init];
    _lineView.frame = CGRectMake(kDeviceWidth/3*0.5-30*kDeviceWidthScale, 44.5*kDeviceHeightScale, 60*kDeviceWidthScale, 1.5);//CGRectMake(kDeviceWidth/3*0.5-30*kDeviceWidthScale, 44.5*kDeviceHeightScale, 60*kDeviceWidthScale, 1.5)
    _lineView.backgroundColor =titOrangeColor;
    [bgView addSubview:_lineView];
    
    self.programView.hidden = NO;
//    self.planTableView.hidden = YES;
    self.questionView.hidden = YES;
    self.recordTableView.hidden = YES;
    
}

#pragma mark - 更新数据

- (void)setRecordArr:(NSArray *)recordArr{
    _recordArr = recordArr;
    
    [self.recordTableView reloadData];
}

#pragma -mark - 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _planTableView) {
        return _planArr.count;
    } else if (tableView == _recordTableView){
        return _recordArr.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _planTableView) {
        MSUTradePlanTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MSUTradePlanTableCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (_planArr.count >= indexPath.row) {
            NSDictionary *dic = _planArr[indexPath.row];
            cell.qiLab.text = [NSString stringWithFormat:@"%ld期",indexPath.row+1];
            cell.timeLab.text = [dic objectForKey:@"expireDate"];
            cell.moneyLab.text = [dic objectForKey:@"repaySumAmount"];
        }
    
        return cell;
    } else if (tableView == _recordTableView){
        MSUTradeRecordTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MSUTradeRecordTableCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSDictionary *dic = _recordArr[indexPath.row];
        cell.moneyLab.text = [NSString stringWithFormat:@"%@元",[dic objectForKey:@"bidAmount"]];
        cell.nameLab.text = [dic objectForKey:@"usernameMask"];
        NSString *time = [dic objectForKey:@"bidTime"];
        NSString *timestring = [[time componentsSeparatedByString:@"."] objectAtIndex:0];
        NSString  *bidNote =[dic objectForKey:@"bidNote"];
        if (bidNote.length>0) {
            cell.timeLab.text = [NSString stringWithFormat:@"%@ (%@)",timestring,[dic objectForKey:@"bidNote"]];
        }else{
            cell.timeLab.text = [NSString stringWithFormat:@"%@",timestring];
        }
        
        cell.topImaView.hidden = YES;
        if (indexPath.row == 0) {
            cell.topImaView.hidden = NO;
            cell.topImaView.image = [MSUPathTools showImageWithContentOfFileByName:@"dym_icon"];
        } else if (indexPath.row == 1){
            cell.topImaView.hidden = NO;
            cell.topImaView.image = [MSUPathTools showImageWithContentOfFileByName:@"dem_icon"];
        } else if (indexPath.row == 2){
            cell.topImaView.hidden = NO;
            cell.topImaView.image = [MSUPathTools showImageWithContentOfFileByName:@"dsm_icon"];
        }
        
        return cell;
    }
    return nil;
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
    text = @"暂无投标记录";
    font = [UIFont systemFontOfSize:13];
    textColor = [UIColor colorWithHex:0x333333];
    
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
    [self.planTableView.mj_header beginRefreshing];
    [self.recordTableView.mj_header beginRefreshing];

}


#pragma mark - 点击事件
- (void)iconBtnClick:(UIButton *)sender{
    for (UIButton *btn in _btnArr) {
        btn.selected = NO;
    }
    sender.selected = YES;
    
    [UIView animateWithDuration:0.25 animations:^{
        _lineView.center = CGPointMake(sender.center.x, 45*kDeviceHeightScale);
    }];
    
    if (self.indexBlock) {
        if (self.recordArr.count == 0) {
            self.indexBlock(sender.titleLabel.text,0);
        } else{
            self.indexBlock(sender.titleLabel.text,1);
        }
    }
    
    if (sender == _btnArr[0]) {
        self.programView.hidden = NO;
//        self.planTableView.hidden = YES;
        self.questionView.hidden = YES;
        self.recordTableView.hidden = YES;
    }
    else if (sender == _btnArr[1]){
        self.programView.hidden = YES;
//        self.planTableView.hidden = NO;
        self.questionView.hidden = NO;
        self.recordTableView.hidden = YES;
    }
    else{
        self.programView.hidden = YES;
//        self.planTableView.hidden = YES;
        self.questionView.hidden = YES;
        self.recordTableView.hidden = NO;
    }
}

#pragma mark - 初始化
- (MSUProgramDetailView *)programView{
    if (!_programView) {
        _programView = [[MSUProgramDetailView alloc] initWithFrame:CGRectMake(0, 47*kDeviceHeightScale, kDeviceWidth, kDeviceHeight-47*kDeviceHeightScale+200*kDeviceHeightScale)];
        _programView.backgroundColor = HEXCOLOR(0xf3f3f3);

        [self addSubview:_programView];
    }
    return _programView;
}

- (MSUQuestionView *)questionView{
    if (!_questionView) {
        _questionView = [[MSUQuestionView alloc] initWithFrame:CGRectMake(0, 57*kDeviceHeightScale, kDeviceWidth, kDeviceHeight+350*kDeviceHeightScale)];
        _questionView.backgroundColor = WhiteColor;
        [self addSubview:_questionView];
    }
    return _questionView;
}

- (UITableView *)planTableView{
    if (!_planTableView) {
        _planTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,  57*kDeviceHeightScale, kDeviceWidth, kDeviceHeight- (47+64)*kDeviceHeightScale) style:UITableViewStylePlain];
        _planTableView.backgroundColor = WhiteColor;
        _planTableView.scrollEnabled = YES;
        _planTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _planTableView.showsVerticalScrollIndicator = NO;
        [self addSubview:_planTableView];
        _planTableView.delegate = self;
        _planTableView.dataSource = self;
        _planTableView.emptyDataSetSource = self;
        _planTableView.emptyDataSetDelegate = self;
        _planTableView.panGestureRecognizer.delaysTouchesBegan = _planTableView.delaysContentTouches;
        _planTableView.rowHeight = 59*kDeviceHeightScale;
        [_planTableView registerClass:[MSUTradePlanTableCell class] forCellReuseIdentifier:@"MSUTradePlanTableCell"];
        if (iOS11) {
            _planTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _planTableView;
}

- (UITableView *)recordTableView{
    if (!_recordTableView) {
        _recordTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,  47*kDeviceHeightScale, kDeviceWidth, kDeviceHeight- (47+64)*kDeviceHeightScale) style:UITableViewStylePlain];
        _recordTableView.backgroundColor = WhiteColor;
        _recordTableView.scrollEnabled = YES;
        _recordTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _recordTableView.showsVerticalScrollIndicator = NO;
        [self addSubview:_recordTableView];
        _recordTableView.delegate = self;
        _recordTableView.dataSource = self;
        _recordTableView.emptyDataSetSource = self;
        _recordTableView.emptyDataSetDelegate = self;
        _recordTableView.panGestureRecognizer.delaysTouchesBegan = _recordTableView.delaysContentTouches;
        _recordTableView.rowHeight = 59*kDeviceHeightScale;
        [_recordTableView registerClass:[MSUTradeRecordTableCell class] forCellReuseIdentifier:@"MSUTradeRecordTableCell"];
        if (iOS11) {
            _recordTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _recordTableView;
}


@end

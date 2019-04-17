//
//  MSUTradeBottomView.m
//  vvlc
//
//  Created by 007 on 2018/1/15.
//  Copyright © 2018年 HM. All rights reserved.
//

#import "MSUTradeBottomView.h"

#import "MSUTradeBottomTableCell.h"

#import "MSUPathTools.h"
#import "MSUStringTools.h"
#import "MSUShadowInView.h"

@interface MSUTradeBottomView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , strong) MSUShadowInView *shadowView;
@property (nonatomic , strong) UIView *popView;

@property (nonatomic , strong) NSArray *imaArr;
@property (nonatomic , strong) NSArray *titArr;

@end

@implementation MSUTradeBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self createView];
//        self.imaArr = @[@"sysj_icon",@"qtje_icon",@"hkfs_icon",@"jxfs_icon"];
        self.titArr = @[@"投资规则",@"起息时间",@"还款方式",@"回款时间"];
        self.imaArr = @[@"50起投，50的整数倍投资",@"满标次日计息",@"按月付息 到期还本",@"本息到期次日回款至账户余额"];
    }
    return self;
}

- (void)setDataArr:(NSArray *)dataArr{
    _dataArr = dataArr;
    [_tableView reloadData];
}

- (void)createView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, (50.5*4+35)*kDeviceHeightScale) style:UITableViewStylePlain];
    _tableView.backgroundColor = HEXCOLOR(0xf3f3f3);
    _tableView.scrollEnabled = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    [self addSubview:_tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.panGestureRecognizer.delaysTouchesBegan = self.tableView.delaysContentTouches;
    _tableView.rowHeight = 50.5*kDeviceHeightScale;
    [_tableView registerClass:[MSUTradeBottomTableCell class] forCellReuseIdentifier:@"MSUTradeBottomTableCell"];
    if (iOS11) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MSUTradeBottomTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MSUTradeBottomTableCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
//    cell.leftImaView.image = [MSUPathTools showImageWithContentOfFileByName:_imaArr[indexPath.row]];
    cell.leftLab.text = _titArr[indexPath.row];
    cell.rightLab.text = _imaArr[indexPath.row];

    if (indexPath.row == 2) {
        cell.rightLab.frame = CGRectMake(kDeviceWidth*0.5-33*kDeviceWidthScale-3, 15.5*kDeviceHeightScale,kDeviceWidth*0.5-5.2*kDeviceWidthScale, 20*kDeviceHeightScale);
        UIButton *questionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        questionBtn.frame = CGRectMake(kDeviceWidth-33*kDeviceWidthScale, 16*kDeviceHeightScale, 17*kDeviceWidthScale, 17*kDeviceHeightScale);
        [questionBtn setImage:[MSUPathTools showImageWithContentOfFileByName:@"ckgd"] forState:UIControlStateNormal];
        [cell addSubview:questionBtn];
        [questionBtn addTarget:self action:@selector(questionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
//    NSString *straa = _dataArr[0];
//    if (straa.length == 0) {
//        straa = @"--天--时--分";
//    }
//
//    if (_dataArr.count > 0) {
//        if (indexPath.row == 0) {
//            cell.rightLab.textColor = titBlackColor;
//            cell.rightLab.attributedText = [MSUStringTools makeKeyWordAttributedWithSubText:@"天" textA:@"分" textB:@"时" textC:@"" inOrigiText:_dataArr[0] font:14 color:titQianColor];
//        } else if (indexPath.row == 1) {
//            NSString *str = [NSString stringWithFormat:@"%ld元",[_dataArr[1] integerValue]];
//            cell.rightLab.attributedText = [MSUStringTools makeKeyWordAttributedWithSubText:str inOrigiText:[NSString stringWithFormat:@"%ld元起投",[_dataArr[1] integerValue]] font:14 color:titOrangeColor];
//        }
//    }
    return cell;
}

- (void)questionBtnClick:(UIButton *)sender{
    self.shadowView.hidden = NO;
    self.popView.hidden = NO;
}

- (MSUShadowInView *)shadowView{
    if (!_shadowView) {
        self.shadowView = [[MSUShadowInView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
        _shadowView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [MSUMainWindow addSubview:_shadowView];
        _shadowView.hidden = YES;
    }
    return _shadowView;
}

- (UIView *)popView{
    if (!_popView) {
        self.popView = [[UIView alloc] initWithFrame:CGRectMake(60.5, kDeviceHeight*0.5-116*kDeviceHeightScale, kDeviceWidth-121, 232*kDeviceHeightScale)];
        _popView.backgroundColor = WhiteColor;
        [self.shadowView addSubview:_popView];
        
        UILabel *attentionLab = [[UILabel alloc] init];
        attentionLab.frame = CGRectMake(0, 15.5*kDeviceHeightScale, kDeviceWidth-121, 21*kDeviceHeightScale);
        attentionLab.text = @"回款说明";
        attentionLab.font = [UIFont systemFontOfSize:15];
        attentionLab.textAlignment = NSTextAlignmentCenter;
        attentionLab.textColor = HEXCOLOR(0x000000);
        [_popView addSubview:attentionLab];
        
        NSString *stre = @"      按月付息，到期还本是指每隔一个月支付给您一个月的利息，项目到期后还本金至账户。";
        CGRect rect = [MSUStringTools danamicGetHeightFromText:stre WithWidth:kDeviceWidth-121-28 font:15];
        UILabel *subLab = [[UILabel alloc] init];
        subLab.frame = CGRectMake(14,attentionLab.bottom + 15.5*kDeviceHeightScale, kDeviceWidth-121-28, rect.size.height);
        subLab.text = stre;
        subLab.font = [UIFont systemFontOfSize:14];
        subLab.numberOfLines = 0;
        subLab.textColor = HEXCOLOR(0x454545);
        [_popView addSubview:subLab];
        
        UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sureBtn.frame = CGRectMake(0,attentionLab.bottom + 159*kDeviceHeightScale, kDeviceWidth-121, 21*kDeviceHeightScale);
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [sureBtn setTitleColor:HEXCOLOR(0xFB6337) forState:UIControlStateNormal];
        sureBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_popView addSubview:sureBtn];
        [sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
      
    }
    return _popView;
}

- (void)sureBtnClick:(UIButton *)sender{
    self.shadowView.hidden = YES;
}


@end

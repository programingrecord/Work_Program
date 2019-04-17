//
//  PickerChoiceView.m
//  WTJR
//
//  Created by H on 16/6/12.
//  Copyright © 2016年 HM. All rights reserved.
//

#import "PickerChoiceView.h"


#define hScale ([UIScreen mainScreen].bounds.size.height) / 667

@interface PickerChoiceView()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic,strong)UIView *bgV;

@property (nonatomic,strong)UIButton *cancelBtn;

@property (nonatomic,strong)UIButton *conpleteBtn;


@property (nonatomic,strong)UIPickerView *pickerV;

@end
@implementation PickerChoiceView


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame DataArr:(NSMutableArray *)DataArr{
    if (self = [super initWithFrame:frame]) {
    
        self.DataArr = [[NSMutableArray alloc] initWithArray:DataArr];
        NSLog(@"%@",self.DataArr);
        self.frame = frame;
        self.backgroundColor = RGBA(51, 51, 51, 0.8);
        self.bgV = [[UIView alloc]initWithFrame:CGRectMake(0,self.height, self.width,260 *hScale)];
        self.bgV.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.bgV];
        
        [self showAnimation];

        //取消
        self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cancelBtn.frame = CGRectMake(20, 0, 60, 40);
        self.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [self.cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.cancelBtn setTitleColor:RGBA(0, 122, 255, 1) forState:UIControlStateNormal];
        //完成
        [self.bgV addSubview:self.cancelBtn];

        self.conpleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.conpleteBtn.frame = CGRectMake(self.bgV.width-80, 0, 60, 40);
        self.conpleteBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.conpleteBtn setTitle:@"完成" forState:UIControlStateNormal];
        [self.conpleteBtn addTarget:self action:@selector(completeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.conpleteBtn setTitleColor:RGBA(0, 122, 255, 1) forState:UIControlStateNormal];
        [self.bgV addSubview:self.conpleteBtn];

        //选择titi
        self.selectLb = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, self.width-160, 40)];
        self.selectLb.textColor = RGBA(51, 51, 51, 1);
        self.selectLb.font = [UIFont systemFontOfSize:15];
        self.selectLb.textAlignment = NSTextAlignmentCenter;
        [self.bgV addSubview:self.selectLb];
        
        //线
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0,40,self.width,1)];
        line.backgroundColor = RGBA(224, 224, 224, 1);
        [self.bgV addSubview:line];

        //选择器
        self.pickerV = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 41, self.bgV.width, self.bgV.height-41)];
        self.pickerV.delegate = self;
        self.pickerV.dataSource = self;
        [self.bgV addSubview:self.pickerV];
    }
    return self;
}

- (void)setChoiceType:(PickerChoiceViewType)ChoiceType{
    _ChoiceType = ChoiceType;
    switch (ChoiceType) {
        case PickerBankType:
        {
            self.selectLb.text = @"请选择开户银行";
        }
            break;
        case PickerProvinceType:
        {
            self.selectLb.text = @"请选择开户省份";
        }
            break;
        case PickerCityType:
        {
            self.selectLb.text = @"请选择开户城市";
        }
            break;
        default:
            break;
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return self.DataArr.count;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *label=[[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    
    return label;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSMutableDictionary *dic= [self.DataArr objectAtIndex:row];
    if (self.ChoiceType == PickerBankType) {
        return [dic objectForKey:@"bankType"];

    }else if (self.ChoiceType == PickerProvinceType){
        return [dic objectForKey:@"provinceType"];

    }else if(self.ChoiceType == PickerCityType){
        return [dic objectForKey:@"cityType"];
    }else{
        return nil;
    }
}

//隐藏动画
- (void)hideAnimation{
    [UIView animateWithDuration:0.5 animations:^{
        
        CGRect frame = self.bgV.frame;
        frame.origin.y = kDeviceHeight;
        self.bgV.frame = frame;
        
    } completion:^(BOOL finished) {
        
        [self.bgV removeFromSuperview];
        [self removeFromSuperview];
    }];
}

//显示动画
- (void)showAnimation{
    [UIView animateWithDuration:0.5 animations:^{
        
        CGRect frame = self.bgV.frame;
        frame.origin.y = self.height-260*hScale;
        self.bgV.frame = frame;
    }];
}

- (void)cancelBtnClick{
    [self hideAnimation];
}

- (void)completeBtnClick{
    if (_delegate && [_delegate respondsToSelector:@selector(PickerChoice:type:)]) {
        [_delegate PickerChoice:[self.pickerV selectedRowInComponent:0] type:self.ChoiceType];
    }

    [self hideAnimation];
}

@end

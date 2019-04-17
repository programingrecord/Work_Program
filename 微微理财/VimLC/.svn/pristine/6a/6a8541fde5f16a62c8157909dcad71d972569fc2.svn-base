//
//  PickerChoiceView.h
//  WTJR
//
//  Created by H on 16/6/12.
//  Copyright © 2016年 HM. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PickerChoiceViewType) {
    PickerBankType,
    PickerProvinceType,
    PickerCityType,
};

@protocol PickerChoiceDelegate <NSObject>

@optional;
- (void)PickerChoice:(NSInteger)index type:(PickerChoiceViewType) choiceType;

@end


@interface PickerChoiceView : UIView

@property (nonatomic,strong)UILabel *selectLb;

@property (nonatomic, assign) PickerChoiceViewType ChoiceType;
@property (nonatomic, strong) NSArray *DataArr;

@property (nonatomic,assign)id<PickerChoiceDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame DataArr:(NSMutableArray *)DataArr;

@end

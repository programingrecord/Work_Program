//
//  ReceiptCell.m
//  WTJR
//
//  Created by H on 16/6/18.
//  Copyright © 2016年 HM. All rights reserved.
//

#import "ReceiptCell.h"

@implementation ReceiptCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setReceiptModel:(ReceiptModel *)receiptModel
{
    if (_receiptModel != receiptModel) {
        _receiptModel =receiptModel;
    }
    
    NSString *title = _receiptModel.title;
    NSMutableAttributedString * amountAtt = [self setAttributedString:title font:[UIFont systemFontOfSize:16] color:RGBA(51, 51, 51, 1)];
    [amountAtt appendAttributedString:[self setAttributedString:[NSString stringWithFormat:@"(%@)",_receiptModel.planIndex] font:[UIFont systemFontOfSize:12] color:RGBA(51,51,51, 1)]];
    _titleText.attributedText = amountAtt ;

    _dateText.text = _receiptModel.expireDate;
    _capitalText.text = _receiptModel.capitalInterest;
    _detailText.text = [NSString stringWithFormat:@"(本金：%@+利息：%@)",_receiptModel.capital,_receiptModel.interest];
}

-(NSMutableAttributedString *)setAttributedString:(NSString *)string font:(UIFont *)font color:(UIColor *)color
{
    NSRange range = NSMakeRange(0,string.length);
    NSMutableAttributedString *mulString = [[NSMutableAttributedString alloc] initWithString:string];
    [mulString addAttribute:NSFontAttributeName value:font range:range];
    [mulString addAttribute:NSForegroundColorAttributeName value:color range:range];
    return mulString ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

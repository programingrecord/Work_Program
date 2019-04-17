//
//  TransferCell.m
//  WTJR
//
//  Created by H on 16/6/4.
//  Copyright © 2016年 HM. All rights reserved.
//

#import "TransferCell.h"

@implementation TransferCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
- (void)setModel:(TransferModel *)model{
    if (_model != model) {
        _model =model;
    }
    _title.text = [NSString stringWithFormat:@"%@",_model.title];
    
    NSString *PercentString = [NSString stringWithFormat:@"%@",_model.profitRateDNoPercentSign];
    NSMutableAttributedString * PercentAtt = [self setAttributedString:PercentString font:[UIFont systemFontOfSize:18] color:RGBA(255, 127, 0, 1)];
    [PercentAtt appendAttributedString:[self setAttributedString:@"%" font:[UIFont systemFontOfSize:12] color:RGBA(255, 127, 0, 1)]];
    _Percent.attributedText = PercentAtt ;
    
    
    
    NSString *timeLongString = [NSString stringWithFormat:@"%@",_model.daysLeft2Receipt];
    NSMutableAttributedString * TimeLongAtt = [self setAttributedString:timeLongString font:[UIFont systemFontOfSize:18] color:RGBA(51, 51, 51, 1)];
    [TimeLongAtt appendAttributedString:[self setAttributedString:@"天" font:[UIFont systemFontOfSize:12] color:RGBA(127, 127, 127, 1)]];
    _timeLong.attributedText = TimeLongAtt ;
    
    _Amount.text = [NSString stringWithFormat:@"债权价值:%@元",_model.transferAmount];
    _LoseTime.text = [NSString stringWithFormat:@"失效时间:%@",_model.expireDate];
}

-(NSMutableAttributedString *)setAttributedString:(NSString *)string font:(UIFont *)font color:(UIColor *)color
{
    NSRange range = NSMakeRange(0,string.length);
    NSMutableAttributedString *mulString = [[NSMutableAttributedString alloc] initWithString:string];
    [mulString addAttribute:NSFontAttributeName value:font range:range];
    [mulString addAttribute:NSForegroundColorAttributeName value:color range:range];
    return mulString ;
}
@end

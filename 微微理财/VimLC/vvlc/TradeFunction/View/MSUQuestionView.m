//
//  MSUQuestionView.m
//  vvlc
//
//  Created by 007 on 2018/2/27.
//  Copyright © 2018年 HM. All rights reserved.
//

#import "MSUQuestionView.h"

#import "MSUStringTools.h"

@implementation MSUQuestionView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self createView];
        
    }
    return self;
}


- (void)createView{
    self.questionLab = [[UILabel alloc] init];
    _questionLab.backgroundColor = HEXCOLOR(0xffffff);
    _questionLab.textColor = titBlackQianColor;
    _questionLab.font = [UIFont systemFontOfSize:14];
    _questionLab.numberOfLines = 0;
    
    NSString *queStr = [NSString stringWithFormat:@"%@", @"Q:什么是票据宝？\n     A:票票据宝是以借款项目所出具的银行承兑汇票作为基础，实现债权匹配，待投资者投资满期天后自动退出，退出成功后按退出本金的比例结算对应收益。借款一般在7天到3个月之间。\n\n Q:票据宝安全吗？\n     A:银行承兑汇票凭借银行信用，银行承诺无条件兑付作为保障，即使借款人第一还款来源丧失，借款到期将质押的票据在二级市场转让或者提前向承兑银行贴现来获取还款资金，对出借人来说，没有任何风险，是目前市面上P2P网络借贷中安全系数最高的产品之一。\n\n Q:票据宝标的未满怎么办? \n     A：标的发布3天内如果未满标标的将发生流标，出借资金将全数自动返回您的账户，目前票据宝基本当天就能满标，未出现过流标的情况，请您放心投资。\n\n Q：定期产品起息时间是如何计算？\n     标A：定期产品起息时间为满标日的次日计算。\n\n Q：票据宝收益如何计算\n     A：定期产品分为天标和月标\n    月标的计算公式：定期到期收益 = 本金 * 定期年化收益率 / 12* 月数 \n    如：票据宝1月标 \n    天标的计算公式：定期到期收益 = 本金 * 定期年化收益率 /360* 天数 \n    如：票据宝7天\n\n Q：票据宝支不支持提前赎回？\n     A：暂不支持。\n\n Q：票据宝何时回款 \n  A：票据宝到期之日回款 \n\n  Q：票据宝到期提现需要多久？\n     A：票据宝项目到期后，您的出借本金和收益将返还到您的余额账户，您可以根据自己的需求选择提现到个人的银行卡账户，或者继续投资我们的产品。票据宝提现规则一般为：\n    1：工作日16:00之前申请提现，当天处理提现操作，具体到账时间以银行通知为准 \n    2：工作日16:00之后申请提现，顺延第二个工作日处理提现操作，具体到账时间以银行通知为准 \n    3：如遇周末节假日，提现处理操作时间顺延至下一个工作日"];
    _questionLab.text = queStr;
    [MSUStringTools changeLineSpaceForLabel:_questionLab WithSpace:5];
    
    CGRect recta = [MSUStringTools danamicGetHeightFromText:_questionLab.text WithWidth:kDeviceWidth-40 font:14];
    _questionLab.frame = CGRectMake(20, 0, kDeviceWidth-40, recta.size.height);
    self.frame = CGRectMake(0, 57*kDeviceHeightScale, kDeviceWidth, recta.size.height);

    [self addSubview:_questionLab];
}

/*  多个字符串修改颜色字体 */
- (NSMutableAttributedString *)makeKeyWordAttributedWithSubText:(NSString *)subText textA:(NSString *)textA textB:(NSString *)textB textC:(NSString *)textC textD:(NSString *)textD textE:(NSString *)textE textF:(NSString *)textF inOrigiText:(NSString *)origiText font:(CGFloat)font color:(UIColor *)color{
    if (subText.length > 0) {
        // 获取关键字的位置
        NSRange range = [origiText rangeOfString:subText];
        NSRange range1 = [origiText rangeOfString:textA];
        NSRange range2 = [origiText rangeOfString:textB];
        NSRange range3 = [origiText rangeOfString:textC];
        NSRange range4 = [origiText rangeOfString:textD];
        NSRange range5 = [origiText rangeOfString:textE];
        NSRange range6 = [origiText rangeOfString:textF];
        
        // 转换成可以操作的字符串类型.
        NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:origiText];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:2];
        [attribute addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [origiText length])];
        
        // 添加属性(粗体)
        [attribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:range];
        [attribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:range1];
        [attribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:range2];
        [attribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:range3];
        [attribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:range4];
        [attribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:range5];
        [attribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:range6];

        // 关键字高亮
        [attribute addAttribute:NSForegroundColorAttributeName value:color range:range];
        [attribute addAttribute:NSForegroundColorAttributeName value:color range:range1];
        [attribute addAttribute:NSForegroundColorAttributeName value:color range:range2];
        [attribute addAttribute:NSForegroundColorAttributeName value:color range:range3];
        [attribute addAttribute:NSForegroundColorAttributeName value:color range:range4];
        [attribute addAttribute:NSForegroundColorAttributeName value:color range:range5];
        [attribute addAttribute:NSForegroundColorAttributeName value:color range:range6];

        return attribute;
    }
    return [[NSMutableAttributedString alloc] initWithString:origiText];
}


@end

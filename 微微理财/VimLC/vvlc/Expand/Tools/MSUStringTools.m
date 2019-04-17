//
//  MSUStringTools.m
//  测试
//
//  Created by Zhuge_Su on 2017/7/3.
//  Copyright © 2017年 Zhuge_Su. All rights reserved.
//

#import "MSUStringTools.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#define HEXCOLOR(rgbValue)      [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation MSUStringTools

#pragma mark - 移除字符串中的空格和换行
/* 移除字符串中的空格和换行 */
+ (NSString *)removeSpaceAndNewline:(NSString *)str {
    NSString *temp = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return temp;
}

#pragma mark - 判断字符串中是否有中文
/* 判断字符串中是否有中文 */
+ (BOOL)isContainChinese:(NSString *)str{
    NSString *match=@"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:str];
}

#pragma mark - 判断字符串是否为空
/* 判断字符串是否为空 */
+  (BOOL)isBlankString:(NSString *)aStr {
    if (!aStr) {
        return YES;
    }
    if ([aStr isKindOfClass:[NSNull class]]) {
        return YES;
    }
    // 创建一个字符集对象, 包含所有的空格和换行字符
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    // 从字符串中过滤掉首尾的空格和换行, 得到一个新的字符串
    NSString *trimmedStr = [aStr stringByTrimmingCharactersInSet:set];
    // 判断新字符串的长度是否为0
    if (!trimmedStr.length) {
        return YES;
    }
    if ([aStr isEqualToString:@"(null)"] || [aStr isEqualToString:@"null"]) {
        return YES;
    }
    return NO;
}

#pragma mark - 将阿拉伯数字转换成汉文数字
/* 将阿拉伯数字转换成汉文数字 */
+ (NSString *)translationToStringWithArabicNum:(NSInteger)arabicNum
{
    NSString *arabicNumStr = [NSString stringWithFormat:@"%ld",(long)arabicNum];
    NSArray *arabicNumeralsArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"];
    NSArray *chineseNumeralsArray = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"零"];
    NSArray *digits = @[@"个",@"十",@"百",@"千",@"万",@"十",@"百",@"千",@"亿",@"十",@"百",@"千",@"兆"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:chineseNumeralsArray forKeys:arabicNumeralsArray];
    
    if (arabicNum < 20 && arabicNum > 9) {
        if (arabicNum == 10) {
            return @"十";
        }else{
            NSString *subStr1 = [arabicNumStr substringWithRange:NSMakeRange(1, 1)];
            NSString *a1 = [dictionary objectForKey:subStr1];
            NSString *chinese1 = [NSString stringWithFormat:@"十%@",a1];
            return chinese1;
        }
    }else{
        NSMutableArray *sums = [NSMutableArray array];
        for (int i = 0; i < arabicNumStr.length; i ++)
        {
            NSString *substr = [arabicNumStr substringWithRange:NSMakeRange(i, 1)];
            NSString *a = [dictionary objectForKey:substr];
            NSString *b = digits[arabicNumStr.length -i-1];
            NSString *sum = [a stringByAppendingString:b];
            
            if ([a isEqualToString:chineseNumeralsArray[9]])
            {
                if([b isEqualToString:digits[4]] || [b isEqualToString:digits[8]])
                {
                    sum = b;
                    if ([[sums lastObject] isEqualToString:chineseNumeralsArray[9]])
                    {
                        [sums removeLastObject];
                    }
                }else
                {
                    sum = chineseNumeralsArray[9];
                }
                
                if ([[sums lastObject] isEqualToString:sum])
                {
                    continue;
                }
            }
            
            [sums addObject:sum];
            
        }
        NSString *sumStr = [sums  componentsJoinedByString:@""];
        NSString *chinese = [sumStr substringToIndex:sumStr.length-1];
        return chinese;
    }
}

#pragma mark - 将日期转换成古月份
/* 将日期转换成古月份 */
+ (NSString *)translationChineseWithArabicNum:(NSInteger)arabicNum
{
    NSString *arabicNumStr = [NSString stringWithFormat:@"%ld",(long)arabicNum];
    NSArray *arabicNumeralsArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"];
    NSArray *chineseNumeralsArray = @[@"壹",@"贰",@"叁",@"肆",@"伍",@"陆",@"柒",@"捌",@"玖",@"拾",@"冬",@"腊"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:chineseNumeralsArray forKeys:arabicNumeralsArray];
    
    NSString *chinese = [dictionary objectForKey:arabicNumStr];
    return chinese;
}

/* 将月份转换成汉字月份 */
+ (NSString *)translationChineseMonthWithArabicNum:(NSInteger)arabicNum
{
    NSString *arabicNumStr = [NSString stringWithFormat:@"%ld",(long)arabicNum];
    NSArray *arabicNumeralsArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"];
    NSArray *chineseNumeralsArray = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"十一",@"十二"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:chineseNumeralsArray forKeys:arabicNumeralsArray];
    
    NSString *chinese = [dictionary objectForKey:arabicNumStr];
    return chinese;
}

/* 将日期转换成汉字月份 */
+ (NSString *)translationChineseDayWithArabicNum:(NSInteger)arabicNum
{
    NSString *arabicNumStr = [NSString stringWithFormat:@"%ld",(long)arabicNum];
    NSArray *arabicNumeralsArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31"];
    NSArray *chineseNumeralsArray = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"十一",@"十二",@"十三",@"十四",@"十五",@"十六",@"十七",@"十八",@"十九",@"二十",@"二十一",@"二十二",@"二十三",@"二十四",@"二十五",@"二十六",@"二十七",@"二十八",@"二十九",@"三十",@"三十一"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:chineseNumeralsArray forKeys:arabicNumeralsArray];
    
    NSString *chinese = [dictionary objectForKey:arabicNumStr];
    return chinese;
}

#pragma mark - 获取当前日期和未来日期
+ (NSString *)getNDay:(NSInteger)n{
    NSDate*nowDate = [NSDate date];
    NSDate* theDate;
    if(n!=0){
        NSTimeInterval  oneDay = 24*60*60*1;  //1天的长度
        theDate = [nowDate initWithTimeIntervalSinceNow: oneDay*n ];//initWithTimeIntervalSinceNow是从现在往前后推的秒数
    }else{
        theDate = nowDate;
    }
    
    NSDateFormatter *date_formatter = [[NSDateFormatter alloc] init];
//    [date_formatter setDateFormat:@"MM-dd"];
    [date_formatter setDateFormat:@"MM-dd"];
    NSString *the_date_str = [date_formatter stringFromDate:theDate];
    
    return the_date_str;
}

#pragma mark - 富文本 修改局部字段颜色
/* 富文本 修改局部（前半部或后半部）字段颜色 */
+ (NSMutableAttributedString*)changeLabelWithText:(NSString*)needText AndFromOrigiFont:(CGFloat)origi toChangeFont:(CGFloat)change AndFromOrigiLoca:(NSInteger)loca WithBeforePart:(NSInteger)part
{
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:needText];
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:origi] range:NSMakeRange(0,loca)];
    
    [attrString addAttribute:NSKernAttributeName value:@1.0f range:NSMakeRange(0, needText.length)];
    
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:change] range:NSMakeRange(loca,needText.length-loca)];

    // 如果是前半部分
    if (!part) {
        [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:236/255.0 green:0/255.0 blue:0/255.0 alpha:1] range:NSMakeRange(0,loca)];
        
        [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(loca,needText.length-loca)];
    }else{
        [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,loca)];
        
        [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:236/255.0 green:0/255.0 blue:0/255.0 alpha:1] range:NSMakeRange(loca,needText.length-loca)];

    }
    
    return attrString;
}

/* 在已有字符串中 修改 输入字符 颜色和大小 */
+ (NSMutableAttributedString *)makeKeyWordAttributedWithSubText:(NSString *)subText inOrigiText:(NSString *)origiText font:(CGFloat)font color:(UIColor *)color{
    if (subText.length > 0 && origiText.length > 0) {
        // 获取关键字的位置
        NSRange range = [origiText rangeOfString:subText];
        
        // 转换成可以操作的字符串类型.
        NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:origiText];
        
        // 添加属性(粗体)
        [attribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:range];
        
        // 关键字高亮
        [attribute addAttribute:NSForegroundColorAttributeName value:color range:range];
        
        return attribute;
    }
    return [[NSMutableAttributedString alloc] initWithString:origiText];
}

/*  多个字符串修改颜色字体 */
+ (NSMutableAttributedString *)makeKeyWordAttributedWithSubText:(NSString *)subText textA:(NSString *)textA textB:(NSString *)textB textC:(NSString *)textC inOrigiText:(NSString *)origiText font:(CGFloat)font color:(UIColor *)color{
    if (subText.length > 0) {
        // 获取关键字的位置
        NSRange range = [origiText rangeOfString:subText];
        NSRange range1 = [origiText rangeOfString:textA];
        NSRange range2 = [origiText rangeOfString:textB];
        NSRange range3 = [origiText rangeOfString:textC];
        
        
        // 转换成可以操作的字符串类型.
        NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:origiText];
        
        // 添加属性(粗体)
        [attribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:range];
        [attribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:range1];
        [attribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:range2];
        [attribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:range3];
        
        // 关键字高亮
        [attribute addAttribute:NSForegroundColorAttributeName value:color range:range];
        [attribute addAttribute:NSForegroundColorAttributeName value:color range:range1];
        [attribute addAttribute:NSForegroundColorAttributeName value:color range:range2];
        [attribute addAttribute:NSForegroundColorAttributeName value:color range:range3];
        
        
        return attribute;
    }
    return [[NSMutableAttributedString alloc] initWithString:origiText];
}

/* 在已有富文本字符串中 修改 输入字符 颜色和大小 */
+ (NSMutableAttributedString *)makeAttrubuteKeyWordAttributedWithSubText:(NSString *)subText inOrigiText:(NSMutableAttributedString *)origiText font:(CGFloat)font color:(UIColor *)color{
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithAttributedString:origiText];

    [attrString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0,subText.length)];

    
    return attrString;
}

/* 截取对应位置的字符串改变颜色大小 */
+ (NSMutableAttributedString *)makeAttrubuteKeyWordAttributedWithIndex:(NSInteger)index inOrigiText:(NSString *)origiText font:(CGFloat)font color:(UIColor *)color{
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:origiText];
    
    NSRange rangel = [[attrString string] rangeOfString:[origiText substringFromIndex:index]];
    [attrString addAttribute:NSForegroundColorAttributeName value:deepOrange range:rangel];
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:rangel];
    
    
    return attrString;
}

+ (NSMutableAttributedString *)makeLineSpaceAndAttributedWithSubText:(NSString *)subText inOrigiText:(NSString *)origiText font:(CGFloat)font color:(UIColor *)color space:(CGFloat)space{
    if (subText.length > 0 && origiText.length > 0) {
        // 获取关键字的位置
        NSRange range = [origiText rangeOfString:subText];
        
        // 转换成可以操作的字符串类型.
        NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:origiText];
        
        // 添加属性(粗体)
        [attribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:NSMakeRange(0, origiText.length)];
        
        // 关键字高亮
        [attribute addAttribute:NSForegroundColorAttributeName value:titQianColor range:NSMakeRange(0, origiText.length)];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:space];
        [attribute addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [origiText length])];
        
        // 添加属性(粗体)
        [attribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:range];
        
        // 关键字高亮
        [attribute addAttribute:NSForegroundColorAttributeName value:color range:range];
        
        return attribute;
    }
    return [[NSMutableAttributedString alloc] initWithString:origiText];
}

#pragma amrk - 动态获取 String 宽高
/* 动态获取 String 宽 */
+ (CGSize)danamicGetWidthFromText:(NSString *)text WithFont:(CGFloat)font{
    CGSize size = [text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:font],NSFontAttributeName, nil]];
    return size;
}

/* 动态获取 String 高 */
+ (CGRect)danamicGetHeightFromText:(NSString *)text WithWidth:(CGFloat)width font:(CGFloat)font{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:font],NSFontAttributeName, nil] context:nil];
    return rect;
}

/*  设置label行间距 */
+ (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space {
    
    NSString *labelText = label.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    [label sizeToFit];
    
}

+ (void)changeLineSpaceForAttributLabel:(UILabel *)label WithSpace:(float)space {
    
    NSAttributedString *labelText = label.attributedText;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    [label sizeToFit];
    
}

/* 获取行数  */
+ (NSInteger)getStringLineNumberWithLabel:(UILabel *)label WithLabelWidth:(CGFloat)width{
    CGFloat labelHeight = [label sizeThatFits:CGSizeMake(width, MAXFLOAT)].height;
    NSInteger count = (labelHeight) / label.font.lineHeight;
    return count;
}


/*  设置下划线 */
+ (NSMutableAttributedString *)setUnderLineWithString:(NSString *)str  WithSpace:(float)space {
    NSMutableAttributedString *contentStr = [[NSMutableAttributedString alloc] initWithString:str];
    [contentStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, str.length)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    [contentStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
    return contentStr;
}


#pragma mark - 转换 html字符串
/* 转换 html转行等符号 为 OC换行字符串 */
+ (NSString *)htmlEntityDecode:(NSString *)string{
    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    string = [string stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"]; // Do this last so that, e.g. @"&amp;lt;" goes to @"&lt;" not @"<"
    string = [string stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];

    return string;
}

/* 将HTML字符串转化为NSAttributedString富文本字符串  */
+ (NSAttributedString *)attributedStringWithHTMLString:(NSString *)htmlString
{
    NSDictionary *options = @{ NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,
                               NSCharacterEncodingDocumentAttribute :@(NSUTF8StringEncoding) };
    
    NSData *data = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    
    return [[NSAttributedString alloc] initWithData:data options:options documentAttributes:nil error:nil];
}

#pragma mark - 压缩图片
/* 压缩图片到指定尺寸  */
+ (UIImage *)compressOriginalImage:(UIImage *)image toSize:(CGSize)size{
    UIImage * resultImage = image;
    UIGraphicsBeginImageContext(size);
    [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIGraphicsEndImageContext();
    return image;
}

/* 压缩图片到指定大小  */
+ (NSData *)compressOriginalImage:(UIImage *)image withScale:(NSInteger)scale{
    NSData *data = nil;
    data =UIImageJPEGRepresentation(image,scale);

//    if(!UIImagePNGRepresentation(image)) {
//        data =UIImageJPEGRepresentation(image,scale);
//    }else{
//        data =UIImagePNGRepresentation(image);
//    }
    return data;
}

/* 图片拉伸不失真  */
+ (UIImage *)stretchWithImage:(UIImage *)image{
    return  [image stretchableImageWithLeftCapWidth:image.size.width topCapHeight:image.size.height*0.5];
}

#pragma mark - json字符串和字典互转
/* json字符串转成字典  */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        MyLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

/*  字典转Json字符串 */
+ (NSString *)convertToJsonData:(NSDictionary *)dict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
}

#pragma mark - 四舍五入（向上保留、向下保留）
+ (NSDecimalNumber *)keepTheDecimalPointWithStr:(NSString *)str withRoundingMode:(NSRoundingMode)roundingMode{
    /* typedef NS_ENUM(NSUInteger, NSRoundingMode) {
        NSRoundPlain,   // Round up on a tie        四舍五入
        NSRoundDown,    // Always down == truncate  向下保留  1.256 - 1.25
        NSRoundUp,      // Always up                向上保留  1.256 - 1.26
        NSRoundBankers  // on a tie round so last digit is even 貌似是：
        if(四舍五入位==5）{
            if(5后有非0数字){//如：1.251  - 1.26
                入
            }
            else{//如：1.25 - 1.25
                舍
            }
        }else{
            四舍五入
        }
     };
     */
    //2、scale 保留小数个数
    NSDecimalNumber *num_1 = [NSDecimalNumber decimalNumberWithString:str];
    NSDecimalNumber *num_2 = [NSDecimalNumber decimalNumberWithString:@"0"];
    NSDecimalNumberHandler *handel = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:roundingMode scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *num_3 = [num_1 decimalNumberBySubtracting:num_2 withBehavior:handel];
    
    NSLog(@"num_3 == %@",num_3);
    
    return num_3;
}

@end

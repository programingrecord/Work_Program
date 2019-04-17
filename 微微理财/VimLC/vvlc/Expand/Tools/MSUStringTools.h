//
//  MSUStringTools.h
//  测试
//
//  Created by Zhuge_Su on 2017/7/3.
//  Copyright © 2017年 Zhuge_Su. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MSUStringTools : NSObject

#pragma mark - 移除字符串中的空格和换行
/* 移除字符串中的空格和换行 */
+ (NSString *)removeSpaceAndNewline:(NSString *)str;

#pragma mark - 将阿拉伯数字转换成汉文数字
/* 将阿拉伯数字转换成汉文数字 */
+ (NSString *)translationToStringWithArabicNum:(NSInteger)arabicNum;

#pragma mark - 判断字符串中是否有中文
/* 判断字符串中是否有中文 */
+ (BOOL)isContainChinese:(NSString *)str;

#pragma mark - 判断字符串是否为空
/* 判断字符串是否为空 */
+  (BOOL)isBlankString:(NSString *)aStr;

#pragma mark - 将日期转换成古月份
/* 将日期转换成古月份 */
+ (NSString *)translationChineseWithArabicNum:(NSInteger)arabicNum;

/* 将日期转换成汉字月份 */
+ (NSString *)translationChineseMonthWithArabicNum:(NSInteger)arabicNum;

/* 将日期转换成汉字月份 */
+ (NSString *)translationChineseDayWithArabicNum:(NSInteger)arabicNum;

#pragma mark - 获取当前日期和未来日期
/* 获取当前日期和未来日期  */
+ (NSString *)getNDay:(NSInteger)n;

#pragma mark - 富文本 修改局部字段颜色
/* 富文本 修改局部字段颜色 */
+ (NSMutableAttributedString*)changeLabelWithText:(NSString*)needText AndFromOrigiFont:(CGFloat)origi toChangeFont:(CGFloat)change AndFromOrigiLoca:(NSInteger)loca WithBeforePart:(NSInteger)part;

/*  多个字符串 修改局部字段颜色 */
+ (NSMutableAttributedString *)makeKeyWordAttributedWithSubText:(NSString *)subText textA:(NSString *)textA textB:(NSString *)textB textC:(NSString *)textC inOrigiText:(NSString *)origiText font:(CGFloat)font color:(UIColor *)color;

/* 在已有字符串中 修改 输入字符 颜色和大小 */
+ (NSMutableAttributedString *)makeKeyWordAttributedWithSubText:(NSString *)subText inOrigiText:(NSString *)origiText font:(CGFloat)font color:(UIColor *)color;

/* 在已有富文本字符串中 修改 输入字符 颜色和大小 */
+ (NSMutableAttributedString *)makeAttrubuteKeyWordAttributedWithSubText:(NSString *)subText inOrigiText:(NSMutableAttributedString *)origiText font:(CGFloat)font color:(UIColor *)color;

/* 截取对应位置的字符串改变颜色大小 */
+ (NSMutableAttributedString *)makeAttrubuteKeyWordAttributedWithIndex:(NSInteger)index inOrigiText:(NSString *)origiText font:(CGFloat)font color:(UIColor *)color;

/*  设置下划线 */
+ (NSMutableAttributedString *)setUnderLineWithString:(NSString *)str  WithSpace:(float)space ;

/* 富文本 修改局部字段颜色 行间距 */
+ (NSMutableAttributedString *)makeLineSpaceAndAttributedWithSubText:(NSString *)subText inOrigiText:(NSString *)origiText font:(CGFloat)font color:(UIColor *)color space:(CGFloat)space;

#pragma amrk - 动态获取 String 宽高
/* 动态获取 String 宽 */
+ (CGSize)danamicGetWidthFromText:(NSString *)text WithFont:(CGFloat)font;

/* 动态获取 String 高 */
+ (CGRect)danamicGetHeightFromText:(NSString *)text WithWidth:(CGFloat)width font:(CGFloat)font;

/*  设置label行间距 */
+ (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space;

+ (void)changeLineSpaceForAttributLabel:(UILabel *)label WithSpace:(float)space ;

/* 获取行数  */
+ (NSInteger)getStringLineNumberWithLabel:(UILabel *)label WithLabelWidth:(CGFloat)width;

#pragma mark - 压缩图片
/* 压缩图片到指定尺寸  */
+ (UIImage *)compressOriginalImage:(UIImage *)image toSize:(CGSize)size;

/* 压缩图片到指定大小  */
+ (NSData *)compressOriginalImage:(UIImage *)image withScale:(NSInteger)scale;

/* 图片拉伸不失真   */
+ (UIImage *)stretchWithImage:(UIImage *)image;

#pragma mark - 转换 html字符串 先转换转行等符号，再转换成富文本
/* 转换 html转行等符号 为 OC换行字符串 */
+ (NSString *)htmlEntityDecode:(NSString *)string;

/* 将HTML字符串转化为NSAttributedString富文本字符串  */
+ (NSAttributedString *)attributedStringWithHTMLString:(NSString *)htmlString;

#pragma mark - json字符串和字典互转
/* json字符串转成字典  */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

/*  字典转Json字符串 */
+ (NSString *)convertToJsonData:(NSDictionary *)dict;

#pragma mark - 四舍五入（向上保留、向下保留）
+ (NSDecimalNumber *)keepTheDecimalPointWithStr:(NSString *)str withRoundingMode:(NSRoundingMode)roundingMode;

@end

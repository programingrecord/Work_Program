//
//  MSUAesTools.h
//  aaa
//
//  Created by 007 on 2018/1/22.
//  Copyright © 2018年 007. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSUAesTools : NSObject

+(NSData *)AES256ParmEncryptWithKey:(NSString *)key Encrypttext:(NSData *)text;   //加密

+(NSData *)AES256ParmDecryptWithKey:(NSString *)key Decrypttext:(NSData *)text;   //解密

+(NSString *) aes256_encrypt:(NSString *)key Encrypttext:(NSString *)text;

+(NSString *) aes256_decrypt:(NSString *)key Decrypttext:(NSString *)text;

// http://blog.csdn.net/coyote1994/article/details/52368921 参考  key 是和后台约定的私钥，aes 需要一个私钥， 私钥长度为16字节 举例：16BytesLengthKey
+ (NSString *) msu_aes_encryt:(NSString *)content key:(NSString *)key;
+ (NSString *) msu_aes_decryt:(NSString *)content key:(NSString *)key;


@end

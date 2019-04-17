//
//  NetworkTools.h
//  WTJR
//
//  Created by H on 2017/4/18.
//  Copyright © 2017年 HM. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ImagesucessBlock)(UIImage *imageData);
typedef void(^ImagefailBlock)(void);


@interface NetworkTools : NSObject

+(void)GetImageFromUrlString:(NSString *)urlString withParams:(NSDictionary *)params andResultBlock:(ImagesucessBlock) resultBlock andfail:(ImagefailBlock) failBlock;


@end

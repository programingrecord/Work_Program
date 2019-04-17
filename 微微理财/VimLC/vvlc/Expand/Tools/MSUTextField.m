//
//  MSUTextField.m
//  XiuBei
//
//  Created by Zhuge_Su on 2017/8/25.
//  Copyright © 2017年 Zhuge_Su. All rights reserved.
//

#import "MSUTextField.h"

@implementation MSUTextField

- (void)deleteBackward{
    [super deleteBackward];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteBtnClick:)]) {
        [self.delegate deleteBtnClick:self];
    }
    
}

@end

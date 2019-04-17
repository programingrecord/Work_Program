//
//  CenterItem.h
//  WTJR
//
//  Created by HM on 16/6/2.
//  Copyright © 2016年 HM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CenterItem : UIControl
- (id)initWithFrame:(CGRect)frame
         imageNamed:(NSString *)imageNamed
         rightImage:(NSString *)rightImage
              title:(NSString *)title
         titleValue:(NSString *)titleValue;

@property (nonatomic,retain)UILabel *titleLabel;
@property (nonatomic,retain)UILabel *titleValueLabel;
@property (nonatomic,retain)UIImageView *imageView;
@property (nonatomic,retain)UIImageView *tailIcon;

@end

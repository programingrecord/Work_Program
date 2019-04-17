//
//  PAProgressView.h
//  PARockPay
//
//  Created by Chen Jacky on 12-12-31.
//  Copyright (c) 2012年 xyh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    PAProgressViewTypeString,                         //只有文字
    PAProgressViewTypeActivityIndicatorViewAndString, //文字+activityIndicatorView
    PAProgressViewTypeCustom,
    
}PAProgressViewType;

@class PAProgressView;

@protocol PAProgressViewDelegate <NSObject>

@optional

- (void)PAProgressViewDismiss:(PAProgressView *)PAProgressView;

@end

@interface PAProgressView : UIView

@property (nonatomic, assign) id                    delegate;
@property (nonatomic, assign) PAProgressViewType    progressType;
@property (nonatomic, copy) NSString                *contentString;


+ (PAProgressView *)showInView:(UIView *)view
                 contentString:(NSString *)string;

+ (PAProgressView *)showInView:(UIView *)view
                 contentString:(NSString *)string
                      delegate:(id)delegate;




+ (PAProgressView *)showInView:(UIView *)view
                 contentString:(NSString *)string
          withProgressViewType:(PAProgressViewType)type;

+ (PAProgressView *)showInView:(UIView *)view
                 contentString:(NSString *)string
          withProgressViewType:(PAProgressViewType)type
                      delegate:(id)delegate;

+ (void)hideForView:(UIView *)view;

- (void)showInView:(UIView *)view;

- (void)hide;

@end

//
//  MSUProgressView.m
//  vvlc
//
//  Created by 007 on 2018/3/26.
//  Copyright © 2018年 HM. All rights reserved.
//

#import "MSUProgressView.h"

@interface MSUProgressView()

@property (assign, nonatomic)float regIncomePercent;
@property (assign, nonatomic)float MLBIncomePersent;
@property (assign, nonatomic)float totalIncome;

@end

@implementation MSUProgressView

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        _totalAccount = 0;
        _regIncomePercent = 0;
        _MLBIncomePersent = 0;
        _totalIncome = 0;
        _width = 0;
        
    }
    
    return self;
    
}

- (void)drawRect:(CGRect)rect{
    
    [self addArcBackColor];
    
    //    [self addreceiptArc];
    [self addRegIncomePercentArc];
    [self addMLBArc];

    
    [self addCenterBack];
    [self addCenterLabel];
    
}

- (void)setRegIncomePersent:(float)regIncomePersent MLBIncomePersent:(float)MLBIncomePersent totalIncome:(float)totalIncome{
    _regIncomePercent = regIncomePersent;
    _MLBIncomePersent = MLBIncomePersent;
    _totalIncome = totalIncome;
    if (_totalIncome !=0) {
        [self setNeedsDisplay];
    }
}

- (void)addArcBackColor{
    
    CGColorRef color = (_arcBackColor == nil) ? RGBA(255, 222, 203, 1).CGColor : _arcBackColor.CGColor;
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    CGSize viewSize = self.bounds.size;
    
    CGPoint center = CGPointMake(viewSize.width / 2, viewSize.height / 2);
    
    CGFloat radius = viewSize.width / 2;
    
    CGContextBeginPath(contextRef);
    
    CGContextMoveToPoint(contextRef, center.x, center.y);
    
    CGContextAddArc(contextRef, center.x, center.y, radius, 0,2*M_PI, 0);
    
    CGContextSetFillColorWithColor(contextRef, color);
    
    CGContextFillPath(contextRef);
    
}

- (void)addRegIncomePercentArc{
    
    if (_regIncomePercent != 0) {
        
        float endAngle = 2*M_PI*_regIncomePercent;
        
        CGColorRef color = (_regularColor == nil) ? [UIColor blueColor].CGColor : _regularColor.CGColor;
        
        CGContextRef contextRef = UIGraphicsGetCurrentContext();
        
        CGSize viewSize = self.bounds.size;
        
        CGPoint center = CGPointMake(viewSize.width / 2, viewSize.height / 2);
        
        
        CGFloat radius = viewSize.width / 2;
        
        CGContextBeginPath(contextRef);
        
        CGContextMoveToPoint(contextRef, center.x, center.y);
        
        CGContextAddArc(contextRef, center.x, center.y, radius,0,endAngle, 0);
        
        CGContextSetFillColorWithColor(contextRef, color);
        
        CGContextFillPath(contextRef);
        
    }
}

//添加冻结金额
- (void)addMLBArc{
    if (_MLBIncomePersent !=0) {
        
        float begAngle = 2*M_PI*_regIncomePercent;
        float endAngle = 2*M_PI*(_regIncomePercent+_MLBIncomePersent);
        
        CGColorRef color = (_MLBColor == nil) ? [UIColor blueColor].CGColor : _MLBColor.CGColor;
        
        CGContextRef contextRef = UIGraphicsGetCurrentContext();
        
        CGSize viewSize = self.bounds.size;
        
        CGPoint center = CGPointMake(viewSize.width / 2, viewSize.height / 2);
        
        
        CGFloat radius = viewSize.width / 2;
        
        CGContextBeginPath(contextRef);
        
        CGContextMoveToPoint(contextRef, center.x, center.y);
        
        CGContextAddArc(contextRef, center.x, center.y, radius,begAngle,endAngle, 0);
        
        CGContextSetFillColorWithColor(contextRef, color);
        
        CGContextFillPath(contextRef);
        
    }
    
}


-(void)addCenterBack{
    
    float width = (_width == 0) ? 5 : _width;
    
    CGColorRef color = (_centerColor == nil) ? [UIColor whiteColor].CGColor : _centerColor.CGColor;
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    CGSize viewSize = self.bounds.size;
    
    CGPoint center = CGPointMake(viewSize.width / 2, viewSize.height / 2);
    
    // Draw the slices.
    
    CGFloat radius = viewSize.width / 2 - width;
    
    CGContextBeginPath(contextRef);
    
    CGContextMoveToPoint(contextRef, center.x, center.y);
    
    CGContextAddArc(contextRef, center.x, center.y, radius, 0,2*M_PI, 0);
    
    CGContextSetFillColorWithColor(contextRef, color);
    
    CGContextFillPath(contextRef);
    
}


- (void)addCenterLabel{
    
    CGSize viewSize = self.bounds.size;
    
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    
    paragraph.alignment = NSTextAlignmentCenter;
    [paragraph setLineSpacing:6];
    
    
    NSMutableAttributedString * firstPart = [[NSMutableAttributedString alloc] initWithString:@"累计收益(元)\n"];
    NSDictionary * firstAttributes = @{ NSFontAttributeName:[UIFont boldSystemFontOfSize:12],NSForegroundColorAttributeName:RGBA(208, 208, 208, 1),NSParagraphStyleAttributeName:paragraph};
    
    [firstPart setAttributes:firstAttributes range:NSMakeRange(0,firstPart.length)];
    
    
    NSMutableAttributedString * secondPart = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f",_totalIncome]];
    
    
    
    NSDictionary * secondAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:RGBA(108, 108, 108, 108),NSParagraphStyleAttributeName:paragraph};
    [secondPart setAttributes:secondAttributes range:NSMakeRange(0,secondPart.length)];
    
    NSDictionary * thirdAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:RGBA(51, 51, 51, 51),NSParagraphStyleAttributeName:paragraph};
    
    [secondPart setAttributes:thirdAttributes range:NSMakeRange(0,secondPart.length-2)];
    
    
    [firstPart appendAttributedString:secondPart];
    
    
    [firstPart drawInRect:CGRectMake(5, (viewSize.height-40)/2, viewSize.width-10, 60)];
}


@end

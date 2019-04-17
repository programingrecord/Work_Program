//
//  ProgressViews.m
//  ProgressView
//
//  Created by HM on 16/6/15.
//  Copyright © 2016年 HM. All rights reserved.
//

#import "ProgressViews.h"

@interface ProgressViews()

@property (assign, nonatomic)double receiptPercent; //代收金额百分比
@property (assign, nonatomic)double frozenPercent;  //冻结资金百分比
@property (assign, nonatomic)double availablePercent;  //可用金额百分比
@property (assign, nonatomic)double MLBPercent;      //可用金额百分比
@property (assign, nonatomic)double MarchPercent;
@property (assign, nonatomic)double januaryPercent;
@property (assign, nonatomic)double sevenPercent;
@property (assign, nonatomic)double totalIncome;
@property (assign, nonatomic)double totalAcoount;




@end

@implementation ProgressViews

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _totalAccount = 0;
        _frozenPercent = 0;
        _receiptPercent = 0;
        _availablePercent = 0;
        _MarchPercent = 0;
        _width = 0;
    }
    
    return self;
}

- (void)setfrozenPersent:(double) frozenPeresent  availablePersent:(double) availablePersent MLBPersent:(double) MLBPersent januaryPercent:(double) januaryPercent sevenPercent:(double) sevenPercent MarchPercent:(double) MarchPercent totalAcoount:(double)totalAcoount totalIncome:(double)totalIncome{
    _frozenPercent = frozenPeresent;
//    _receiptPercent = receiptPersent;
    _availablePercent = availablePersent;
    _MLBPercent = MLBPersent;
    _sevenPercent = sevenPercent;
    _januaryPercent = januaryPercent;
    _MarchPercent = MarchPercent;
    _totalAccount = totalAcoount;
    _totalIncome = totalIncome;
//    MyLog(@"======%f,%f,%F,%F,%f,%F,%f",totalAcoount,frozenPeresent,availablePersent,MLBPersent,sevenPercent,januaryPercent,MarchPercent);
    if (_totalIncome !=0) {
//        if (_sevenPercent < 0.01 && _sevenPercent > 0) {
//            _sevenPercent = 0.01;
//        }
//        if (_januaryPercent < 0.01 && _januaryPercent > 0) {
//            _sevenPercent = 0.01;
//        }
//        if (_sevenPercent < 0.01 && _sevenPercent > 0) {
//            _sevenPercent = 0.01;
//        }
        if (_MarchPercent < 0.01 && _MarchPercent > 0) {
            _MarchPercent = 0.01;
        }
        if (_MLBPercent < 0.01 && _MLBPercent > 0) {
            _MLBPercent = 0.01;
        }
//        MyLog(@"!!!!!!!-%f,%f,%F,%F,%f,%F,%f",totalAcoount,frozenPeresent,availablePersent,MLBPersent,sevenPercent,januaryPercent,MarchPercent);

        [self setNeedsDisplay];
    }
}



- (void)drawRect:(CGRect)rect{
    [self addArcBackColor];
    
//    [self addreceiptArc];
    [self addMarchArc];
    [self addMLBArc];
    [self AddavailableArc];
    [self addfrozenArc];
    [self addSevenArc];
    [self addJanuaryArc];
//    [self addRegIncomeArc];
    
    [self addCenterBack];
    [self addCenterLabel];
    
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

- (void)addMarchArc{
    if (_MarchPercent !=0) {
        
//        float begAngle = 2*M_PI*(_availablePercent + _frozenPercent +_MLBPercent);
        float endAngle = 2*M_PI*_MarchPercent;
        
        CGColorRef color = (_MarchColor == nil) ? [UIColor blackColor].CGColor : _MarchColor.CGColor;
        
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

//添加微微宝
- (void)addMLBArc{
    if (_MLBPercent !=0) {
        
        float begAngle = 2*M_PI*_MarchPercent;
        float endAngle = 2*M_PI*(_MarchPercent +_MLBPercent);
        
        CGColorRef color = (_MLBColor == nil) ? [UIColor blackColor].CGColor : _MLBColor.CGColor;
        
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

//添加可用余额
- (void)AddavailableArc{
    if (_availablePercent != 0) {
        float begAngle = 2*M_PI*(_MarchPercent+_MLBPercent);
        float endAngle = 2*M_PI*(_MarchPercent +_MLBPercent + _availablePercent);
        
        CGColorRef color = (_availableColor == nil) ? [UIColor blackColor].CGColor : _availableColor.CGColor;
        
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

//添加冻结金额
- (void)addfrozenArc{
    if (_frozenPercent !=0) {
        
        float begAngle = 2*M_PI*(_MarchPercent+_MLBPercent+_availablePercent);
        float endAngle = 2*M_PI*(_MarchPercent +_MLBPercent + _availablePercent+_frozenPercent);

        CGColorRef color = (_frozenColor == nil) ? [UIColor blackColor].CGColor : _frozenColor.CGColor;
        
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

- (void)addSevenArc{
    if (_sevenPercent !=0) {
        float begAngle = 2*M_PI*(_MarchPercent+_MLBPercent+_availablePercent);
        float endAngle = 2*M_PI*(_MarchPercent+_MLBPercent+_availablePercent + _sevenPercent);
        
        CGColorRef color = (_sevenColor == nil) ? [UIColor blackColor].CGColor : _sevenColor.CGColor;
        
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

- (void)addJanuaryArc{
    if (_januaryPercent !=0) {
        float begAngle = 2*M_PI*(_MarchPercent+_MLBPercent+_availablePercent + _sevenPercent);
        float endAngle = 2*M_PI*(_MarchPercent+_MLBPercent+_availablePercent + _sevenPercent + _januaryPercent);
        
        CGColorRef color = (_januaryColor == nil) ? [UIColor blackColor].CGColor : _januaryColor.CGColor;
        
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

//- (void)addRegIncomeArc{
//    if (_regIncomePercent !=0) {
//
//        float begAngle = 2*M_PI*(_availablePercent+_receiptPercent + _frozenPercent +_MLBPercent + _MarchPercent + _sevenPercent + _januaryPercent);
//        float endAngle = 2*M_PI*(_availablePercent+_receiptPercent + _frozenPercent +_MLBPercent + _MarchPercent + _sevenPercent + _januaryPercent+ _regIncomePercent);
//
//        CGColorRef color = (_MLBColor == nil) ? [UIColor blueColor].CGColor : _regIncomeColor.CGColor;
//
//        CGContextRef contextRef = UIGraphicsGetCurrentContext();
//
//        CGSize viewSize = self.bounds.size;
//
//        CGPoint center = CGPointMake(viewSize.width / 2, viewSize.height / 2);
//
//
//        CGFloat radius = viewSize.width / 2;
//
//        CGContextBeginPath(contextRef);
//
//        CGContextMoveToPoint(contextRef, center.x, center.y);
//
//        CGContextAddArc(contextRef, center.x, center.y, radius,begAngle,endAngle, 0);
//
//        CGContextSetFillColorWithColor(contextRef, color);
//
//        CGContextFillPath(contextRef);
//    }
//}


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

    NSMutableAttributedString * firstPart = [[NSMutableAttributedString alloc] initWithString:@"总资产(元)\n"];
    NSDictionary * firstAttributes = @{ NSFontAttributeName:[UIFont boldSystemFontOfSize:12],NSForegroundColorAttributeName:RGBA(208, 208, 208, 1),NSParagraphStyleAttributeName:paragraph};
    [firstPart setAttributes:firstAttributes range:NSMakeRange(0,firstPart.length)];
    
    NSMutableAttributedString * secondPart = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f",_totalIncome]];
    NSDictionary * secondAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:RGBA(108, 108, 108, 108),NSParagraphStyleAttributeName:paragraph};
    [secondPart setAttributes:secondAttributes range:NSMakeRange(0,secondPart.length)];
    
    NSDictionary * thirdAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:RGBA(51, 51, 51, 51),NSParagraphStyleAttributeName:paragraph};
    [secondPart setAttributes:thirdAttributes range:NSMakeRange(0,secondPart.length-2)];

    
    [firstPart appendAttributedString:secondPart];
    
    [firstPart drawInRect:CGRectMake(5, (viewSize.height-40)/2, viewSize.width-10, 60)];
    
    UIImage *ima = [UIImage imageNamed:@"questioncopy"];
    [ima drawInRect:CGRectMake(viewSize.width-42, (viewSize.height-40)/2, 15, 15)];
}


@end

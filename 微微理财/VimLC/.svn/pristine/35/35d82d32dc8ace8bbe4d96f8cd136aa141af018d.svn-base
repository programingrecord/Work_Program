//
//  BezierCurveView.m
//  BezierCurveLineDemo
//
//  Created by mac on 16/7/20.
//  Copyright © 2016年 xiayuanquan. All rights reserved.
//


#import "BezierCurveView.h"

static CGRect myFrame;

@interface BezierCurveView ()

@end

@implementation BezierCurveView

//初始化画布
+(instancetype)initWithFrame:(CGRect)frame{
    
    BezierCurveView *bezierCurveView = [[NSBundle mainBundle] loadNibNamed:@"BezierCurveView" owner:self options:nil].lastObject;
    bezierCurveView.frame = frame;
    
    //背景视图
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    backView.backgroundColor = [UIColor whiteColor];
    [bezierCurveView addSubview:backView];
    
    myFrame = frame;
    return bezierCurveView;
}

/**
 *  画坐标轴
 */
-(void)drawXYLine:(NSMutableArray *)x_names yLine:(NSMutableArray *)y_names{
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    //1.Y轴、X轴的直线
//    [path moveToPoint:CGPointMake(MARGIN, CGRectGetHeight(myFrame)-MARGIN)];
//    [path addLineToPoint:CGPointMake(MARGIN, MARGIN)];
//
//    [path moveToPoint:CGPointMake(MARGIN, CGRectGetHeight(myFrame)-MARGIN)];
//    [path addLineToPoint:CGPointMake(MARGIN+CGRectGetWidth(myFrame)-2*MARGIN, CGRectGetHeight(myFrame)-MARGIN)];
    
    //2.添加箭头
//    [path moveToPoint:CGPointMake(MARGIN, MARGIN)];
//    [path addLineToPoint:CGPointMake(MARGIN-5, MARGIN+5)];
//    [path moveToPoint:CGPointMake(MARGIN, MARGIN)];
//    [path addLineToPoint:CGPointMake(MARGIN+5, MARGIN+5)];
//
//    [path moveToPoint:CGPointMake(MARGIN+CGRectGetWidth(myFrame)-2*MARGIN, CGRectGetHeight(myFrame)-MARGIN)];
//    [path addLineToPoint:CGPointMake(MARGIN+CGRectGetWidth(myFrame)-2*MARGIN-5, CGRectGetHeight(myFrame)-MARGIN-5)];
//    [path moveToPoint:CGPointMake(MARGIN+CGRectGetWidth(myFrame)-2*MARGIN, CGRectGetHeight(myFrame)-MARGIN)];
//    [path addLineToPoint:CGPointMake(MARGIN+CGRectGetWidth(myFrame)-2*MARGIN-5, CGRectGetHeight(myFrame)-MARGIN+5)];

    //3.添加索引格
    //X轴
//    for (int i=0; i<x_names.count; i++) {
//        CGFloat X = MARGIN + MARGIN*(i+1);
//        CGPoint point = CGPointMake(X,CGRectGetHeight(myFrame)-MARGIN);
//        [path moveToPoint:point];
//        [path addLineToPoint:CGPointMake(point.x, point.y-3)];
//    }
//    //Y轴（实际长度为200,此处比例缩小一倍使用）
    for (int i=0; i<y_names.count; i++) {
        CGFloat Y ;
        if (is_iPhoneX) {
            Y = CGRectGetHeight(myFrame)-MARGIN-30*kDeviceHeightScale*i;
        } else{
          Y = CGRectGetHeight(myFrame)-MARGIN-Y_EVERY_MARGIN*i;
        }
        CGPoint point = CGPointMake(MARGIN,Y);
        [path moveToPoint:point];
        [path addLineToPoint:CGPointMake(point.x+MARGIN+CGRectGetWidth(myFrame)-2*MARGIN, point.y)];
        CGFloat dash[] = {10,10};
        [path setLineDash:dash count:2 phase:10];
        [path stroke];

    }
//
    //4.添加索引格文字
    //X轴
    for (int i=0; i<x_names.count; i++) {
        CGFloat X ;
        if ([UIScreen mainScreen].bounds.size.width == 320.f) {
            X = MARGIN + (20+20)*i;
        } else{
            X = MARGIN + (MARGIN+20)*i;
        }
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(X, CGRectGetHeight(myFrame)-MARGIN+5, MARGIN, 20)];
        textLabel.text = x_names[i];
        textLabel.font = [UIFont systemFontOfSize:9];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.textColor = [UIColor colorWithRed:127/255.0 green:127/255.0 blue:127/255.0 alpha:1];
        [self addSubview:textLabel];
    }
    //Y轴
    for (int i=0; i<y_names.count; i++) {
        CGFloat Y;
        if (is_iPhoneX) {
            Y = CGRectGetHeight(myFrame)-MARGIN-Y_EVERY_MARGIN*kDeviceHeightScale*i;
        } else{
            Y = CGRectGetHeight(myFrame)-MARGIN-Y_EVERY_MARGIN*i;
        }
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, Y-5, MARGIN, 10)];
        textLabel.text = [NSString stringWithFormat:@"%@",y_names[i]];
        textLabel.font = [UIFont systemFontOfSize:9];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.textColor = [UIColor colorWithRed:127/255.0 green:127/255.0 blue:127/255.0 alpha:1];
        [self addSubview:textLabel];
    }

    //5.渲染路径
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    shapeLayer.borderWidth = 0.5;
    shapeLayer.lineWidth = 1;
    shapeLayer.strokeColor = LineColor.CGColor;
    shapeLayer.fillColor = [UIColor colorWithRed:127/255.0 green:127/255.0 blue:127/255.0 alpha:1].CGColor;
    [self.subviews[0].layer addSublayer:shapeLayer];
}


/**
 *  画折线图
 */
-(void)drawLineChartViewWithX_Value_Names:(NSMutableArray *)x_names TargetValues:(NSMutableArray *)targetValues dataArr:(NSArray *)dataArr space:(CGFloat)space LineType:(LineType) lineType{
    
    //1.画坐标轴
    [self drawXYLine:x_names yLine:targetValues];
    
    //2.获取目标值点坐标
    NSMutableArray *allPoints = [NSMutableArray array];
    for (int i=0; i<dataArr.count; i++) {
        NSString *str = dataArr[i];
        CGFloat aa = (([str doubleValue] - [targetValues[0] doubleValue]));
//        NSLog(@"--%ld",aa);
        CGFloat doubleValue ;
        if (is_iPhoneX) {
            doubleValue = (double)Y_EVERY_MARGIN*kDeviceHeightScale*aa/space;
        } else{
           doubleValue = (double)Y_EVERY_MARGIN*aa/space;
        }
        CGFloat X ;
        if ([UIScreen mainScreen].bounds.size.width == 320.f) {
            X = MARGIN+ 15 + (20+20)*i;
        } else{
            X = MARGIN+ 15 + (MARGIN+20)*i;
        }
        CGFloat Y = CGRectGetHeight(myFrame)-MARGIN-doubleValue;
        CGPoint point = CGPointMake(X,Y);
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(point.x-2.5, point.y-2.5, 5, 5) cornerRadius:5];
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.strokeColor = [UIColor colorWithRed:101/255.0 green:159/255.0 blue:238/255.0 alpha:1].CGColor;
        layer.fillColor = [UIColor colorWithRed:101/255.0 green:159/255.0 blue:238/255.0 alpha:1].CGColor;
        layer.path = path.CGPath;
        [self.subviews[0].layer addSublayer:layer];
        [allPoints addObject:[NSValue valueWithCGPoint:point]];
    }

    //3.坐标连线
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:[allPoints[0] CGPointValue]];
    CGPoint PrePonit;
    switch (lineType) {
        case LineType_Straight: //直线
            for (int i =1; i<allPoints.count; i++) {
                CGPoint point = [allPoints[i] CGPointValue];
                [path addLineToPoint:point];
            }
            break;
        case LineType_Curve:   //曲线
            for (int i =0; i<allPoints.count; i++) {
                if (i==0) {
                    PrePonit = [allPoints[0] CGPointValue];
                }else{
                    CGPoint NowPoint = [allPoints[i] CGPointValue];
                    [path addCurveToPoint:NowPoint controlPoint1:CGPointMake((PrePonit.x+NowPoint.x)/2, PrePonit.y) controlPoint2:CGPointMake((PrePonit.x+NowPoint.x)/2, NowPoint.y)]; //三次曲线
                    PrePonit = NowPoint;
                }
            }
            break;
    }
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    shapeLayer.strokeColor = [UIColor colorWithRed:101/255.0 green:159/255.0 blue:238/255.0 alpha:1].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.borderWidth = 1;
    [self.subviews[0].layer addSublayer:shapeLayer];
    
    //4.添加目标值文字
    for (int i =0; i<allPoints.count; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor colorWithRed:101/255.0 green:159/255.0 blue:238/255.0 alpha:1];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:12];
        [self.subviews[0] addSubview:label];
        
        if (i==0) {
            CGPoint NowPoint = [allPoints[0] CGPointValue];
            label.text = [NSString stringWithFormat:@"%@",dataArr[0]];
            label.frame = CGRectMake(NowPoint.x-MARGIN/2, NowPoint.y-20, 40, 20);
            PrePonit = NowPoint;
        }else{
            CGPoint NowPoint = [allPoints[i] CGPointValue];
            label.frame = CGRectMake(NowPoint.x-MARGIN/2, NowPoint.y-20, 40, 20);

//            if (NowPoint.y<PrePonit.y) {  //文字置于点上方
//                label.frame = CGRectMake(NowPoint.x-MARGIN/2, NowPoint.y-20, 40, 20);
//            }else{ //文字置于点下方
//                label.frame = CGRectMake(NowPoint.x-MARGIN/2, NowPoint.y, 40, 20);
//            }
            label.text = [NSString stringWithFormat:@"%@",dataArr[i]];
            PrePonit = NowPoint;
        }
    }
}

/**
 *  画柱状图
 */
-(void)drawBarChartViewWithX_Value_Names:(NSMutableArray *)x_names TargetValues:(NSMutableArray *)targetValues{
    
    //1.画坐标轴
    [self drawXYLine:x_names yLine:targetValues];
    
    //2.每一个目标值点坐标
    for (int i=0; i<targetValues.count; i++) {
        CGFloat doubleValue = 2*[targetValues[i] floatValue]; //目标值放大两倍
        CGFloat X = MARGIN + MARGIN*(i+1)+5;
        CGFloat Y = CGRectGetHeight(myFrame)-MARGIN-doubleValue;
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(X-MARGIN/2, Y, MARGIN-10, doubleValue)];
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = path.CGPath;
        shapeLayer.strokeColor = [UIColor clearColor].CGColor;
        shapeLayer.fillColor = XYQRandomColor.CGColor;
        shapeLayer.borderWidth = 2.0;
        [self.subviews[0].layer addSublayer:shapeLayer];
        
        //3.添加文字
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(X-MARGIN/2, Y-20, MARGIN-10, 20)];
        label.text = [NSString stringWithFormat:@"%.0lf",(CGRectGetHeight(myFrame)-Y-MARGIN)/2];
        label.textColor = [UIColor purpleColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:10];
        [self.subviews[0] addSubview:label];
    }
}


/**
 *  画饼状图
 */
-(void)drawPieChartViewWithX_Value_Names:(NSMutableArray *)x_names TargetValues:(NSMutableArray *)targetValues{
    
    //设置圆点
    CGPoint point = CGPointMake(self.frame.size.width/2,self.frame.size.height/2);
    CGFloat startAngle = 0;
    CGFloat endAngle ;
    CGFloat radius = 100;
    
    //计算总数
    __block CGFloat allValue = 0;
    [targetValues enumerateObjectsUsingBlock:^(NSNumber *targetNumber, NSUInteger idx, BOOL * _Nonnull stop) {
        allValue += [targetNumber floatValue];
    }];
    
    //画图
    for (int i =0; i<targetValues.count; i++) {
        
        CGFloat targetValue = [targetValues[i] floatValue];
        endAngle = startAngle + targetValue/allValue*2*M_PI;

        //bezierPath形成闭合的扇形路径
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:point
                                                                   radius:radius
                                                               startAngle:startAngle                                                                 endAngle:endAngle
                                                                clockwise:YES];
        [bezierPath addLineToPoint:point];
        [bezierPath closePath];
        
        
        //添加文字
        CGFloat X = point.x + 120*cos(startAngle+(endAngle-startAngle)/2) - 10;
        CGFloat Y = point.y + 110*sin(startAngle+(endAngle-startAngle)/2) - 10;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(X, Y, 30, 20)];
        label.text = x_names[i];
        label.font = [UIFont systemFontOfSize:11];
        label.textColor = XYQColor(13, 195, 176);
        [self.subviews[0] addSubview:label];
        
        
        //渲染
        CAShapeLayer *shapeLayer=[CAShapeLayer layer];
        shapeLayer.lineWidth = 1;
        shapeLayer.fillColor = XYQRandomColor.CGColor;
        shapeLayer.path = bezierPath.CGPath;
        [self.layer addSublayer:shapeLayer];
        
        startAngle = endAngle;
    }
}
@end

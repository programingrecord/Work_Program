//
//  GesturePasswordView.m
//  GesturePassword
//
//  Created by hb on 14-8-23.
//  Copyright (c) 2014年 黑と白の印记. All rights reserved.
//

#import "GesturePasswordView.h"
#import "GesturePasswordButton.h"
#import "TentacleView.h"
#import "UIImageView+WebCache.h"
@implementation GesturePasswordView {
    NSMutableArray * buttonArray;
    
    CGPoint lineStartPoint;
    CGPoint lineEndPoint;
    
}
@synthesize forgetButton;
@synthesize headNavview;
@synthesize tentacleView;
@synthesize state;
@synthesize gesturePasswordDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

        
        self.backgroundColor = [UIColor whiteColor];
        
        
        
        NSDate *now = [NSDate date];
       
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
        NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
        
        int month = (int) [dateComponent month];
        int day = (int) [dateComponent day];
        


        NSString *string = [NSString stringWithFormat:@"%d%d月",day,month];
        
        
        self.Daylable = [[UILabel alloc] initWithFrame:CGRectMake(20, 30*kDeviceHeightScale, 50, 40*kDeviceHeightScale)];
        self.Daylable.text = [NSString stringWithFormat:@"%d",day];
        self.Daylable.font = TEXTFONT(40);
        self.Daylable.textAlignment= NSTextAlignmentRight;
        self.Daylable.textColor = [UIColor colorWithHex:0x7f7f7f];
        [self addSubview:self.Daylable];
        
        
        
        self.Monthlable = [[UILabel alloc] initWithFrame:CGRectMake(self.Daylable.right+2, 35*kDeviceHeightScale, 40, 13*kDeviceHeightScale)];
        self.Monthlable.text = [NSString stringWithFormat:@"%d月",month];
        self.Monthlable.font = TEXTFONT(13);
        self.Monthlable.textColor = [UIColor colorWithHex:0x7f7f7f];
        [self addSubview:self.Monthlable];


        self.Tiplable = [[UILabel alloc] initWithFrame:CGRectMake(20, self.Daylable.bottom+5*kDeviceHeightScale, 200, 40*kDeviceHeightScale)];
        self.Tiplable.numberOfLines = 0;
        
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        
        paraStyle.lineSpacing = 5; //设置行间距
        
        NSString *cLabelString = @"微米在线\n 专业的票据投资平台";
        NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:cLabelString];

        [attributedString addAttribute:NSParagraphStyleAttributeName value:paraStyle range:NSMakeRange(0, [cLabelString length])];

        self.Tiplable.attributedText = attributedString;
        self.Tiplable.font = TEXTFONT(13);
        self.Tiplable.textColor = [UIColor colorWithHex:0x7f7f7f];
        [self addSubview:self.Tiplable];

        
//        NSString *DayString = [NSString stringWithFormat:@"%d",day];
//        
//        
//        NSMutableAttributedString *Astring = [[NSMutableAttributedString alloc] initWithString:string];
//        
//        [Astring addAttribute:NSFontAttributeName value:TEXTFONT(13)  range:NSMakeRange(0, DayString.length)];
//        
//        [Astring addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0x7f7f7f] range:NSMakeRange(0, string.length)];
//        
//        [Astring addAttribute:NSFontAttributeName value:TEXTFONT(40)  range:NSMakeRange(0, DayString.length)];
//        self.Datelable.attributedText = Astring;
//        [self addSubview:self.Datelable];
//
        
        
        
        
        
        buttonArray = [[NSMutableArray alloc]initWithCapacity:0];
        
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(frame.size.width/2-160, frame.size.height/2-140*kDeviceHeightScale, 320*kDeviceWidthScale, 320*kDeviceWidthScale)];
        for (int i=0; i<9; i++) {
            NSInteger row = i/3;
            NSInteger col = i%3;
            
            NSInteger distance = 320/3;
            NSInteger size = distance/1.5;
            NSInteger margin = size/4;
            GesturePasswordButton * gesturePasswordButton = [[GesturePasswordButton alloc]initWithFrame:CGRectMake(col*distance+margin, row*distance, size, size)];
            [gesturePasswordButton setTag:i];
            [view addSubview:gesturePasswordButton];
            [buttonArray addObject:gesturePasswordButton];
        }
        frame.origin.y=0;
        [self addSubview:view];
        tentacleView = [[TentacleView alloc]initWithFrame:view.frame];
        [tentacleView setButtonArray:buttonArray];
        [tentacleView setTouchBeginDelegate:self];
        [self addSubview:tentacleView];
        
        state = [[UILabel alloc]initWithFrame:CGRectMake(0, frame.size.height/2-200*kDeviceHeightScale, frame.size.width, 30*kDeviceHeightScale)];
        state.text = @"请绘制手势密码";
        state.textColor = [UIColor colorWithHex:0x333333] ;

        [state setTextAlignment:NSTextAlignmentCenter];
        [state setFont:[UIFont systemFontOfSize:18.f]];
        [self addSubview:state];
        
        
        
        
        
        
        forgetButton = [[UIButton alloc]initWithFrame:CGRectMake(10, frame.size.height/2+220*kDeviceHeightScale, kDeviceWidth-20, 30*kDeviceHeightScale)];
        [forgetButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [forgetButton setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
        [forgetButton setTitle:@"忘记手势密码?" forState:UIControlStateNormal];
        [forgetButton addTarget:self action:@selector(useUMLogin) forControlEvents:UIControlEventTouchDown];
        [self addSubview:forgetButton];
        
        
        _useOtherButton = [[UIButton alloc]initWithFrame:CGRectMake(10,forgetButton.bottom+20*kDeviceHeightScale, kDeviceWidth-20, 30*kDeviceHeightScale)];
        [_useOtherButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_useOtherButton setTitleColor:RGBA(101, 201, 247, 1) forState:UIControlStateNormal];
        [_useOtherButton setTitle:@"账号密码登录" forState:UIControlStateNormal];
        [_useOtherButton addTarget:self action:@selector(useUMLogin) forControlEvents:UIControlEventTouchDown];
        [self addSubview:_useOtherButton];
        
        if (IS_IPHONE_5) {
            _passButton = [[UIButton alloc]initWithFrame:CGRectMake(10,forgetButton.bottom+20*kDeviceHeightScale, kDeviceWidth-20, 30*kDeviceHeightScale)];
        } else{
            _passButton = [[UIButton alloc]initWithFrame:CGRectMake(10,forgetButton.bottom+0, kDeviceWidth-20, 30*kDeviceHeightScale)];
        }
        [_passButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_passButton setTitleColor:RGBA(101, 201, 247, 1) forState:UIControlStateNormal];
        [_passButton setTitle:@"暂不设置" forState:UIControlStateNormal];
        [_passButton addTarget:self action:@selector(passBtnClick) forControlEvents:UIControlEventTouchDown];
        [self addSubview:_passButton];
        
        
        
        headNavview = [[UIView alloc] initWithFrame:CGRectMake(0,0,kDeviceWidth,64*kDeviceHeightScale)];
        headNavview.backgroundColor = [UIColor colorWithHex:0xFB6337];
        [self addSubview:headNavview];
        
        //返回按钮
        self.backbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.backbtn.center = CGPointMake(20, 42);
        self.backbtn.bounds = CGRectMake(0, 0, 40, 40);
        [self.backbtn.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
        [self.backbtn setImage:[UIImage imageNamed:@"nav_icon_back_white"] forState:UIControlStateNormal];
        [self.backbtn setBackgroundColor:[UIColor clearColor]];
        self.backbtn.adjustsImageWhenHighlighted = NO;
        [self.backbtn addTarget:self action:@selector(handBackTaped) forControlEvents:UIControlEventTouchDown];
        
        //注意：代理设置放到了父视图设置
        [headNavview addSubview:self.backbtn];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60,27*kDeviceHeightScale,kDeviceWidth - 120,30*kDeviceHeightScale)];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_titleLabel setFont:[UIFont boldSystemFontOfSize:20.0f]];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [headNavview addSubview:_titleLabel];
        
    }
    
    return self;
}


- (void)drawRect:(CGRect)rect
{
    
}

- (void)gestureTouchBegin {
    
}

-(void)useUMLogin{
    
    if (gesturePasswordDelegate && [gesturePasswordDelegate respondsToSelector:@selector(useUMLogin)]) {
        [gesturePasswordDelegate useUMLogin];
        
    }
}


- (void)handBackTaped{
    if (gesturePasswordDelegate && [gesturePasswordDelegate respondsToSelector:@selector(handBackTaped)]) {
        [gesturePasswordDelegate handBackTaped];
    }
}

- (void)passBtnClick{
    if (gesturePasswordDelegate && [gesturePasswordDelegate respondsToSelector:@selector(passBtnClick)]) {
        [gesturePasswordDelegate passBtnClick];
    }
}

@end

//
//  XGQRScanView.m
//  XGDevelopDemo
//
//  Created by 小广 on 2016/11/29.
//  Copyright © 2016年 小广. All rights reserved.
//  二维码扫描区域的view

#import "XGQRScanView.h"

static NSTimeInterval kLineanimateDuration = 0.02;

@interface XGQRScanView()

/// 二维码上下扫描的一条线
@property (nonatomic, strong) UIImageView *qrLine;
/// 条形码（暂且只有二维码）
//@property (nonatomic, strong) UIImageView *barLine;
/// 记录二维码扫描线的y位置
@property (nonatomic, assign) CGFloat qrLineY;
/// 扫描框下面的提示语句label
@property (nonatomic, strong) UILabel *noteLabel;
/// 扫描的定时器
@property dispatch_source_t timer;

@end

@implementation XGQRScanView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.scanType = XGSanSourceTypeQR;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    NSLog(@"------首先调用的是layoutSubviews方法------");
    // 目前只有二维码扫描
    self.scanType = XGSanSourceTypeQR;
    [self initQRLine];
    [self showQRScanBlock];
}

- (void)initQRLine {
    NSLog(@"------initQRLine------");
    if (!self.qrLine) {
        self.qrLine = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width/2-self.transparentArea.width/2+2, self.bounds.size.height/2-self.transparentArea.height/2, 235, 3)];
        [self.qrLine setImage:[UIImage imageNamed:@"qr_line"]];
        [self.qrLine setContentMode:UIViewContentModeScaleAspectFill];
        [self addSubview:self.qrLine];
        self.qrLineY = self.qrLine.frame.origin.y;
    }
}

- (void)showQRScanBlock {
    
    if (self.timer) {
        dispatch_source_cancel(self.timer);
    }
    [self.qrLine setHidden:NO];
    CGFloat maxBorder = self.frame.size.height / 2 + self.transparentArea.height / 2 - 4;
    __block CGFloat qrLineY_temp = self.qrLineY;
    __block CGRect qrLine_frame = self.qrLine.frame;
    
    kWeakSelf;
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,dispatch_get_main_queue());
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),kLineanimateDuration*NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        qrLine_frame.origin.y = qrLineY_temp;
        weakSelf.qrLine.frame = qrLine_frame;
        if (qrLineY_temp > maxBorder) {
            qrLineY_temp = weakSelf.frame.size.height/2 - weakSelf.transparentArea.height/2;
        }
        qrLineY_temp++;
    });
    dispatch_resume(self.timer);
}

- (void)drawRect:(CGRect)rect {
    NSLog(@"------其次调用的是drawRect方法------");
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            [view removeFromSuperview];
            break;
        }
    }
    //整个二维码扫描界面的颜色
    CGSize screenSize =[UIScreen mainScreen].bounds.size;
    CGRect screenDrawRect =CGRectMake(0, 0, screenSize.width,screenSize.height);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //中间清空的矩形框
    CGRect clearDrawRect = CGRectMake(screenDrawRect.size.width / 2 - self.transparentArea.width / 2,
                                      screenDrawRect.size.height / 2 - self.transparentArea.height / 2,
                                      self.transparentArea.width,self.transparentArea.height);
    [self addScreenFillRect:ctx rect:screenDrawRect];
    [self addCenterClearRect:ctx rect:clearDrawRect];
    [self addLabelUnderClearRect:clearDrawRect];
}

// 扫描框下面的提示语句
- (void)addLabelUnderClearRect:(CGRect)rect {
    if (!_noteLabel) {
        CGFloat startX = rect.origin.x;
        CGFloat startY = rect.origin.y;
        CGFloat width = rect.size.width;
        CGFloat height = rect.size.height;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(startX, startY + height + 30.0, width, 17.0)];
        [label setTextColor:[UIColor whiteColor]];
        label.font = [UIFont systemFontOfSize:18.0];
        [label setTextAlignment:NSTextAlignmentCenter];
        _noteLabel = label;
    }
    _noteLabel.text = ISNULL(self.noteString).length > 0 ? ISNULL(self.noteString) : @"将二维码放入扫描框内";
    [self addSubview:_noteLabel];
}


/// 绘制扫描框相关
- (void)addScreenFillRect:(CGContextRef)ctx rect:(CGRect)rect {
    
    CGContextSetRGBFillColor(ctx, 40 / 255.0,40 / 255.0,40 / 255.0,0.5);
    CGContextFillRect(ctx, rect);   //draw the transparent layer
}

- (void)addCenterClearRect :(CGContextRef)ctx rect:(CGRect)rect {
    
    CGContextClearRect(ctx, rect);  //clear the center rect  of the layer
}





- (void)addWhiteRect:(CGContextRef)ctx rect:(CGRect)rect {
    
    CGContextStrokeRect(ctx, rect);
    CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 1);
    CGContextSetLineWidth(ctx, 0.8);
    CGContextAddRect(ctx, rect);
    CGContextStrokePath(ctx);
}

- (void)addCornerLineWithContext:(CGContextRef)ctx rect:(CGRect)rect{
    
    //画四个边角
    CGContextSetLineWidth(ctx, 2);
    CGContextSetRGBStrokeColor(ctx, 83 /255.0, 239/255.0, 111/255.0, 1);//绿色
    
    //左上角
    CGPoint poinsTopLeftA[] = {
        CGPointMake(rect.origin.x+0.7, rect.origin.y),
        CGPointMake(rect.origin.x+0.7 , rect.origin.y + 15)
    };
    
    CGPoint poinsTopLeftB[] = {CGPointMake(rect.origin.x, rect.origin.y +0.7),CGPointMake(rect.origin.x + 15, rect.origin.y+0.7)};
    [self addLine:poinsTopLeftA pointB:poinsTopLeftB ctx:ctx];
    
    //左下角
    CGPoint poinsBottomLeftA[] = {CGPointMake(rect.origin.x+ 0.7, rect.origin.y + rect.size.height - 15),CGPointMake(rect.origin.x +0.7,rect.origin.y + rect.size.height)};
    CGPoint poinsBottomLeftB[] = {CGPointMake(rect.origin.x , rect.origin.y + rect.size.height - 0.7) ,CGPointMake(rect.origin.x+0.7 +15, rect.origin.y + rect.size.height - 0.7)};
    [self addLine:poinsBottomLeftA pointB:poinsBottomLeftB ctx:ctx];
    
    //右上角
    CGPoint poinsTopRightA[] = {CGPointMake(rect.origin.x+ rect.size.width - 15, rect.origin.y+0.7),CGPointMake(rect.origin.x + rect.size.width,rect.origin.y +0.7 )};
    CGPoint poinsTopRightB[] = {CGPointMake(rect.origin.x+ rect.size.width-0.7, rect.origin.y),CGPointMake(rect.origin.x + rect.size.width-0.7,rect.origin.y + 15 +0.7 )};
    [self addLine:poinsTopRightA pointB:poinsTopRightB ctx:ctx];
    
    CGPoint poinsBottomRightA[] = {CGPointMake(rect.origin.x+ rect.size.width -0.7 , rect.origin.y+rect.size.height+ -15),CGPointMake(rect.origin.x-0.7 + rect.size.width,rect.origin.y +rect.size.height )};
    CGPoint poinsBottomRightB[] = {CGPointMake(rect.origin.x+ rect.size.width - 15 , rect.origin.y + rect.size.height-0.7),CGPointMake(rect.origin.x + rect.size.width,rect.origin.y + rect.size.height - 0.7 )};
    [self addLine:poinsBottomRightA pointB:poinsBottomRightB ctx:ctx];
    CGContextStrokePath(ctx);
}

- (void)addLine:(CGPoint[])pointA pointB:(CGPoint[])pointB ctx:(CGContextRef)ctx {
    CGContextAddLines(ctx, pointA, 2);
    CGContextAddLines(ctx, pointB, 2);
}

@end

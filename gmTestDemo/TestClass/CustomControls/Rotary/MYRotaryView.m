//
//  myview.m
//  testlayer
//
//  Created by lemonmgy on 2017/1/16.
//  Copyright © 2017年 lemonmgy. All rights reserved.
//

#import "MYRotaryView.h"

#define kBug NO

@interface RotaryDataView : UIView {
    CGFloat _radius;
    CGFloat _dotCount;
}
@property (nonatomic, strong) NSMutableArray *angleArray;
@property (nonatomic, assign) CGFloat angleBase;
@end

@implementation RotaryDataView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.angleArray = [NSMutableArray new];
        
        CGFloat sw = self.frame.size.width;
        CGFloat sh = self.frame.size.height;
        _radius = sw/2.0;//大圆半径
        _dotCount = 12*1; //大圆点个数
        CGFloat radius = _radius;
        CGFloat x = (sw - 2*radius)/2.0;
        CGFloat y = (sh - 2*radius)/2.0;
        
        UIView *centerYline = [UIView new];
        centerYline.backgroundColor = [UIColor greenColor];
        centerYline.frame = CGRectMake(0, sh/2.0, sw, 1);
        [self addSubview:centerYline];
        
        UIView *centerXline = [UIView new];
        centerXline.backgroundColor = [UIColor greenColor];
        centerXline.frame = CGRectMake(sw/2.0, 0, 1, sh);
        [self addSubview:centerXline];
        
        
        UIView *topline = [UIView new];
        topline.backgroundColor = [UIColor greenColor];
        topline.frame = CGRectMake(0, y, sw, 1);
        [self addSubview:topline];
        
        UIView *bottomline = [UIView new];
        bottomline.backgroundColor = [UIColor greenColor];
        bottomline.frame = CGRectMake(0, y+2*radius, sw, 1);
        [self addSubview:bottomline];
        
        UIView *leftline = [UIView new];
        leftline.backgroundColor = [UIColor greenColor];
        leftline.frame = CGRectMake(x, 0, 1, sh);
        [self addSubview:leftline];
        
        UIView *rightline = [UIView new];
        rightline.backgroundColor = [UIColor greenColor];
        rightline.frame = CGRectMake(x+2*radius, 0, 1, sh);
        [self addSubview:rightline];
        
        
        
        CGFloat dotLength = 0;//圆点的长度
        CGFloat dotR = 4;//大圆点半径
        CGFloat dotCount = _dotCount; //大圆点个数
        CGFloat interval = [self arcLengthWithDotCount:dotCount andRadius:radius andDotLength:dotLength];
        NSArray *patternArray = @[[NSNumber numberWithDouble:dotLength],[NSNumber numberWithDouble:interval]];
        CGRect rect = CGRectMake(x, y, 2*radius, 2*radius);
        CAShapeLayer *bigDotteLine = [self getDotteLineWithRadius:dotR strokeColor:[UIColor redColor] lineDashPattern:patternArray rect:rect];
        
        dotR = dotR/2.0;//小圆点半径
        dotCount = 5*dotCount;
        interval = [self arcLengthWithDotCount:dotCount andRadius:radius andDotLength:dotLength];
        patternArray = @[[NSNumber numberWithDouble:dotLength],[NSNumber numberWithDouble:interval]];
        CAShapeLayer *smallDotteLine = [self getDotteLineWithRadius:dotR strokeColor:[UIColor yellowColor] lineDashPattern:patternArray rect:rect];
        [self.layer addSublayer:smallDotteLine];
        [self.layer addSublayer:bigDotteLine];
        
        
        CGFloat l = 0;
        for (int i = 0; i < dotCount; i ++) {
            l = i * (interval+dotLength);
            CGFloat angle = l/radius;
            [self.angleArray addObject:[NSNumber numberWithFloat:angle]];
            if (i == 1) {
                self.angleBase = angle;
            }
        }
        
        [self setNeedsDisplay];
        
    }
    return self;
    
}
- (CGFloat)arcLengthWithDotCount:(CGFloat)dotCount andRadius:(CGFloat)radius andDotLength:(CGFloat)dotLength {
    return (2*radius*M_PI-dotCount*dotLength)/dotCount;
}

- (CAShapeLayer *)getDotteLineWithRadius:(CGFloat)radius strokeColor:(UIColor *)strokeColor lineDashPattern:(NSArray *)lineDashArray rect:(CGRect)rect {
    CAShapeLayer *dotteLine =  [CAShapeLayer layer];
    dotteLine.lineWidth = 2*radius;
    dotteLine.strokeColor = strokeColor.CGColor;
    dotteLine.fillColor = [UIColor clearColor].CGColor;
    dotteLine.lineCap = @"round";
    dotteLine.lineDashPattern = lineDashArray;
    CGMutablePathRef dottePath =  CGPathCreateMutable();
    CGPathAddEllipseInRect(dottePath, nil, rect);
    dotteLine.path = dottePath;
    CGPathRelease(dottePath);
    return dotteLine;
}


-(void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    NSString *str2 = @"";
    for (int i = 0; i < _dotCount; i++) {
        str2 = (i == 0)? @"0":[NSString stringWithFormat:@"%@ %d",str2,i];
    }
    
    NSMutableArray *array = [NSMutableArray new];
    array = (NSMutableArray*)[str2 componentsSeparatedByString:@" "];
    
    NSDictionary *dic = @{NSFontAttributeName :[UIFont systemFontOfSize:12]};
  
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat l = 0;
    int index = -1;
    CGFloat dotNumber = _dotCount;
    CGFloat roundR = _radius;
    CGFloat interval = (2*roundR*M_PI-dotNumber)/dotNumber;
    

    for (NSString *str in array) {

        CGSize cSize = [str sizeWithAttributes:dic];
        
        l = (++index) * (interval+1);
        
        CGFloat angle = l/roundR;
        CGPoint point = CGPointMake(-cSize.width/2.0, 5);
        
        CGFloat offsetX = (sin(angle) + 1)*roundR;
        CGFloat offsetY = (1 - cos(angle))*roundR;
        
        CGContextSaveGState(context);
            CGContextTranslateCTM(context, offsetX, offsetY);
            CGContextRotateCTM(context, angle);
            [str drawAtPoint:point withAttributes:dic];
            
            if (kBug) {
                CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
                CGContextAddRect(context, CGRectMake(point.x, point.y, cSize.width, cSize.height));
                CGContextStrokePath(context);
            }
        CGContextRestoreGState(context);
    }
    
}

- (void)line:(CGContextRef )context x:(CGFloat)x y:(CGFloat)y{
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, x, y);
    CGContextStrokePath(context);
}
@end



@interface MYTriangleView :UIView

@end

@implementation MYTriangleView

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor purpleColor].CGColor);
//    CGContextSetStrokeColorWithColor(context, [UIColor purpleColor].CGColor);
    CGContextSetLineWidth(context, 1);
    CGFloat baseValue = rect.size.width/2.0+0.5;
    CGContextMoveToPoint(context, baseValue, 0);
    CGContextAddLineToPoint(context, baseValue - 2, rect.size.height/2.0);
    CGContextAddLineToPoint(context, baseValue + 2, rect.size.height/2.0);
    CGContextClosePath(context);
//    CGContextStrokePath(context);
    CGContextFillPath(context);
}

@end


@interface MYRotaryView(){
    RotaryDataView *_rotaryView;
    MYTriangleView *_triangleView;
}
@property (nonatomic, assign) CGFloat lastOffset;
@property (nonatomic, assign) int selectedIndex;

@end

@implementation MYRotaryView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
    self.frame = frame;
        [self panView];
        
    }
    return self;
}

- (void)panView {
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panClick:)];
    [self addGestureRecognizer:pan];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [self addGestureRecognizer:tap];
    
    _rotaryView = [[RotaryDataView alloc] initWithFrame:CGRectMake(15, 15, CGRectGetWidth(self.frame)-30, CGRectGetWidth(self.frame)-30)];
    _rotaryView.backgroundColor = [UIColor clearColor];
    [self addSubview:_rotaryView];
    
    _triangleView = [[MYTriangleView alloc] initWithFrame:_rotaryView.frame];
    _triangleView.backgroundColor = [UIColor clearColor];
    [self addSubview:_triangleView];
    
}

- (void)panClick:(UIPanGestureRecognizer *)pan {
    CGPoint point = [pan translationInView:self];
//    [pan locationInView:self];
    
    CGFloat offset = point.x/self.frame.size.width*1.2 + _lastOffset;

    if (offset >= 0) {
        _lastOffset = 0;
        _rotaryView.transform = CGAffineTransformIdentity;
        return;
    }else if(offset <= -M_PI*2) {
        _lastOffset = -M_PI*2;
        _rotaryView.transform = CGAffineTransformMakeRotation(_lastOffset);
        return;
    }
    
    [self areaWithOffset:offset andBaseAngle:_rotaryView.angleBase andEnd:NO];
 
    if (pan.state == UIGestureRecognizerStateBegan ||
        pan.state == UIGestureRecognizerStateChanged) {
        
        _rotaryView.transform = CGAffineTransformMakeRotation(offset);
        
    }else if (pan.state == UIGestureRecognizerStateEnded||
              pan.state == UIGestureRecognizerStateCancelled) {
        
        _lastOffset = [self areaWithOffset:offset andBaseAngle:_rotaryView.angleBase andEnd:YES];
        [UIView animateWithDuration:0.3 animations:^{
            self->_rotaryView.transform = CGAffineTransformMakeRotation(self->_lastOffset);
        }];
        
     }
}

- (CGFloat)areaWithOffset:(CGFloat)offset andBaseAngle:(CGFloat)angleBase andEnd:(BOOL)end {
    CGFloat offsetValue = fabs(offset);
    int index = offsetValue/angleBase;
    CGFloat indexAngle = angleBase * index;
        
    if ((offsetValue >= (indexAngle + angleBase/2.0))) {
        index = index +1;
        indexAngle = index*angleBase;
    }
    
    if (end) {
        offset = -indexAngle;
    }
    
    if (self.selectedIndex != index) {
        self.selectedIndex = index;
        [self blockCallback:self.selectedIndex];
    }

    return offset;
}

- (void)blockCallback:(int)index {
    if (self.block) {
        self.block([NSString stringWithFormat:@"%d",index]);
    }
}

- (void)tapClick:(UITapGestureRecognizer *)tap {
    _rotaryView.transform = CGAffineTransformIdentity;
    _lastOffset = 0;
}

- (double)getValuePoint:(CGPoint)point {
    CGFloat sq = sqrt((pow(point.x, 2)+pow(point.y, 2)));
    if (point.y < 0||point.x < 0) {
        return -sq;
    }
    return sq;
}


@end

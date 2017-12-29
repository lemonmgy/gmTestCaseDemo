//
//  myview.m
//  testlayer
//
//  Created by lemonmgy on 2017/1/16.
//  Copyright © 2017年 lemonmgy. All rights reserved.
//

#import "myview.h"

@interface RotaryView : UIView {
    CALayer *_myLayer;
}

@end

@implementation RotaryView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor redColor];
//
        

        
        CGFloat sw = self.frame.size.width;
        
        CGFloat sh = self.frame.size.height;
        
        CGFloat bigDotR = 8;//大圆点直径
        CGFloat roundR = (sw-bigDotR)/2.0;//大圆半径
        CGFloat w = 2*roundR;
        CGFloat x = (sw - w)/2.0-0.5;
        CGFloat y = (sh - w)/2.0-0.5;
        
        
        UIView *line = [UIView new];
        line.backgroundColor = [UIColor greenColor];
        line.frame = CGRectMake(0, sh/2.0-0.5, sw, 1);
        [self addSubview:line];
        
        UIView *line22 = [UIView new];
        line22.backgroundColor = [UIColor greenColor];
        line22.frame = CGRectMake(sw/2.0-0.5, 0, 1, sh);
        [self addSubview:line22];
        
        
        UIView *topline = [UIView new];
        topline.backgroundColor = [UIColor greenColor];
        topline.frame = CGRectMake(0, y, sw, 1);
        [self addSubview:topline];
        
        UIView *bottomline = [UIView new];
        bottomline.backgroundColor = [UIColor greenColor];
        bottomline.frame = CGRectMake(0, y+w, sw, 1);
        [self addSubview:bottomline];
        
        UIView *leftline = [UIView new];
        leftline.backgroundColor = [UIColor greenColor];
        leftline.frame = CGRectMake(x, 0, 1, sh);
        [self addSubview:leftline];
        
        UIView *rightline = [UIView new];
        rightline.backgroundColor = [UIColor greenColor];
        rightline.frame = CGRectMake(x+w, 0, 1, sh);
        [self addSubview:rightline];
        
//        //
//        CAShapeLayer *dotteLine =  [CAShapeLayer layer];
//        CGMutablePathRef dottePath =  CGPathCreateMutable();
//        
//        dotteLine.lineWidth = 10;
//        dotteLine.strokeColor = [UIColor orangeColor].CGColor;
//        dotteLine.fillColor = [UIColor clearColor].CGColor;
//        CGPathAddEllipseInRect(dottePath, nil, CGRectMake(x, y, w, w));
//        dotteLine.path = dottePath;
//        //    dotteLine.strokeStart = 0.25;
//        //    dotteLine.strokeEnd = 0.5;
//        
//        
//        CGFloat dotNumber = 12;
//        CGFloat interval = (w*M_PI-dotNumber)/dotNumber;
//        
//        NSArray *arr = [[NSArray alloc] initWithObjects:[NSNumber numberWithDouble:1],[NSNumber numberWithDouble:interval], nil];
//        dotteLine.lineDashPattern = arr;
//        dotteLine.lineCap = @"round";
//        
//        CAShapeLayer *dotteLine2 =  [CAShapeLayer layer];
//        
//        dotteLine2.lineWidth = 3.0f;
//        dotteLine2.strokeColor = [UIColor blackColor].CGColor;
//        dotteLine2.fillColor = [UIColor clearColor].CGColor;
//        dotteLine2.path = dottePath;
//        
//        dotNumber = 4.0*dotNumber;
//        interval = (w*M_PI-dotNumber)/dotNumber;
//        NSArray *arr2 = @[@1,[NSNumber numberWithFloat:interval]];
//        dotteLine2.lineDashPattern = arr2;
//        dotteLine2.lineCap = @"round";
//        
//        CGPathRelease(dottePath);
//        [self.layer addSublayer:dotteLine2];
//        
//        [self.layer addSublayer:dotteLine];
//        
//        
//        CGAffineTransform textTransform = CGAffineTransformIdentity;
////        CGAffineTransformMakeRotation(M_PI_4);
//        textTransform = CGAffineTransformTranslate(textTransform, 200, 200);
//        
//        line.transform = textTransform;
////
//        [self setNeedsDisplay];
        
        
//        CALayer *layer = [CALayer layer];
//        
//        layer.backgroundColor = [UIColor blueColor].CGColor;
//        layer.frame = CGRectMake(100, 100, 200, 200);
//        _myLayer = layer;
//        [self.layer addSublayer:layer];
//        [self.layer setNeedsDisplay];
        
        
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.fillColor = [UIColor clearColor].CGColor;
        layer.strokeColor = [UIColor purpleColor].CGColor;
        layer.lineWidth = 6;
        CGMutablePathRef pathRef =  CGPathCreateMutable();
        CGPathAddEllipseInRect(pathRef, &CGAffineTransformIdentity, CGRectMake(20, 20, 200, 200));
        layer.path = pathRef;
        CGPathRelease(pathRef);
        
        NSArray *arr = @[@5,@20];
        layer.lineDashPattern = arr;
        layer.lineCap = @"round";
        
        [self.layer addSublayer:layer];
        
    }
    return self;
    
}

- (void)drawContext:(CGContextRef)context block:(void(^)())block {
    CGContextSaveGState(context);
    block();
    CGContextRestoreGState(context);
    
}

-(void)dealloc {
    
    NSLog(@"dealloc");
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    
    [super drawLayer:layer inContext:ctx];
    
    CGContextSetFillColorWithColor(ctx, [UIColor greenColor].CGColor);
    CGContextAddRect(ctx, CGRectMake(-80, 0, 100, 100));
    
    CGContextFillPath(ctx);
    
}

//- (void)drawRect:(CGRect)rect {
//    [super drawRect:rect];
//    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    
//    CGFloat sw = rect.size.width;
//    CGFloat sh = rect.size.height;
//    CGFloat centerX = sw/2.0;
//    CGFloat centerY = sh/2.0;
//    
//    CGFloat bigDotR = 8;//大圆点直径
//    CGFloat roundR = (sw-0)/2.0;//大圆半径
//    CGFloat bigDotNumber = 12;
//    CGFloat bigInterval = (2*roundR*M_PI-bigDotNumber)/bigDotNumber;
//    
//    
//    CGFloat smallDotR = 3;//小圆点直径
//    CGFloat smallDotNumber = 5.0*bigDotNumber;
//    CGFloat smallInterval = (2*roundR*M_PI-smallDotNumber)/smallDotNumber;
//    
//    [self drawContext:context block:^{  //小圆点
//        CGContextSetStrokeColorWithColor(context, [[UIColor blueColor] CGColor]);
//        CGContextSetLineWidth(context, smallDotR);
//        CGFloat lenghts[] = {1,smallInterval};
//        CGContextSetLineDash(context, 0, lenghts, 2);
//        CGContextSetLineCap(context, kCGLineCapRound);
//        CGContextAddArc(context, centerX, centerY, roundR, 0, M_PI*2, 0);
//        CGContextStrokePath(context);
//    }];
//    
//    [self drawContext:context block:^{  //大圆点
//        CGContextSetStrokeColorWithColor(context, [[UIColor yellowColor] CGColor]);
//        CGContextSetLineWidth(context, bigDotR);
//        CGFloat lenghts[] = {1,bigInterval};
//        CGContextSetLineDash(context, 0, lenghts, 2);
//        CGContextSetLineCap(context, kCGLineCapRound);
//        CGContextAddArc(context, centerX, centerY, roundR, 0, M_PI*2, 0);
//        CGContextStrokePath(context);
//    }];
//    
//    
//    [self drawContext:context block:^{  //大圆点
//        CGContextSetStrokeColorWithColor(context, [[UIColor greenColor] CGColor]);
//        CGContextSetLineWidth(context, 1);
//        CGContextAddArc(context, centerX, centerY, roundR, 0, M_PI*2, 0);
//        CGContextStrokePath(context);
//    }];
//    
//    
//    //画文字
//    [self drawContext:context block:^{
//    }];
//
//    
//        NSString *str2 = @"2 1 2 3 4 5 6 7 8 9 2 2";
//        NSArray *array = [str2 componentsSeparatedByString:@" "];
//        
//        NSDictionary *dic = @{NSFontAttributeName :[UIFont systemFontOfSize:12]};
//    
//        CGFloat l = 0;//弧长
//        roundR = roundR;
//    
//    sw = sw;
//    int index = 0;
//    
//    CGFloat chaNumber = bigDotNumber;
//    CGFloat chaInterval = (2*roundR*M_PI-bigDotNumber)/bigDotNumber;
////    bigInterval;
//    
//    CGFloat angle    = 0;
//    CGFloat offsetX  = 0;
//    CGFloat offsetY  = 0;
//    CGSize  fontSize = CGSizeZero;
//    CGPoint point    = CGPointZero;
//    CGPoint startPoint = CGPointMake(0, bigDotR/2.0);
//    for (NSString *character in array) {
//        fontSize = [character sizeWithAttributes:dic];
//        NSLog(@"%f",fontSize.width);
//        point = CGPointMake(-fontSize.width/2.0, 0);
//        
//        l = (index) * (chaInterval+1);
//        index++;
//        
//        angle = l/roundR;
//        offsetX = (sin(angle) + 1)*roundR;
//        offsetY = (1 - cos(angle))*roundR;
//        
//        CGContextSaveGState(context);
////        
//        CGContextTranslateCTM(context, offsetX, offsetY);
//        CGContextRotateCTM(context, angle);
//        [character drawAtPoint:point withAttributes:dic];
//        
//        CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
//        CGContextAddRect(context, CGRectMake(point.x, point.y, fontSize.width, fontSize.height));
//        
//        CGContextStrokePath(context);
//        CGContextRestoreGState(context);
//        
//    }
//    
//
//    
//}

- (void)line:(CGContextRef )context x:(CGFloat)x y:(CGFloat)y{
    
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, x, y);
    CGContextStrokePath(context);
}
@end



@interface TriangleView :UIView

@end

@implementation TriangleView

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor purpleColor].CGColor);
    CGContextMoveToPoint(context, rect.size.width/2.0, 0);
    CGContextAddLineToPoint(context, rect.size.width/2.0-5, rect.size.height/2.0);
    CGContextAddLineToPoint(context, rect.size.width/2.0+5, rect.size.height/2.0);
    CGContextClosePath(context);
    CGContextFillPath(context);
}

@end


@interface myview(){
    CGFloat _lastValue;
    RotaryView *_rotaryView;
    TriangleView *_triangleView;
}

@end

@implementation myview

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
    
        [self panView];
        
    }
    return self;
    
}

- (void)panView {
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panClick:)];
    [self addGestureRecognizer:pan];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [self addGestureRecognizer:tap];
    
    _rotaryView = [[RotaryView alloc] initWithFrame:CGRectMake(50, 50, 300, 300)];
//    _rotaryView.backgroundColor = [UIColor redColor];
    [self addSubview:_rotaryView];
    
    _triangleView = [[TriangleView alloc] initWithFrame:_rotaryView.frame];
//    _triangleView.backgroundColor = [UIColor clearColor];
//    [self addSubview:_triangleView];
    
}
- (void)panClick:(UIPanGestureRecognizer *)pan {
    CGPoint point = [pan translationInView:self];
//    NSLog(@"%f  %f",point.x,point.y);
  
    CGFloat value = point.x;
//    [self getValuePoint:point];
    
   static CGFloat offset = 0;
    offset = value/self.frame.size.width*2.0+ _lastValue;

    if (pan.state == UIGestureRecognizerStateBegan ||
        pan.state == UIGestureRecognizerStateChanged) {
        
        _rotaryView.transform = CGAffineTransformMakeRotation(offset);
        
        NSLog(@"UIGestureRecognizerStateChanged   offset === %f  value = %f", offset,value);
    }else if (pan.state == UIGestureRecognizerStateEnded||
              pan.state == UIGestureRecognizerStateCancelled) {
       _lastValue = offset;
            NSLog(@"UIGestureRecognizerStateCancelled _lastValue ==== %f", _lastValue);
    }
}

- (void)tapClick:(UITapGestureRecognizer *)tap {
    _rotaryView.transform = CGAffineTransformIdentity;
    _lastValue = 0;
}

- (double)getValuePoint:(CGPoint)point {
    CGFloat sq = sqrt((pow(point.x, 2)+pow(point.y, 2)));
    if (point.y < 0||point.x < 0) {
        return -sq;
    }
    return sq;
}


@end

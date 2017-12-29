//
//  MYTableView.m
//  apiData
//
//  Created by lemonmgy on     /  /  .
//  Copyright ©     年 lemonmgy. All rights reserved.
//

#import "TouchTableView.h"
#import "MYButton.h"
@implementation TouchTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style]) {
         self.delaysContentTouches = NO;
        self.canCancelContentTouches = NO;
     }
    return  self;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
  
{
      
    [super touchesBegan:touches withEvent:event];
      
    NSLog(@"%s   type == %ld      subtype == %ld",__func__,(long)event.type,(long)event.subtype);

    
    if ([_touchDelegate conformsToProtocol:@protocol(TouchTableViewDelegate)] &&
          
        [_touchDelegate respondsToSelector:@selector(tableView:touchesBegan:withEvent:)])
          
    {
          
        [_touchDelegate tableView:self touchesBegan:touches withEvent:event];
          
    }
      
}
  

  
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
  
{
      
    [super touchesCancelled:touches withEvent:event];
      
    NSLog(@"%s",__func__);
    
    if ([_touchDelegate conformsToProtocol:@protocol(TouchTableViewDelegate)] &&
          
        [_touchDelegate respondsToSelector:@selector(tableView:touchesCancelled:withEvent:)])
          
    {
          
        [_touchDelegate tableView:self touchesCancelled:touches withEvent:event];
          
    }
      
}
  

  
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
  
{
      
    [super touchesEnded:touches withEvent:event];
      
    NSLog(@"%s",__func__);
      
    if ([_touchDelegate conformsToProtocol:@protocol(TouchTableViewDelegate)] &&
          
        [_touchDelegate respondsToSelector:@selector(tableView:touchesEnded:withEvent:)])
          
    {
          
        [_touchDelegate tableView:self touchesEnded:touches withEvent:event];
          
    }
      
}
  

  
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
  
{
      
    [super touchesMoved:touches withEvent:event];
      
    
      NSLog(@"%s",__func__);
    if ([_touchDelegate conformsToProtocol:@protocol(TouchTableViewDelegate)] &&
          
        [_touchDelegate respondsToSelector:@selector(tableView:touchesMoved:withEvent:)])
          
    {
          
        [_touchDelegate tableView:self touchesMoved:touches withEvent:event];
          
    }
      
}

- (BOOL)touchesShouldBegin:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event inContentView:(UIView *)view {
    [super touchesShouldBegin:touches withEvent:event inContentView:view];
    
    NSLog(@"%@  %@",view,self);
    
    if ([view isKindOfClass:[MYButton class]]) {
//        MYButton *btn = (MYButton *)view;
 
    }
//    view.superview
    
    return  YES;
} 
@end

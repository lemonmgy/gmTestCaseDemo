//
//  GMLog.m
//  gmTestDemo
//
//  Created by lemonmgy on 2018/4/26.
//  Copyright © 2018年 lemonmgy. All rights reserved.
//

#import "GMLog.h"
#import <UIKit/UIKit.h>

@implementation GMLog

#define log_number(value,name) NSLog(@"%@ == {%@}",name,@(value));

void log_objc(id obj, id name) {
    NSLog(@"%@ == {%@}",name,obj);
}

void log_objcx(id obj) {
    log_objc(obj, @"obj");
}

void log_insets(UIEdgeInsets insets, id name) {
    NSLog(@"%@ == {top:%f left:%f bottom:%f right:%f}",name,insets.top,insets.left,insets.bottom,insets.right);
}

void log_indexPath(NSIndexPath *indexPath, id name) {
     NSLog(@"%@ == {section:%ld row:%ld}",name,indexPath.section,indexPath.row);
}

void log_range(NSRange range, id name) {
    NSLog(@"%@ == {location:%lu length:%lu}",name,(unsigned long)range.location,(unsigned long)range.length);
}

void log_rect(CGRect rect, id name) {
    NSLog(@"\n%@ == { x=%f , y=%f , w=%f , h=%f}\n",name,rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);
}

void log_point(CGPoint point, id name) {
    NSLog(@"\n%@ == { x=%f , y=%f }\n",name,point.x,point.y);
}

void log_size(CGSize size, id name) {
    NSLog(@"\n%@ == { x=%f , y=%f }\n",name,size.width,size.height);
}

@end

//
//  GMLog.h
//  gmTestDemo
//
//  Created by lemonmgy on 2018/4/26.
//  Copyright © 2018年 lemonmgy. All rights reserved.
//

#import <Foundation/Foundation.h>

#if DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"[%s:%d行] %s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(FORMAT, ...) nil
#endif

#define log_number(value,name) NSLog(@"%@ == {%@}",name,@(value));

@interface GMLog : NSObject
void log_objc(id obj, id name);
void log_objcx(id obj);
void log_insets(UIEdgeInsets insets, id name);
void log_indexPath(NSIndexPath *indexPath, id name);
void log_range(NSRange range, id name);
void log_rect(CGRect rect, id name);
void log_point(CGPoint point, id name);
void log_size(CGSize size, id name);
@end

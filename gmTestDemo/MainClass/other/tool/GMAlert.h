//
//  GMAlert.h
//  gmTestDemo
//
//  Created by lemonmgy on 2018/4/26.
//  Copyright © 2018年 lemonmgy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GMAlert : NSObject

void show_alert(NSString *msg);
void show_alert_forever(NSString *msg);
void hidden_alert(NSString *msg);

@end

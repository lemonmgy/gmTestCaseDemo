//
//  NSDictionary+Value.m
//  
//  Created by lemonmgy on 2016/11/3.
//  Copyright © 2016年 lemonmgy. All rights reserved.
//

#import "NSDictionary+Value.h"

@implementation NSDictionary (Value)


- (id)valueStringForKey:(NSString *)key
{
    id value = [self valueForKey:key];
    if ([value isKindOfClass:[NSString class]]) {
        return value;
    }
    else if ([value isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithFormat:@"%@",value];
    }
    else if  (nil == value) {
        return @"";
    }
    else if ([value isKindOfClass:[NSNull class]]) {
        return @"";
    }
    else if  ([value isEqualToString:@"null"]) {
        return @"";
    }
    return value;
}

@end

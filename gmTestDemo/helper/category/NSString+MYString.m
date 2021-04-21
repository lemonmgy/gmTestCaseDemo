

//
//  NSString+MYString.m
//  test
//
//  Created by lemonmgy on 2017/1/6.
//  Copyright © 2017年 lemonmgy. All rights reserved.
//

#import "NSString+MYString.h"

@implementation NSString (MYString)

- (NSString *)appending:(id)value {
    return [NSString stringWithFormat:@"%@%@",self,value];
}

@end

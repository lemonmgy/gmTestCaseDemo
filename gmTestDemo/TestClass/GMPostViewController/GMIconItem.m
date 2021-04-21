//
//  GMIconItem.m
//  gmTestDemo
//
//  Created by lemonmgy on 2017/1/24.
//  Copyright © 2017年 lemonmgy. All rights reserved.
//

#import "GMIconItem.h"

@implementation GMIconItem

+ (UIImage*)imageFromCacheForKey:(NSString *)key {
    if (![key containsString:@"http"]) {
        return [UIImage imageNamed:key];
    }
    
    UIImage *image = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:key];
    if (!image) {
        image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:key];;
    }
    
    return image;
}
@end

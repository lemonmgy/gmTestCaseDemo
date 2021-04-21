//
//  GMIconItem.h
//  gmTestDemo
//
//  Created by lemonmgy on 2017/1/24.
//  Copyright © 2017年 lemonmgy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
@interface GMIconItem : NSObject

@property (nonatomic, weak) UIView *thumbView;

//图片浏览器
@property (nonatomic, copy) NSString *bigIconUrl;
@property (nonatomic, copy) NSString *smallIconUrl;
+ (UIImage *)imageFromCacheForKey:(NSString *)key;


//localPhotoAlbum本地相册
@property (nonatomic, strong) UIImage *smallImage;
@property (nonatomic, strong) UIImage *bigImage;
@property (nonatomic, strong) PHAsset *asset;
@end

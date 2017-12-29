//
//  GMPhotosUtils.h
//  test
//
//  Created by lemonmgy on 2016/11/15.
//  Copyright © 2016年 lemonmgy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>

@protocol GMPhotosUtilsDelegate <NSObject>

- (void)imagesResults:(id)obj info:(NSDictionary *)info asset:(PHAsset *)asset;

@end

typedef void(^ImagesResultsBlock)(id obj, NSDictionary *info, PHAsset *asset);

@interface GMPhotosUtils : NSObject
@property (nonatomic, assign) BOOL stop;
@property (nonatomic, weak) id<GMPhotosUtilsDelegate> delegate;
+ (instancetype)defaultManager;
- (void)getAllThumbnailImagesWithSize:(CGSize)size completion:(ImagesResultsBlock)imagesResultsBlock;
- (void)getImageWithAsset:(PHAsset *)asset resultHandler:(ImagesResultsBlock)imagesResultsBlock;
//- (PHImageRequestID)getOneThumbnailImageWithSize:(CGSize)size andAsset:(PHAsset *)asset resultHandler:(ImagesResultsBlock)imagesResultsBlock;

@end

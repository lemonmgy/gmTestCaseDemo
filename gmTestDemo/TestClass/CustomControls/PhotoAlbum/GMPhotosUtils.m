//
//  GMPhotosUtils.m
//  test
//
//  Created by lemonmgy on 2016/11/15.
//  Copyright © 2016年 lemonmgy. All rights reserved.
//

#import "GMPhotosUtils.h"
#import "GMIconItem.h"

@interface GMPhotosUtils()
@property (nonatomic, strong) PHFetchResult *allAssetDatas;

@end

@implementation GMPhotosUtils

+ (instancetype)defaultManager{
    static dispatch_once_t onceToken;
    static GMPhotosUtils *utils = nil;
    dispatch_once(&onceToken, ^{
        utils = [[GMPhotosUtils alloc]init];
    });
    return utils;
}

- (BOOL)judgeIsHavePhotoAblumAuthority
{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted ||
        status == PHAuthorizationStatusDenied) {
        return NO;
    }
    return YES;
}

- (BOOL)judgeIsHaveCameraAuthority
{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusRestricted ||
        status == AVAuthorizationStatusDenied) {
        return NO;
    }
    return YES;
}

- (void)getAllThumbnailImagesWithSize:(CGSize)size completion:(ImagesResultsBlock)imagesResultsBlock {
    [GMPhotosUtils defaultManager].stop = NO;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        __block NSUInteger max = self.allAssetDatas.count;
        NSMutableArray *tempArr = [NSMutableArray new];
        [self.allAssetDatas enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger idx, BOOL * _Nonnull stop) {
            if (self.stop) *stop = YES;
            
            [self getOneThumbnailImageWithSize:size andAsset:asset resultHandler:^(UIImage *image, NSDictionary *info, PHAsset *asset) {
                
                GMIconItem *item = [GMIconItem new];
                item.smallImage = image;
                item.asset = asset;
                [tempArr addObject:item];
                if (max == (idx+1) || idx%20 == 0) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        imagesResultsBlock([tempArr mutableCopy],info,asset);
                        [tempArr removeAllObjects];
                    });
                    NSLog(@"%lu  currentThread == %@",(unsigned long)idx,[NSThread currentThread]);

                }
            }];
        }];
    });
}

- (PHFetchResult *)allAssetDatas {
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc]init];
    fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    PHFetchResult *fetchResult = [PHAsset fetchAssetsWithOptions:fetchOptions];
    return fetchResult;
    
    
//    PHFetchResult *assetCollectionResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
//        PHAssetCollection *assetCollection = assetCollectionResult.lastObject;
    
    //    PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:fetchOptions];
//    PHFetchResult *fetchResult = [PHAsset fetchAssetsWithOptions:fetchOptions];
}

- (void)getImageWithAsset:(PHAsset *)asset resultHandler:(ImagesResultsBlock)imagesResultsBlock {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self getOneThumbnailImageWithSize:PHImageManagerMaximumSize andAsset:asset resultHandler:^(UIImage *image, NSDictionary *info, PHAsset *asset) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"currentThread == %@",[NSThread currentThread]);

                imagesResultsBlock(image,info,asset);
            });
        }];
    });
}

- (PHImageRequestID)getOneThumbnailImageWithSize:(CGSize)size andAsset:(PHAsset *)asset resultHandler:(ImagesResultsBlock)imagesResultsBlock {
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc]init];
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    options.synchronous = YES;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
    // PHImageManagerMaximumSize
    return [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if (![[info objectForKey:PHImageCancelledKey] boolValue] &&
            ![info objectForKey:PHImageErrorKey] && //出现错误
            ![[info objectForKey:PHImageResultIsDegradedKey] boolValue] &&//不拿小图
            imagesResultsBlock) {
            imagesResultsBlock(result,info,asset);
        }
    }];
}

@end

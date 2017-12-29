////
////  GMProgressView.m
////  test
////
////  Created by lemonmgy on 2016/11/16.
////  Copyright © 2016年 lemonmgy. All rights reserved.
////
//
//#import "GMProgressView.h"
//#import <Photos/Photos.h>
//@implementation GMProgressView
//
//
////#import <AssetsLibrary/AssetsLibrary.h> //IOS 9 开始废弃
///************************************保存到自己创建的相册中的图片************************************/
////- (void)ss
////{
//////        //1.判断授权状态
////PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
////if (status == PHAuthorizationStatusRestricted) {// 因为家长控制, 导致应用无法方法相册(跟用户的选择没有关系)
////    [SVProgressHUD showErrorWithStatus:@"因为系统原因，无法访问相册"];
////}else if (status == PHAuthorizationStatusDenied){// 用户拒绝当前应用访问相册(用户当初点击了"不允许")
////    BSLog(@"提醒用户去[设置-隐私-照片-xxx]打开访问开关");
////    
////}else if (status == PHAuthorizationStatusNotDetermined){//用户还没有做出选择
////    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {//弹出授权的框
////        if (status == PHAuthorizationStatusAuthorized) {
////            //设置图片
////            [self setupImage];
////        }
////        
////    }];
////}else if (status == PHAuthorizationStatusAuthorized){//用户允许当前应用访问相册(用户当初点击了"好")
////    //设置图片
////    [self setupImage];
////}
////}
//
////保存照片
//-(void)setupImage{
//    //PHAsset:一个资源，比如一张图片或者一个视频
//    //PHAssetCollection:一个相簿。
//    //图片标识
//    __block NSString *assetLocalIdentifier = nil;
//    //修改相册的内容都得放进[PHPhotoLibrary sharedPhotoLibrary] performChanges方法
//    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
//        //1.保存图片到“相机胶卷”A
//        assetLocalIdentifier = [PHAssetCreationRequest creationRequestForAssetFromImage:nil].placeholderForCreatedAsset.localIdentifier;
//    } completionHandler:^(BOOL success, NSError * _Nullable error) {
//        if (error) {//保存失败
//            [self showErrorWithText:@"图片保存到相机胶卷失败"];
//            return;
//        }
//        //获取相册
//        PHAssetCollection *assetCollection = [self createdAssetCollection];
//        if(assetCollection != nil){//相册创建成功
//            [[PHPhotoLibrary sharedPhotoLibrary]performChanges:^{
//                //3.添加“相机胶卷”中的图片A到新建的相簿D中
//                //得到相册
//                // PHAssetCollection *collection =  [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[assetCollectionLocalIdentifier] options:nil].lastObject;
//                //得到图片
//                PHAsset *asset = [PHAsset fetchAssetsWithLocalIdentifiers:@[assetLocalIdentifier] options:nil].lastObject;
//                //添加图片到相册中的请求
//                PHAssetCollectionChangeRequest *request =  [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
//                //添加图片到相册中
//                [request addAssets:@[asset]];
//                
//            } completionHandler:^(BOOL success, NSError * _Nullable error) {
//                if (success == NO) {
//                    [self showErrorWithText:@"添加[图片]到[相簿]失败!"];
//                } else {
//                    [self showSuccessWithText:@"成功添加[图片]到[相簿]!"];
//                }
//                
//            }];
//            
//        }else{//相册创建出错
//            [self showErrorWithText:@"相册创建失败！"];
//        }
//    }];
//    
//}
///**
// *  获取相册
// */
//-(PHAssetCollection *)createdAssetCollection{
//    //获取所有相簿
//    PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
//    for (PHAssetCollection *assetCollection in assetCollections) {
//        if ([assetCollection.localizedTitle isEqualToString:BSAssetCollection]) {
//            return assetCollection;
//        }
//    }
//    //没有创建过进入这
//    NSError *error = nil;
//    //创建的时候获取标识 相册标识
//    __block NSString *assetCollectionLocalIdentifier = nil;
//    
//    [[PHPhotoLibrary sharedPhotoLibrary]performChangesAndWait:^{
//        //2.创建“相簿”D
//        assetCollectionLocalIdentifier =  [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:BSAssetCollection].placeholderForCreatedAssetCollection.localIdentifier;
//    } error:&error];
//    
//    if (error) return nil;
//    
//    return [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[assetCollectionLocalIdentifier] options:nil].lastObject;
//}
//
//
///**返回主界面刷新*/
////成功
//-(void)showSuccessWithText:(NSString *)text{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [SVProgressHUD showSuccessWithStatus:text];
//    });
//}
////失败
//-(void)showErrorWithText:(NSString *)text{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [SVProgressHUD showErrorWithStatus:text];
//    });
//}
//
//
//
///************************************获取相册中的照片************************************/
///**
// *  获得所有相簿的原图
// */
//- (void)getOriginalImages
//{
//    // 获得所有的自定义相簿
//    PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
//    // 遍历所有的自定义相簿
//    for (PHAssetCollection *assetCollection in assetCollections) {
//        [self emunerImageWithAssetCollection:assetCollection original:YES];
//    }
//    
//    // 获得相机胶卷
//    PHAssetCollection *cameraRoll = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil].lastObject;
//    [self emunerImageWithAssetCollection:cameraRoll original:YES];
//    
//}
///**
// *  获得所有相簿中的缩略图
// */
//-(void)getThumbnailImages{
//    //获得所有自定义相册
//    PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
//    //遍历所有的自定义相册
//    for (PHAssetCollection *assetCollection in assetCollections) {
//        NSLog(@"%@",assetCollection.localizedTitle);
//        [self emunerImageWithAssetCollection:assetCollection original:NO];
//    }
//    //获得相机胶卷
//    PHAssetCollection *rollCollection = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil].lastObject;
//    [self emunerImageWithAssetCollection:rollCollection original:NO];
//}
///**
// *  遍历相簿中的所有图片
// *
// *  @param assetCollection 相簿
// *  @param original        是否要原图
// */
//-(void)emunerImageWithAssetCollection:(PHAssetCollection *)assetCollection original:(BOOL)original
//{
//    
//    PHImageRequestOptions *options = [[PHImageRequestOptions alloc]init];
//    // 同步获得图片, 只会返回1张图片
//    options.synchronous = YES;
//    // 获得某个相簿中的所有PHAsset对象
//    PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:0];
//    
//    for (PHAsset *asset in assets) {
//        //是否要原图
//        CGSize size = original ? CGSizeMake(asset.pixelWidth, asset.pixelHeight) : CGSizeZero;
//        //照片管理
//        PHImageManager *imageManager = [PHImageManager defaultManager];
//        //根据相簿属相获取相簿中的所有图片
//        [imageManager requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
//            NSLog(@"-----%@",result);
//        }];
//    }
//    
//}
//
//
//@end

//
//  MYMediaTools.m
//  gmTestDemo
//
//  Created by lemonmgy on 2017/3/3.
//  Copyright © 2017年 lemonmgy. All rights reserved.
//

#import "MYMediaTools.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>

@implementation MYMediaTools

+ (BOOL)judgeIsHavePhotoAblumAuthority {//是否有相册权限
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted ||
        status == PHAuthorizationStatusDenied) {
        return NO;
    }
    return YES;
}

+ (BOOL)judgeIsHaveCameraAuthority {//是否有相机权限
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusRestricted ||
        status == AVAuthorizationStatusDenied) {
        return NO;
    }
    return YES;
}

+ (void)openTheApplicationSettings {
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}






- (void)wakeUpTheCamera:(BOOL)camera  {
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    if (camera) {
        sourceType = UIImagePickerControllerSourceTypeCamera;
        if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) { //没有相机设备
            show_alert(@"没有相机");
            return;
        }
        
        if ([MYMediaTools judgeIsHaveCameraAuthority]) {//拥有相机权限
            show_alert(@"没有开启相机权限");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MYMediaTools openTheApplicationSettings];
            });
            return;
        }
    }else {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary]) {//相册可用
            show_alert(@"没有开启相机权限");
            return;
        }
        if (![MYMediaTools judgeIsHavePhotoAblumAuthority]) {//有相册权限
            show_alert(@"没有开启相册权限");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MYMediaTools openTheApplicationSettings];
            });
            return;
        }
    }
    
    //    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
    //    pickerImage.sourceType = sourceType;
    //    pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
    //    [self presentViewController:pickerImage animated:YES completion:nil];
}


@end

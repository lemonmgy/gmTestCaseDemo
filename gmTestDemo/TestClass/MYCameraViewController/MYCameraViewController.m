//
//  MYCameraViewController.m
//  cameraDemo
//
//  Created by lemonmgy on 2017/3/3.
//  Copyright © 2017年 lemonmgy. All rights reserved.
//

#import "MYCameraViewController.h"
#import "MYMediaTools.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>

@interface MYCameraViewController ()
@property (weak, nonatomic) IBOutlet UIButton *takingBtn;
@property (weak, nonatomic) IBOutlet UIView *controlsBackView;
@property (weak, nonatomic) IBOutlet UIView *cameraBackView;

@property (nonatomic, copy) NSString *appName;
/**
 *  AVCaptureSession对象来执行输入设备和输出设备之间的数据传递
 */
//@property (nonatomic, strong) AVCaptureSession *session;
/**
 *  输入设备
 */
@property (nonatomic, strong) AVCaptureDeviceInput *videoInput;
/**
 *  照片输出流 AVCapturePhotoOutput
 */
@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;
/**
 *  预览图层
 */
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@end

@implementation MYCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) { //没有相机设备
        show_alert(@"没有相机");
        self.view = [UIView new];
        return;
    }
    [self initCamera];

}
    

- (void)initCamera {
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:device error:nil];
    
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary * outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
    [self.stillImageOutput setOutputSettings:outputSettings];
    
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:[AVCaptureSession new]];
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    self.previewLayer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64);
    [self.cameraBackView.layer addSublayer:self.previewLayer];

    
    if ([self.previewLayer.session canAddInput:self.videoInput]) {
        [self.previewLayer.session addInput:self.videoInput];
    }
    if ([self.previewLayer.session canAddOutput:self.stillImageOutput]) {
        [self.previewLayer.session addOutput:self.stillImageOutput];
    }
    
    [self.previewLayer.session startRunning];
}

-(AVCaptureVideoOrientation)avOrientationForDeviceOrientation:(UIDeviceOrientation)deviceOrientation
{
    AVCaptureVideoOrientation result = (AVCaptureVideoOrientation)deviceOrientation;
    if ( deviceOrientation == UIDeviceOrientationLandscapeLeft )
        result = AVCaptureVideoOrientationLandscapeRight;
    else if ( deviceOrientation == UIDeviceOrientationLandscapeRight )
        result = AVCaptureVideoOrientationLandscapeLeft;
    return result;
}
- (IBAction)switchClick:(UIButton *)sender {
    
    for (AVCaptureDevice *device in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
        if (device.position != self.videoInput.device.position) {
            [self.previewLayer.session beginConfiguration];
            UIView *view= [UIView new];
            view.frame = self.cameraBackView.frame;
            view.backgroundColor = [UIColor redColor];
            [self.view addSubview:view];
            [self.view sendSubviewToBack:view];
[UIView transitionFromView:self.cameraBackView toView:view duration:2.0 options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished) {
    
    
    for (AVCaptureInput *oldInput in self.previewLayer.session.inputs) {
        [self.previewLayer.session removeInput:oldInput];
    }
    self.videoInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    [self.previewLayer.session addInput:self.videoInput];
    [self.previewLayer.session commitConfiguration];
    
}];
    break;
        }
    }
    
    
}

- (IBAction)flashBtnClick:(UIButton *)sender {
    
    AVCaptureDevice *device = self.videoInput.device;
    
    [device lockForConfiguration:nil];
    if ([device hasFlash]) {
        
        if (device.flashMode == AVCaptureFlashModeOff) {
            device.flashMode = AVCaptureFlashModeOn;
            [sender setTitle:@"on" forState:UIControlStateNormal];
        }else if (device.flashMode == AVCaptureFlashModeOn) {
            device.flashMode = AVCaptureFlashModeAuto;
            [sender setTitle:@"auto" forState:UIControlStateNormal];
        }else if (device.flashMode == AVCaptureFlashModeAuto) {
            device.flashMode = AVCaptureFlashModeOff;
            [sender setTitle:@"off" forState:UIControlStateNormal];
        }
        
    }else {
        show_alert(@"没有闪关灯");
    }
    [device unlockForConfiguration];
}

- (IBAction)takingBtnClick:(UIButton *)sender {
    NSLog(@"%ld",(long)[[UIDevice currentDevice] orientation]);
    
    AVCaptureConnection *connection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
 
    AVCaptureVideoOrientation avcaptureOrientation = [self avOrientationForDeviceOrientation:[[UIDevice currentDevice] orientation]];
    [connection setVideoOrientation:avcaptureOrientation];
    [connection setVideoScaleAndCropFactor:1];
    
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:connection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        NSData *jpegData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        if (![MYMediaTools judgeIsHavePhotoAblumAuthority]){
            //无权限
            show_alert(@"无权限");
            return ;
        }
        [self saveImage:[UIImage imageWithData:jpegData]];
    }];
}

- (void)saveImage:(UIImage *)image {
    if (!image) return;

    
    __block NSString *assetIdentifier = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        //1,保存图片到系统相册
        assetIdentifier = [PHAssetChangeRequest creationRequestForAssetFromImage:image].placeholderForCreatedAsset.localIdentifier;
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (!success) return;
        NSLog(@"%@",[NSThread currentThread]);
        dispatch_async(dispatch_get_main_queue(), ^{
            show_alert(@"存储成功");
        });
        
        //2,获取相簿
        PHAssetCollection *assetCollection = [self getCustomPhotoAlbum];
        if (!assetCollection) return;
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            //3,添加照片
            //获取图片
            PHAsset *asset = [PHAsset fetchAssetsWithLocalIdentifiers:@[assetIdentifier] options:nil].firstObject;
            //添加图片的请求
            PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
            //添加图片
            [request addAssets:@[asset]];
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            if (!success) return;
        }];
    }];
}


- (PHAssetCollection *)getCustomPhotoAlbum {
    PHFetchResult *result = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];

    for (PHAssetCollection *collection in result) {
        if ([collection.localizedTitle isEqualToString:self.appName]) {
            return collection;
        }
    }
    
    __block NSString *identifier = @"";
    [[PHPhotoLibrary sharedPhotoLibrary]  performChangesAndWait:^{
        identifier = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:self.appName].placeholderForCreatedAssetCollection.localIdentifier;
    } error:nil];
    
    return [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[identifier] options:nil].lastObject;
}


-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [self.previewLayer.session stopRunning];
}

- (NSString *)appName {
    if (!_appName) {
        _appName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
    }
    return _appName;
}
@end

//
//  MYCIFilterViewController.m
//  test
//
//  Created by lemonmgy on 2017/1/20.
//  Copyright © 2017年 lemonmgy. All rights reserved.
//

#import "MYCIFilterViewController.h"

@interface MYCIFilterViewController ()

@end

@implementation MYCIFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.topItemNameArr = @[@"虚化"];
    [self topButtonClick:nil];
}

- (void)topButtonClick:(UIBarButtonItem *)sender  {
    
    UIImageView *ima = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 100, 100)];
    ima.backgroundColor = [UIColor redColor];
    ima.image = [UIImage imageNamed:@"icon4"];
    [self.view addSubview:ima];
    
    
    UIImageView *ima2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 200, 100, 100)];
    ima2.backgroundColor = [UIColor greenColor];
    show_alert_forever(@"处理图片");
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage *ims = [self getImage:[ima.image copy]];
       dispatch_sync(dispatch_get_main_queue(), ^{
           hidden_alert(@"处理完成");
           ima2.image = ims;
           
       });
    });
    
    [self.view addSubview:ima2];
}

- (UIImage *)getImage:(UIImage *)image {
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CIImage *inputImage = [[CIImage alloc] initWithImage:image];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    
    [filter setValue:inputImage forKey:kCIInputImageKey];
    
    [filter setValue:[NSNumber numberWithFloat:10.0] forKey:@"inputRadius"];
    
    //        CIImage *result = [filter valueForKey:kCIOutputImageKey];
    
    CIImage *result = [filter outputImage];
    
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    
    UIImage *resultImage = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    return resultImage;
    
}
 
@end

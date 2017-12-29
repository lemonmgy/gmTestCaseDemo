//
//  MYDownLoadViewController.m
//  gmTestDemo
//
//  Created by lemonmgy on 2017/7/11.
//  Copyright © 2017年 lemonmgy. All rights reserved.
//

#import "MYDownLoadViewController.h"

@interface MYDownLoadViewController ()<NSURLSessionDelegate>
@property (nonatomic, strong) NSURLSessionDownloadTask *downLoadTask;
@end

@implementation MYDownLoadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithTitle:@"跳转" style:UIBarButtonItemStylePlain target:self action:@selector(goClick)],[[UIBarButtonItem alloc] initWithTitle:@"暂停" style:UIBarButtonItemStylePlain target:self action:@selector(resumeClick)]];


}

- (void)goClick {
    NSString *url = @"https://vd1.bdstatic.com/mda-hgjiyvkg4kgkvpmy/mda-hgjiyvkg4kgkvpmy.mp4?playlist=%5B%22hd%22%2C%22sc%22%5D&amp;auth_key=1499841599-0-0-0c73abd0f257e327e6411e4a0cbf6420&amp;bcevod_channel=nwise_search";
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDownloadTask *downLoadTask = [session downloadTaskWithURL:[NSURL URLWithString:url]];
    self.downLoadTask = downLoadTask;
    [downLoadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        
        NSError *error = nil;
        [resumeData writeToFile:[self getpath:downLoadTask.response.suggestedFilename] options:NSDataWritingAtomic error:&error];
        if (error) {
            NSLog(@"errorerrorerror == %@",error);
        }
        NSLog(@"countOfBytesReceived ==%lld    countOfBytesExpectedToReceive ==%lld",downLoadTask.countOfBytesReceived,downLoadTask.countOfBytesExpectedToReceive);
    }];
    
    [downLoadTask resume];
    
}

- (void)resumeClick {
    [self.downLoadTask suspend];

}

- (NSString *)getpath:(NSString *)name {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* filename=[path stringByAppendingPathComponent:name];
    return filename;
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  MYtestDocumentsViewController.m
//  test
//
//  Created by lemonmgy on 2017/1/4.
//  Copyright © 2017年 lemonmgy. All rights reserved.
//

#import "MYtestDocumentsViewController.h"

@interface MYtestDocumentsViewController ()
@property (nonatomic,assign) BOOL gett;
@property (nonatomic, assign) NSString *tags;
@end

@implementation MYtestDocumentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"开启";
    self.tableViewDataArr = (NSMutableArray *)@[@"Documents",@"Caches",@"Downloads",@"NSTemporaryDirectory",@"NSUserDefaults",@"123123.zip"];
    self.topItemNameArr = (NSMutableArray *)@[@"get",@"set",@"2",@"!2"];
    
}

- (void)topButtonClick:(UIBarButtonItem *)sender {
    [self alert:nil content:sender.title];
    if ([sender.title isEqualToString:@"set"]) {
        self.gett = NO;
    }else if ([sender.title isEqualToString:@"get"]){
        self.gett = YES;
    }else if ([sender.title isEqualToString:@"2"]){
        self.tags = @"2";
    }else {
        self.tags = nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *name = self.tableViewDataArr[indexPath.row];
    
    if ([name isEqualToString:@"Documents"]) {//Documents
        NSArray *arrPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        NSString *documentPath = [arrPaths objectAtIndex:0];
        
        NSLog(@"%@",arrPaths);
        NSLog(@"Documents path: %@",documentPath);
        if (self.gett) {
            [self isExecutableFileAtPath:documentPath];
        }else {
            [self savePaht:documentPath];
        }
        //        NSFileHandle *writeHandel = [NSFileHandle fileHandleForWritingAtPath:filePath];
        
    }else if ([name isEqualToString:@"Caches"]) {//Caches
        NSArray *cachesArray = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *cachesPath = [cachesArray objectAtIndex:0];
        
        NSLog(@"%@",cachesArray);
        NSLog(@"cachesPath path: %@",cachesPath);
        if (self.gett) {
            [self isExecutableFileAtPath:cachesPath];
        }else {
            [self savePaht:cachesPath];
        }
        
    }else if ([name isEqualToString:@"Downloads"]) {
        //        Downloads
        NSArray *downloadsArray = NSSearchPathForDirectoriesInDomains(NSDownloadsDirectory, NSUserDomainMask, YES);
        NSString *downloadsPath = [downloadsArray objectAtIndex:0];
        
        NSLog(@"downloadsPath path: %@",downloadsPath);
        if (self.gett) {
            [self isExecutableFileAtPath:downloadsPath];
        }else {
            [self savePaht:downloadsPath];
        }
    }else if ([name isEqualToString:@"NSTemporaryDirectory"]) {
        
        NSLog(@"downloadsPath path: %@",NSTemporaryDirectory());
        if (self.gett) {
            [self isExecutableFileAtPath:NSTemporaryDirectory()];
        }else {
            [self savePaht:NSTemporaryDirectory()];
        }
    }else if ([name isEqualToString:@"NSUserDefaults"]) {
        if (self.gett) {
            NSMutableString *str = [NSMutableString string];
            NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"dict"];

            for (int i = 0; i < 50; i++) {
//               = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"data=%d",i]];
                NSData *data = [dict valueForKey:[NSString stringWithFormat:@"data=%d",i]];
                [str appendString:[NSString stringWithFormat:@"(data%d=%lu)",i,(unsigned long)data.length]];
            }
            
            [self alert:nil content:[NSString stringWithFormat:@"%@",str]];
        }else {
            
            NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Swift3.0" ofType:@"pdf"];
            NSData *data = [NSData dataWithContentsOfFile:plistPath];
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            for (int i = 0; i < 50; i++) {
                [dict setValue:data forKey:[NSString stringWithFormat:@"data=%d",i]];
            }
            [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"dict"];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else if ([name isEqualToString:@"123123.zip"]) {
        NSArray *arr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString*path = [arr objectAtIndex:0];
        
        BOOL ret = [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/%@",path,@"123123.zip"]];
        
        [self alert:@"" content:[NSString stringWithFormat:@"%d",ret]];
        
    }else if ([name isEqualToString:@"Documents"]) {
        
    }else if ([name isEqualToString:@"Documents"]) {
        
    }else if ([name isEqualToString:@"Documents"]) {
        
    }else if ([name isEqualToString:@"Documents"]) {
        
    }else if ([name isEqualToString:@"Documents"]) {
        
    }else if ([name isEqualToString:@"Documents"]) {
        
    }else if ([name isEqualToString:@"Documents"]) {
        
    }else if ([name isEqualToString:@"Documents"]) {
        
    }else if ([name isEqualToString:@"Documents"]) {
        
    }else if ([name isEqualToString:@"Documents"]) {
        
    }
    
    
}

- (void)savePaht:(NSString *)path {
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Swift3.0" ofType:@"pdf"];
    
    NSData *data = [NSData dataWithContentsOfFile:plistPath];
    //    NSData *data = UIImagePNGRepresentation(image);
    
//    indicator
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    [self.view addSubview:indicator];
    [indicator startAnimating];
    NSFileManager *manger = [NSFileManager defaultManager];
    dispatch_group_t group = dispatch_group_create();
    if (self.tags.length) {
        for (int i = 0; i < 1; i++) {
            dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
                NSLog(@"%@",[NSThread currentThread]);
                NSString *repath = [NSString stringWithFormat:@"%@/%@-Swift3.0.%d.pdf",path,self.tags,i];
                [manger createFileAtPath:repath contents:data attributes:nil];
            });
        }
        dispatch_group_notify(group, dispatch_get_global_queue(0, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [indicator startAnimating];
                [indicator removeFromSuperview];
                [self alert:nil content:@"完成"];
            });
            
        });
        
    }else {

    for (int i = 0; i < 1; i++) {
        dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
            NSLog(@"%@",[NSThread currentThread]);
            NSString *repath = [NSString stringWithFormat:@"%@/Swift3.0.%d.pdf",path,i];
            [manger createFileAtPath:repath contents:data attributes:nil];
        });
    }
    dispatch_group_notify(group, dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [indicator startAnimating];
            [indicator removeFromSuperview];
        [self alert:nil content:@"完成"];
        });
        
    });
        
    }
}

- (void)isExecutableFileAtPath:(NSString *)path {
    
    NSFileManager *manger = [NSFileManager defaultManager];
    NSMutableString *str = [NSMutableString string];
    if (self.tags.length) {
        for (int i = 0; i < 1; i++) {
            NSString *repath = [NSString stringWithFormat:@"%@/%@-Swift3.0.%d.pdf",path,self.tags,i];
            BOOL ret = [manger fileExistsAtPath:repath];
            [str appendString:[NSString stringWithFormat:@"(name%d=%d)",i,ret]];
        }

    }else {
    for (int i = 0; i < 1; i++) {
        NSString *repath = [NSString stringWithFormat:@"%@/Swift3.0.%d.pdf",path,i];
        BOOL ret = [manger fileExistsAtPath:repath];
        [str appendString:[NSString stringWithFormat:@"(name%d=%d)",i,ret]];
    }
    }
    [self alert:nil content:str];
}

- (void)alert:(NSString *)title content:(NSString *)content {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:content delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
    [alert show];
}

@end

//
//  MYShufflingViewController.m
//  test
//
//  Created by lemonmgy on 2016/11/14.
//  Copyright © 2016年 lemonmgy. All rights reserved.
//

#import "MYShufflingViewController.h"
#import "GMShufflingView.h"

@interface MYShufflingViewController ()
{
    GMShufflingView *_shufflingView;
}
@property (nonatomic, strong) UIImageView *callBackImageView;
@end

@implementation MYShufflingViewController

- (void)dealloc {
    NSLog(@"dealloc----->>>%@<<<-----dealloc",[self class]);
    _shufflingView.pauseTimer = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor  =[UIColor whiteColor];

    self.topItemNameArr = [NSMutableArray arrayWithArray:@[@"1",@"2",@"3",@"url"]];
    _shufflingView = [[GMShufflingView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 300)];
    _shufflingView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:_shufflingView];
    
    __weak __typeof (self) weakSelf = self;
    [_shufflingView setShufflingCallBack:^(id obj){
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        NSString *url = [((GMShufflingModel *)obj) imageUrl];
        if ([url containsString:@"http"]) {
            [strongSelf.callBackImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@""]];
        }else {
            strongSelf.callBackImageView.image = [UIImage imageNamed:url];
        }
        [strongSelf.navigationController pushViewController:[[strongSelf class] new] animated:YES];
        kShowAlert(@"点击了广告位");
    }];
    [self.view addSubview:self.callBackImageView];

}

- (void)topButtonClick:(UIBarButtonItem *)sender
{
    NSArray *array = @[@"Shuffling0",@"Shuffling1",@"Shuffling2.jpg"];
    if (sender.tag == 0) {
        array = @[@"Shuffling0"];
    }else if (sender.tag == 1){
        array = @[@"Shuffling0",@"Shuffling1"];
    }
    else if (sender.tag == 3) {
        array = @[@"http://pic.txship.com/advertisingImg/s_20161019143404149.jpg",@"http://pic.txship.com/advertisingImg/s_20161013164543452.jpg",@"http://pic.txship.com/zoneactivity/s_20160713104729423.jpg"];
    }
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:10];
    for (NSString *url  in array) {
        GMShufflingModel * model = [[GMShufflingModel alloc]init];
        model.imageUrl = url;
        [arr addObject:model];
    }
    _shufflingView.dataSourceArray = arr;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImageView *)callBackImageView {
    if (!_callBackImageView) {
    _callBackImageView =[[UIImageView alloc]initWithFrame:CGRectMake( 0 , kSCREEN_HEIGHT - 64 -150, kSCREEN_WIDTH, 150)];
    _callBackImageView.backgroundColor = [UIColor redColor];
    }
    return _callBackImageView;
}

@end

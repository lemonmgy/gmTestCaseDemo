//
//  MainViewController.m
//  test
//
//  Created by lemonmgy on 16/10/27.
//  Copyright © 2016年 lemonmgy. All rights reserved.
//

#import "GMCaseListViewController.h"
#import "BaseViewController.h"
#import "CGAffineTransformViewController.h"

@interface GMCaseListViewController ()<UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation GMCaseListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically
    self.view.backgroundColor = [UIColor redColor];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 70;
    [self.view addSubview:self.tableView];
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"测试" style:UIBarButtonItemStyleDone target:self action:@selector(dismiss)];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"123123"];
    NSString *info = self.dataArr[indexPath.row];
    if ([info containsString:@"-"]) {
        NSArray *infos = [info componentsSeparatedByString:@"-"];
        cell.textLabel.text = [infos firstObject];
        cell.detailTextLabel.text = [infos lastObject];
    }else {
        cell.textLabel.text = info;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.dataArr.count<indexPath.row) return;
    id className = self.dataArr[indexPath.row];
    if ([className containsString:@"-"]) {className = [[(NSString *)className componentsSeparatedByString:@"-"] firstObject];}
    className = NSClassFromString(className);

    if (className) {
        UIViewController *classObj = (UIViewController *)[[className alloc]init];
        classObj.navigationItem.title = NSStringFromClass([classObj class]);
        [self.navigationController pushViewController:classObj animated:YES];
    }else {
        NSString *alr = [NSString stringWithFormat:@"{%@}不存在",self.dataArr[indexPath.row]];
        show_alert(alr);
    }
}

- (NSArray*)dataArr {
    if (!_dataArr) {
        _dataArr = @[@"MYBezierPathViewController-赛贝尔曲线",
                     @"MYAnimatedStartViewController-过渡动画",
                     @"TransitionsAnimationBeganViewController-过渡动画",
                     @"MYCalendarViewController-日历",
                     @"GMPhotosViewController-相册",
                     @"GMPostViewController-图片浏览",
                     @"MYShufflingViewController-轮播图",
                     @"MYCameraViewController-相机",
                     @"MYUnlockViewController-手势解锁",
                     @"GMHitViewViewController-hit点击事件测试"];
    }
    return _dataArr;
}


@end



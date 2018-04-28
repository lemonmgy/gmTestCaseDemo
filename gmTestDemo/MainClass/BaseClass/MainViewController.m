//
//  MainViewController.m
//  test
//
//  Created by lemonmgy on 16/10/27.
//  Copyright © 2016年 lemonmgy. All rights reserved.
//

#import "MainViewController.h"

#import "BaseViewController.h"
#import "CGAffineTransformViewController.h"
#import "MYUISearchBar.h"
#import "SearchController.h"

@interface MainViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong)UITableView *tableView;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically
    self.view.backgroundColor = [UIColor redColor];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 70;
    [self.view addSubview:self.tableView];
    
    self.navigationItem.leftBarButtonItem =
    [[UIBarButtonItem alloc]
     initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(dismiss)];
    [self.tableView reloadData];
}

- (void)dismiss {
    [self.tabBarController dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"123123"];
    id obj = _dataArr[indexPath.row];
    if ([obj isKindOfClass:[NSString class]]) {
        cell.textLabel.text = obj;
    }else {
        cell.textLabel.text = [obj firstObject];
        cell.detailTextLabel.text = [obj lastObject];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_dataArr.count<indexPath.row) return;
    
    id className = _dataArr[indexPath.row];
    if ([className isKindOfClass:[NSArray class]]) {className = [className firstObject];}
    className = NSClassFromString(className);

    if (className) {
        UIViewController *classObj = (UIViewController *)[[className alloc]init];
        classObj.navigationItem.title = NSStringFromClass([classObj class]);
        [self.navigationController pushViewController:classObj animated:YES];
    }else {
        NSString *alr = [NSString stringWithFormat:@"{%@}不存在",_dataArr[indexPath.row]];
        show_alert(alr);
    }
}

- (void)changeHeaderView:(CGFloat)y andView:(UIView *)view{
    if (y > 0) return;
    static CGFloat height = 0;
    if (!height) height = view.frame.size.height;
    y = fabs(y);
    CGFloat offset = 1 + y/height*1.0;
    view.transform = CGAffineTransformMake(offset, 0, 0, (1+ 1.0*y/height), -(offset-1)/2.0, -y/2.0);
}

- (void)dataWithIndex:(int)index {
    
    NSArray *arr = @[];
    NSString *nam = @"";
    switch (index) {
        case 1:
        {
            arr = kOneArray;
            nam = @"SystemControls";
        }
            break;
        case 2:
        {
            arr = kTwoArray;
            nam = @"CustomControls";
        }
            break;
        case 3:
        { //   navanimation
            arr = kThreeArray;
            nam = @"UIEffect";
        }
            break;
        case 4:
        { //   navanimationb
            arr = kFourArray;
            nam = @"navanimation";
        }
            break;
    }
    _dataArr = arr;
    self.navigationController.title = nam;
    self.tabBarItem.title = nam;
}

+ (void)gotoTabBarController {
    UITabBarController *barC = [[UITabBarController alloc]init];
    for (int index = 1; index <= 4; index++) {
        MainViewController *mainVc = [[MainViewController alloc]init];
        [barC addChildViewController:[[MYNavigationController alloc] initWithRootViewController:mainVc]];
        [mainVc dataWithIndex:index];
    }
    [barC setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:barC animated:YES completion:nil];
}

@end

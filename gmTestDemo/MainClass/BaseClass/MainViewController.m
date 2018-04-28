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

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, weak) UITextField *textFiled;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically
    self.view.backgroundColor = [UIColor redColor];
    
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 50;
    [self.view addSubview:self.tableView];
    
    self.navigationItem.leftBarButtonItem =
    [[UIBarButtonItem alloc]
     initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(dismiss)];
    
}
- (void)dismiss {
    [self.tabBarController dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"123123"];
    cell.textLabel.text = _dataArr[indexPath.row];
    
    
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_dataArr.count<indexPath.row) return;
   
    id className = NSClassFromString(_dataArr[indexPath.row]);
    
    if (className) {
       UIViewController *classObj =  (UIViewController *)[[className alloc]init];
        classObj.navigationItem.title = _dataArr[indexPath.row];
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

@end




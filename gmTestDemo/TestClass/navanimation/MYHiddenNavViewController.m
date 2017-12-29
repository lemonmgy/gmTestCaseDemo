//
//  MYHiddenNavViewController.m
//  test
//
//  Created by lemonmgy on 2017/1/5.
//  Copyright © 2017年 lemonmgy. All rights reserved.
//

#import "MYHiddenNavViewController.h"
#import "MYLasetViewController.h"


@interface MYHiddenNavViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, assign) BOOL navShow;
@property (nonatomic, assign) BOOL onPage;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation MYHiddenNavViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!self.navShow&&!self.onPage) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    self.onPage = YES;
    NSLog(@"%d",self.navigationController.navigationBar.hidden);
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.onPage = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor brownColor];
    
//        self.edgesForExtendedLayout = UIRectEdgeNone;不开启
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.navigationItem.title = @"我隐藏了";
    
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor colorWithRed:247/255.0 green:163/255.0 blue:46/255.0 alpha:1];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 50;
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor purpleColor];
   
    for (int i = 0 ; i <50; i++) {
        [self.dataArray addObject:[NSString stringWithFormat:@"%@---%d",self.navigationItem.title,i]];
        [self.tableView reloadData];
    }
   
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"12223123"];
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MYLasetViewController *new = [MYLasetViewController new];
    [self.navigationController pushViewController:new animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    if (scrollView.contentOffset.y>=100&&self.navigationController.navigationBar.hidden) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        self.navShow = YES;
    }else if(!self.navigationController.navigationBar.hidden &&scrollView.contentOffset.y<100){
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        self.navShow = NO;
    }
    
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}
@end

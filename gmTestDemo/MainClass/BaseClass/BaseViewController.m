//
//  BaseViewController.m
//  test
//
//  Created by lemonmgy on 16/10/27.
//  Copyright © 2016年 lemonmgy. All rights reserved.
//

#import "BaseViewController.h"
#import <objc/runtime.h>

@interface BaseViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation BaseViewController

@synthesize iconNameArr = _iconNameArr;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableViewDataArr = [NSMutableArray arrayWithCapacity:10];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height -64) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor colorWithRed:247/255.0 green:163/255.0 blue:46/255.0 alpha:1];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 50;
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
    self.tableView.hidden = YES;
}

- (void)setTableViewDataArr:(NSMutableArray *)tableViewDataArr
{
    _tableViewDataArr = tableViewDataArr;
    
    [self.tableView reloadData];
    //    NSArray *arr = self.iconNameArr;
}

- (void)setIconNameArr:(NSMutableArray *)iconNameArr {
    if (!_iconNameArr.count) {
        _iconNameArr = [NSMutableArray arrayWithCapacity:10];
        for (int i =0; i < _tableViewDataArr.count; i++) {
            [_iconNameArr addObject:[NSString stringWithFormat:@"icon%d.jpg",arc4random()%5]];
        }
        [self.tableView reloadData];
    }
}

- (NSMutableArray *)iconNameArr
{
    if (!_iconNameArr.count) {
        _iconNameArr = [NSMutableArray arrayWithCapacity:10];
    }
    return _iconNameArr;
}

- (UITableView *)tableView
{
    if (_tableView.hidden) _tableView.hidden = NO;
    
    return _tableView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableViewDataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"12223123"];
    cell.backgroundColor = _cellColor?:[UIColor whiteColor];
    cell.textLabel.text = self.tableViewDataArr[indexPath.row];
    if (self.iconNameArr.count) {
        cell.imageView.image = [UIImage imageNamed:self.iconNameArr[indexPath.row]];
        cell.imageView.layer.masksToBounds = YES;
        cell.imageView.layer.cornerRadius = cell.imageView.frame.size.width/2.0;
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.navigationController) {
        [self.navigationController pushViewController:[[self class] new] animated:YES];
    }
}

- (void)setBottombtnNameArr:(NSMutableArray<NSString *> *)bottombtnNameArr
{
    _bottombtnNameArr = bottombtnNameArr;
    
    if (!_bottombtnNameArr.count)  return;
    
    CGFloat width = ([UIScreen mainScreen].bounds.size.width - (10*(_bottombtnNameArr.count + 1)))/_bottombtnNameArr.count;
    CGFloat y = self.view.frame.size.height - 200;
    for (int i = 0; i < _bottombtnNameArr.count; i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:[bottombtnNameArr[i] length]?bottombtnNameArr[i]:@"Click" forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
        btn.tag = i;
        btn.frame = CGRectMake(10 + i*(width +10), y, width , 50);
        [btn addTarget:self action:@selector(bottomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
}

- (void)bottomButtonClick:(UIButton *)sender
{
    NSLog(@"%@ --- %ld",sender.titleLabel.text,(long)sender.tag);
}


- (void)setTopItemNameArr:(NSArray<NSString *> *)topItemNameArr
{
    _topItemNameArr = topItemNameArr;
    
    if (!_topItemNameArr.count) return;
    NSMutableArray *barBtnItemArr = [NSMutableArray array];
    for (int i = 0; i < _topItemNameArr.count; i ++)
    {
        UIBarButtonItem *item = nil;
        NSString *name = self.topItemNameArr[i];
        item = [[UIBarButtonItem alloc] initWithTitle:[name length]?name:@"Click" style:UIBarButtonItemStylePlain target:self action:@selector(topButtonClick:)];
        
        
        item.tag = i;
        [barBtnItemArr addObject:item];
    }
    self.navigationItem.rightBarButtonItems = barBtnItemArr;
}

- (void)topButtonClick:(UIBarButtonItem *)sender
{
    NSLog(@"%@ --- %ld",sender.title,(long)sender.tag);
}

- (NSMutableArray *)testArray{
    if (!_testArray) {
        _testArray = [NSMutableArray arrayWithCapacity:10];
    }
    return _testArray;
}

@end

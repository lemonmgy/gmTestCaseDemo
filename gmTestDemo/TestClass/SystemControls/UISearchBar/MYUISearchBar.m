//
//  MYUISearchBar.m
//  test
//
//  Created by lemonmgy on 16/10/28.
//  Copyright © 2016年 lemonmgy. All rights reserved.
//

#import "MYUISearchBar.h"

@interface MYUISearchBar () <UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>

@end


// 保存原始表格数据的NSArray对象。
NSArray * tableData;
// 保存搜索结果数据的NSArray对象。
NSArray* searchData;
// 是否搜索变量
bool isSearch;


@implementation MYUISearchBar








- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 默认没有开始搜索
    isSearch = NO;
    // 初始化原始表格数据
    tableData = [NSArray arrayWithObjects:@"Java讲义",
                 @"轻量级Java EE企业应用实战",
                 @"Android讲义",
                 @"Ajax讲义",
                 @"HTML5/CSS3/JavaScript讲义",
                 @"iOS讲义",
                 @"XML讲义",
                 @"经典Java EE企业应用实战"
                 @"Java入门与精通",
                 @"Java基础教程",
                 @"学习Java",
                 @"Objective-C基础" ,
                 @"Ruby入门与精通",
                 @"iOS开发教程" ,nil];
    
    // 创建UISearchBar对象
    UISearchBar* searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 50, 100, 60)];
    
    // 设置Prompt提示
    [searchBar setPrompt:@"查找图书"];
    // 设置没有输入时的提示占位符
    [searchBar setPlaceholder:@"请输入图书名字"];
    // 显示Cancel按钮
//    searchBar.showsCancelButton = true;
    [searchBar setShowsCancelButton:YES animated:YES];
    // 设置代理
    searchBar.delegate = self;
    
    
     //设置 searchBar 为 table 的头部视图
    self.tableView.tableHeaderView = searchBar;
    // 添加UITableView
    [self.view addSubview:self.tableView];
    
}

#pragma mark - UITableViewDataSource

// 返回表格分区数，默认返回1
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    // 如果处于搜索状态
    if(isSearch)
    {
        // 使用searchData作为表格显示的数据
        return searchData.count;
    }
    else
    {
        // 否则使用原始的tableData座位表格显示的数据
        return tableData.count;
    }
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"----cellForRowAtIndexPath------");
    
    static NSString* cellId = @"cellId";
    // 从可重用的表格行队列中获取表格行
    UITableViewCell* cell = [tableView
                             dequeueReusableCellWithIdentifier:cellId];
    // 如果表格行为nil
    if(!cell)
    {
        // 创建表格行
        cell = [[UITableViewCell alloc] initWithStyle:
                UITableViewCellStyleDefault
                                      reuseIdentifier:cellId];
    }
    // 获取当前正在处理的表格行的行号
    NSInteger rowNo = indexPath.row;
    // 如果处于搜索状态
    if(isSearch)
    {
        // 使用searchData作为表格显示的数据
        cell.textLabel.text = [searchData objectAtIndex:rowNo];
    }
    else{
        // 否则使用原始的tableData作为表格显示的数据
        cell.textLabel.text = [tableData objectAtIndex:rowNo];
    }
    return cell;
}

#pragma mark - UISearchBarDelegate

// UISearchBarDelegate定义的方法，用户单击取消按钮时激发该方法
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"----searchBarCancelButtonClicked------");
    // 取消搜索状态
    isSearch = NO;
    [self.tableView reloadData];
    [searchBar resignFirstResponder];

}

// UISearchBarDelegate定义的方法，当搜索文本框内文本改变时激发该方法
- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchText
{
    
    if (searchBar.text.length >0)
    {
    NSLog(@"----textDidChange------");
    // 调用filterBySubstring:方法执行搜索
    [self filterBySubstring:searchText];
    }
    else
    {
        isSearch = NO;
        [self.tableView reloadData];
    }
}

// UISearchBarDelegate定义的方法，用户单击虚拟键盘上Search按键时激发该方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"----searchBarSearchButtonClicked------");
    // 调用filterBySubstring:方法执行搜索
    [self filterBySubstring:searchBar.text];
    // 放弃作为第一个响应者，关闭键盘
    [searchBar resignFirstResponder];
}

- (void) filterBySubstring:(NSString*) subStr
{
    NSLog(@"----filterBySubstring------");
    // 设置为搜索状态
    isSearch = YES;
    // 定义搜索谓词
    NSPredicate* pred = [NSPredicate predicateWithFormat:
                         @"SELF CONTAINS[c] %@" , subStr];
    // 使用谓词过滤NSArray
    searchData = [tableData filteredArrayUsingPredicate:pred];
    // 让表格控件重新加载数据
    [self.tableView reloadData];
}


@end

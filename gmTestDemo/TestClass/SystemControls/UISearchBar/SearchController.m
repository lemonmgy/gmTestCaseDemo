//
//  MYSearchController.m
//  test
//
//  Created by lemonmgy on 16/10/28.
//  Copyright © 2016年 lemonmgy. All rights reserved.
//

#import "SearchController.h"





@interface MYSearchController : UISearchController


@end

@implementation MYSearchController

- (void)viewDidLoad{

 
}

@end





@interface SearchController ()<UISearchControllerDelegate,UISearchResultsUpdating, UISearchBarDelegate>
{
    CGFloat _keyboardHeight;
}
@property (nonatomic, strong) MYSearchController *searchController;
@property (nonatomic, strong) NSArray *resultsArray;

@property (nonatomic, assign) BOOL isSearch;
@end

@implementation SearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.edgesForExtendedLayout = UIRectEdgeNone;

    
    
    for (int i = 0; i <20; i++) {
        [self.tableViewDataArr addObject:[NSString stringWithFormat:@"小白%d号",arc4random()%100]];
    }
//    self.tableView;
  
//#warning 注意需要添加
    self.definesPresentationContext = YES;
     self.searchController = [[MYSearchController alloc]initWithSearchResultsController:nil];
     self.searchController.searchResultsUpdater = self;
    self.searchController.delegate = self;
    self.searchController.searchBar.delegate = self;
//    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.searchController.dimsBackgroundDuringPresentation = NO;
     self.tableView.tableHeaderView = self.searchController.searchBar;

//    self.navigationItem.titleView = self.searchController.searchBar;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];

    
}


- (void)keyboardWillShow:(NSNotification *)noti
{
    CGRect keyboardRect = [noti.userInfo[UIKeyboardFrameEndUserInfoKey]CGRectValue];
//      CGFloat duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    _keyboardHeight = keyboardRect.size.height;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return !self.isSearch ? self.tableViewDataArr.count : self.resultsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"xxsss"];
    cell.textLabel.text = !self.isSearch ? self.tableViewDataArr[indexPath.row] : self.resultsArray[indexPath.row];
//    cell.imageView.image = [UIImage imageNamed:self.iconNameArr[indexPath.row]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    return cell;
    
}


- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    
    self.isSearch = searchController.searchBar.text.length;
 
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@",searchController.searchBar.text];
     self.resultsArray = (NSMutableArray *)[self.tableViewDataArr filteredArrayUsingPredicate:predicate];
     [self.tableView reloadData];
    
}



- (void)willPresentSearchController:(UISearchController *)searchController
{
    
    
    UIView *bar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 20)];
    bar.backgroundColor = [UIColor redColor];
    bar.tag = 20003;
    [self.view addSubview:bar];
    bar.alpha = 0;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3 animations:^{
            
            bar.alpha = 1;
        }];
    });
    
//    [self.navigationItem setHidesBackButton:YES animated:NO];
    
    
}
- (void)didPresentSearchController:(UISearchController *)searchController
{
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, _keyboardHeight, 0);

 
}

- (void)willDismissSearchController:(UISearchController *)searchController
{
    UIView *bar = [(UIView *)self.view viewWithTag:20003];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [UIView animateWithDuration:0.3 animations:^{
            
            bar.alpha = 0.3;
        }completion:^(BOOL finished) {
            
            [bar removeFromSuperview];
        }];
    });
    
    
    
//    [self.navigationItem setHidesBackButton:NO animated:NO];
}




//- (BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    // 键盘Return的触发事件
//    [textField resignFirstResponder];
//    return YES;
//}



@end







//
//  GMPostViewController.m
//  test
//
//  Created by lemonmgy on 2017/1/20.
//  Copyright © 2017年 lemonmgy. All rights reserved.
//

#import "GMPostViewController.h"
#import "GMPostTableViewCell.h"
#import "GMPictureBrowserViewController.h"
#import "GMIconItem.h"

@interface GMPostViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation GMPostViewController

- (void)clearImageData {
    
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        
    }];
    [[SDImageCache sharedImageCache] clearMemory];
    show_alert(@"清理中...");
    __weak __typeof (self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSString *alert = [NSString stringWithFormat:@"getSize== %lu getDiskCount =%lu",(unsigned long)[[SDImageCache sharedImageCache] getSize], (unsigned long)[[SDImageCache sharedImageCache] getDiskCount]];
        hidden_alert(alert);
        [weakSelf.tableView reloadData];
    });

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height -64) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor colorWithRed:247/255.0 green:163/255.0 blue:46/255.0 alpha:1];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"清理" style:UIBarButtonItemStyleDone target:self action:@selector(clearImageData)];
    
    [self getData];
}

- (void)getData {
    
    self.dataArray = [NSMutableArray new];
    for (int i = 0 ; i < 50; i++) {
        CellModel *model = [CellModel new];
        [self loc:model];
        [self.dataArray addObject:model];
    }
    [self.tableView reloadData];
}
- (void)loc:(CellModel *)model {
    model.iconModelArr = [NSMutableArray new];
    CGFloat w = (kSCREEN_WIDTH - 4*10)/3.0;
    
    static int num = 1;
    if (num > 9) {
        num = arc4random()%9;
    }
    
    int index = 0;
    for (int i = 0; i < num; i ++) {
        GMIconModel *icon = [GMIconModel new];
        index =  arc4random()%19;
//        icon.bigIconUrl = [NSString stringWithFormat:@"https://gmpicture.oss-cn-qingdao.aliyuncs.com/icon%d.png?x-oss-process=image/resize,w_%d",index,(int)kSCREEN_WIDTH*3];
//        //            icon.iconUrl = [NSString stringWithFormat:@"https://gmpicture.oss-cn-qingdao.aliyuncs.com/icon%d.png",index];
//        //            icon.zoomIconUrl = [NSString stringWithFormat:@"https://gmpicture.oss-cn-qingdao.aliyuncs.com/icon%d.png?x-oss-process=image/resize,h_100",index];
//        icon.smallIconUrl = [NSString stringWithFormat:@"https://gmpicture.oss-cn-qingdao.aliyuncs.com/icon%d.png?x-oss-process=image/resize,w_%d",index,(int)(kSCREEN_WIDTH/2.0)];
        
        icon.smallIconUrl = [NSString stringWithFormat:@"icon%d",arc4random()%11];
        icon.bigIconUrl = icon.smallIconUrl;
        int row = i/3;
        int column = i%3;
        icon.iconRect = CGRectMake(10+column*(w+10), 10+row*(10+w), w, w);
        [model.iconModelArr addObject:icon];
    }
    model.cellH = CGRectGetMaxY([[model.iconModelArr lastObject] iconRect]) + 20;
    num ++;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.dataArray[indexPath.row] cellH];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GMPostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MYPostidentifier"];
    
    if (cell == nil) {
        NSLog(@"重用");
        cell = [[GMPostTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MYPostidentifier"];
        __weak __typeof (self) weakSelf = self;
        __weak typeof(cell) weakCell = cell;
        cell.myBlock = ^BOOL(UIView *view,CellModel *model) {
            [weakSelf gotoImageViewController:view andModel:model and:weakCell];
            return YES;
        };
    }

    cell.model = self.dataArray[indexPath.row];
    return cell;
    
}

- (void)gotoImageViewController:(UIView *)view andModel:(CellModel *)model and:(GMPostTableViewCell *)cell {
    NSMutableArray *tempArray = [NSMutableArray new];
    [model.iconModelArr enumerateObjectsUsingBlock:^(GMIconModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        GMIconItem *item = [GMIconItem new];
        item.bigIconUrl = obj.bigIconUrl;
        item.smallIconUrl = obj.smallIconUrl;
        item.thumbView = cell.iconArray[idx];
        [tempArray addObject:item];
    }];
    GMPictureBrowserViewController *vc = [GMPictureBrowserViewController new];
    vc.iconItemArray = tempArray;
    vc.currentIndex = (int)view.tag;
    vc.clickCell = cell;
    [self presentViewController:vc animated:YES completion:nil];
}

@end

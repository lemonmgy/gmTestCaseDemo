//
//  MYCalendarViewController.m
//  gmTestDemo
//
//  Created by lemonmgy on 2017/2/10.
//  Copyright © 2017年 lemonmgy. All rights reserved.
//

#import "MYCalendarViewController.h"
#import "NSCalendar+MYCalendarTool.h"
#import "MYCalendarViewController.h"
#import "MYCalendarSwitchView.h"


@interface MYCalendarViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) MYCalendarSwitchView *switchView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *monthArray;
@property (nonatomic, strong) NSCalendar *calendar;
@end

@implementation MYCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 1;
    layout.minimumInteritemSpacing = 1;
    
    CGFloat w = (kSCREEN_WIDTH-8*5)/7.0;
    layout.itemSize = CGSizeMake(w, w);
    layout.sectionInset = UIEdgeInsetsMake(10, 0, 10, 0);
    layout.headerReferenceSize = CGSizeMake(kSCREEN_WIDTH, 50);
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 120) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor greenColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
//    self.collectionView.
    [self.view addSubview:self.collectionView];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableView"];

    self.switchView = [[MYCalendarSwitchView alloc] initWithFrame:CGRectMake(0,200, kSCREEN_WIDTH, 250)];
    [self.view addSubview:self.switchView];
    
//    __weak __typeof (self) weakSelf = self;
    [self.switchView setSwitchSuccessBlock:^(MYCalendarMonthItem *monthModel) {
        
    }];
    [self.switchView setClickItemBlock:^(MYCalendarDayItem *dayModel) {
        
    }];
    [self getData];
}

- (void)getData {

    self.calendar = [NSCalendar currentCalendar];
    log_objcx(@"开始");
    self.monthArray = [self.calendar calendarMonthArrayDataWithNumber:-(12*100) andBaseDate:nil];
    NSMutableArray *lastMonthArray = [self.calendar calendarMonthArrayDataWithNumber:(12*100) andBaseDate:nil];
    [self.monthArray removeLastObject];
    [self.monthArray addObjectsFromArray:lastMonthArray];
    log_objcx(@"开始");
    [self.collectionView reloadData];
    self.switchView.dataSourceArray = self.monthArray;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *view = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        //重用页眉
        view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableView" forIndexPath:indexPath];
        //设置页眉的颜色
        view.backgroundColor = [UIColor orangeColor];
        UILabel *label = (UILabel *)[view viewWithTag:3000];
        if (!label) {
            label = [UILabel new];
            label.frame =CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
            label.textAlignment = NSTextAlignmentCenter;
            label.numberOfLines = 0;
            label.backgroundColor = [UIColor purpleColor];
            label.tag = 3000;
            [view addSubview:label];
        }
        MYCalendarMonthItem *month = self.monthArray[indexPath.section];
        MYCalendarDayItem *day = [month.dayItemArray lastObject];
        label.text = [NSString stringWithFormat:@"%lu",(unsigned long)day.component.month];
    }
 
    return view;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.monthArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    MYCalendarMonthItem *month = self.monthArray[section];
    return month.dayItemArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor purpleColor];
    cell.contentView.layer.borderColor = [UIColor  grayColor].CGColor;
    cell.contentView.layer.borderWidth = 5.0;
    
   UILabel *label = (UILabel *)[cell.contentView viewWithTag:2000];
    if (!label) {
        label = [UILabel new];
        label.frame =CGRectMake(0, 0, cell.contentView.frame.size.width, cell.contentView.frame.size.height);
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        label.backgroundColor = [UIColor greenColor];
        label.tag = 2000;
        [cell.contentView addSubview:label];
    }
    MYCalendarMonthItem *month = self.monthArray[indexPath.section];
    MYCalendarDayItem *day = month.dayItemArray[indexPath.row];
    if (!day.hidden) {
        label.text = [NSString stringWithFormat:@"%lu",(unsigned long)day.component.day];
    }
    
    NSString *year = [NSString stringWithFormat:@"%lu",(unsigned long)day.component.year];
    if (self.navigationItem.title != year) {
        self.navigationItem.title = year;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"didSelectItemAtIndexPath");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

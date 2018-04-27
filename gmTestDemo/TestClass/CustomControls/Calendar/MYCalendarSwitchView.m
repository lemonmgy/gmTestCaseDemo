//
//  MYCalendarSwitchView.m
//  gmTestDemo
//
//  Created by lemonmgy on 2017/8/8.
//  Copyright © 2017年 lemonmgy. All rights reserved.
//

#import "MYCalendarSwitchView.h"
#import "NSCalendar+MYCalendarTool.h"

@interface MYCalendarSwitchView()<UIScrollViewDelegate,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    CGFloat _itemW;
}
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) NSMutableArray *imagesArray;
@property (nonatomic, assign) NSInteger currentPage;
@end

@implementation MYCalendarSwitchView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self getMainScrollView];
    }
    return self;
}

- (void)getMainScrollView {
    _mainScrollView = [[UIScrollView alloc]init];
    _mainScrollView.backgroundColor = [UIColor purpleColor];
    _mainScrollView.pagingEnabled = YES;
    _mainScrollView.bounces = NO;
    _mainScrollView.showsVerticalScrollIndicator = NO;
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.delegate = self;
    _mainScrollView.userInteractionEnabled = NO;
    [self addSubview:_mainScrollView];
    
    for (int i = 0; i<3; i++) {
        UIView *imageView = [self getSubView];
        imageView.userInteractionEnabled = YES;
        imageView.tag = i;
        [_mainScrollView addSubview:imageView];
        [self.imagesArray addObject:imageView];
    }
    [self setSubviewsFrame];
}


#pragma mark -- subview start
- (UIView *)getSubView {

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 2;
    layout.minimumInteritemSpacing = 2;
    
    _itemW = (kSCREEN_WIDTH - 6*2 - 2*2)/7.0;
    layout.itemSize = CGSizeMake(_itemW, _itemW);
    layout.sectionInset = UIEdgeInsetsMake(2, 2, 2, 2);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, [self collection:layout row:5]) collectionViewLayout:layout];
    collectionView.scrollEnabled = NO;
    collectionView.backgroundColor = [UIColor greenColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableView"];
    
    return collectionView;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger page = [self collectionPage:collectionView];
    MYCalendarMonthItem *month = self.dataSourceArray[page];
    return month.dayItemArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor purpleColor];
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:2000];
    if (!label) {
        label = [UILabel new];
        label.frame =CGRectMake(0, 0, cell.contentView.frame.size.width, cell.contentView.frame.size.height);
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        label.tag = 2000;
        [cell.contentView addSubview:label];
    }
    
    NSInteger page = [self collectionPage:collectionView];
    MYCalendarMonthItem *month = self.dataSourceArray[page];
    MYCalendarDayItem *day = month.dayItemArray[indexPath.row];
    if (!day.hidden) {
        label.text = [NSString stringWithFormat:@"%lu",(unsigned long)day.component.day];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MYCalendarMonthItem *month = self.dataSourceArray[self.currentPage];
    MYCalendarDayItem *item = month.dayItemArray[indexPath.row];
    if (self.clickItemBlock) self.clickItemBlock(item);
}

- (NSInteger)collectionPage:(UICollectionView *)collectionView {
    NSInteger page = self.currentPage;
    if (collectionView == [self.imagesArray firstObject]) {
        page = [self prePage];
    }else if (collectionView == [self.imagesArray lastObject]) {
        page = [self sufPage];
    }
    return page;
}

#pragma mark -- subview end

#pragma mark -- frame处理 start
- (CGFloat)collection:(UICollectionViewLayout *)slayout row:(int)row {
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)slayout;
    return (row * layout.itemSize.height + (row-1) * layout.minimumInteritemSpacing + layout.sectionInset.top + layout.sectionInset.bottom);
}

- (void)updateFrameWithH:(CGFloat)h {
    
    CGRect rect = self.frame;
    rect.size.height = h;
    self.frame = rect;
   
    rect = _mainScrollView.frame;
    rect.size.height = h;
    _mainScrollView.frame = rect;
    
    CGSize size = _mainScrollView.contentSize;
    size.height = h;
    _mainScrollView.contentSize = size;
    
    for (UIScrollView *subView in self.imagesArray) {
        rect = subView.frame;
        rect.size.height = h;
        subView.frame = rect;
        
        size = subView.contentSize;
        size.height = h;
        subView.contentSize = size;
    }
    
    if (self.updateLayout) self.updateLayout();
}

- (void)setSubviewsFrame {
    _mainScrollView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    _mainScrollView.contentSize = CGSizeMake(3*kSCREEN_WIDTH, CGRectGetHeight(self.frame));
    _mainScrollView.contentOffset = CGPointMake(kSCREEN_WIDTH, 0);
    int i = 0;
    for (UIImageView *imageView in self.imagesArray) {
        imageView.frame = CGRectMake(i*kSCREEN_WIDTH, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        i++;
    }
}
#pragma mark -- frame处理 end

- (void)setDataSourceArray:(NSArray *)dataSourceArray {
    
    if (!dataSourceArray ||
        ![dataSourceArray isKindOfClass:[NSArray class]] ||
        !dataSourceArray.count) {
        return;
    }
    _dataSourceArray = dataSourceArray;
    _mainScrollView.userInteractionEnabled = YES;
    if (_dataSourceArray.count ==1) {
        _mainScrollView.scrollEnabled = NO;
    }else if (!_mainScrollView.scrollEnabled) {
        _mainScrollView.scrollEnabled = YES;
    }
    
    _currentPage = 0;
    [self updateImages];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    MYCalendarMonthItem *month = self.dataSourceArray[self.currentPage];
    if (self.switchSuccessBlock) self.switchSuccessBlock(month);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self turnThePage:scrollView];
}

- (void)turnThePage:(UIScrollView *)scrollView {
    if (scrollView != self.mainScrollView) {
        return;
    }
    
    CGFloat x = scrollView.contentOffset.x;
    log_number(x, @"");
    if (x > 0 && x < 2*kSCREEN_WIDTH) {
        return;
    }
    if (x <= 0) {
        self.currentPage = [self prePage];
    }else if (x >= 2*kSCREEN_WIDTH) {
        self.currentPage = [self sufPage];
    }
    [_mainScrollView setContentOffset:CGPointMake(kSCREEN_WIDTH, 0)];
    [self updateImages];
}

//刷新数据
- (void)updateDatas {
    [self updateDatas];
}

- (void)updateImages {
    if (!_dataSourceArray.count) return;
    for (UICollectionView *colView in self.imagesArray) {
        [colView reloadData];
    }
    
    UICollectionView *cView = self.imagesArray[1];
    NSInteger page = [self collectionPage:cView];
    MYCalendarMonthItem *month = self.dataSourceArray[page];
    NSInteger row = month.dayItemArray.count%7;
    row = month.dayItemArray.count/7 + ((row == 0)?0:1);
    
    CGFloat h = [self collection:cView.collectionViewLayout row:(int)row];
    if (h > 0) {
        [UIView animateWithDuration:0.25 animations:^{
            [self updateFrameWithH:h];
        }];
    }
}

- (NSInteger)prePage {
    NSInteger tempPage = self.currentPage;
    return (tempPage-1 < 0)?(self.dataSourceArray.count-1):tempPage-1;
}

- (NSInteger)sufPage {
    NSInteger tempPage = self.currentPage;
    return (tempPage+1 >= self.dataSourceArray.count)?0:tempPage+1;
}

- (NSMutableArray *)imagesArray {
    if (!_imagesArray) {
        _imagesArray = [NSMutableArray array];
    }
    return _imagesArray;
}

- (void)dealloc {
    NSLog(@"dealloc----->>>%@<<<-----dealloc",[self class]);
}

@end

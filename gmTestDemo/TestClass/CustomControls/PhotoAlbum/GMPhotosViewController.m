//
//  GMPhotosViewController.m
//  test
//
//  Created by lemonmgy on 2016/11/17.
//  Copyright © 2016年 lemonmgy. All rights reserved.
//

#import "GMPhotosViewController.h"
#import "GMPhotosCollectionViewCell.h"
#import "GMPhotosUtils.h"
#import "GMCollectionView.h"
#import "GMPictureBrowserViewController.h"
#import "GMIconItem.h"

@interface GMPhotosViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,GMPhotosUtilsDelegate>
{
    CGFloat _margin;
    CGFloat _itemWdith;
}
@property (nonatomic, strong) GMCollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *photosArray;
@property (nonatomic, strong) PHFetchResult *fetchResult;
@end

@implementation GMPhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.topItemNameArr = (NSMutableArray *)@[@"数据源",@"底部"];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createUI];
    [self getPhotosData];
}

- (void)topButtonClick:(UIBarButtonItem *)sender
{
    
    if (sender.tag) {
        
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:(self.photosArray.count-1) inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
    }
    else{
        static int i = 0;
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:(i) inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
        i ++;
    }
}

- (void)getPhotosData {
    [GMPhotosUtils defaultManager].delegate = self;
    [[GMPhotosUtils defaultManager] getAllThumbnailImagesWithSize:CGSizeMake(300, 300) completion:^(id obj, NSDictionary *info, PHAsset *asset) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.photosArray addObjectsFromArray:obj];
            [self.collectionView reloadData];
//            NSLog(@"self.photosArray = %lu      %lu   currentThread = %@",self.photosArray.count,(unsigned long)[((NSArray *)obj) count],[NSThread currentThread]);

        });
    }];
}
- (void)imagesResults:(id)obj info:(NSDictionary *)info asset:(PHAsset *)asset {
    
    [self.photosArray addObjectsFromArray:obj];
    [self.collectionView reloadData];
    NSLog(@"self.photosArray = %lu      %lu   currentThread = %@",self.photosArray.count,(unsigned long)[((NSArray *)obj) count],[NSThread currentThread]);
}

- (void)createUI {
    
    UICollectionViewFlowLayout *layout  =[[UICollectionViewFlowLayout alloc]init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    layout.minimumInteritemSpacing = 3;
    layout.minimumLineSpacing = 3;
    _margin = 3;
    _itemWdith = ([UIScreen mainScreen].bounds.size.width - _margin*3.0-2*layout.minimumInteritemSpacing-2)/4.0;
    layout.itemSize = CGSizeMake(_itemWdith, _itemWdith);
    layout.sectionInset = UIEdgeInsetsMake(_margin, _margin, _margin, _margin);
    
    
    self.collectionView = [[GMCollectionView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT- 64) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor] ;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    [self.collectionView registerClass:[GMPhotosCollectionViewCell class] forCellWithReuseIdentifier:GMPhotosCollectionViewCellID];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
   
    return self.photosArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GMPhotosCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GMPhotosCollectionViewCellID forIndexPath:indexPath];
    GMIconItem *item = self.photosArray[indexPath.row];
    cell.imageView.image = item.smallImage;
    item.thumbView = cell;
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    GMPictureBrowserViewController *vc = [GMPictureBrowserViewController new];
    vc.iconItemArray = self.photosArray;
    
    vc.currentIndex = indexPath.row;
    vc.clickCell = collectionView;
//    [collectionView cellForItemAtIndexPath:indexPath];
    [self presentViewController:vc animated:YES completion:nil];
    
    NSLog(@"%ld    %ld",(long)indexPath.row,indexPath.section);
}


- (NSMutableArray *)photosArray {
    if (!_photosArray) {
        _photosArray = [NSMutableArray arrayWithCapacity:10];
    }
    return _photosArray;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [GMPhotosUtils defaultManager].stop = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

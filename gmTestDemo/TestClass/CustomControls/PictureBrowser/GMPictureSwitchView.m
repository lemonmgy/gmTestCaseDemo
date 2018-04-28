//
//  GMPictureSwitchView.m
//
//  Created by lemonmgy on 2016/11/14.
//

#import "GMPictureSwitchView.h"
#import "GMIconItem.h"
#import "GMPhotosUtils.h"

#define kAfterDelay 3.0

@interface GMPictureSwitchView()<UIScrollViewDelegate>
@property (nonatomic, assign) CGSize selfSize;
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) NSMutableArray *imagesArray;
@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) GMIconItem *currentModel;

@property (nonatomic, assign)  BOOL localPhotoAlbum;//是否本地相册

@property (nonatomic, strong) NSArray <GMIconItem *>*dataSourceArray;
@property (nonatomic, assign) NSInteger currentIndex;
@end

@implementation GMPictureSwitchView

- (BOOL)localPhotoAlbum {
    if ([[self.dataSourceArray lastObject] smallImage]) {
        return YES;
    }else {
        return NO;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.mainScrollView) {
        NSLog(@"scrollViewDidScroll");
        [self turnThePageWithOffsetX:scrollView.contentOffset.x];
    }
}

#pragma mark -- UIScrollViewDelegate start
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    if (scrollView == self.mainScrollView) {
//        [self turnThePageWithOffsetX:scrollView.contentOffset.x];
//    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (scrollView == self.mainScrollView) {
        [self turnThePageWithOffsetX:scrollView.contentOffset.x];
    }
}

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    if (scrollView == self.mainScrollView) return nil;
    if (self.imageScrollView.subviews.lastObject == self.imagesArray[1]) {
        
    }
    return self.imagesArray[1];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    if (scrollView == self.mainScrollView) return;
    if (scrollView.contentSize.height <= self.selfSize.height) {
        scrollView.contentSize = CGSizeMake(scrollView.contentSize.width, self.selfSize.height);
    }
    [self.imagesArray[1] setCenter:CGPointMake(scrollView.contentSize.width/2.0, scrollView.contentSize.height/2.0)];
    
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view {
    if (scrollView == self.mainScrollView) return;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale {
    
    if (scrollView == self.mainScrollView) return;
}

#pragma mark -- UIScrollViewDelegate end

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self getMainScrollView];
    }
    return self;
}

- (void)getMainScrollView {
    
    _mainScrollView = [[UIScrollView alloc]init];
    _mainScrollView.backgroundColor = [UIColor clearColor];
    _mainScrollView.pagingEnabled = YES;
    _mainScrollView.bounces = NO;
    _mainScrollView.showsVerticalScrollIndicator = NO;
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.delegate = self;
    [self addSubview:_mainScrollView];
    
    for (int i = 0; i<3; i++) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.userInteractionEnabled = NO;
        imageView.tag = i;
        if (i == 1) {
            _imageScrollView = [UIScrollView new];
            _imageScrollView.backgroundColor = [UIColor clearColor];
            _imageScrollView.maximumZoomScale = 5;////
            _imageScrollView.delegate = self;
            [_imageScrollView addSubview:imageView];
            [_mainScrollView addSubview:_imageScrollView];
            
            UITapGestureRecognizer *taps = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(taps:)];
            [_imageScrollView addGestureRecognizer:taps];
            
            UITapGestureRecognizer *doubleTaps = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTaps:)];
            doubleTaps.numberOfTapsRequired = 2;
            [_imageScrollView addGestureRecognizer:doubleTaps];
            
            [taps requireGestureRecognizerToFail:doubleTaps];
            
            
        }else {
            [_mainScrollView addSubview:imageView];
        }
        [self.imagesArray addObject:imageView];
        if (i==0)
        {
            imageView.backgroundColor = [UIColor redColor];
        }else if (i == 1)
        {
            imageView.backgroundColor = [UIColor redColor];
        }else{
            imageView.backgroundColor = [UIColor redColor];
        }
    }
    
    self.pageControl = [[UIPageControl alloc]init];
    self.pageControl.currentPage = 0;
    self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    CGFloat value = 233/255.0;
    self.pageControl.pageIndicatorTintColor = [UIColor colorWithRed:value green:value blue:value alpha:0.5];
    [self addSubview:self.pageControl];
}

- (void)setSubviewsFrame {
    if (!self.dataSourceArray.count) return;
    
    CGFloat width = self.selfSize.width;
    CGFloat height = self.selfSize.height;
    _mainScrollView.frame = CGRectMake(0, 0, width, height);
    _mainScrollView.contentSize = CGSizeMake(3*width, height);
    _mainScrollView.contentOffset = CGPointMake(width, 0);
    
    int i = 0;
    for (UIImageView *imageView in self.imagesArray) {
        if (i == 1) {
            imageView.frame = CGRectMake(0, 0, width, height);
            _imageScrollView.frame = CGRectMake(i*width, 0, width, height);
            _imageScrollView.contentSize = CGSizeMake(width, height);
            
        }else{
            imageView.frame = CGRectMake(i*width, 0, width, height);
        }
        i++;
    }
}

- (void)taps:(UITapGestureRecognizer *)taps {
    
    if (self.shufflingCallBackBlock) {
        self.shufflingCallBackBlock(self.currentModel,self.currentIndex, GMShufflingBlockTypeWithExit);
    }
}

- (void)doubleTaps:(UITapGestureRecognizer *)doubleTaps {
    [doubleTaps locationInView:self.imageScrollView];
    CGFloat scale = self.imageScrollView.maximumZoomScale;
    if (self.imageScrollView.zoomScale != self.imageScrollView.minimumZoomScale) {
        scale = self.imageScrollView.minimumZoomScale;
    }
    [self.imageScrollView setZoomScale:scale animated:YES];
}

- (GMIconItem *)currentModel {
    _currentModel = self.dataSourceArray[self.currentIndex];
    return _currentModel;
}

- (NSMutableArray *)imagesArray {
    if (!_imagesArray) {
        _imagesArray = [NSMutableArray array];
    }
    return _imagesArray;
}

- (void)refreshDataSource:(NSArray *)dataSourceArray currentIndex:(NSInteger)currentIndex {
    if (!dataSourceArray | ![dataSourceArray isKindOfClass:[NSArray class]] | !dataSourceArray.count) {
        return;
    }
    self.dataSourceArray = dataSourceArray;
    
    self.pageControl.numberOfPages = _dataSourceArray.count;
    self.currentIndex = currentIndex;
    if (self.pageControl.numberOfPages > 9) {
        self.pageControl.hidden = YES;
    }
    CGFloat width = 17.0*self.dataSourceArray.count;
    _pageControl.frame = CGRectMake(self.selfSize.width- 12 - width, CGRectGetHeight(self.frame)-20, width, 20);
    
    
    if (_dataSourceArray.count ==1) {
        _mainScrollView.scrollEnabled = NO;
        
    }else if (!_mainScrollView.scrollEnabled) {
        _mainScrollView.scrollEnabled = YES;
    }

    [self setSubviewsFrame];
    [self updateImages];
    
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = currentIndex;
    if (_currentIndex <= 9) self.pageControl.currentPage = _currentIndex;

    if (self.shufflingCallBackBlock) {
        self.shufflingCallBackBlock(self.currentModel, self.currentIndex, GMShufflingBlockTypeWithSwitch);
    }
}

- (void)turnThePageWithOffsetX:(CGFloat)x {
    if (x > 0 && x < 2*self.selfSize.width) {
        return;
    }
    if (x <= 0) {
        self.currentIndex = [self prePage];
    }else if (x >= 2*self.selfSize.width) {
        self.currentIndex = [self sufPage];
    }
    [_mainScrollView setContentOffset:CGPointMake(self.selfSize.width, 0)];
    self.pageControl.currentPage = self.currentIndex;
    [self updateImages];
    
    NSLog(@"完成");
}

- (void)updateImages {
    if (!_dataSourceArray.count) return;
    NSArray *pageArr = @[@([self prePage]), @(self.currentIndex),@([self sufPage])];
   
    [pageArr enumerateObjectsUsingBlock:^(NSNumber *page, NSUInteger idx, BOOL * _Nonnull stop) {
        GMIconItem *model = self->_dataSourceArray[[page integerValue]];
        if (self.localPhotoAlbum) {
            [self getlocalPhotoAlbumWithImage:idx andIconModel:model];
        }else {
            [self setAdImage:idx andIconModel:model];
        }
    }];
}
- (void)getlocalPhotoAlbumWithImage:(NSInteger)page andIconModel:(GMIconItem *)model {
    UIImageView *imageView = self.imagesArray[page];
    if (model.bigImage) {
        imageView.image = model.bigImage;
    }else {
        imageView.image = model.smallImage;
//        [self getBigImageWithModel:model andImageView:imageView];
    }
    [self layoutWithImageView:imageView andPage:page andImage:model.smallImage];
}

- (void)getBigImageWithModel:(GMIconItem *)model andImageView:(UIImageView *)imageView {
    if (model.bigImage) return;
//    GMIconItem *models = self.dataSourceArray[self.currentIndex];
    [[GMPhotosUtils defaultManager] getImageWithAsset:model.asset resultHandler:^(id obj, NSDictionary *info, PHAsset *asset) {
        model.bigImage = (UIImage *)obj;
        if (model.asset == asset) imageView.image = (UIImage *)obj;
        log_size(imageView.image.size, @"imageView.image");
    }];
}

- (void)setAdImage:(NSInteger)page andIconModel:(GMIconItem *)model {
    UIImageView *imageView = self.imagesArray[page];
    __weak __typeof (self) weakSelf = self;
    UIImage *image = [GMIconItem imageFromCacheForKey:model.bigIconUrl];
    if (image) {
        imageView.image = image;
        [weakSelf layoutWithImageView:imageView andPage:page andImage:image];
    }else {
        UIImage *placeholderImage = [GMIconItem imageFromCacheForKey:model.smallIconUrl];
        BOOL layout = placeholderImage?YES:NO;
        if (layout) {
            [weakSelf layoutWithImageView:imageView andPage:page andImage:placeholderImage];
            layout = NO;
        }
        imageView.image = placeholderImage;
        UIImageView *ima = [UIImageView new];
        [ima sd_setImageWithURL:[NSURL URLWithString:model.bigIconUrl] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            NSLog(@"完成图片加载%@",imageURL);
            if ([model.bigIconUrl isEqualToString:[imageURL absoluteString]]) {
                imageView.image = image;
            }
            if (layout) [weakSelf layoutWithImageView:imageView andPage:page andImage:image];
        }];
        
    }
    
}

- (void)layoutWithImageView:(UIImageView *)imageView andPage:(NSInteger)page andImage:(UIImage *)image {
    if (image.size.height <= 0 || image.size.width <= 0) {
        return;
    }
    //frame
    CGFloat scale =  image.size.height/image.size.width;
    CGFloat w = self.selfSize.width;
    CGFloat h = w*scale;
    imageView.bounds = CGRectMake(0, 0, w, h);
//    h = (h >= self.selfSize.height)? h:self.selfSize.height;
    h = MAX(h, self.selfSize.height);
    imageView.center = CGPointMake(imageView.center.x, h/2.0);
    _imageScrollView.zoomScale = _imageScrollView.minimumZoomScale;
    
    if (self.currentIndex == page) {
        _imageScrollView.contentSize = CGSizeMake(_imageScrollView.contentSize.width, h);
    }
    
}

- (NSInteger)prePage {
    NSInteger tempPage = self.currentIndex;
    return (tempPage-1 < 0)?(self.dataSourceArray.count-1):tempPage-1;
}

- (NSInteger)sufPage {
    NSInteger tempPage = self.currentIndex;
    return (tempPage+1 >= self.dataSourceArray.count)?0:tempPage+1;
}

- (void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (CGSize)selfSize {
    return CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
}
@end

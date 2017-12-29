//
//  GMShufflingView.m
//
//  Created by lemonmgy on 2016/11/14.
//

#import "GMShufflingView.h"
//#import "UIImageView+WebCache.h"

#define kSCREEH_HEIGHT [UIScreen mainScreen].bounds.size.height
#define kSCREEH_WIDHT  [UIScreen mainScreen].bounds.size.width
#define kAfterDelay 3.0

@implementation GMShufflingModel


@end

@interface GMShufflingView()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) NSMutableArray *imagesArray;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation GMShufflingView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self getMainScrollView];
    }
    return self;
}

- (void)getMainScrollView {
    _mainScrollView = [[UIScrollView alloc]init];
    _mainScrollView.backgroundColor = [UIColor orangeColor];
    _mainScrollView.pagingEnabled = YES;
    _mainScrollView.bounces = NO;
    _mainScrollView.showsVerticalScrollIndicator = NO;
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.delegate = self;
    _mainScrollView.userInteractionEnabled = NO;
    [self addSubview:_mainScrollView];
    
    for (int i = 0; i<3; i++) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.userInteractionEnabled = YES;
        imageView.tag = i;
        if (i==0)
        {
            imageView.backgroundColor = [UIColor redColor];
        }else if (i == 1)
        {
            imageView.backgroundColor = [UIColor yellowColor];
        }else{
        imageView.backgroundColor = [UIColor blueColor];
        }
        UITapGestureRecognizer *taps = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(taps:)];
        [imageView addGestureRecognizer:taps];
        [_mainScrollView addSubview:imageView]; 
        [self.imagesArray addObject:imageView];
    }
    
    self.pageControl = [[UIPageControl alloc]init];
    self.pageControl.currentPage = 0;
    self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    self.pageControl.pageIndicatorTintColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:self.pageControl];
//#warning 后器删除
    _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    [self setSubviewsFrame];
}

- (void)setSubviewsFrame {
    
    _mainScrollView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    _mainScrollView.contentSize = CGSizeMake(3*kSCREEH_WIDHT, CGRectGetHeight(self.frame));
    _mainScrollView.contentOffset = CGPointMake(kSCREEH_WIDHT, 0);
    int i = 0;
    for (UIImageView *imageView in self.imagesArray) {
        imageView.frame = CGRectMake(i*kSCREEH_WIDHT, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        i++;
    }
}
- (void)taps:(UITapGestureRecognizer *)taps {
    
    id obj = nil;
    if (_currentPage < self.dataSourceArray.count) {
    obj = self.dataSourceArray[_currentPage];
    }
    
    if (self.shufflingCallBack) {
        self.shufflingCallBack(obj);
    }
    
}

- (NSMutableArray *)imagesArray {
    if (!_imagesArray) {
        _imagesArray = [NSMutableArray array];
    }
    return _imagesArray;
}

- (void)setDataSourceArray:(NSArray *)dataSourceArray {
    
    if (!dataSourceArray | ![dataSourceArray isKindOfClass:[NSArray class]] | !dataSourceArray.count) {
        return;
    }
    _dataSourceArray = dataSourceArray;
    _mainScrollView.userInteractionEnabled = YES;
    if (_dataSourceArray.count ==1) {
        _mainScrollView.scrollEnabled = NO;
        
    }else if (!_mainScrollView.scrollEnabled)
    {
        _mainScrollView.scrollEnabled = YES;
    }
    
    _currentPage = 0;
    self.pageControl.numberOfPages = _dataSourceArray.count;
    self.pageControl.currentPage = 0;
    CGFloat width = 17.0*self.dataSourceArray.count;
    _pageControl.frame = CGRectMake(kSCREEH_WIDHT- 12 - width, CGRectGetHeight(self.frame)-20, width, 20);
    
    self.pauseTimer = YES;
    self.pauseTimer = NO;
    [self updateImages];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.pauseTimer = YES;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self turnThePageWithOffsetX:scrollView.contentOffset.x];
    self.pauseTimer = NO;
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self turnThePageWithOffsetX:scrollView.contentOffset.x];
}

- (void)turnThePageWithOffsetX:(CGFloat)x {
    
    if (x > 0 && x < 2*kSCREEH_WIDHT) {
        return;
    }
    if (x <= 0) {
        self.currentPage = [self prePage];
    }else if (x >= 2*kSCREEH_WIDHT) {
        self.currentPage = [self sufPage];
    }
    [_mainScrollView setContentOffset:CGPointMake(kSCREEH_WIDHT, 0)];
    self.pageControl.currentPage = self.currentPage;
    [self updateImages];
}
- (void)updateImages{
    if (!_dataSourceArray.count) return;
    NSArray *pageArr = @[@([self prePage]), @(self.currentPage),@([self sufPage])];
    int index = 0;
    for (NSNumber *page in pageArr) {
        GMShufflingModel *model = _dataSourceArray[[page integerValue]];
        [self setAdImage:index andImageUrl:model.imageUrl];
        index ++;
    }
}

- (void)setAdImage:(NSInteger)page andImageUrl:(NSString *)imageUrl{
    if ([imageUrl containsString:@"http"]) {
        [self.imagesArray[page] sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@""]];
    }else {
        UIImageView *imageView = self.imagesArray[page];
        imageView.image = [UIImage imageNamed:imageUrl];
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

- (void)setPauseTimer:(BOOL)pauseTimer
{
    _pauseTimer = pauseTimer;
        if (pauseTimer) {
             [NSObject cancelPreviousPerformRequestsWithTarget:self];
            NSLog(@"暂停.");
        }else
        {
            [self performSelector:@selector(exchange:) withObject:nil afterDelay:kAfterDelay];
             NSLog(@"继续.");
        }
}

- (void)exchange:(BOOL)ret {
    [self performSelector:@selector(exchange:) withObject:nil afterDelay:kAfterDelay];
    [self.mainScrollView setContentOffset:CGPointMake(2*kSCREEH_WIDHT, 0) animated:YES];
    NSLog(@"交换");
}
- (void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    NSLog(@"dealloc----->>>%@<<<-----dealloc",[self class]);
}

@end

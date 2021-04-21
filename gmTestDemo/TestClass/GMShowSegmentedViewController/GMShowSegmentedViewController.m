//
//  YXMyCollectionViewController.m
//  YXP2pMoney
//
//  Created by Houhua Yan on 16/10/17.
//  Copyright © 2016年 yanhouhua. All rights reserved.
//

#import "GMShowSegmentedViewController.h"
#define RGB(r, g, b)   [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define RGBSimeValue(rgb)   [UIColor colorWithRed:rgb/255.0 green:rgb/255.0 blue:rgb/255.0 alpha:1.0]
#define rgba(r, g, b, a)  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define GMScreenW [UIScreen mainScreen].bounds.size.width
#define GMScreenH [UIScreen mainScreen].bounds.size.height


@interface GMSegmentedButton : UIControl
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) BOOL bSelected;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation GMSegmentedButton
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSegmentedButtonInternalUI];
        [self setting];
    }
    return self;
}
- (void)setting {
    self.bSelected = NO;
}
- (void)createSegmentedButtonInternalUI {
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:self.titleLabel];
    
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
}
- (void)setBSelected:(BOOL)bSelected {
    _bSelected = bSelected;
    [self changeTitleLabelState];
}

- (void)changeTitleLabelState {
    if (_bSelected) {
        self.titleLabel.textColor = rgba(91,153,238,1);
        self.titleLabel.font = [UIFont systemFontOfSize:15];
    }else{
        self.titleLabel.textColor = rgba(64,64,64,1);
        self.titleLabel.font = [UIFont systemFontOfSize:15];
    }
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

@end


@interface GMSegmentedControl : UIView

@property (nonatomic, copy) void(^segmentedControlButtonClickStateBlock)(BOOL click, NSInteger index);
@property (nonatomic, assign) CGFloat buttonWidth;
- (void)scrollViewDidEndDeceleratingChangeButtonIndex:(NSInteger)index;
- (void)scrollViewDidScrollchangeButtonTransform:(CGFloat)offset andIndex:(NSInteger)index;

@property (nonatomic, strong) NSMutableArray <GMSegmentedButton *>*buttonArray;
@property (nonatomic, strong) UIScrollView *backScrollView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) GMSegmentedButton *lastButton;
@property (nonatomic, assign) BOOL openSliding;
@end

@implementation GMSegmentedControl

- (instancetype)initWithFrame:(CGRect)frame andTitles:(NSArray *)titles  andButtonWidth:(CGFloat)width {
    if (self = [super initWithFrame:frame]) {
        self.buttonWidth = 0;
        self.openSliding = YES;
        [self createSegmentedControlInternalUIWithTitles:titles andButtonWidth:width];
    }
    return self;
}

- (void)createSegmentedControlInternalUIWithTitles:(NSArray *)titles andButtonWidth:(CGFloat)width {
    if (!titles.count) return;
    //    self.buttonWidth = width;
    
    CGFloat selfWidth = CGRectGetWidth(self.frame);
    CGFloat selfHeight = CGRectGetHeight(self.frame);
    self.backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, selfWidth, selfHeight)];
    self.backScrollView.backgroundColor = [UIColor clearColor];
    self.backScrollView.showsVerticalScrollIndicator = NO;
    self.backScrollView.showsHorizontalScrollIndicator = NO;
    self.backScrollView.bounces = NO;
    [self addSubview:self.backScrollView];
    
    CGFloat buttonW = GMScreenW/titles.count;
    if (width != 0 || titles.count*width>=selfWidth) buttonW = width;
    
    int i = 0;
    for (NSString *title in titles) {
        GMSegmentedButton *button = [GMSegmentedButton new];
        button.frame = CGRectMake(i*buttonW, 0, buttonW, selfHeight);
        button.index = i;
        [button setTitle:title];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.backScrollView addSubview:button];
        [self.buttonArray addObject:button];
        i++;
    }
    
    CGFloat lineTempHeight = 2;
    CGFloat margin = 29*3.0/selfWidth * buttonW;
    self.lineView = [[UIView alloc]initWithFrame:CGRectMake(0, selfHeight-lineTempHeight, buttonW, lineTempHeight)];
    self.lineView.backgroundColor = [UIColor clearColor];
    UIView *line = [[UIView alloc]init];
    line.frame = CGRectMake(margin, 0, CGRectGetWidth(self.lineView.frame)-2*margin, CGRectGetHeight(self.lineView.frame));
    line.backgroundColor = rgba(91,153,238,1);
    [self.lineView addSubview:line];
    [self.backScrollView addSubview:self.lineView];
    
    self.backScrollView.contentSize = CGSizeMake(CGRectGetMaxX([self.buttonArray lastObject].frame), self.backScrollView.contentSize.height);
    [self buttonClick:self.buttonArray[0]];
}

- (void)scrollViewDidScrollchangeButtonTransform:(CGFloat)offset andIndex:(NSInteger)index
{
    if(!self.openSliding) return;
    
    CGFloat lineOffset = CGRectGetWidth(self.lineView.frame)/CGRectGetWidth(self.frame)*1.0*offset;
    self.lineView.transform = CGAffineTransformMakeTranslation(lineOffset, 0);
}

- (void)scrollViewDidEndDeceleratingChangeButtonIndex:(NSInteger)index {
    if (index > self.buttonArray.count) return;
    [self buttonClick:self.buttonArray[index]];
    self.openSliding = YES;
}

- (void)buttonClick:(GMSegmentedButton *)sender {
    if (!sender) return;
    
    if(self.lastButton) self.openSliding = NO;
    BOOL click = (self.lastButton == sender);
    
    if (!click) {//不是同一个按钮
        sender.bSelected = YES;
        if (self.lastButton) self.lastButton.bSelected = NO;
        [self slidingAnimateWithView:sender];
        [self alignmentCenterWithselectedButton:sender];
        self.lastButton = sender;
    }
    
    if (self.segmentedControlButtonClickStateBlock) {
        self.segmentedControlButtonClickStateBlock(click,sender.index);
    }
}

- (void)slidingAnimateWithView:(GMSegmentedButton *)sender {
    NSInteger number = labs((sender.index - self.lastButton.index));
    [UIView animateWithDuration:0.35*(number+1)/3 animations:^{
        self.lineView.transform = CGAffineTransformMakeTranslation(sender.index * CGRectGetWidth(self.lineView.frame), 0);
    }];
}

- (void)alignmentCenterWithselectedButton:(GMSegmentedButton *)sender {
    CGFloat x = sender.center.x - CGRectGetWidth(self.frame)/2.0;
    if ((x + CGRectGetWidth(self.frame)) > self.backScrollView.contentSize.width) {
        x = self.backScrollView.contentSize.width - CGRectGetWidth(self.frame);
    }else if (x < 0 ){
        x = 0;
    }
    [self.backScrollView setContentOffset:CGPointMake(x, 0) animated:YES];
}

-(NSMutableArray<GMSegmentedButton *> *)buttonArray {
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}

@end
 
@interface GMShowSegmentedViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) GMSegmentedControl *segmentedControl;
@property (nonatomic, strong) UIScrollView *backScrollView;
@end

@implementation GMShowSegmentedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    NSArray *arr = @[@"新闻",@"帖子",@"动态",@"详情",@"账本",@"动态"];
    self.segmentedControl = [[GMSegmentedControl alloc]initWithFrame:CGRectMake(0, 0, GMScreenW, 40) andTitles:arr andButtonWidth:0];
    self.segmentedControl.backgroundColor =  [UIColor whiteColor];
    __weak __typeof (self) weakSelf = self;
    [self.segmentedControl setSegmentedControlButtonClickStateBlock:^(BOOL click, NSInteger index) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf segmentedControlClickSelectedButton:click andIndex:index
         ];
    }];
    [self.view addSubview:self.segmentedControl];
    
    CGFloat tempWidth = GMScreenW;
    CGFloat tempHeight = GMScreenH - 64 - CGRectGetHeight(self.segmentedControl.frame);
    self.backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.segmentedControl.frame), tempWidth, tempHeight)];
    self.backScrollView.backgroundColor = [UIColor greenColor];
    self.backScrollView.showsVerticalScrollIndicator = NO;
    self.backScrollView.showsHorizontalScrollIndicator = NO;
    //    self.backScrollView.bounces = NO;
    self.backScrollView.pagingEnabled = YES;
    self.backScrollView.delegate = self;
    [self.view addSubview:self.backScrollView];
    
    for (int i = 0; i < arr.count; i ++) {
        UITableViewController *subViewController = [[UITableViewController alloc]init];
        subViewController.view.frame = CGRectMake(i*GMScreenW, 0, CGRectGetWidth(self.backScrollView.frame), CGRectGetHeight(self.backScrollView.frame));
        [self.backScrollView addSubview:subViewController.view];
        [self addChildViewController:subViewController];
    }
    self.backScrollView.contentSize = CGSizeMake(arr.count * CGRectGetWidth(self.backScrollView.frame), CGRectGetHeight(self.backScrollView.frame));
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //    NSLog(@"%f",scrollView.contentOffset.x);
    NSInteger index = scrollView.contentOffset.x/scrollView.frame.size.width;
    [self.segmentedControl scrollViewDidScrollchangeButtonTransform:scrollView.contentOffset.x andIndex:index];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x/scrollView.frame.size.width;
    [self.segmentedControl scrollViewDidEndDeceleratingChangeButtonIndex:index];
    NSLog(@"%s",__func__);
}

- (void)segmentedControlClickSelectedButton:(BOOL)click andIndex:(NSInteger)index {
    NSLog(@"%s",__func__);
    if (click) {
    }else {
        [self.backScrollView setContentOffset:CGPointMake(index*CGRectGetWidth(self.backScrollView.frame), 0) animated:YES];
        [self RefreshCurrentTableviewDataWithIndex:index];
    }
}
- (void)RefreshCurrentTableviewDataWithIndex:(NSInteger)index { }


@end

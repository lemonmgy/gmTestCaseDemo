//
//  YXMyCollectionViewController.m
//  YXP2pMoney
//
//  Created by Houhua Yan on 16/10/17.
//  Copyright © 2016年 yanhouhua. All rights reserved.
//

#import "YXMyCollectionViewController.h"

@interface SMYSegmentedButton : UIControl

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) BOOL bSelected;



@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation SMYSegmentedButton


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


@interface SMYSegmentedControl : UIView

@property (nonatomic, copy) void(^segmentedControlButtonClickStateBlock)(BOOL click, NSInteger index);
@property (nonatomic, assign) CGFloat buttonWidth;
- (void)scrollViewDidEndDeceleratingChangeButtonIndex:(NSInteger)index;
- (void)scrollViewDidScrollchangeButtonTransform:(CGFloat)offset andIndex:(NSInteger)index;

@property (nonatomic, strong) NSMutableArray <SMYSegmentedButton *>*buttonArray;
@property (nonatomic, strong) UIScrollView *backScrollView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) SMYSegmentedButton *lastButton;
@property (nonatomic, assign) BOOL openSliding;
@end

@implementation SMYSegmentedControl

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
    
    CGFloat buttonW = YXScreenW/titles.count;
    if (width != 0 || titles.count*width>=selfWidth) buttonW = width;
    
    int i = 0;
    for (NSString *title in titles) {
        SMYSegmentedButton *button = [SMYSegmentedButton new];
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

- (void)buttonClick:(SMYSegmentedButton *)sender {
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

- (void)slidingAnimateWithView:(SMYSegmentedButton *)sender {
    NSInteger number = labs((sender.index - self.lastButton.index));
    [UIView animateWithDuration:0.35*(number+1)/3 animations:^{
        self.lineView.transform = CGAffineTransformMakeTranslation(sender.index * CGRectGetWidth(self.lineView.frame), 0);
    }];
}

- (void)alignmentCenterWithselectedButton:(SMYSegmentedButton *)sender {
    CGFloat x = sender.center.x - CGRectGetWidth(self.frame)/2.0;
    if ((x + CGRectGetWidth(self.frame)) > self.backScrollView.contentSize.width) {
        x = self.backScrollView.contentSize.width - CGRectGetWidth(self.frame);
    }else if (x < 0 ){
        x = 0;
    }
    [self.backScrollView setContentOffset:CGPointMake(x, 0) animated:YES];
}

-(NSMutableArray<SMYSegmentedButton *> *)buttonArray {
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}

@end


@interface SMYViewController: UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SMYViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    //    RGB(arc4random()%255, arc4random()%255, arc4random()%255);
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)loadView {
    [super loadView];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = [UIView new];
    self.view = self.tableView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"123123123"];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

@end


@interface YXMyCollectionViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) SMYSegmentedControl *segmentedControl;
@property (nonatomic, strong) UIScrollView *backScrollView;

@end

@implementation YXMyCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    NSArray *arr = @[@"新闻",@"帖子",@"动态",@"详情",@"账本",@"动态"];
    self.segmentedControl = [[SMYSegmentedControl alloc]initWithFrame:CGRectMake(0, 0, YXScreenW, 40) andTitles:arr andButtonWidth:0];
    self.segmentedControl.backgroundColor =  [UIColor whiteColor];
    __weak __typeof (self) weakSelf = self;
    [self.segmentedControl setSegmentedControlButtonClickStateBlock:^(BOOL click, NSInteger index) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf segmentedControlClickSelectedButton:click andIndex:index
         ];
    }];
    [self.view addSubview:self.segmentedControl];
    
    CGFloat tempWidth = YXScreenW;
    CGFloat tempHeight = YXScreenH - 64 - CGRectGetHeight(self.segmentedControl.frame);
    self.backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.segmentedControl.frame), tempWidth, tempHeight)];
    self.backScrollView.backgroundColor = [UIColor greenColor];
    self.backScrollView.showsVerticalScrollIndicator = NO;
    self.backScrollView.showsHorizontalScrollIndicator = NO;
    //    self.backScrollView.bounces = NO;
    self.backScrollView.pagingEnabled = YES;
    self.backScrollView.delegate = self;
    [self.view addSubview:self.backScrollView];
    
    for (int i = 0; i < arr.count; i ++) {
        SMYViewController *subViewController = [[SMYViewController alloc]init];
        subViewController.view.frame = CGRectMake(i*YXScreenW, 0, CGRectGetWidth(self.backScrollView.frame), CGRectGetHeight(self.backScrollView.frame));
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
- (void)RefreshCurrentTableviewDataWithIndex:(NSInteger)index {
    
    
    
}


@end

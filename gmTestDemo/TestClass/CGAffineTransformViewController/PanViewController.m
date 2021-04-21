//
//  CGAffineTransformViewController.m
//  test
//
//  Created by lemonmgy on 16/10/27.
//  Copyright © 2016年 lemonmgy. All rights reserved.
//

#import "PanViewController.h"
#import "PanTableView.h"

static NSString *dataArrID = @"dataArrIDTableViewCellid";
static NSString *lastDataArrID = @"lastDataArrIDTableViewCellid";
static BOOL openPan = NO;

@interface PanViewController ()<UITableViewDelegate,UITableViewDataSource, PanTableViewDelegate>{
    CGFloat _lastX;
    NSMutableDictionary *_faImageViewDict;
}


@property (nonatomic, strong) PanTableView *panTableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *lastDataArr;
@property (nonatomic, strong) UIImageView *faImageView;
@property (nonatomic, strong) UIImageView *nextImageView;

@property (nonatomic, assign) BOOL currentIndex;

@end

@implementation PanViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.topItemNameArr = (NSMutableArray *)@[@"0",@"1",@"2",@"3"];
    _faImageViewDict = [NSMutableDictionary dictionaryWithCapacity:2];
    [self settingUI];
    [self getData];
}
- (void)topButtonClick:(UIBarButtonItem *)sender
{
    self.currentIndex = !self.currentIndex;
    [self.panTableView reloadData];
}

- (void)settingUI{
    self.panTableView = [[PanTableView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT-64) style:UITableViewStylePlain];
    self.panTableView.delegate = self;
    self.panTableView.dataSource = self;
    self.panTableView.touchDelegate = self;
    self.panTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:self.panTableView];
    [self.view addSubview:self.faImageView];
    [self.view addSubview:self.nextImageView];
    [self.view bringSubviewToFront:self.panTableView];
}


- (void)getData
{
    for (NSInteger i = 0; i < 120; ++i) {
        NSString *age = [NSString stringWithFormat:@"%ld",(long)i];
        NSDictionary*dict = @{@"name":@"聚金资本分析师",@"age":age};
        [self.dataArr addObject:dict];
    }
    
    
    for (NSInteger i = 0; i < 120; ++i) {
        NSString *age = [NSString stringWithFormat:@"%ld",(long)i];
        NSDictionary*dict = @{@"name":@"小剑客",@"age":age,@"icon":@"moren.jpeg"};
        [self.lastDataArr addObject:dict];
    }
    [self.panTableView reloadData];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.currentIndex ? self.lastDataArr.count:self.dataArr.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return self.currentIndex ? 60:40;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    if (self.currentIndex) {
        
       cell = [tableView dequeueReusableCellWithIdentifier:lastDataArrID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:lastDataArrID];
        }
        cell.textLabel.text = self.lastDataArr[indexPath.row][@"name"];
        cell.detailTextLabel.text = self.lastDataArr[indexPath.row][@"age"];
        cell.imageView.image = [UIImage imageNamed:self.lastDataArr[indexPath.row][@"icon"]];
        cell.backgroundColor = [UIColor orangeColor];
    }
    else
    {
        
        cell = [tableView dequeueReusableCellWithIdentifier:dataArrID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:dataArrID];
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
            btn.backgroundColor = [UIColor purpleColor];
            btn.frame = CGRectMake(kSCREEN_WIDTH-150, 0, 150, 40);
//            [cell.contentView addSubview:btn];
//            [btn addTarget: self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
            
            UIImageView *imview = [UIImageView new];
            imview.backgroundColor = [UIColor grayColor];
            imview.frame = CGRectMake(0, 0, 150, 40);
//            [cell.contentView addSubview:imview];
            imview.userInteractionEnabled = YES;
//            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
//            [imview addGestureRecognizer:tap];
        }
        cell.textLabel.text = self.dataArr[indexPath.row][@"name"];
        cell.detailTextLabel.text = self.dataArr[indexPath.row][@"age"];
        cell.backgroundColor = [UIColor greenColor];
    }

    return cell;
    
}
- (void)btnClick {
    
}
- (void)tapClick {
    NSLog(@"tapClick");
}

//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    [BaseViewController show:@"didSelectRow"];
//}

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray arrayWithCapacity:10];
    }
    return _dataArr;
}

- (NSMutableArray *)lastDataArr{
    if (!_lastDataArr) {
        _lastDataArr = [NSMutableArray arrayWithCapacity:10];
    }
    return _lastDataArr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//
- (void)tableView:(UITableView *)tableView touchesBegan:(UIPanGestureRecognizer *)pan {
      //NSLog(@"%s",__func__);
    self.faImageView.image = _faImageViewDict[@"lastImage"];
    self.nextImageView.image =  _faImageViewDict[@"lastImage"];
    self.nextImageView.hidden = NO;
    self.faImageView.hidden = NO;
    UIImage *lastImage = [self screenView:self.view];
    [_faImageViewDict setObject:lastImage forKey:@"currentImage"];
    
    NSNumber *currentindexPath = [NSNumber numberWithFloat:[self.panTableView contentOffset].y];
    [_faImageViewDict setObject:currentindexPath forKey:@"currentindexPath"];
    
    CGPoint touchPoint = [pan translationInView:tableView];
    _lastX = touchPoint.x;
//    self.panTableView.scrollEnabled = NO;
}

- (void)tableView:(UITableView *)tableView touchesCancelled:(UIPanGestureRecognizer *)pan {
      //NSLog(@"%s",__func__);
    [self tableView:tableView touchesEnded:pan];
    
}

- (void)tableView:(UITableView *)tableView touchesEnded:(UIPanGestureRecognizer *)pan {
      //NSLog(@"%s",__func__);
    CGPoint touchPoint = [pan translationInView:tableView];
    CGFloat offset = touchPoint.x - _lastX;
    BOOL ret = fabs(offset) > kSCREEN_WIDTH*2/5.0;
//    NSLog(@"%ff   %ff",self.nextImageView.transform.tx,self.panTableView.transform.tx);
    if (ret) {
        CGFloat time = 0.3*fabs(offset)/(kSCREEN_WIDTH*2/5.0);

        id obj = _faImageViewDict[@"currentImage"];
        obj?[_faImageViewDict setObject:obj forKey:@"lastImage"]:@"";
        
        [UIView animateWithDuration:time animations:^{
            if (offset > 0) {
                
                self.panTableView.transform = CGAffineTransformMakeTranslation(kSCREEN_WIDTH, 0);
                 self.faImageView.transform = CGAffineTransformMakeTranslation(kSCREEN_WIDTH, 0);
                
            }else {
                self.panTableView.transform = CGAffineTransformMakeTranslation(-kSCREEN_WIDTH, 0);
                self.nextImageView.transform = CGAffineTransformMakeTranslation(-kSCREEN_WIDTH, 0);;

            }
            
        } completion:^(BOOL finished) {
            
            
            self.currentIndex = !self.currentIndex;
            [self.panTableView reloadData];
            [self complate];
            
            openPan = YES;
            NSNumber *lastindexPath = self->_faImageViewDict[@"lastindexPath"];
            if (lastindexPath) {
                
                [self.panTableView setContentOffset:CGPointMake(0, [lastindexPath floatValue]) animated:NO];
            }else {
                [self.panTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];

            }
            
            
            id obj2 = self->_faImageViewDict[@"currentindexPath"];
            obj2 ? [self->_faImageViewDict setObject:obj2 forKey:@"lastindexPath"]:@"";

        }];
    } else {
        CGFloat time = 0.3*fabs(offset)/(kSCREEN_WIDTH*3/5.0);

        [UIView animateWithDuration:time animations:^{
            self.panTableView.transform = CGAffineTransformIdentity;
            self.faImageView.transform = CGAffineTransformIdentity;
            self.nextImageView.transform = CGAffineTransformIdentity;

         } completion:^(BOOL finished) {
            
            [self complate];
        }];

    }

}

- (void)complate {
    
    self.panTableView.transform = CGAffineTransformIdentity;
    self.faImageView.transform = CGAffineTransformIdentity;
    self.nextImageView.transform = CGAffineTransformIdentity;
//    self.panTableView.scrollEnabled = YES;
    self.nextImageView.hidden = YES;
    self.faImageView.hidden = YES;
//      self.panTableView 
}

- (void)tableView:(UITableView *)tableView touchesMoved:(UIPanGestureRecognizer *)pan {
  //NSLog(@"%s",__func__);
    CGPoint touchPoint = [pan translationInView:tableView];
//    NSLog(@"touchPoint.x == %ff    timestamp = %f",touchPoint.x,touch.timestamp);
    CGFloat offset = touchPoint.x - _lastX;
    //    NSLog(@"%ff",offset);
    CGPoint velocity = [pan velocityInView:tableView];
    CGFloat vx = fabs(velocity.x);
//    NSLog(@"x==%f      y==%f",[pan velocityInView:tableView].x,[pan velocityInView:tableView].y);
    
//    if ((fabs(offset) < 100 && vx > 500)) {
//        NSLog(@"fabs(offset) < 100 &&vx > 500");
//    }else if ((fabs(offset) > 100 && vx > 500)){
//        
//    }else if (fabs(offset) > 100&& vx < 500){
//        
//        
//        NSLog(@" (fabs(offset) > 100)");
//    }else if (fabs(offset) < 100&& vx < 500){
//        
//    }else {
    //        return;
    //    }
    if ((fabs(offset) < 30 && vx > 700)) {
        
        CGFloat time = 1;
        
        id obj = _faImageViewDict[@"currentImage"];
        obj?[_faImageViewDict setObject:obj forKey:@"lastImage"]:@"";
        
        [UIView animateWithDuration:time animations:^{
            if (offset > 0) {
                
                self.panTableView.transform = CGAffineTransformMakeTranslation(kSCREEN_WIDTH, 0);
                self.faImageView.transform = CGAffineTransformMakeTranslation(kSCREEN_WIDTH, 0);
                
            }else {
                self.panTableView.transform = CGAffineTransformMakeTranslation(-kSCREEN_WIDTH, 0);
                self.nextImageView.transform = CGAffineTransformMakeTranslation(-kSCREEN_WIDTH, 0);;
                
            }
            
        } completion:^(BOOL finished) {
            
            
            self.currentIndex = !self.currentIndex;
            [self.panTableView reloadData];
            [self complate];
            
            openPan = YES;
            NSNumber *lastindexPath = self->_faImageViewDict[@"lastindexPath"];
            if (lastindexPath) {
                [self.panTableView setContentOffset:CGPointMake(0, [lastindexPath floatValue]) animated:NO];
            }else {
                [self.panTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                
            }
            
            
            id obj2 = self->_faImageViewDict[@"currentindexPath"];
            obj2 ? [self->_faImageViewDict setObject:obj2 forKey:@"lastindexPath"]:@"";
            
        }];
        
    } else if (fabs(offset) < 30) return;
    
    self.panTableView.transform = CGAffineTransformMakeTranslation(offset, 0);
    
    self.nextImageView.transform = CGAffineTransformMakeTranslation(offset, 0);
    
    self.faImageView.transform = CGAffineTransformMakeTranslation(offset, 0);
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"%s",__func__);
    self.panTableView.myPan.enabled = NO;
    if (openPan) {
        self.panTableView.myPan.enabled = YES;
    }
    openPan = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"%s",__func__);
    self.panTableView.myPan.enabled = YES;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset NS_AVAILABLE_IOS(5_0);
{
    NSLog(@"%s",__func__);
    self.panTableView.myPan.enabled = YES;
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    NSLog(@"%s",__func__);
    self.panTableView.myPan.enabled = YES;
}

- (UIImage*)screenView:(UIView *)view{
    CGRect rect = view.frame;
//    UIGraphicsBeginImageContext(rect.size);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
- (UIImageView *)faImageView {
    if (!_faImageView) {
        _faImageView = [[UIImageView alloc]initWithFrame:CGRectMake(-CGRectGetWidth(self.panTableView.frame), 0, CGRectGetWidth(self.panTableView.frame), CGRectGetHeight(self.panTableView.frame))];
        _faImageView.hidden = YES;
        _faImageView.backgroundColor = [UIColor redColor];
    }
    return _faImageView;
}


- (UIImageView *)nextImageView {
    if (!_nextImageView) {
        _nextImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.panTableView.frame), 0, CGRectGetWidth(self.panTableView.frame), CGRectGetHeight(self.panTableView.frame))];
        _nextImageView.backgroundColor = [UIColor greenColor];
        _nextImageView.hidden = YES;
    }
    return _nextImageView;
}
@end

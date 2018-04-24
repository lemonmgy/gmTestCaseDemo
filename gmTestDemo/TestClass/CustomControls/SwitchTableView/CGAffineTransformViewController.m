//
//  CGAffineTransformViewController.m
//  test
//
//  Created by lemonmgy on 16/10/27.
//  Copyright © 2016年 lemonmgy. All rights reserved.
//

#import "CGAffineTransformViewController.h"
#import "TouchTableView.h"
#import "MYButton.h"
static NSString *dataArrID = @"dataArrIDTableViewCellid";
static NSString *lastDataArrID = @"lastDataArrIDTableViewCellid";

@interface CGAffineTransformViewController ()<TouchTableViewDelegate,UITableViewDelegate,UITableViewDataSource>{
    CGFloat _lastX;
    NSMutableDictionary *_faImageViewDict;
}


@property (nonatomic, strong) TouchTableView *touchTableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *lastDataArr;
@property (nonatomic, strong) UIImageView *faImageView;
@property (nonatomic, strong) UIImageView *nextImageView;

@property (nonatomic, assign) BOOL currentIndex;

@end

@implementation CGAffineTransformViewController

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
    [self.touchTableView reloadData];
}
- (void)settingUI{
    self.touchTableView = [[TouchTableView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT-64) style:UITableViewStylePlain];
    self.touchTableView.delegate = self;
    self.touchTableView.dataSource = self;
    self.touchTableView.touchDelegate = self;
    self.touchTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:self.touchTableView];
    [self.view addSubview:self.faImageView];
    [self.view addSubview:self.nextImageView];
    [self.view bringSubviewToFront:self.touchTableView];
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
    [self.touchTableView reloadData];
}


- (NSInteger)tableView:(TouchTableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.currentIndex ? self.lastDataArr.count:self.dataArr.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return self.currentIndex ? 60:40;
}
- (UITableViewCell *)tableView:(TouchTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
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
            MYButton *btn = [MYButton buttonWithType:UIButtonTypeSystem];
            btn.backgroundColor = [UIColor purpleColor];
            btn.frame = CGRectMake(kSCREEN_WIDTH-150, 0, 150, 40);
            [cell.contentView addSubview:btn];
//            [btn addTarget: self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
            
            UIImageView *imview = [UIImageView new];
            imview.backgroundColor = [UIColor grayColor];
            imview.frame = CGRectMake(0, 0, 150, 40);
            [cell.contentView addSubview:imview];
            imview.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
            [imview addGestureRecognizer:tap];
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
- (void)tableView:(UITableView *)tableView touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.faImageView.image = _faImageViewDict[@"lastImage"];
    self.nextImageView.image =  _faImageViewDict[@"lastImage"];
    self.nextImageView.hidden = NO;
    self.faImageView.hidden = NO;
    UIImage *lastImage = [self screenView:self.view];
    [_faImageViewDict setObject:lastImage forKey:@"currentImage"];
    
    NSNumber *currentindexPath = [NSNumber numberWithFloat:[self.touchTableView contentOffset].y];
    [_faImageViewDict setObject:currentindexPath forKey:@"currentindexPath"];
    
     UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.view];
    _lastX = touchPoint.x;
    self.touchTableView.scrollEnabled = NO;
}
- (void)tableView:(UITableView *)tableView touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self tableView:tableView touchesEnded:touches withEvent:event];
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    self.touchTableView.decelerationRate
//    NSLog(@"%f",self.touchTableView.decelerationRate);
}
- (void)tableView:(UITableView *)tableView touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.view];
    CGFloat offset = touchPoint.x - _lastX;
    BOOL ret = fabs(offset) > kSCREEN_WIDTH*2/5.0;
//    NSLog(@"%ff   %ff",self.nextImageView.transform.tx,self.touchTableView.transform.tx);
    if (ret) {
        CGFloat time = 0.3*fabs(offset)/(kSCREEN_WIDTH*2/5.0);

        id obj = _faImageViewDict[@"currentImage"];
        obj?[_faImageViewDict setObject:obj forKey:@"lastImage"]:@"";
        
        [UIView animateWithDuration:time animations:^{
            if (offset > 0) {
                
                self.touchTableView.transform = CGAffineTransformMakeTranslation(kSCREEN_WIDTH, 0);
                 self.faImageView.transform = CGAffineTransformMakeTranslation(kSCREEN_WIDTH, 0);
                
            }else {
                self.touchTableView.transform = CGAffineTransformMakeTranslation(-kSCREEN_WIDTH, 0);
                self.nextImageView.transform = CGAffineTransformMakeTranslation(-kSCREEN_WIDTH, 0);;

            }
            
        } completion:^(BOOL finished) {
            
            
            self.currentIndex = !self.currentIndex;
            [self.touchTableView reloadData];
            [self complate];
            
            
            NSNumber *lastindexPath = self->_faImageViewDict[@"lastindexPath"];
            if (lastindexPath) {
                
                [self.touchTableView setContentOffset:CGPointMake(0, [lastindexPath floatValue])];
            }else {
                [self.touchTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];

            }
            
            
            id obj2 = self->_faImageViewDict[@"currentindexPath"];
            obj2 ? [self->_faImageViewDict setObject:obj2 forKey:@"lastindexPath"]:@"";

        }];
    } else {
        CGFloat time = 0.3*fabs(offset)/(kSCREEN_WIDTH*3/5.0);

        [UIView animateWithDuration:time animations:^{
            self.touchTableView.transform = CGAffineTransformIdentity;
            self.faImageView.transform = CGAffineTransformIdentity;
            self.nextImageView.transform = CGAffineTransformIdentity;

         } completion:^(BOOL finished) {
            
            [self complate];
        }];

    }

}

- (void)complate {
 
    self.touchTableView.transform = CGAffineTransformIdentity;
    self.faImageView.transform = CGAffineTransformIdentity;
    self.nextImageView.transform = CGAffineTransformIdentity;
    self.touchTableView.scrollEnabled = YES;
    self.nextImageView.hidden = YES;
    self.faImageView.hidden = YES;
}

- (void)tableView:(UITableView *)tableView touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.view];
//    NSLog(@"touchPoint.x == %ff    timestamp = %f",touchPoint.x,touch.timestamp);
    CGFloat offset = touchPoint.x - _lastX;
//    NSLog(@"%ff",offset);
//    if (fabs(offset) < 20)  return;
    self.touchTableView.transform = CGAffineTransformMakeTranslation(offset, 0);
    
    self.nextImageView.transform = CGAffineTransformMakeTranslation(offset, 0);
    
    self.faImageView.transform = CGAffineTransformMakeTranslation(offset, 0);
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
        _faImageView = [[UIImageView alloc]initWithFrame:CGRectMake(-CGRectGetWidth(self.touchTableView.frame), 0, CGRectGetWidth(self.touchTableView.frame), CGRectGetHeight(self.touchTableView.frame))];
        _faImageView.hidden = YES;
        _faImageView.backgroundColor = [UIColor redColor];
    }
    return _faImageView;
}


- (UIImageView *)nextImageView {
    if (!_nextImageView) {
        _nextImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.touchTableView.frame), 0, CGRectGetWidth(self.touchTableView.frame), CGRectGetHeight(self.touchTableView.frame))];
        _nextImageView.backgroundColor = [UIColor greenColor];
        _nextImageView.hidden = YES;
    }
    return _nextImageView;
}
@end

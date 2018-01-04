//
//  GMGCDViewController.m
//  gmTestDemo
//
//  Created by lemonmgy on 2018/1/2.
//  Copyright © 2018年 lemonmgy. All rights reserved.
//

#import "GMGCDViewController.h"

static NSString *idn = @"UICollectionViewCellID";

@interface GMGCDViewController () <UICollectionViewDelegate,
    UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout> {
    dispatch_semaphore_t _sema;
}
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) int tickets;
@end

@implementation GMGCDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 5;
    layout.itemSize = CGSizeMake(kSCREEN_WIDTH, 50);
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT-64) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor brownColor];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    
    
    [self.view addSubview:self.collectionView];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:idn];
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:idn forIndexPath:indexPath];
    UILabel *label = [cell.contentView viewWithTag:2000];
    if (!label) {
        label = [UILabel new];
        label.frame = cell.bounds;
        label.backgroundColor = [UIColor greenColor];
        label.tag = 2000;
        label.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:label];
    }
    
    label.text = self.dataArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *methodStr = self.dataArray[indexPath.row];
    SEL sel = NSSelectorFromString(methodStr);
    if ([self respondsToSelector:sel]) {
        [self performSelectorOnMainThread:sel withObject:nil waitUntilDone:YES];
    }else {
        kShowAlert(@"没有实现这个方法");
    }
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithArray:[self titles]];
    }
    return _dataArray;
}

- (NSArray *)titles {
    return @[@"dispatch_queue",@"dispatch_semaphore",@"asyncSaleTickets",@"线程2",@"bar2",@"bars3",@"线程3",@"bar4",@"bars5"];
}

- (void)dispatch_queue {
   
    dispatch_queue_t serial_queue = dispatch_queue_create("com.lemonmgy.serial", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t concurrent_queue = dispatch_queue_create("com.lemonmgy.concurrent", DISPATCH_QUEUE_CONCURRENT);
}

- (void)dispatch_semaphore {
    kShowAlert(@"dispatch_queue");
    
    dispatch_queue_t queue_t =  dispatch_queue_create("com.lemonmgy.queue", DISPATCH_QUEUE_CONCURRENT);
    
    {
        
    }
    
    dispatch_semaphore_t sema = dispatch_semaphore_create(1);
    
    dispatch_async(queue_t, ^{
        
        dispatch_async(queue_t, ^{
            NSLog(@"111");
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
            
            sleep(3);
            NSLog(@"111睡醒了");
            dispatch_semaphore_signal(sema);
        });
        
        dispatch_async(queue_t, ^{
            NSLog(@"222");
            
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
            
            sleep(3);
            NSLog(@"222222waiceng睡醒了");
            dispatch_semaphore_signal(sema);
        });
        dispatch_async(queue_t, ^{
            NSLog(@"33333333");
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
            
            NSLog(@"3333333waiceng睡醒了");
            dispatch_semaphore_signal(sema);
        });
        
        dispatch_async(queue_t, ^{
            NSLog(@"444444444");
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
            
            NSLog(@"4444444444waiceng睡醒了");
            dispatch_semaphore_signal(sema);
        });
        dispatch_async(queue_t, ^{
            NSLog(@"xxxxxxxxxzczxcxzczxc");
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
            NSLog(@"xxxxxxxx=%@",[NSThread currentThread]);
            dispatch_semaphore_signal(sema);
        });
        
    });

}


- (void)asyncSaleTickets {
    dispatch_queue_t concurrent_queue = dispatch_queue_create("com.lemonmgy.concurrent", DISPATCH_QUEUE_CONCURRENT);
    self.tickets = 100;
    if (!_sema) {
        _sema = dispatch_semaphore_create(1);

    }
    [self cycleNumber:10 handler:^(int number) {
        dispatch_async(concurrent_queue, ^{
            [self saleTickets];
        });
    }];

}


- (void)saleTickets
{
    // while 循环保证每个窗口都可以单独把所有的票卖完
    while (YES) {
        
        // 模拟网络延迟
        [self semaphoreWaitHandler:^{
            [NSThread sleepForTimeInterval:0.5];
            // 判断是否有票
            if (self.tickets>0) {
                // 有票就卖
                self.tickets--;
                // 卖完一张票就提示用户余票数
                NSLog(@"剩余票数 => %zd %@",self.tickets,[NSThread currentThread]);
            }
            
        }];
        if (self.tickets<=0) {
            // 没有就提示用户
            NSLog(@"没票了");
            // 此处要结束循环,不然会死循环
            break;
        }
    }
}





- (void)semaphoreWaitHandler:(void(^)(void))handler {
    dispatch_semaphore_wait(_sema, DISPATCH_TIME_FOREVER);
    if(handler) handler();
    dispatch_semaphore_signal(_sema);
}





- (void)cycleNumber:(int)number handler:(void(^)(int number))handler {
    int i = 0;
    while (i < number) {
        handler(i);
        i++;
    }
}
@end

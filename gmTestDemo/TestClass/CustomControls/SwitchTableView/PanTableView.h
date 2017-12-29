//
//  MYTableView.h
//  apiData
//
//  Created by lemonmgy on 2016/11/22.
//  Copyright © 2016年 lemonmgy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PanTableViewDelegate <NSObject>
@optional
- (void)tableView:(UITableView *)tableView touchesBegan:(UIPanGestureRecognizer *)pan;
- (void)tableView:(UITableView *)tableView touchesCancelled:(UIPanGestureRecognizer *)pan;
- (void)tableView:(UITableView *)tableView touchesEnded:(UIPanGestureRecognizer *)pan;
- (void)tableView:(UITableView *)tableView touchesMoved:(UIPanGestureRecognizer *)pan;

@end

@interface PanTableView : UITableView
@property (nonatomic,weak) id<PanTableViewDelegate> touchDelegate;
@property (nonatomic, strong)UIPanGestureRecognizer *myPan;
@end

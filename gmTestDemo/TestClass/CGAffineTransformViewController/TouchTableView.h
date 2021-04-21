//
//  MYTableView.h
//  apiData
//
//  Created by lemonmgy on 2016/11/22.
//  Copyright © 2016年 lemonmgy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TouchTableViewDelegate <NSObject>
@optional
- (void)tableView:(UITableView *)tableView touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)tableView:(UITableView *)tableView touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)tableView:(UITableView *)tableView touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

- (void)tableView:(UITableView *)tableView touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;

@end
@interface TouchTableView : UITableView
@property (nonatomic,weak) id<TouchTableViewDelegate> touchDelegate;

@end

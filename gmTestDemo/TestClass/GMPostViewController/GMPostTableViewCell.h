//
//  GMPostTableViewCell.h
//  test
//
//  Created by lemonmgy on 2017/1/20.
//  Copyright © 2017年 lemonmgy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GMIconModel : NSObject
@property (nonatomic, assign) CGRect iconRect;
@property (nonatomic, copy) NSString *bigIconUrl;
@property (nonatomic, copy) NSString *smallIconUrl;
@end

@interface CellModel : NSObject
@property (nonatomic, strong) NSMutableArray <GMIconModel *>*iconModelArr;
@property (nonatomic, assign) CGFloat cellH;
@end

@interface GMPostTableViewCell : UITableViewCell
@property (nonatomic, strong) CellModel *model;
@property (nonatomic, strong) NSMutableArray *iconArray;
@property (nonatomic, copy) BOOL (^myBlock)(UIView * clickView, CellModel *model);
@end

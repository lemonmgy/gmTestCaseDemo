//
//  GMPictureSwitchView.h
//
//  Created by lemonmgy on 2016/11/14.
//

#import <UIKit/UIKit.h>
@class GMIconItem;

typedef enum : NSUInteger {
    GMShufflingBlockTypeWithExit,
    GMShufflingBlockTypeWithSwitch,
} GMShufflingBlockType;

typedef void(^GMShufflingBlock)(GMIconItem *obj, NSInteger currentIndex, GMShufflingBlockType type);


@interface GMPictureSwitchView : UIView
@property (nonatomic, strong) UIScrollView *imageScrollView;
@property (nonatomic, copy) GMShufflingBlock shufflingCallBackBlock;
- (void)refreshDataSource:(NSArray *)dataSourceArray currentIndex:(NSInteger)currentIndex;
@end


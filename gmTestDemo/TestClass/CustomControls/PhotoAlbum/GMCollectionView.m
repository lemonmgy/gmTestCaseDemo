//
//  GMCollectionView.m
//  test
//
//  Created by lemonmgy on 2016/11/18.
//  Copyright © 2016年 lemonmgy. All rights reserved.
//

#import "GMCollectionView.h"

@implementation GMCollectionView


- (void)layoutSubviews {
    [super layoutSubviews];
    return;
//    if (self.contentSize.height > [[UIScreen mainScreen] bounds].size.height) {
//        [self scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
//        // 展示图片数
//        self.contentOffset = CGPointMake(self.contentOffset.x, -self.contentInset.top);
//    }
}

@end

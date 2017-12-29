//
//  GMPhotosCollectionViewCell.m
//  test
//
//  Created by lemonmgy on 2016/11/17.
//  Copyright © 2016年 lemonmgy. All rights reserved.
//

#import "GMPhotosCollectionViewCell.h"
NSString *GMPhotosCollectionViewCellID = @"GMPhotosCollectionViewCellID";
@implementation GMPhotosCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.imageView = [[UIImageView alloc]init];
        self.imageView.image = [UIImage imageNamed:@"moren.jpeg"];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}
@end

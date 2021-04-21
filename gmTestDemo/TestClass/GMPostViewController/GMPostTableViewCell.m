//
//  GMPostTableViewCell.m
//  test
//
//  Created by lemonmgy on 2017/1/20.
//  Copyright © 2017年 lemonmgy. All rights reserved.
//

#import "GMPostTableViewCell.h"
#import "GMIconItem.h"

@implementation GMIconModel
@end
@implementation CellModel
@end

@interface GMPostTableViewCell()

@end
@implementation GMPostTableViewCell

- (void)setFrame:(CGRect)frame {
    CGRect rect = frame;
    rect.size.height = frame.size.height - 10;
    [super setFrame:rect];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self customUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)customUI
{
    
    self.iconArray = [NSMutableArray new];
    for (int i = 0; i < 9; i++) {
        UIImageView * icon = [self getImageView];
        icon.tag = i;
        icon.frame = CGRectMake(0, 0, 100, 100);
        [self.iconArray addObject:icon];
    }
}

- (UIImageView *)getImageView {
    UIImageView * icon = [UIImageView new];
    icon.userInteractionEnabled = YES;
    icon.backgroundColor = [UIColor redColor];
    icon.contentMode = UIViewContentModeScaleAspectFill;
    icon.layer.masksToBounds = YES;
    [self.contentView addSubview:icon];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    [icon addGestureRecognizer:tap];
    return icon;
}

- (void)tapClick:(UITapGestureRecognizer *)tap {
    BOOL ret = NO;
    if (self.myBlock) {
        ret = self.myBlock(tap.view,self.model);
    }
}

- (void)setModel:(CellModel *)model {
    
    _model = model;
    int i = 0;
    for (UIImageView *icon in self.iconArray) {
        if (i<self.model.iconModelArr.count) {
            icon.hidden = NO;
            GMIconModel *iconModel = self.model.iconModelArr[i];
            icon.frame = iconModel.iconRect;
            UIImage *ima = [GMIconItem imageFromCacheForKey:iconModel.smallIconUrl];
            if (ima) {
                icon.image = ima;
            }else {
                [icon sd_setImageWithURL:[NSURL URLWithString:iconModel.smallIconUrl]];
            }
        }else {
            icon.hidden = YES;
            icon.image = nil;
        }
        i++;
    }
}

-(void)dealloc {
    NSLog(@"dealloc----->>>%@<<<-----dealloc",[self class]);
}

@end

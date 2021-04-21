//
//  GMShufflingView.h
//
//  Created by lemonmgy on 2016/11/14.
//

#import <UIKit/UIKit.h>

typedef void(^GMShufflingBlock)(id obj);

@interface GMShufflingModel : NSObject
@property (nonatomic, copy) NSString *imageUrl;
@end

@interface GMShufflingView : UIView
@property (nonatomic, strong) NSArray *dataSourceArray;
@property (nonatomic, assign) BOOL pauseTimer;//vc销毁时，一定要取消
@property (nonatomic, copy) GMShufflingBlock shufflingCallBack;
@end


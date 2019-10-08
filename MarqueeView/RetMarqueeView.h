//
//  RetMarqueeView.h
//  Pods
//
//  Created by tao on 2019/9/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RetMarqueeView : UIView

- (instancetype)initWithFrame:(CGRect)frame datas:(NSArray *)datas;
- (void)beginAnimation;
- (void)stopAnimation;
@end

NS_ASSUME_NONNULL_END

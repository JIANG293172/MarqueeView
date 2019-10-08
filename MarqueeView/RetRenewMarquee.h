//
//  RetRenewMarquee.h
//  XYFinance
//
//  Created by tao on 2019/9/10.
//

#import <UIKit/UIKit.h>

@interface RetRenewMarquee : UIView

- (instancetype)initWithFrame:(CGRect)frame withInfo:(NSString *)text;
- (void)startAnimation;
- (void)removeAnimation;
- (void)stopAniamtion;
- (void)updateTitles:(NSString *)text;
@end



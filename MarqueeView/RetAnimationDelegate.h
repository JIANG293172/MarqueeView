//
//  XYVIPAnimationDelegate.h
//  XYFinance
//
//  Created by tao on 2019/9/16.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol RetAnimationBackDelegate <NSObject>
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag;

@end

@interface RetAnimationDelegate : NSObject<CAAnimationDelegate>

@property (nonatomic, weak) id<RetAnimationBackDelegate> delegate;

@end



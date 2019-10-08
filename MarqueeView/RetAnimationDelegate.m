//
//  RetAnimationDelegate.m
//  XYFinance
//
//  Created by tao on 2019/9/16.
//

#import "RetAnimationDelegate.h"


@implementation RetAnimationDelegate


- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if ([self.delegate respondsToSelector:@selector(animationDidStop:finished:)]) {
        [self.delegate animationDidStop:anim finished:flag];
    }
}

@end

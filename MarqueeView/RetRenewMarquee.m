//
//  RetRenewMarquee.m
//  XYFinance
//
//  Created by tao on 2019/9/10.
//

#import "RetRenewMarquee.h"
#import "RetAnimationDelegate.h"

@interface RetRenewMarquee ()<RetAnimationBackDelegate> {
    CGFloat labelHeight;
    UILabel *leftLabel;
    UILabel *rightLabel;
    
    CGRect currentFrame;
    CGRect behindFrame;
    CGFloat animationDuration;
    CGFloat isStop;
    BOOL canAnimation;
}
@property (nonatomic, strong) RetAnimationDelegate *animaDele;

@end

@implementation RetRenewMarquee


- (instancetype)initWithFrame:(CGRect)frame withInfo:(NSString *)text
{
    self = [super initWithFrame:frame];
    
    if (self) {
        if (text) {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickMarquee)];
            [self addGestureRecognizer:tap];
            
            animationDuration = text.length/4;
            CGFloat viewHeight = frame.size.height;
            labelHeight = viewHeight;

            leftLabel = [[UILabel alloc]init];
            leftLabel.numberOfLines = 1;
            leftLabel.text = text;
            leftLabel.textColor = [UIColor blackColor];
            leftLabel.font = [UIFont systemFontOfSize:14.0f];
            leftLabel.textAlignment = NSTextAlignmentLeft;
            
            CGFloat calcuWidth = [leftLabel textRectForBounds:CGRectMake(0, 0, MAXFLOAT, 0) limitedToNumberOfLines:0].size.width + 40;
            currentFrame = CGRectMake(0, 0, calcuWidth, labelHeight);
            behindFrame = CGRectMake(currentFrame.origin.x+currentFrame.size.width, 0, calcuWidth, labelHeight);
            if (calcuWidth>frame.size.width) {
                canAnimation = YES;
            }
            leftLabel.frame = currentFrame;
            [self addSubview:leftLabel];
            
            rightLabel = [[UILabel alloc]init];
            rightLabel.numberOfLines = 1;
            rightLabel.frame = behindFrame;
            rightLabel.text = text;
            rightLabel.textColor = [UIColor blackColor];
            rightLabel.font = [UIFont systemFontOfSize:14.0f];
            rightLabel.textAlignment = NSTextAlignmentLeft;
            [self addSubview:rightLabel];
            rightLabel.hidden = !canAnimation;
            
            _animaDele = [[RetAnimationDelegate alloc] init];
            _animaDele.delegate = self;
        }
    }
    return self;
}

- (void)didClickMarquee {
    NSLog(@"didClickMarquee");
}

- (void)updateTitles:(NSString *)text {
    if (!text) return;
    animationDuration = text.length/4;
    leftLabel.text = text;
    CGFloat calcuWidth = [leftLabel textRectForBounds:CGRectMake(0, 0, MAXFLOAT, 0) limitedToNumberOfLines:0].size.width + 40;
    currentFrame = CGRectMake(0, 0, calcuWidth, labelHeight);
    leftLabel.frame = currentFrame;
    
    if (calcuWidth>self.frame.size.width) {
        canAnimation = YES;
        rightLabel.text = text;
        behindFrame = CGRectMake(currentFrame.origin.x+currentFrame.size.width, 0, calcuWidth, labelHeight);
        rightLabel.frame = behindFrame;
    } else {
        canAnimation = NO;
    }
    rightLabel.hidden = !canAnimation;
}

- (void)startAnimation
{
    if (!canAnimation) return;
        
    CABasicAnimation *leftAnimation = [CABasicAnimation animation];
    leftAnimation.keyPath = @"position.x";
    leftAnimation.fromValue = @(leftLabel.frame.origin.x+currentFrame.size.width*0.5);
    leftAnimation.toValue = @(leftLabel.frame.origin.x-currentFrame.size.width*0.5);
    leftAnimation.duration = animationDuration;
    leftAnimation.beginTime = CACurrentMediaTime() + 1;
    leftAnimation.fillMode = kCAFillModeBoth;
    leftAnimation.removedOnCompletion = NO;
    leftAnimation.delegate = self.animaDele;
    leftAnimation.repeatCount = 1;
    [leftLabel.layer addAnimation:leftAnimation forKey:@"leftAnimation"];
    
    CABasicAnimation *rightAnimation = [CABasicAnimation animation];
    rightAnimation.keyPath = @"position.x";
    rightAnimation.fromValue = @(rightLabel.frame.origin.x+currentFrame.size.width*0.5);
    rightAnimation.toValue = @(rightLabel.frame.origin.x-currentFrame.size.width*0.5);
    rightAnimation.duration = animationDuration;
    rightAnimation.beginTime = CACurrentMediaTime() + 1;
    rightAnimation.fillMode = kCAFillModeBoth;
    rightAnimation.removedOnCompletion = NO;
    rightAnimation.delegate = self.animaDele;
    rightAnimation.repeatCount = 1;
    [rightLabel.layer addAnimation:rightAnimation forKey:@"rightAnimation"];
}

- (void)removeAnimation {
    [leftLabel.layer removeAllAnimations];
    [rightLabel.layer removeAllAnimations];
    leftLabel.frame = currentFrame;
    rightLabel.frame = behindFrame;
    [self resumeLayer:leftLabel.layer];
    [self resumeLayer:rightLabel.layer];

}

- (void)stopAniamtion {
    [self pauseLayer:leftLabel.layer];
    [self pauseLayer:rightLabel.layer];
    isStop = YES;
}

- (void)pauseLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0;
    layer.timeOffset = pausedTime;
}

- (void)resumeLayer:(CALayer*)layer
{
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (!canAnimation) return;
    if (flag) {
        [leftLabel.layer removeAllAnimations];
        [rightLabel.layer removeAllAnimations];
        UILabel *label = rightLabel;
        rightLabel = leftLabel;
        leftLabel = label;
        leftLabel.frame = currentFrame;
        rightLabel.frame = behindFrame;
        
        [self startAnimation];
    }
}

@end

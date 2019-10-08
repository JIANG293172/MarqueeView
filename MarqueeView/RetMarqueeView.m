//
//  RetMarqueeView.m
//  Pods
//
//  Created by tao on 2019/9/10.
//

#import "RetMarqueeView.h"
#import "RetRenewMarquee.h"
#import "RetAnimationDelegate.h"

@interface RetMarqueeView ()<RetAnimationBackDelegate>
@property(nonatomic, strong) UIImageView *headImageView;
@property(nonatomic, strong) UIView *textContainerView;

@property(nonatomic, strong) RetRenewMarquee *topMarqueee;
@property(nonatomic, strong) RetRenewMarquee *bottomMarqueee;
@property(nonatomic, assign) CGRect currentFrame;
@property(nonatomic, assign) CGRect behindFrame;
@property(nonatomic, copy) NSArray <NSString *> *datas;
@property(nonatomic, assign) NSInteger topIndex;
@property(nonatomic, assign) NSInteger bottomIndex;
@property(nonatomic, assign) NSInteger showIndex;
@property(nonatomic, assign) BOOL didStartAnimation;
@property (nonatomic, strong) RetAnimationDelegate *animaDele;

@end

@implementation RetMarqueeView


- (instancetype)initWithFrame:(CGRect)frame datas:(NSArray *)datas {
    if ([super initWithFrame:frame]) {
        _datas = datas;
        [self initView];
    }
    return self;
}

- (void)initView {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 4;
    self.layer.masksToBounds = YES;
    
    _headImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"red_trumpet"]];
    _headImageView.frame = CGRectMake(12, (self.frame.size.height-16)/2, 16, 16);
    [self addSubview:_headImageView];
    
    _textContainerView = [[UIView alloc] init];
    _textContainerView.clipsToBounds = YES;
    [self addSubview:_textContainerView];
    _textContainerView.frame = CGRectMake(40, 0, self.frame.size.width-40, self.frame.size.height);
    if (self.datas.count > 0) {
        self.topIndex = 0;
        self.showIndex = 0;
        self.currentFrame = CGRectMake(0, 0, self.textContainerView.frame.size.width, self.textContainerView.frame.size.height);
        self.behindFrame = CGRectMake(0, self.currentFrame.origin.y+self.currentFrame.size.height, self.textContainerView.frame.size.width, self.textContainerView.frame.size.height);
        self.topMarqueee= [[RetRenewMarquee alloc] initWithFrame:self.currentFrame withInfo:self.datas[self.topIndex]];
        [self.textContainerView addSubview:self.topMarqueee];
        [self loggerIndex:self.topIndex andEnent:@"Domestic_VIPMemberPage_Text_Imp"];
        
        self.animaDele = [[RetAnimationDelegate alloc] init];
        self.animaDele.delegate = self;
        if (self.datas.count > 1) {
            self.bottomIndex = 1;
            self.bottomMarqueee = [[RetRenewMarquee alloc] initWithFrame:self.behindFrame withInfo:self.datas[self.bottomIndex]];
            [self.textContainerView addSubview:self.bottomMarqueee];
        }
    }
}

- (void)beginAnimation {
    if (self.datas.count > 0 && !self.didStartAnimation) {
        [self.topMarqueee startAnimation];
        if (_bottomIndex < self.datas.count && self.datas.count > 1) {
            [self.bottomMarqueee removeAnimation];
            [self.bottomMarqueee updateTitles:self.datas[_bottomIndex]];
            self.didStartAnimation = YES;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.didStartAnimation = NO;
                [self.topMarqueee stopAniamtion];
                [self.bottomMarqueee removeAnimation];
                [self startAnimation];
                // 循环最多记录一次展示埋点
                self.showIndex = self.showIndex > self.bottomIndex?self.showIndex:self.bottomIndex;
                [self loggerIndex:self.showIndex andEnent:@"Domestic_VIPMemberPage_Text_Imp"];
                if (self.showIndex == self.datas.count - 1 ) {
                    self.showIndex = self.datas.count;
                }
            });
        }
    }
}

- (void)startAnimation {
    
    // 停止滚动
    CABasicAnimation *topAnimation = [CABasicAnimation animation];
    topAnimation.keyPath = @"position.y";
    topAnimation.fromValue = @(self.topMarqueee.frame.origin.y+self.currentFrame.size.height/2);
    topAnimation.toValue = @(self.topMarqueee.frame.origin.y-self.currentFrame.size.height/2);
    topAnimation.duration = 1;
    topAnimation.removedOnCompletion = NO;
    topAnimation.fillMode = kCAFillModeBoth;
    topAnimation.delegate = self.animaDele;
    topAnimation.repeatCount = 1;
    [self.topMarqueee.layer addAnimation:topAnimation forKey:@"topAnimation"];

    CABasicAnimation *bottomAnimation = [CABasicAnimation animation];
    bottomAnimation.keyPath = @"position.y";
    bottomAnimation.fromValue = @(self.bottomMarqueee.frame.origin.y+self.currentFrame.size.height/2);
    bottomAnimation.toValue = @(self.bottomMarqueee.frame.origin.y-self.currentFrame.size.height/2);
    bottomAnimation.duration = 1;
    bottomAnimation.removedOnCompletion = NO;
    bottomAnimation.fillMode = kCAFillModeBoth;
    bottomAnimation.delegate = self.animaDele;
    bottomAnimation.repeatCount = 1;
    [self.bottomMarqueee.layer addAnimation:bottomAnimation forKey:@"bottomAnimation"];

}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag && anim == [self.topMarqueee.layer animationForKey:@"topAnimation"]) {
        [self.topMarqueee.layer removeAnimationForKey:@"topAnimation"];
        [self.bottomMarqueee.layer removeAnimationForKey:@"bottomAnimation"];
        RetRenewMarquee *marquee = self.bottomMarqueee;
        self.bottomMarqueee = self.topMarqueee;
        self.topMarqueee = marquee;
        self.topMarqueee.frame = self.currentFrame;
        self.bottomMarqueee.frame = self.behindFrame;
        [self updateNextIndex];
        
        [self beginAnimation];
    }
}

- (void)stopAnimation {
    if (self.datas.count > 0) {
        _topIndex = 0;
        [self.topMarqueee updateTitles:self.datas[_topIndex]];
        self.topMarqueee.frame = self.currentFrame;
        [self.topMarqueee.layer removeAllAnimations];
        [self.topMarqueee removeAnimation];
    }
    if (self.datas.count > 1) {
        _bottomIndex = 1;
        [self.bottomMarqueee updateTitles:self.datas[_bottomIndex]];
        self.bottomMarqueee.frame = self.behindFrame;
        [self.bottomMarqueee.layer removeAllAnimations];
        [self.topMarqueee removeAnimation];
    }
}

- (void)updateNextIndex {
    _topIndex = _bottomIndex;
    if (_bottomIndex >= self.datas.count - 1) {
        _bottomIndex = 0;
    } else {
        _bottomIndex++;
    }
}

- (void)loggerIndex:(NSInteger)index andEnent:(NSString *)event {
    NSLog(@"showIndex: %ld", (long)index);
}

@end

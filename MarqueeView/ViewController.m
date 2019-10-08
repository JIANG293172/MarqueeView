//
//  ViewController.m
//  MarqueeView
//
//  Created by tao on 2019/10/8.
//  Copyright © 2019 tao. All rights reserved.
//

#import "ViewController.h"
#import "RetMarqueeView.h"

@interface ViewController ()
@property (nonatomic, strong) RetMarqueeView *marqueeView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    NSInteger padding = 15;
    
    _marqueeView = [[RetMarqueeView alloc] initWithFrame:CGRectMake(padding, 100, [UIScreen mainScreen].bounds.size.width-2*padding, 36) datas:@[@"RetMarqueeViewRetMarqueeViewRetMarqueeViewRetMarqueeView", @"RetMarqueeViewRetMarqueeViewRetMarqueeViewRetMarqueeView"]];
    [self.view addSubview:_marqueeView];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_marqueeView beginAnimation];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_marqueeView stopAnimation];
}


@end

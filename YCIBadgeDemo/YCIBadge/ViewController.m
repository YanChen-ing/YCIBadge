//
//  ViewController.m
//  YCIBadge
//
//  Created by yanchen on 15/8/13.
//  Copyright (c) 2015年 yanchen. All rights reserved.
//

#import "ViewController.h"
#import "YCIBadgeView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet YCIBadgeView *badge;

@end

@implementation ViewController

- (void)viewDidAppear:(BOOL)animated{
    _badge.animatePin = YCIBadgeAnimatePinCenter;
    
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
    
}

- (void)handleTimer:(NSTimer *)timer{
    
    static NSInteger idx = 0;
    
    NSArray *arr = @[
                     @"123",
                     @"0",
                     @"ojjag",
                     @"new+",
                     @"oang938niej923p"
                     ];
    
    [_badge showText:arr[idx++%arr.count]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

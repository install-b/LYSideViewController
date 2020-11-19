//
//  ViewController.m
//  LYSideView
//
//  Created by Shangen Zhang on 2017/4/8.
//  Copyright © 2017年 Shangen Zhang. All rights reserved.
//

#import "ViewController.h"
#import "LYRootViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    for (int i = 0; i < 2; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(80 + i * 120, 300, 110, 32)];
        btn.tag = i;
        [btn setTitle: i == 0 ? @"OC version" : @"Swift Version" forState: UIControlStateNormal];
        [btn setTitleColor: UIColor.systemRedColor forState: UIControlStateNormal];
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents: UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    
}


- (void)buttonClick:(UIButton *)sender {

    UIViewController *vc = sender.tag == 0 ? [LYRootViewController OCRootViewController] : [LYRootViewController SwiftRootViewController];
    [UIApplication sharedApplication].keyWindow.rootViewController = vc;
}

@end

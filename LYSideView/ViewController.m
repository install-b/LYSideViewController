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
   
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [UIApplication sharedApplication].keyWindow.rootViewController = [LYRootViewController rootViewController];
}

@end

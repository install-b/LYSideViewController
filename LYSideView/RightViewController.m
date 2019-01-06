//
//  RightViewController.m
//  LYSideView
//
//  Created by Shangen Zhang on 2017/4/8.
//  Copyright © 2017年 Shangen Zhang. All rights reserved.
//

#import "RightViewController.h"
#import "UIViewController+LYSideView.h"

@interface RightViewController ()

@end

@implementation RightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor purpleColor];
    UILabel *label1 = [[UILabel alloc] init];
    label1.text = @"fslkjffhwlifuwehfwjwekf";
    [label1 sizeToFit];
    label1.center = self.view.center;
    [self.view addSubview:label1];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"right touch begin");
    //[self showMainSideViewController:nil];
}
@end

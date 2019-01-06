//
//  LeftViewController.m
//  LYSideView
//
//  Created by Shangen Zhang on 2017/4/8.
//  Copyright © 2017年 Shangen Zhang. All rights reserved.
//

#import "LeftViewController.h"
#import "UIViewController+LYSideView.h"

@interface LeftViewController ()

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"1324cqkwofiweuftwhq";
    [label sizeToFit];
    label.center = self.view.center;
    [self.view addSubview:label];

}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"left touch begin");
    //[self showMainSideViewController:nil];
}

@end

//
//  SubTabBarViewController.m
//  LYSideView
//
//  Created by Shangen Zhang on 2017/4/10.
//  Copyright © 2017年 Shangen Zhang. All rights reserved.
//

#import "SubTabBarViewController.h"
#import "UIViewController+LYSideView.h"
#import "LYSideViewViewController.h"

@interface SubTabBarViewController ()

@end

@implementation SubTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavigation];
    
    
}



- (void)configNavigation {
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"left" style:UIBarButtonItemStylePlain target:self action:@selector(navigationItemClick:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"right" style:UIBarButtonItemStylePlain target:self action:@selector(navigationItemClick:)];
    
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitle:@"psuh vc" forState:UIControlStateNormal];
    [btn sizeToFit];
    btn.backgroundColor = [UIColor redColor];
    [btn setCenter:self.view.center];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(pushViewController:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)navigationItemClick:(UIBarButtonItem *)item {
    if ([[item valueForKey:@"title"] isEqualToString:@"left"]) {
        [self showLeftSideViewController:nil];
    }else {
        [self showRightSideViewController:nil];
    }
}

- (void)pushViewController:(id)sender {
    UIViewController *pushVc = [[UIViewController alloc] init];
    pushVc.view.backgroundColor = [UIColor blueColor];
    [self.navigationController pushViewController:pushVc animated:YES];
}


- (void)viewDidAppear:(BOOL)animated {
    self.sideViewController.panEnable = YES;
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidDisappear:(BOOL)animated {
    self.sideViewController.panEnable = NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

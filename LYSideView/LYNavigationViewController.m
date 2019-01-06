//
//  LYNavigationViewController.m
//  LYSideView
//
//  Created by Shangen Zhang on 2017/4/10.
//  Copyright © 2017年 Shangen Zhang. All rights reserved.
//

#import "LYNavigationViewController.h"

@interface LYNavigationViewController ()

@end

@implementation LYNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.childViewControllers.count > 0) {
        self.tabBarController.tabBar.hidden = YES;
    }
    [super pushViewController:viewController animated:animated];
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

//
//  LYRootViewController.m
//  LYSideView
//
//  Created by Shangen Zhang on 2017/4/10.
//  Copyright © 2017年 Shangen Zhang. All rights reserved.
//

#import "LYRootViewController.h"
#import "MainViewController.h"
#import "LeftViewController.h"
#import "RightViewController.h"

@interface LYRootViewController ()

@end

@implementation LYRootViewController

+ (instancetype)rootViewController {
    MainViewController * mainVc = [[MainViewController alloc] init];
    UIViewController * leftVc = [[LeftViewController alloc] init];
    UIViewController * rightVc = [[RightViewController alloc] init];
    
    LYRootViewController *rooVc = [[self alloc] initWithMainViewController:mainVc leftViewController:leftVc rightViewController:rightVc];
    
    rooVc.delegate = mainVc;
    
    return rooVc;
}


- (instancetype)init {
    if (self = [super init]) {
        CGFloat offset = [UIScreen mainScreen].bounds.size.width - 80.0f;
        self.leftContentOffset = offset;
        self.rightContentOffset = offset;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

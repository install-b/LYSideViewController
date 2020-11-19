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
#import "LYSideViewViewController.h"
#import <SideViewController-Swift.h>


@implementation LYRootViewController

+ (UIViewController *)rootViewController {
    MainViewController * mainVc = [[MainViewController alloc] init];
    UIViewController * leftVc = [[LeftViewController alloc] init];
    UIViewController * rightVc = [[RightViewController alloc] init];
    
//    SideViewController *rooVc = [[SideViewController alloc] initWithMainViewController:mainVc leftViewController:leftVc rightViewController:rightVc];
    LYSideViewViewController *rooVc = [[LYSideViewViewController alloc] initWithMainViewController:mainVc leftViewController:leftVc rightViewController:rightVc];
    CGFloat offset = [UIScreen mainScreen].bounds.size.width - 80.0f;
    rooVc.leftContentOffset = offset;
    rooVc.rightContentOffset = offset;
    rooVc.delegate = mainVc;
    
    return rooVc;
}
@end



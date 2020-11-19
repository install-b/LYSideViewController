//
//  MainViewController.m
//  LYSideView
//
//  Created by Shangen Zhang on 2017/4/8.
//  Copyright © 2017年 Shangen Zhang. All rights reserved.
//

#import "MainViewController.h"
#import "UIViewController+LYSideView.h"
#import "LYNavigationViewController.h"

@interface MainViewController ()

/** cover */
@property (nonatomic,strong) UIView * coverView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    [self setUpSubControllers];
//    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer:)];
//    //tap.delegate = self;
//    [self.view addGestureRecognizer:tap];

}
- (void)tapGestureRecognizer:(id)sender {

    //NSLog(@"tapGestureRecognizer -- sender");
}
- (void)setUpSubControllers {
    
    UIViewController *firstViewController = [self subTabBarVcWithTitle:@"first" rootViewContrllerClass:NSClassFromString(@"FirstViewController")];
    firstViewController.title = @"first";
    UIViewController *secondViewController = [self subTabBarVcWithTitle:@"second" rootViewContrllerClass:NSClassFromString(@"SecondViewController")];
    secondViewController.title = @"second";
    
    [self addChildViewController:firstViewController];
    [self addChildViewController:secondViewController];
}

- (UIViewController *)subTabBarVcWithTitle:(NSString *)title rootViewContrllerClass:(Class)rootVcClass {
    
    UIViewController *rootVc = [[rootVcClass alloc] init];
    rootVc.title = title;
    
    return [[LYNavigationViewController alloc] initWithRootViewController:[[rootVcClass alloc] init]];
}

- (void)setCoverViewProgress:(CGFloat)progress {
    if (progress == 0) {
        return [_coverView removeFromSuperview];
    }
    
    if (!self.coverView.superview) {
        [self.view addSubview:self.coverView];
    }
    
    [self.coverView setAlpha:progress];
}

#pragma mark - LYSideViewViewControllerDelegate

- (void)sideViewViewController:(LYSideViewViewController *)sideVc willShowLeftView:(UIViewController *)mainVc animaDuratoin:(NSTimeInterval)duration {
    [self.view addSubview:self.coverView];
    [UIView animateWithDuration:duration animations:^{
        self.coverView.alpha = 1.0f;
    }];
}

- (void)sideViewViewController:(LYSideViewViewController *)sideVc didShowLeftViewController:(UIViewController *)lefttVc
                      progress:(CGFloat)progress  {
    [self setCoverViewProgress:progress];
}

- (void)sideViewViewController:(LYSideViewViewController *)sideVc willDismissLeftViewController:(UIViewController *)leftVc
                 animaDuratoin:(NSTimeInterval)duration {
    [UIView animateWithDuration:duration animations:^{
        self.coverView.alpha = 0.01f;
    }];

}

- (void)sideViewViewController:(LYSideViewViewController *)sideVc didDismissLeftViewController:(UIViewController *)leftVc {
    [self.coverView removeFromSuperview];
}

#pragma mark - SideViewViewControllerDelegate

- (void)sideViewDidDismissLeftView:(SideViewController *)sideVc :(UIViewController *)leftVc {
    
}

- (void)sideViewDidDismissRightView:(SideViewController *)sideVc :(UIViewController *)rightVc {
    
}

- (void)sideViewDidShowLeftView:(SideViewController *)sideVc :(UIViewController *)leftVc progress:(CGFloat)progress {
    
}

- (void)sideViewDidShowRightView:(SideViewController *)sideVc :(UIViewController *)rightVc progress:(CGFloat)progress {
    
}

#pragma mark - lazy load
- (UIView *)coverView {
    if (!_coverView) {
        _coverView = [[UIView alloc] initWithFrame:self.view.bounds];
        _coverView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    }
    return _coverView;
}

@end

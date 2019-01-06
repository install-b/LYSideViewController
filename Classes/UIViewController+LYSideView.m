//
//  UIViewController+LYSideView.m
//  LYSideView
//
//  Created by Shangen Zhang on 2017/4/8.
//  Copyright © 2017年 Shangen Zhang. All rights reserved.
//

#import "UIViewController+LYSideView.h"
#import "LYSideViewViewController.h"


@implementation UIViewController (LYSideView)

- (void)showLeftSideViewController:(id)sender {
    [self.sideViewController showLeftViewController];
}

- (void)showRightSideViewController:(id)sender {

    [self.sideViewController showRightViewController];
}

- (void)showMainSideViewController:(id)sender {
    [self.sideViewController showMainViewController];
}

- (LYSideViewViewController *)sideViewController {
    
    UIViewController *vc = self.parentViewController;
    
    while (vc) {
        if ([vc isKindOfClass:[LYSideViewViewController class]]) {
            return (LYSideViewViewController *) vc;
        }

        else if (vc.parentViewController && vc.parentViewController != vc) {
            vc = vc.parentViewController;
        }
        
        else {
            vc = nil;
        }
    }
    
    return nil;
}

@end

//
//  UIViewController+LYSideView.h
//  LYSideView
//
//  Created by Shangen Zhang on 2017/4/8.
//  Copyright © 2017年 Shangen Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LYSideViewViewController;

@interface UIViewController (LYSideView)
/** seek self sideViewController */
@property (nonatomic,strong,readonly) LYSideViewViewController * sideViewController;


- (IBAction)showLeftSideViewController:(id)sender;

- (IBAction)showRightSideViewController:(id)sender;

- (IBAction)showMainSideViewController:(id)sender;
@end

//
//  LYSideViewViewController.h
//  LYSideView
//
//  Created by Shangen Zhang on 2017/4/8.
//  Copyright © 2017年 Shangen Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LYSideViewViewControllerDelegate;

@interface LYSideViewViewController : UIViewController

- (instancetype)initWithMainViewController:(UIViewController *)mainVc leftViewController:( UIViewController *)leftVc rightViewController:(UIViewController *)rightVc;

- (void)setMainViewController:(UIViewController *)mainViewController leftViewController:( UIViewController *)leftViewController rightViewController:(UIViewController *)rightViewController;


- (void)showLeftViewController;
- (void)showRightViewController;
- (void)showMainViewController;


/** delegate */
@property (nonatomic,weak) id<LYSideViewViewControllerDelegate> delegate;

/** left offset */
@property(nonatomic,assign) CGFloat leftContentOffset;

/** right offset */
@property(nonatomic,assign) CGFloat rightContentOffset;

/** panEnable  default is YES */
@property(nonatomic,assign,getter=isPanEnable) BOOL panEnable;

@end

#pragma mark - ******** LYSideViewViewControllerDelegate  **********

@protocol LYSideViewViewControllerDelegate <NSObject>
@optional
#pragma mark - show left view controller state

- (void)sideViewViewController:(LYSideViewViewController *)sideVc willShowLeftView:(UIViewController *)mainVc animaDuratoin:(NSTimeInterval)duration;

- (void)sideViewViewController:(LYSideViewViewController *)sideVc didShowLeftViewController:(UIViewController *)lefttVc
                      progress:(CGFloat)progress ;

- (void)sideViewViewController:(LYSideViewViewController *)sideVc willDismissLeftViewController:(UIViewController *)leftVc
                 animaDuratoin:(NSTimeInterval)duration;

- (void)sideViewViewController:(LYSideViewViewController *)sideVc didDismissLeftViewController:(UIViewController *)leftVc;

#pragma mark - show right view controller state

- (void)sideViewViewController:(LYSideViewViewController *)sideVc willShowRightView:(UIViewController *)rightVc animaDuratoin:(NSTimeInterval)duration;


- (void)sideViewViewController:(LYSideViewViewController *)sideVc didShowRightViewController:(UIViewController *)rightVc
                      progress:(CGFloat)progress ;

- (void)sideViewViewController:(LYSideViewViewController *)sideVc willDismissRightViewController:(UIViewController *)rightVc
                 animaDuratoin:(NSTimeInterval)duration;

- (void)sideViewViewController:(LYSideViewViewController *)sideVc didDismissRightViewController:(UIViewController *)rightVc;


@end

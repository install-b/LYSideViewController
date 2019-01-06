//
//  LYSideViewViewController.m
//  LYSideView
//
//  Created by Shangen Zhang on 2017/4/8.
//  Copyright © 2017年 Shangen Zhang. All rights reserved.
//

#import "LYSideViewViewController.h"

#pragma mark - UIViewController Category (fast set viewController bounds and frame)
@implementation UIViewController (Bounds)

- (CGFloat)boundsX {
    return self.view.bounds.origin.x;
}
- (void)setBoundsX:(CGFloat)boundsX {
    CGRect bounds = self.view.bounds;
    bounds.origin.x = boundsX;
    self.view.bounds = bounds;
}
- (CGFloat)boundsY {
    return self.view.bounds.origin.y;
}
- (void)setBoundsY:(CGFloat)boundsY {
    CGRect bounds = self.view.bounds;
    bounds.origin.y = boundsY;
    self.view.bounds = bounds;
}

- (CGFloat)frameX {
    return self.view.frame.origin.x;
}
- (void)setFrameX:(CGFloat)frameX {
    CGRect frame = self.view.frame;
    frame.origin.x = frameX;
    self.view.frame = frame;
}
- (CGFloat)frameY {
    return self.view.frame.origin.y;
}
- (void)setFrameY:(CGFloat)frameY {
    CGRect frame = self.view.frame;
    frame.origin.y = frameY;
    self.view.frame = frame;
}

@end
#pragma mark - -------------LYSideViewViewController----------------

#define animaDuration 0.25f
@interface LYSideViewViewController () <UIGestureRecognizerDelegate>
/** main view controller */
@property (nonatomic,weak) UIViewController * mainViewController;
/** left view controller */
@property (nonatomic,weak) UIViewController * leftViewController;
/** right view controller */
@property (nonatomic,weak) UIViewController * rightViewController;

/** left progress */
@property(nonatomic,assign) CGFloat leftProgress ;
/** right progress */
@property(nonatomic,assign) CGFloat rightProgress ;

/** startPoint  */
@property(nonatomic,assign) CGPoint startPoint;

/** side cover */
@property (nonatomic,strong) UIView * sideCoverView;
@end

@implementation LYSideViewViewController
#pragma init
- (instancetype)initWithMainViewController:(UIViewController *)mainViewController leftViewController:( UIViewController *)leftViewController rightViewController:(UIViewController *)rightViewController {
    if (self = [self init]) {
        [self setMainViewController:mainViewController leftViewController:leftViewController rightViewController:rightViewController];
    }
    return self;
}
- (instancetype)init {
    if (self = [super init]) {
        [self initalizeSetUp];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [self initalizeSetUp];
}

- (void)initalizeSetUp {
    self.panEnable = YES;
}
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpSubVcViews];
}
#pragma mark - setup
- (void)setMainViewController:(UIViewController *)mainViewController leftViewController:( UIViewController *)leftViewController rightViewController:(UIViewController *)rightViewController {
    !mainViewController ? : [self addChildViewController:mainViewController];
    !leftViewController ? : [self addChildViewController:leftViewController];
    !rightViewController ?: [self addChildViewController:rightViewController];
    
    self.mainViewController  = mainViewController;
    self.leftViewController  = leftViewController;
    self.rightViewController = rightViewController;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer:)];
    tap.delegate = self;
    [self.mainViewController.view addGestureRecognizer:tap];
}

- (void)setUpSubVcViews {
    [self.view addSubview:self.mainViewController.view];
    
    [self.leftViewController view];
    [self.rightViewController view];
    
    UIPanGestureRecognizer *panGest = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
    panGest.delegate = self;
    
    [self.view addGestureRecognizer:panGest];
    
    //self.scrollBounces = NO;
    self.leftProgress = 0.0f;
    self.rightProgress = 0.0f;
}

#pragma mark - public animate method
- (void)showLeftViewController {
    if (!self.leftViewController ||
        self.mainViewController.frameX == self.leftContentOffset) {
        return;
    }
    if (!self.leftViewController.view.superview) {
        [self.view insertSubview:self.leftViewController.view belowSubview:self.mainViewController.view];
    }
    [self.view insertSubview:self.sideCoverView aboveSubview:self.leftViewController.view];
    
    // noti delegate left vc will show with anima
    if ([self.delegate respondsToSelector:@selector(sideViewViewController:willShowLeftView:animaDuratoin:)]) {
        [self.delegate sideViewViewController:self willShowLeftView:self.leftViewController animaDuratoin:animaDuration];
    }
    
    self.leftViewController.boundsX = (1 - _leftProgress) * _leftContentOffset * 0.5;
    
    [self animateAdjustWithFrameX:self.leftContentOffset complete:^(BOOL finished) {
        // do something when did show left view controller
        if ([self.delegate respondsToSelector:@selector(sideViewViewController:didShowLeftViewController:progress:)]) {
            [self.delegate sideViewViewController:self didShowLeftViewController:self.leftViewController progress:1.0];
        }
        
        [self.rightViewController.view removeFromSuperview];
        [self.sideCoverView removeFromSuperview];
    }];
}
- (void)showRightViewController {
    if (!self.rightViewController ||
        self.mainViewController.frameX == -self.rightContentOffset) {
        return;
    }
    
    if (!self.rightViewController.view.superview) {
        [self.view insertSubview:self.rightViewController.view belowSubview:self.mainViewController.view];
    }
    [self.view insertSubview:self.sideCoverView aboveSubview:self.rightViewController.view];
    
    // noti delegate right vc will show with anima
    if ([self.delegate respondsToSelector:@selector(sideViewViewController:willShowRightView:animaDuratoin:)]) {
        [self.delegate sideViewViewController:self willShowRightView:self.rightViewController animaDuratoin:animaDuration];
    }
    
    self.rightViewController.boundsX = (_leftProgress - 1) * _rightProgress * 0.5;
    
    [self animateAdjustWithFrameX:-self.rightContentOffset complete:^(BOOL finished) {
        // do something when did show right view controller
        if ([self.delegate respondsToSelector:@selector(sideViewViewController:didShowRightViewController:progress:)]) {
            [self.delegate sideViewViewController:self didShowRightViewController:self.rightViewController progress:1.0];
        }
        [self.leftViewController.view removeFromSuperview];
        [self.sideCoverView removeFromSuperview];
    }];
}
- (void)showMainViewController {
    if (self.mainViewController.frameX == 0.0) {
        return;
    }
    [self.view insertSubview:self.sideCoverView belowSubview:self.mainViewController.view];
    BOOL isLeft = self.mainViewController.frameX > 0;
    if (isLeft) {
        if ([self.delegate respondsToSelector:@selector(sideViewViewController:willDismissLeftViewController:animaDuratoin:)]) {
            [self.delegate sideViewViewController:self willDismissLeftViewController:self.leftViewController animaDuratoin:animaDuration];
        }
    }else {
        if ([self.delegate respondsToSelector:@selector(sideViewViewController:willDismissRightViewController:animaDuratoin:)]) {
            [self.delegate sideViewViewController:self willDismissRightViewController:self.rightViewController animaDuratoin:animaDuration];
        }
    }
    
    [self animateAdjustWithFrameX:0.0f complete:^(BOOL finished) {
        // do something when did show main view controller
        [self.rightViewController.view removeFromSuperview];
        [self.leftViewController.view removeFromSuperview];
        [self.sideCoverView removeFromSuperview];
        if (isLeft) {
            if ([self.delegate respondsToSelector:@selector(sideViewViewController:didDismissLeftViewController:)]) {
                [self.delegate sideViewViewController:self didDismissLeftViewController:self.leftViewController];
            }
            
        }else {
            if ([self.delegate respondsToSelector:@selector(sideViewViewController:didDismissRightViewController:)]) {
                [self.delegate sideViewViewController:self didDismissRightViewController:self.rightViewController];
            }
        }
    }];
}

#pragma mark - pravite methods
- (void)animateAdjustWithFrameX:(CGFloat)frameX complete:(void(^)(BOOL finished))complete {
    
    BOOL isleft = (frameX > 0 || (frameX == 0 && self.mainViewController.frameX > 0));
    [UIView animateWithDuration:animaDuration animations:^{
        self.mainViewController.frameX = frameX;
        
        if (isleft) {
            
            _leftProgress =  _leftContentOffset ? frameX / _leftContentOffset : 0.0;
            self.leftViewController.boundsX = (1 - _leftProgress) * self.leftContentOffset * 0.5;
            self.sideCoverView.alpha = 1 - _leftProgress;
        }else {
            
            _rightProgress = _rightContentOffset ? -frameX / _rightContentOffset : 0.0;
            self.rightViewController.boundsX = (_rightProgress - 1.0) * self.rightContentOffset * 0.5;
            
            self.sideCoverView.alpha = 1 - _rightProgress;
        }
        
        [self.view layoutIfNeeded];
    } completion:complete];
}

//#pragma mark - setter
//#pragma mark publik setter
//- (void)setScrollBounces:(BOOL)scrollBounces {
//    _scrollBounces = scrollBounces;
//}
#pragma mark  pravit setter
- (void)setLeftProgress:(CGFloat)leftProgress {
    
    if (!self.leftViewController) {
        return;
    }
    
    if (leftProgress > 1.0f) {
        leftProgress = 1.0f;
    }else if (leftProgress < 0) {
        leftProgress = 0;
    }else {
        // do something when scroll leftview showing with progress
        self.sideCoverView.alpha = 1 - leftProgress;
        self.leftViewController.boundsX = (1.0 - leftProgress) * self.leftContentOffset * 0.5;
        
        // noti delegate
        if ([self.delegate respondsToSelector:@selector(sideViewViewController:didShowLeftViewController:progress:)]) {
            [self.delegate sideViewViewController:self didShowLeftViewController:self.leftViewController progress:leftProgress];
        }
    }
    
    _leftProgress = leftProgress;
    
}

- (void)setRightProgress:(CGFloat)rightProgress {
    if (!self.rightViewController) {
        return;
    }
    if (rightProgress > 1.0f) {
        rightProgress = 1.0f;
    }else if (rightProgress < 0) {
        rightProgress = 0;
    }else {
        // do something when scroll rightview showing with progress
        
        self.sideCoverView.alpha = 1 - rightProgress;
        self.rightViewController.boundsX = (rightProgress - 1.0) * self.rightContentOffset * 0.5;
        
        // noti delegate
        if ([self.delegate respondsToSelector:@selector(sideViewViewController:didShowRightViewController:progress:)]) {
            [self.delegate sideViewViewController:self didShowLeftViewController:self.rightViewController progress:rightProgress];
        }
    }
    
    _rightProgress = rightProgress;
    
}

#pragma mark - GestureRecognizer action
- (void)tapGestureRecognizer:(UITapGestureRecognizer *)tap {
    if (tap.view.frame.origin.x != 0) {
        [self showMainViewController];
    }
}

- (void)panGestureRecognizer:(UIPanGestureRecognizer *)pan {
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.startPoint = [pan locationInView:self.view];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint point = [pan locationInView:self.view];
            [self touchMovedWithOffset:point.x - self.startPoint.x];
            self.startPoint = point;
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            [self touchEndAdjustPosition];
        }
            break;
            
        default:
            break;
    }
}
#pragma mark - UIGestureRecognizer delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]] &&
        self.mainViewController.frameX == 0.0
        ) {
        return NO;
    }
    else if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        return self.isPanEnable;
    }
    
    CGPoint touchP = [touch locationInView:gestureRecognizer.view];
    return  [gestureRecognizer.view pointInside:touchP withEvent:nil];
}

#pragma mark - deal touch method
- (void)touchMovedWithOffset:(CGFloat)offset {
    CGFloat frameX = self.mainViewController.frameX  + offset;
    if (frameX > 0) {
        frameX = (frameX <= self.leftContentOffset) ? frameX : self.leftContentOffset;
        [self.rightViewController.view removeFromSuperview];
        if (!self.leftViewController.view.superview) {
            [self.view insertSubview:self.leftViewController.view belowSubview:self.mainViewController.view];
        }
        [self.view insertSubview:self.sideCoverView aboveSubview:self.leftViewController.view];
        self.leftProgress = frameX / self.leftContentOffset;
    }else {
        frameX = (frameX >= -self.rightContentOffset) ? frameX : -self.rightContentOffset;
        [self.leftViewController.view removeFromSuperview];
        if (!self.rightViewController.view.superview) {
            [self.view insertSubview:self.rightViewController.view belowSubview:self.mainViewController.view];
        }
        [self.view insertSubview:self.sideCoverView aboveSubview:self.rightViewController.view];
        self.rightProgress = frameX / -self.rightContentOffset;
    }
    self.mainViewController.frameX = frameX;
}

- (void)touchEndAdjustPosition {
    
    if (self.mainViewController.frameX >= self.leftContentOffset * 0.5) {
        [self showLeftViewController];
    }
    else if (self.mainViewController.frameX <= - self.rightContentOffset * 0.5) {
        [self showRightViewController];
    }
    else {
        [self showMainViewController];
    }
}

#pragma mark - lazy load
- (UIView *)sideCoverView {
    if (!_sideCoverView) {
        _sideCoverView = [[UIView alloc] initWithFrame:self.view.bounds];
        _sideCoverView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.9];
    }
    return _sideCoverView;
}
@end

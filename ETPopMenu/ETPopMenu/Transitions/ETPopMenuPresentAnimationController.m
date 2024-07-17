//
//  ETPopMenuPresentAnimationController.m
//  ETPopMenu
//
//  Created by Flameliu liu on 2024/7/15.
//

#import "ETPopMenuPresentAnimationController.h"
#import "ETPopMenuViewController.h"

@implementation ETPopMenuPresentAnimationController

- (instancetype)initWithSourceFrame:(CGRect)sourceFrame {
    self = [super init];
    if (self) {
        _sourceFrame = sourceFrame;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.138;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    ETPopMenuViewController *menuViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    if (!menuViewController) return;
    
    UIView *containerView = transitionContext.containerView;
    UIView *view = menuViewController.view;
    view.frame = containerView.frame;
    [containerView addSubview:view];
    
    [self prepareAnimation:menuViewController];
    
    NSTimeInterval animationDuration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:animationDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self animate:menuViewController];
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}

- (void)prepareAnimation:(ETPopMenuViewController *)viewController {
    viewController.containerView.alpha = 0;
    viewController.backgroundView.alpha = 0;
    
    if (!CGRectEqualToRect(_sourceFrame, CGRectZero)) {
        viewController.contentLeftConstraint.constant = _sourceFrame.origin.x;
        viewController.contentTopConstraint.constant = _sourceFrame.origin.y;
        viewController.contentWidthConstraint.constant = _sourceFrame.size.width;
        viewController.contentHeightConstraint.constant = _sourceFrame.size.height;
    }
}

- (void)animate:(ETPopMenuViewController *)viewController {
    viewController.containerView.alpha = 1;
    viewController.backgroundView.alpha = 1;
    
    CGRect contentFrame = viewController.contentFrame;
    viewController.contentLeftConstraint.constant = contentFrame.origin.x;
    viewController.contentTopConstraint.constant = contentFrame.origin.y;
    viewController.contentWidthConstraint.constant = contentFrame.size.width;
    viewController.contentHeightConstraint.constant = contentFrame.size.height;
    
    [viewController.containerView layoutIfNeeded];
}

@end

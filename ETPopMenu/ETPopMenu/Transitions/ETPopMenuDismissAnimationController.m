//
//  ETPopMenuDismissAnimationController.m
//  ETPopMenu
//
//  Created by Flameliu liu on 2024/7/15.
//

#import "ETPopMenuDismissAnimationController.h"
#import "ETPopMenuViewController.h"

@implementation ETPopMenuDismissAnimationController

- (instancetype)initWithSourceFrame:(CGRect)sourceFrame {
    self = [super init];
    if (self) {
        _sourceFrame = sourceFrame;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.0982;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    ETPopMenuViewController *menuViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    if (!menuViewController) return;
    
    UIView *containerView = transitionContext.containerView;
    UIView *view = menuViewController.view;
    view.frame = containerView.frame;
    [containerView addSubview:view];
    
    NSTimeInterval animationDuration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:animationDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self animate:menuViewController];
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}

- (void)animate:(ETPopMenuViewController *)viewController {
    viewController.containerView.alpha = 0;
    viewController.backgroundView.alpha = 0;
    
    viewController.containerView.transform = CGAffineTransformMakeScale(0.55, 0.55);
}

@end

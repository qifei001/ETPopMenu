//
//  ETPopMenuManager.m
//  ETPopMenu
//
//  Created by Flameliu liu on 2024/7/15.
//

#import "ETPopMenuManager.h"

@implementation ETPopMenuManager

+ (instancetype)defaultManager {
    static ETPopMenuManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[ETPopMenuManager alloc] init];
    });
    return sharedManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _popMenuShouldDismissOnSelection = YES;
        _popMenuShouldEnableHaptics = YES;
        _actions = @[];
        _popMenuAppearance = [[ETPopMenuAppearance alloc] init];
    }
    return self;
}

- (void)setPopMenuDelegate:(id<ETPopMenuViewControllerDelegate>)popMenuDelegate {
    _popMenuDelegate = popMenuDelegate;
    if (_popMenu) {
        _popMenu.delegate = popMenuDelegate;
    }
}

- (void)prepareViewControllerWithSourceView:(id)sourceView {
    _popMenu = [[ETPopMenuViewController alloc] initWithSourceView:sourceView actions:self.actions];
    _popMenu.delegate = self.popMenuDelegate;
    _popMenu.appearance = self.popMenuAppearance;
    _popMenu.shouldDismissOnSelection = self.popMenuShouldDismissOnSelection;
    _popMenu.didDismiss = self.popMenuDidDismiss;
    _popMenu.shouldEnableHaptics = self.popMenuShouldEnableHaptics;
}

- (void)addAction:(id<ETPopMenuAction>)action {
    if (_popMenu) {
        [_popMenu addAction:action];
    } else {
        if (!self.actions) {
            self.actions = [NSArray array];
        }
        NSMutableArray *mutableActions = [self.actions mutableCopy];
        [mutableActions addObject:action];
        self.actions = [mutableActions copy];
    }
}

- (void)presentFromSourceView:(id)sourceView {
    [self presentFromSourceView:sourceView onViewController:nil animated:YES completion:nil];
}

- (void)presentFromSourceView:(id)sourceView animated:(BOOL)animated {
    [self presentFromSourceView:sourceView onViewController:nil animated:animated completion:nil];
}

- (void)presentFromSourceView:(id)sourceView onViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion {
    [self prepareViewControllerWithSourceView:sourceView];
    
    if (!_popMenu) {
        NSLog(@"Pop Menu has not been initialized yet.");
        return;
    }
    
    if (viewController) {
        [viewController presentViewController:_popMenu animated:animated completion:^{
            if (completion) {
                completion();
            }
        }];
    } else {
        UIViewController *topViewController = [ETPopMenuManager getTopViewControllerInWindow];
        if (topViewController) {
            [topViewController presentViewController:_popMenu animated:animated completion:^{
                if (completion) {
                    completion();
                }
            }];
        }
    }
}

+ (UIViewController *)getTopViewControllerInWindow {
    UIWindow *keyWindow = nil;
    if (@available(iOS 13.0, *)) {
        for (UIWindow *window in [UIApplication sharedApplication].windows) {
            if (window.isKeyWindow) {
                keyWindow = window;
                break;
            }
        }
    } else {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
        keyWindow = [[UIApplication sharedApplication] keyWindow];
#pragma GCC diagnostic pop
    }
    if (keyWindow) {
        return [self topViewControllerWithRootViewController:keyWindow.rootViewController];
    }
    return nil;
}

+ (UIViewController *)topViewControllerWithRootViewController:(UIViewController *)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.topViewController];
    } else if (rootViewController.presentedViewController) {
        return [self topViewControllerWithRootViewController:rootViewController.presentedViewController];
    }
    return rootViewController;
}

@end

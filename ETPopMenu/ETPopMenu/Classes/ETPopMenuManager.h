//
//  ETPopMenuManager.h
//  ETPopMenu
//
//  Created by Flameliu liu on 2024/7/15.
//

#import <Foundation/Foundation.h>
#import "ETPopMenuViewController.h"

NS_ASSUME_NONNULL_BEGIN

// PopMenuManager
@interface ETPopMenuManager : NSObject

// MARK: - Properties

// Default manager singleton
+ (instancetype)defaultManager;

// Reference to the pop menu view controller
@property (nonatomic, strong) ETPopMenuViewController *popMenu;

// Reference to the pop menu delegate instance
@property (nonatomic, weak) id<ETPopMenuViewControllerDelegate> popMenuDelegate;

// Determines whether to dismiss menu after an action is selected
@property (nonatomic, assign) BOOL popMenuShouldDismissOnSelection;

// The dismissal handler for pop menu
@property (nonatomic, copy) void (^popMenuDidDismiss)(BOOL);

// Determines whether to use haptics for menu selection
@property (nonatomic, assign) BOOL popMenuShouldEnableHaptics;

// Appearance for passing on to pop menu
@property (nonatomic, strong) ETPopMenuAppearance *popMenuAppearance;

// Every action item about to be displayed
@property (nonatomic, strong) NSArray<id<ETPopMenuAction>> *actions;

// MARK: - Important Methods

// Pass a new action to pop menu
- (void)addAction:(id<ETPopMenuAction>)action;

- (void)presentFromSourceView:(id)sourceView;

- (void)presentFromSourceView:(id)sourceView animated:(BOOL)animated;

- (void)presentFromSourceView:(id)sourceView onViewController:(nullable UIViewController *)viewController animated:(BOOL)animated completion:(nullable void (^)(void))completion;

@end

NS_ASSUME_NONNULL_END

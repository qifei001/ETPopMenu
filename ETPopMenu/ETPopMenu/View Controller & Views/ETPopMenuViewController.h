//
//  ETPopMenuViewController.h
//  ETPopMenu
//
//  Created by Flameliu liu on 2024/7/15.
//

#import <UIKit/UIKit.h>
#import "ETPopMenuAppearance.h"
#import "ETPopMenuGradientView.h"
#import "ETPopMenuAction.h"

NS_ASSUME_NONNULL_BEGIN

@class ETPopMenuViewController;
@protocol ETPopMenuViewControllerDelegate <NSObject>

@optional
- (void)et_popMenuDidSelectItem:(ETPopMenuViewController *)popMenuViewController atIndex:(NSInteger)index;

@end

@interface ETPopMenuViewController : UIViewController

// MARK: - Properties

/// Delegate instance for handling callbacks.
@property (nonatomic, weak) id<ETPopMenuViewControllerDelegate> delegate;

/// Appearance configuration.
@property (nonatomic, strong) ETPopMenuAppearance *appearance;

/// Background overlay that covers the whole screen.
@property (nonatomic, strong) UIView *backgroundView;

/// The blur overlay view for translucent illusion.
@property (nonatomic, strong) UIVisualEffectView *blurOverlayView;

/// Main root view that has shadows.
@property (nonatomic, strong) UIView *containerView;

/// Main content view.
@property (nonatomic, strong) ETPopMenuGradientView *contentView;

/// The view contains all the actions.
@property (nonatomic, strong) UIStackView *actionsView;

/// The source View to be displayed from.
@property (nonatomic, strong) id sourceView;

/// The absolute source frame relative to screen.
@property (nonatomic, assign) CGRect absoluteSourceFrame;

/// The calculated content frame.
@property (nonatomic, assign) CGRect contentFrame;

// MARK: - Configurations

/// Determines whether to dismiss menu after an action is selected.
@property (nonatomic, assign) BOOL shouldDismissOnSelection;

/// Determines whether the pan gesture is enabled on the actions.
@property (nonatomic, assign) BOOL shouldEnablePanGesture;

/// Determines whether enable haptics for iPhone 7 and up.
@property (nonatomic, assign) BOOL shouldEnableHaptics;

/// Handler for when the menu is dismissed.
@property (nonatomic, copy) void(^didDismiss)(BOOL);

/// Actions of menu.
@property (nonatomic, strong) NSMutableArray <id<ETPopMenuAction>> *actions;

/// Max content width allowed for the content to stretch to.
@property (nonatomic, assign) CGFloat maxContentWidth;

// MARK: - Constraints

@property (nonatomic, strong) NSLayoutConstraint *contentLeftConstraint;
@property (nonatomic, strong) NSLayoutConstraint *contentTopConstraint;
@property (nonatomic, strong) NSLayoutConstraint *contentWidthConstraint;
@property (nonatomic, strong) NSLayoutConstraint *contentHeightConstraint;

- (instancetype)initWithSourceView:(id _Nullable)sourceView actions:(NSArray <id<ETPopMenuAction>> *)actions;
- (void)addAction:(id<ETPopMenuAction>)action;

@end

NS_ASSUME_NONNULL_END

//
//  ETPopMenuViewController.m
//  ETPopMenu
//
//  Created by Flameliu liu on 2024/7/15.
//

#import "ETPopMenuViewController.h"
#import "UIView+ETShadows.h"
#import "ETHaptics.h"
#import "ETPopMenuPresentAnimationController.h"
#import "ETPopMenuDismissAnimationController.h"
#import "UIColor+ETContrast.h"

@interface ETPopMenuViewController () <UIViewControllerTransitioningDelegate>

/// The UIView instance of source view.
@property (nonatomic, strong) UIView *sourceViewAsUIView;

/// Tap gesture to dismiss for background view.
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureForDismissal;

/// Pan gesture to highligh actions.
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureForMenu;


@end

@implementation ETPopMenuViewController

- (instancetype)initWithSourceView:(id)sourceView actions:(NSArray<id<ETPopMenuAction>> *)actions {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _sourceView = sourceView;
        _actions = [actions mutableCopy];
        _appearance = [[ETPopMenuAppearance alloc] init];
        _shouldDismissOnSelection = YES;
        _shouldEnablePanGesture = YES;
        _shouldEnableHaptics = YES;
        _maxContentWidth = UIScreen.mainScreen.bounds.size.width * 0.9;
        
        [self setAbsoluteSourceFrame];
        self.transitioningDelegate = self;
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
        self.modalPresentationCapturesStatusBarAppearance = YES;
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    self.view.backgroundColor = UIColor.clearColor;
    [self configureBackgroundView];
    [self configureContentView];
    [self configureActionsView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setAbsoluteSourceFrame {
    UIView *view = self.sourceViewAsUIView;
    if (view) {
        self.absoluteSourceFrame = [view convertRect:view.bounds toView:nil];
    }
}

- (void)addAction:(id<ETPopMenuAction>)action {
    [self.actions addObject:action];
}

// MARK: - Status Bar Appearance

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationFade;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    // If style defined, return
    if (self.appearance.popMenuStatusBarStyle != -1) {
        return self.appearance.popMenuStatusBarStyle;
    }
    
    // Contrast of blur style
    ETPopMenuBackgroundStyle *backgroundStyle = self.appearance.popMenuBackgroundStyle;
    if (backgroundStyle.blurStyle != -1) {
        switch (backgroundStyle.blurStyle) {
            case UIBlurEffectStyleDark:
                return UIStatusBarStyleLightContent;
            default:
                return UIStatusBarStyleDefault;
        }
    }
    
    // Contrast of dimmed color
    if (backgroundStyle.dimColor) {
        CGFloat red, green, blue, alpha;
        [backgroundStyle.dimColor.blackOrWhiteContrastingColor getRed:&red green:&green blue:&blue alpha:&alpha];
        if (red == 1 && green == 1 && blue == 1 && alpha == 1) {
            return UIStatusBarStyleLightContent;;
        } else {
            return UIStatusBarStyleDefault;
        }
    }
    
    return UIStatusBarStyleLightContent;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        [self configureBackgroundView];
        self.contentFrame = [self calculateContentFittingFrame];
        [self setupContentConstraints];
    } completion:nil];
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

- (void)configureBackgroundView {
    self.backgroundView.frame = self.view.frame;
    self.backgroundView.backgroundColor = UIColor.clearColor;
    self.backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.backgroundView addGestureRecognizer:self.tapGestureForDismissal];
    self.backgroundView.userInteractionEnabled = YES;
    
    ETPopMenuBackgroundStyle *backgroundStyle = self.appearance.popMenuBackgroundStyle;
    if (backgroundStyle.isBlurred) {
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:backgroundStyle.blurStyle];
        UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:effect];
        blurView.frame = self.backgroundView.frame;
        
        [self.backgroundView addSubview:blurView];
    }
    
    if (backgroundStyle.isDimmed) {
        UIColor *color = backgroundStyle.dimColor;
        CGFloat opacity = backgroundStyle.dimOpacity;
        
        self.backgroundView.backgroundColor = [color colorWithAlphaComponent:opacity];
    }
    
    [self.view insertSubview:self.backgroundView atIndex:0];
}

- (void)configureContentView {
    self.containerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.containerView addShadowWithOffset:CGSizeMake(0, 1) opacity:0.5 radius:20 color:UIColor.blackColor];
    self.containerView.layer.cornerRadius = self.appearance.popMenuCornerRadius;
    self.containerView.backgroundColor = UIColor.clearColor;
    
    [self.view addSubview:self.containerView];
    
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    self.contentView.layer.cornerRadius = self.appearance.popMenuCornerRadius;
    self.contentView.layer.masksToBounds = YES;
    self.contentView.clipsToBounds = YES;
    
    NSArray *colors = self.appearance.popMenuColor.backgroundColor.colors;
    if (colors.count > 0) {
        if (colors.count == 1) {
            // Configure solid fill background.
            self.contentView.backgroundColor = [colors.firstObject colorWithAlphaComponent:0.9];
            self.contentView.startColor = UIColor.clearColor;
            self.contentView.endColor = UIColor.clearColor;
        } else {
            // Configure gradient color.
            self.contentView.diagonalMode = YES;
            self.contentView.startColor = colors.firstObject;
            self.contentView.endColor = colors.lastObject;
            self.contentView.gradientLayer.opacity = 0.8;
        }
    }
    
    [self.containerView addSubview:self.blurOverlayView];
    [self.containerView addSubview:self.contentView];
    
    [self setupContentConstraints];
}

- (void)setupContentConstraints {
    self.contentLeftConstraint = [self.containerView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant:self.contentFrame.origin.x];
    self.contentTopConstraint = [self.containerView.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:self.contentFrame.origin.y];
    self.contentWidthConstraint = [self.containerView.widthAnchor constraintEqualToConstant:self.contentFrame.size.width];
    self.contentHeightConstraint = [self.containerView.heightAnchor constraintEqualToConstant:self.contentFrame.size.height];
    
    [NSLayoutConstraint activateConstraints:@[
        self.contentLeftConstraint,
        self.contentTopConstraint,
        self.contentWidthConstraint,
        self.contentHeightConstraint
    ]];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.contentView.leftAnchor constraintEqualToAnchor:self.containerView.leftAnchor],
        [self.contentView.rightAnchor constraintEqualToAnchor:self.containerView.rightAnchor],
        [self.contentView.topAnchor constraintEqualToAnchor:self.containerView.topAnchor],
        [self.contentView.bottomAnchor constraintEqualToAnchor:self.containerView.bottomAnchor],
    ]];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.blurOverlayView.leftAnchor constraintEqualToAnchor:self.containerView.leftAnchor],
        [self.blurOverlayView.rightAnchor constraintEqualToAnchor:self.containerView.rightAnchor],
        [self.blurOverlayView.topAnchor constraintEqualToAnchor:self.containerView.topAnchor],
        [self.blurOverlayView.bottomAnchor constraintEqualToAnchor:self.containerView.bottomAnchor],
    ]];
}

- (CGRect)calculateContentFittingFrame {
    CGFloat height;
    
    if (self.actions.count >= self.appearance.popMenuActionCountForScrollable) {
        // Make scroll view
        height = (CGFloat)self.appearance.popMenuActionCountForScrollable * self.appearance.popMenuActionHeight;
        height -= 20;
    } else {
        height = (CGFloat)self.actions.count * self.appearance.popMenuActionHeight;
    }
    
    CGSize size = CGSizeMake([self calculateContentWidth], height);
    CGPoint origin = [self calculateContentOriginWithSize:size];
    
    return (CGRect){origin, size};
}

- (CGPoint)calculateContentOriginWithSize:(CGSize)size {
    if (CGRectEqualToRect(self.absoluteSourceFrame, CGRectZero)) {
        return CGPointMake(self.view.center.x - size.width / 2, self.view.center.y - size.height / 2);
    }
    
    CGFloat minContentPos = UIScreen.mainScreen.bounds.size.width * 0.05;
    CGFloat maxContentPos = UIScreen.mainScreen.bounds.size.width * 0.95;
    
    // Get desired content origin point
    CGFloat offsetX = (size.width - self.absoluteSourceFrame.size.width ) / 2;
    CGPoint desiredOrigin = CGPointMake(self.absoluteSourceFrame.origin.x - offsetX, self.absoluteSourceFrame.origin.y);
    if (desiredOrigin.x + size.width > maxContentPos) {
        desiredOrigin.x = maxContentPos - size.width;
    }
    if (desiredOrigin.x < minContentPos) {
        desiredOrigin.x = minContentPos;
    }
    
    // Move content in place
    [self translateOverflowX:&desiredOrigin contentSize:size];
    [self translateOverflowY:&desiredOrigin contentSize:size];
    
    return desiredOrigin;
}

- (void)translateOverflowX:(CGPoint *)desiredOrigin contentSize:(CGSize)contentSize {
    CGFloat edgePadding = 8;
    BOOL leftSide = (*desiredOrigin).x - self.view.center.x < 0;

    CGPoint origin = CGPointMake(leftSide ? (*desiredOrigin).x : (*desiredOrigin).x + contentSize.width, (*desiredOrigin).y);

    if (!CGRectContainsPoint(self.view.frame, origin)) {
        CGFloat overflowX = (leftSide ? 1 : -1) * ((leftSide ? self.view.frame.origin.x : self.view.frame.origin.x + self.view.frame.size.width) - origin.x) + edgePadding;

        *desiredOrigin = CGPointMake((*desiredOrigin).x - (leftSide ? -1 : 1) * overflowX, origin.y);
    }
}

- (void)translateOverflowY:(CGPoint *)desiredOrigin contentSize:(CGSize)contentSize {
    CGFloat edgePadding;

    CGPoint origin = CGPointMake((*desiredOrigin).x, (*desiredOrigin).y + contentSize.height);

    if (@available(iOS 11.0, *)) {
        UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
        UIEdgeInsets safeAreaInsets = window.safeAreaInsets;
        edgePadding = safeAreaInsets.bottom;
    } else {
        edgePadding = 8;
    }

    // Check content inside of view or not
    if (!CGRectContainsPoint(self.view.frame, origin)) {
        CGFloat overFlowY = origin.y - self.view.frame.size.height + edgePadding;

        (*desiredOrigin).y -= overFlowY;
    }
}

- (CGFloat)calculateContentWidth {
    CGFloat contentFitWidth = ETPopMenuDefaultAction.textLeftPadding * 2;

    // Calculate the widest width from action titles to determine the width
    CGFloat maxTextWidth = 0;
    CGFloat maxIconWidth = 0;
    for (id<ETPopMenuAction> action in self.actions) {
        if (action.title) {
            UILabel *label = [UILabel new];
            label.text = action.title;
            CGSize labelSize = [label sizeThatFits:self.view.bounds.size];
            maxTextWidth = MAX(maxTextWidth, labelSize.width);
        }
        maxIconWidth = MAX(maxIconWidth, action.iconWidthHeight);
    }
    
    // Adding maxWidth to contentFitWidth
    contentFitWidth += maxTextWidth;
    
    // Adding Icon Width
    contentFitWidth += maxIconWidth;
    
    return MIN(contentFitWidth, self.maxContentWidth);
}

- (void)configureActionsView {
    self.actionsView.translatesAutoresizingMaskIntoConstraints = NO;
    self.actionsView.axis = UILayoutConstraintAxisVertical;
    self.actionsView.alignment = UIStackViewAlignmentFill;
    self.actionsView.distribution = UIStackViewDistributionFillEqually;
    
    for (id<ETPopMenuAction> action in self.actions) {
        action.font = self.appearance.popMenuFont;
        action.tintColor = action.color ? : self.appearance.popMenuColor.actionColor.color;
        action.cornerRadius = self.appearance.popMenuCornerRadius / 2;
        [action renderActionView];
        
        // Give separator to each action but the last
        if (action != self.actions.lastObject) {
            [self addSeparatorToActionView:action.view];
        }
        
        UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuDidTap:)];
        tapper.delaysTouchesEnded = NO;
        
        [action.view addGestureRecognizer:tapper];
        
        [self.actionsView addArrangedSubview:action.view];
    }
    
    // Check add scroll view or not
    if (self.actions.count >= self.appearance.popMenuActionCountForScrollable) {
        // Scrollable actions
        UIScrollView *scrollView = [UIScrollView new];
        scrollView.translatesAutoresizingMaskIntoConstraints = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = !self.appearance.popMenuScrollIndicatorHidden;
        scrollView.indicatorStyle = self.appearance.popMenuScrollIndicatorStyle;
        CGSize size = scrollView.contentSize;
        size.height = self.appearance.popMenuActionHeight * self.actions.count;
        scrollView.contentSize = size;
        
        [scrollView addSubview:self.actionsView];
        [self.contentView addSubview:scrollView];
        
        [NSLayoutConstraint activateConstraints:@[
            [scrollView.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor],
            [scrollView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor],
            [scrollView.rightAnchor constraintEqualToAnchor:self.contentView.rightAnchor],
            [scrollView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor],
        ]];
        
        [NSLayoutConstraint activateConstraints:@[
            [self.actionsView.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor],
            [self.actionsView.topAnchor constraintEqualToAnchor:scrollView.topAnchor],
            [self.actionsView.rightAnchor constraintEqualToAnchor:self.contentView.rightAnchor],
            [self.actionsView.heightAnchor constraintEqualToConstant:scrollView.contentSize.height]
        ]];
    } else {
        // Not scrollable
        [self.actionsView addGestureRecognizer:self.panGestureForMenu];
        
        [self.contentView addSubview:self.actionsView];
        
        [NSLayoutConstraint activateConstraints:@[
            [self.actionsView.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor],
            [self.actionsView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:4],
            [self.actionsView.rightAnchor constraintEqualToAnchor:self.contentView.rightAnchor],
            [self.actionsView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-4],
        ]];
    }
}

- (void)menuDidTap:(UITapGestureRecognizer *)tap {
    for (id<ETPopMenuAction> action in self.actions) {
        if (action.view == tap.view) {
            NSInteger index = [self.actions indexOfObject:action];
            [self actionDidSelectAtIndex:index];
            break;
        }
    }
}

- (void)addSeparatorToActionView:(UIView *)actionView {
    if ([self.appearance.popMenuItemSeparator isEqualToSeparator:[ETPopMenuActionSeparator none]]) {
        return;
    }
    
    ETPopMenuActionSeparator *separator = self.appearance.popMenuItemSeparator;
    
    UIView *separatorView = [UIView new];
    separatorView.translatesAutoresizingMaskIntoConstraints = NO;
    separatorView.backgroundColor = separator.color;
    
    [actionView addSubview:separatorView];
    
    [NSLayoutConstraint activateConstraints:@[
        [separatorView.leftAnchor constraintEqualToAnchor:actionView.leftAnchor],
        [separatorView.heightAnchor constraintEqualToConstant:separator.height],
        [separatorView.rightAnchor constraintEqualToAnchor:actionView.rightAnchor],
        [separatorView.bottomAnchor constraintEqualToAnchor:actionView.bottomAnchor],
    ]];
}

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [UIView new];
    }
    return _backgroundView;
}

- (UIVisualEffectView *)blurOverlayView {
    if (!_blurOverlayView) {
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        _blurOverlayView = [[UIVisualEffectView alloc] initWithEffect:effect];
        _blurOverlayView.translatesAutoresizingMaskIntoConstraints = NO;
        _blurOverlayView.layer.cornerRadius = self.appearance.popMenuCornerRadius;
        _blurOverlayView.layer.masksToBounds = YES;
        _blurOverlayView.userInteractionEnabled = NO;
    }
    return _blurOverlayView;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [UIView new];
    }
    return _containerView;
}

- (ETPopMenuGradientView *)contentView {
    if (!_contentView) {
        _contentView = [ETPopMenuGradientView new];
    }
    return _contentView;
}

- (UIStackView *)actionsView {
    if (!_actionsView) {
        _actionsView = [UIStackView new];
    }
    return _actionsView;
}

- (CGRect)contentFrame {
    return [self calculateContentFittingFrame];
}

- (NSMutableArray *)actions {
    if (!_actions) {
        _actions = [@[] mutableCopy];
    }
    return _actions;
}

- (UIView *)sourceViewAsUIView {
    if (!self.sourceView) return nil;
    
    if ([self.sourceView isKindOfClass:[UIBarButtonItem class]]) {
        UIView *buttonView = [self.sourceView valueForKey:@"view"];
        if ([buttonView isKindOfClass:[UIView class]]) {
            return buttonView;
        }
    }
    
    if ([self.sourceView isKindOfClass:[UIView class]]) {
        return (UIView *)self.sourceView;
    }
    
    return nil;
}

- (UITapGestureRecognizer *)tapGestureForDismissal {
    if (!_tapGestureForDismissal) {
        _tapGestureForDismissal = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewDidTap:)];
        _tapGestureForDismissal.cancelsTouchesInView = NO;
        _tapGestureForDismissal.delaysTouchesEnded = NO;
    }
    return _tapGestureForDismissal;
}

- (void)backgroundViewDidTap:(UITapGestureRecognizer *)tap {
    if (tap == self.tapGestureForDismissal && ![self touchedInsideContent:[tap locationInView:self.view]]) {
        [self dismissViewControllerAnimated:YES completion:^{
            if (self.didDismiss) {
                self.didDismiss(NO);
            }
        }];
    }
}

- (BOOL)touchedInsideContent:(CGPoint)location {
    return CGRectContainsPoint(self.containerView.frame, location);
}

- (UIPanGestureRecognizer *)panGestureForMenu {
    if (!_panGestureForMenu) {
        _panGestureForMenu = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(menuDidPan:)];
        _panGestureForMenu.maximumNumberOfTouches = 1;
    }
    return _panGestureForMenu;
}

- (void)menuDidPan:(UIPanGestureRecognizer *)pan {
    if (!self.shouldEnablePanGesture) return;
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged: {
            NSInteger index = [self associatedActionIndex:pan];
            if (index != NSNotFound) {
                id<ETPopMenuAction> action = self.actions[index];
                if (action.highlighted) return;
                
                if (self.shouldEnableHaptics) {
                    ETHaptics *haptic = [[ETHaptics alloc] initWithType:ETHapticTypeSelection];
                    [haptic generate];
                }
                
                action.highlighted = YES;
                
                for (id<ETPopMenuAction> ac in self.actions) {
                    if (ac != action) {
                        ac.highlighted = NO;
                    }
                }
            }
        }
            break;
        case UIGestureRecognizerStateEnded: {
            for (id<ETPopMenuAction> ac in self.actions) {
                if (ac.highlighted) {
                    ac.highlighted = NO;
                }
            }
            
            NSInteger index = [self associatedActionIndex:pan];
            if (index != NSNotFound) {
                [self actionDidSelectAtIndex:index animated:NO];
            }
        }
            break;
        default:
            break;
    }
}

- (NSInteger)associatedActionIndex:(UIGestureRecognizer *)ges {
    if ([self touchedInsideContent:[ges locationInView:self.view]]) {
        CGPoint touchLocation = [ges locationInView:self.actionsView];
        
        for (UIView *view in self.actionsView.arrangedSubviews) {
            if (CGRectContainsPoint(view.frame, touchLocation)) {
                return [self.actionsView.arrangedSubviews indexOfObject:view];
            }
        }
    }
    
    return NSNotFound;
}

- (void)actionDidSelectAtIndex:(NSInteger)index {
    [self actionDidSelectAtIndex:index animated:YES];
}

- (void)actionDidSelectAtIndex:(NSInteger)index animated:(BOOL)animated {
    id<ETPopMenuAction> action = self.actions[index];
    [action actionSelectedAnimated:animated];
    
    if (self.shouldEnableHaptics) {
        if (@available(iOS 10.0, *)) {
            ETHaptics *haptic = [[ETHaptics alloc] initWithType:ETHapticTypeImpact impactStyle:ETHapticImpactStyleMedium notificationType:ETHapticNotificationTypeNone];
            [haptic generate];
        }
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(et_popMenuDidSelectItem:atIndex:)]) {
        [self.delegate et_popMenuDidSelectItem:self atIndex:index];
    }
    
    if (self.shouldDismissOnSelection) {
        [self dismissViewControllerAnimated:YES completion:^{
            if (self.didDismiss) {
                self.didDismiss(YES);
            }
        }];
    }
}

#pragma mark - UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [[ETPopMenuPresentAnimationController alloc] initWithSourceFrame:self.absoluteSourceFrame];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [[ETPopMenuDismissAnimationController alloc] initWithSourceFrame:self.absoluteSourceFrame];;
}

@end

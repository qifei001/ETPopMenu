//
//  ETPopMenuAction.h
//  ETPopMenu
//
//  Created by Flameliu liu on 2024/7/15.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// Define the PopMenuAction protocol
@protocol ETPopMenuAction <NSObject>

// Title of the action.
@property (nonatomic, readonly, nullable) NSString *title;

// Image of the action.
@property (nonatomic, readonly, nullable) UIImage *image;

// Container view of the action.
@property (nonatomic, readonly, strong) UIView *view;

// The initial color of the action.
@property (nonatomic, readonly, nullable) UIColor *color;

typedef void(^ETPopMenuActionHandler)(id<ETPopMenuAction> action);

// The handler of action.
@property (nonatomic, copy, nullable) ETPopMenuActionHandler didSelect;

// Left padding when texts-only.
+ (CGFloat)textLeftPadding;

// Icon left padding when icons are present.
+ (CGFloat)iconLeftPadding;

// Icon sizing.
@property (nonatomic) CGFloat iconWidthHeight;

// The color to set for both label and icon.
@property (nonatomic) UIColor *tintColor;

// The font for label.
@property (nonatomic) UIFont *font;

// The corner radius of action view.
@property (nonatomic) CGFloat cornerRadius;

// Is the view highlighted by gesture.
@property (nonatomic) BOOL highlighted;

// Render the view for action.
- (void)renderActionView;

// Called when the action gets selected.
- (void)actionSelectedAnimated:(BOOL)animated;

@end

// The default PopMenu action class.
@interface ETPopMenuDefaultAction : NSObject <ETPopMenuAction>

// Title of action.
@property (nonatomic, strong, nullable) NSString *title;

// Icon of action.
@property (nonatomic, strong, nullable) UIImage *image;

// Image rendering option.
@property (nonatomic) UIImageRenderingMode imageRenderingMode;

// Rendered view of action.
@property (nonatomic, strong) UIView *view;

// Color of action.
@property (nonatomic, strong, nullable) UIColor *color;

// Is the view highlighted by gesture.
@property (nonatomic) BOOL highlighted;

// Handler of action when selected.
@property (nonatomic, copy, nullable) ETPopMenuActionHandler didSelect;

// Icon sizing.
@property (nonatomic) CGFloat iconWidthHeight;

// Background color for highlighted state.
@property (nonatomic) UIColor *backgroundColor;

// Title label view instance.
@property (nonatomic, strong) UILabel *titleLabel;

// Icon image view instance.
@property (nonatomic, strong) UIImageView *iconImageView;

// Initializer.
- (instancetype)initWithTitle:(nullable NSString *)title image:(nullable UIImage *)image color:(nullable UIColor *)color;

- (instancetype)initWithTitle:(nullable NSString *)title image:(nullable UIImage *)image color:(nullable UIColor *)color didSelect:(nullable ETPopMenuActionHandler)didSelect;

// Setup necessary views.
- (void)configureViews;

// Highlight the view when panned on top,
// unhighlight the view when pan gesture left.
- (void)highlightActionView:(BOOL)highlight;

@end

NS_ASSUME_NONNULL_END

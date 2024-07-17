//
//  ETPopMenuAction.m
//  ETPopMenu
//
//  Created by Flameliu liu on 2024/7/15.
//

#import "ETPopMenuAction.h"
#import "UIColor+ETContrast.h"

@implementation ETPopMenuDefaultAction

// Constants
+ (CGFloat)textLeftPadding {
    return 25;
}
+ (CGFloat)iconLeftPadding {
    return 18;
}

// Initializer
- (instancetype)initWithTitle:(nullable NSString *)title image:(nullable UIImage *)image color:(nullable UIColor *)color {
    return [self initWithTitle:title image:image color:color didSelect:nil];
}

- (instancetype)initWithTitle:(nullable NSString *)title image:(nullable UIImage *)image color:(nullable UIColor *)color didSelect:(ETPopMenuActionHandler)didSelect {
    self = [super init];
    if (self) {
        _title = title;
        _image = image;
        _color = color;
        _didSelect = didSelect;
        _view = [[UIView alloc] init];
        _iconWidthHeight = 27;
        _backgroundColor = UIColor.whiteColor;
        _imageRenderingMode = UIImageRenderingModeAlwaysTemplate;
        _highlighted = NO;
    }
    return self;
}

// Render the action view.
- (void)renderActionView {
    self.view.layer.cornerRadius = 14;
    self.view.layer.masksToBounds = YES;
    
    [self configureViews];
}

// Setup necessary views.
- (void)configureViews {
    BOOL hasImage = self.image != nil;
    
    if (hasImage) {
        [self.view addSubview:self.iconImageView];
        
        [NSLayoutConstraint activateConstraints:@[
            [self.iconImageView.widthAnchor constraintEqualToConstant:self.iconWidthHeight],
            [self.iconImageView.heightAnchor constraintEqualToAnchor:self.iconImageView.widthAnchor],
            [self.iconImageView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:ETPopMenuDefaultAction.iconLeftPadding],
            [self.iconImageView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor]
        ]];
    }
    
    [self.view addSubview:self.titleLabel];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.titleLabel.leadingAnchor constraintEqualToAnchor:hasImage ? self.iconImageView.trailingAnchor : self.view.leadingAnchor constant:hasImage ? 8 : ETPopMenuDefaultAction.textLeftPadding],
        [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:20],
        [self.titleLabel.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor]
    ]];
}

// Highlight the view when panned on top,
// unhighlight the view when pan gesture left.
- (void)highlightActionView:(BOOL)highlight {
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.26 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:9 options:highlight ? UIViewAnimationOptionCurveEaseIn : UIViewAnimationOptionCurveEaseOut animations:^{
            self.view.transform = highlight ? CGAffineTransformMakeScale(1.09, 1.09) : CGAffineTransformIdentity;
            self.view.backgroundColor = highlight ? [self.backgroundColor colorWithAlphaComponent:0.25] : [UIColor clearColor];
        } completion:nil];
    });
}

// When the action is selected.
- (void)actionSelectedAnimated:(BOOL)animated {
    // Trigger handler.
    if (self.didSelect) {
        self.didSelect(self);
    }
    
    // Animate selection
    if (!animated) { return; }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.175 animations:^{
            self.view.transform = CGAffineTransformMakeScale(0.915, 0.915);
            self.view.backgroundColor = [self.backgroundColor colorWithAlphaComponent:0.18];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.175 animations:^{
                self.view.transform = CGAffineTransformIdentity;
                self.view.backgroundColor = [UIColor clearColor];
            }];
        }];
    });
}

- (void)setTintColor:(UIColor *)tintColor {
    self.titleLabel.textColor = tintColor;
    self.iconImageView.tintColor = tintColor;
    self.backgroundColor = tintColor.blackOrWhiteContrastingColor;
}

- (UIColor *)tintColor {
    return self.titleLabel.textColor;
}

- (void)setFont:(UIFont *)font {
    self.titleLabel.font = font;
}

- (UIFont *)font {
    return self.titleLabel.font;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.view.layer.cornerRadius = cornerRadius;
}

- (CGFloat)cornerRadius {
    return self.view.layer.cornerRadius;
}

- (void)setHighlighted:(BOOL)highlighted {
    if (_highlighted != highlighted) {
        _highlighted = highlighted;
        [self highlightActionView:highlighted];
    }
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.userInteractionEnabled = NO;
        _titleLabel.text = self.title;
    }
    return _titleLabel;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
        _iconImageView.translatesAutoresizingMaskIntoConstraints = NO;
        _iconImageView.image = [self.image imageWithRenderingMode:self.imageRenderingMode];
    }
    return _iconImageView;
}

@end

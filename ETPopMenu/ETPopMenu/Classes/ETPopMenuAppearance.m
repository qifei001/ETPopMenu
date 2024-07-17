//
//  ETPopMenuAppearance.m
//  ETPopMenu
//
//  Created by Flameliu liu on 2024/7/15.
//

#import "ETPopMenuAppearance.h"

@implementation ETPopMenuBackgroundStyle

+ (instancetype)dimmedWithColor:(UIColor *)color opacity:(CGFloat)opacity {
    ETPopMenuBackgroundStyle *style = [[ETPopMenuBackgroundStyle alloc] init];
    style.isDimmed = YES;
    style.dimColor = color;
    style.dimOpacity = opacity;
    return style;
}

+ (instancetype)blurredWithStyle:(UIBlurEffectStyle)blurEffectStyle {
    ETPopMenuBackgroundStyle *style = [[ETPopMenuBackgroundStyle alloc] init];
    style.isBlurred = YES;
    style.blurStyle = blurEffectStyle;
    return style;
}

+ (instancetype)none {
    return [[ETPopMenuBackgroundStyle alloc] init];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _blurStyle = -1;
    }
    return self;
}

@end

@implementation ETPopMenuActionBackgroundColor

+ (instancetype)solidWithColor:(UIColor *)color {
    ETPopMenuActionBackgroundColor *bgColor = [[ETPopMenuActionBackgroundColor alloc] init];
    bgColor.colors = @[color];
    return bgColor;
}

+ (instancetype)gradientWithColors:(NSArray *)colors {
    ETPopMenuActionBackgroundColor *bgColor = [[ETPopMenuActionBackgroundColor alloc] init];
    bgColor.colors = colors;
    return bgColor;
}

@end


@implementation ETPopMenuActionColor

+ (instancetype)tintColor:(UIColor *)color {
    ETPopMenuActionColor *actionColor = [[ETPopMenuActionColor alloc] init];
    actionColor.color = color;
    return actionColor;
}

@end

@implementation ETPopMenuColor

+ (instancetype)configureWithBackground:(ETPopMenuActionBackgroundColor *)background action:(ETPopMenuActionColor *)action {
    ETPopMenuColor *color = [[ETPopMenuColor alloc] init];
    color.backgroundColor = background;
    color.actionColor = action;
    return color;
}

+ (instancetype)defaultColor {
    return [ETPopMenuColor configureWithBackground:[ETPopMenuActionBackgroundColor gradientWithColors:@[[UIColor colorWithRed:0.168627451 green:0.168627451 blue:0.168627451 alpha:1], [UIColor colorWithRed:0.2156862745 green:0.2156862745 blue:0.2156862745 alpha:1]]] action:[ETPopMenuActionColor tintColor:UIColor.whiteColor]];
}

@end

@implementation ETPopMenuActionSeparator

- (instancetype)init {
    self = [super init];
    if (self) {
        _height = 0.5;
        _color = [UIColor.whiteColor colorWithAlphaComponent:0.5];
    }
    return self;
}

+ (instancetype)fillWithColor:(UIColor *)color height:(CGFloat)height {
    ETPopMenuActionSeparator *separator = [[ETPopMenuActionSeparator alloc] init];
    separator.color = color;
    separator.height = height;
    return separator;
}

+ (instancetype)none {
    ETPopMenuActionSeparator *separator = [[ETPopMenuActionSeparator alloc] init];
    separator.color = [UIColor clearColor];
    separator.height = 0;
    return separator;
}

- (BOOL)isEqualToSeparator:(ETPopMenuActionSeparator *)separator {
    return self.color == separator.color && self.height == separator.height;
}

@end

@implementation ETPopMenuPresentationStyle

+ (instancetype)cover {
    ETPopMenuPresentationStyle *presentationStyle = [[ETPopMenuPresentationStyle alloc] init];
    presentationStyle.direction = ETPopMenuDirectionNone;
    presentationStyle.offset = CGPointZero;
    return presentationStyle;
}

+ (instancetype)nearWithDirection:(ETPopMenuDirection)direction offset:(CGPoint)offset {
    ETPopMenuPresentationStyle *presentationStyle = [[ETPopMenuPresentationStyle alloc] init];
    presentationStyle.direction = direction;
    presentationStyle.offset = offset;
    return presentationStyle;
}

@end

@implementation ETPopMenuAppearance

- (instancetype)init {
    self = [super init];
    if (self) {
        _popMenuColor = [ETPopMenuColor defaultColor];
        _popMenuBackgroundStyle = [ETPopMenuBackgroundStyle dimmedWithColor:UIColor.blackColor opacity:0.4];
        _popMenuFont = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
        _popMenuCornerRadius = 24;
        _popMenuActionHeight = 50;
        _popMenuActionCountForScrollable = 6;
        _popMenuScrollIndicatorStyle = UIScrollViewIndicatorStyleWhite;
        _popMenuScrollIndicatorHidden = NO;
        _popMenuItemSeparator = [ETPopMenuActionSeparator none];
        _popMenuStatusBarStyle = -1;
        _popMenuPresentationStyle = [ETPopMenuPresentationStyle cover];
    }
    return self;
}

@end

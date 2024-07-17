//
//  ETPopMenuAppearance.h
//  ETPopMenu
//
//  Created by Flameliu liu on 2024/7/15.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#if TARGET_OS_MAC
    #define Color NSColor
#else
    #define Color UIColor
#endif

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ETPopMenuDirection) {
    ETPopMenuDirectionTop,
    ETPopMenuDirectionLeft,
    ETPopMenuDirectionRight,
    ETPopMenuDirectionBottom,
    ETPopMenuDirectionNone
};

// ETPopMenuBackgroundStyle
@interface ETPopMenuBackgroundStyle : NSObject

@property (nonatomic, assign) BOOL isDimmed;
@property (nonatomic, strong) UIColor *dimColor;
@property (nonatomic, assign) CGFloat dimOpacity;
@property (nonatomic, assign) BOOL isBlurred;
@property (nonatomic, assign) UIBlurEffectStyle blurStyle;

+ (instancetype)dimmedWithColor:(UIColor *)color opacity:(CGFloat)opacity;
+ (instancetype)blurredWithStyle:(UIBlurEffectStyle)style;
+ (instancetype)none;

@end

// ETPopMenuActionBackgroundColor
@interface ETPopMenuActionBackgroundColor : NSObject

@property (nonatomic, strong) NSArray<UIColor *> *colors;

+ (instancetype)solidWithColor:(UIColor *)color;
+ (instancetype)gradientWithColors:(NSArray *)colors;

@end

// ETPopMenuActionColor
@interface ETPopMenuActionColor : NSObject

@property (nonatomic, strong) UIColor *color;

+ (instancetype)tintColor:(UIColor *)color;

@end

// ETPopMenuColor
@interface ETPopMenuColor : NSObject

@property (nonatomic, strong) ETPopMenuActionBackgroundColor *backgroundColor;
@property (nonatomic, strong) ETPopMenuActionColor *actionColor;

+ (instancetype)configureWithBackground:(ETPopMenuActionBackgroundColor *)background action:(ETPopMenuActionColor *)action;
+ (instancetype)defaultColor;

@end

// ETPopMenuActionSeparator
@interface ETPopMenuActionSeparator : NSObject

@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) UIColor *color;

+ (instancetype)fillWithColor:(UIColor *)color height:(CGFloat)height;
+ (instancetype)none;
- (BOOL)isEqualToSeparator:(ETPopMenuActionSeparator *)separator;

@end

// ETPopMenuPresentationStyle
@interface ETPopMenuPresentationStyle : NSObject

@property (nonatomic, assign) ETPopMenuDirection direction;
@property (nonatomic, assign) CGPoint offset;

+ (instancetype)cover;
+ (instancetype)nearWithDirection:(ETPopMenuDirection)direction offset:(CGPoint)offset;

@end

@interface ETPopMenuAppearance : NSObject

@property (nonatomic, strong) ETPopMenuColor *popMenuColor;
@property (nonatomic, strong) ETPopMenuBackgroundStyle *popMenuBackgroundStyle;
@property (nonatomic, strong) UIFont *popMenuFont;
@property (nonatomic, assign) CGFloat popMenuCornerRadius;
@property (nonatomic, assign) CGFloat popMenuActionHeight;
@property (nonatomic, assign) NSUInteger popMenuActionCountForScrollable;
@property (nonatomic, assign) UIScrollViewIndicatorStyle popMenuScrollIndicatorStyle;
@property (nonatomic, assign) BOOL popMenuScrollIndicatorHidden;
@property (nonatomic, strong) ETPopMenuActionSeparator *popMenuItemSeparator;
@property (nonatomic, assign) UIStatusBarStyle popMenuStatusBarStyle;
@property (nonatomic, strong) ETPopMenuPresentationStyle *popMenuPresentationStyle;

@end

NS_ASSUME_NONNULL_END

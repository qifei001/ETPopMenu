//
//  UIColor+ETContrast.h
//  ETPopMenu
//
//  Created by Flameliu liu on 2024/7/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Extensions)

- (void)getRGBA:(CGFloat *)red green:(CGFloat *)green blue:(CGFloat *)blue alpha:(CGFloat *)alpha;
- (UIColor *)blackOrWhiteContrastingColor;

@end

NS_ASSUME_NONNULL_END

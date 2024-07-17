//
//  UIColor+ETContrast.m
//  ETPopMenu
//
//  Created by Flameliu liu on 2024/7/15.
//

#import "UIColor+ETContrast.h"

@implementation UIColor (Extensions)

- (void)getRGBA:(CGFloat *)red green:(CGFloat *)green blue:(CGFloat *)blue alpha:(CGFloat *)alpha {
    CGColorRef cgColor = [self CGColor];
    const CGFloat *components;
    
    if (CGColorGetNumberOfComponents(cgColor) == 4) {
        components = CGColorGetComponents(cgColor);
        *red = components[0];
        *green = components[1];
        *blue = components[2];
        *alpha = components[3];
    } else if (CGColorGetNumberOfComponents(cgColor) == 2) {
        components = CGColorGetComponents(cgColor);
        *red = components[0];
        *green = components[0];
        *blue = components[0];
        *alpha = components[1];
    } else {
        *red = 0;
        *green = 0;
        *blue = 0;
        *alpha = 1;
    }
}

- (UIColor *)blackOrWhiteContrastingColor {
    CGFloat red, green, blue, alpha;
    [self getRGBA:&red green:&green blue:&blue alpha:&alpha];
    CGFloat value = 1 - (0.299 * red + 0.587 * green + 0.114 * blue);
    return value < 0.5 ? [UIColor blackColor] : [UIColor whiteColor];
}

@end

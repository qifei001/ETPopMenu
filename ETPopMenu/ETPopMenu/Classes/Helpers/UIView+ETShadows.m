//
//  UIView+ETShadows.m
//  ETPopMenu
//
//  Created by Flameliu liu on 2024/7/15.
//

#import "UIView+ETShadows.h"

@implementation UIView (Shadows)

- (void)addShadowWithOffset:(CGSize)offset opacity:(CGFloat)opacity radius:(CGFloat)radius color:(UIColor *)color {
    CALayer *layer = self.layer;
    layer.shadowOffset = offset;
    layer.shadowOpacity = opacity;
    layer.shadowRadius = radius;
    layer.shadowColor = [color CGColor];
    layer.masksToBounds = NO;
}

@end

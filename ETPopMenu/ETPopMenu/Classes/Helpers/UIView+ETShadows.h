//
//  UIView+ETShadows.h
//  ETPopMenu
//
//  Created by Flameliu liu on 2024/7/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Shadows)

- (void)addShadowWithOffset:(CGSize)offset opacity:(CGFloat)opacity radius:(CGFloat)radius color:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END

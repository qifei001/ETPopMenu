//
//  ETPopMenuPresentAnimationController.h
//  ETPopMenu
//
//  Created by Flameliu liu on 2024/7/15.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// PopMenuPresentAnimationController
@interface ETPopMenuPresentAnimationController : NSObject <UIViewControllerAnimatedTransitioning>

// Source view's frame.
@property (nonatomic, readonly) CGRect sourceFrame;

// Initializer with source view's frame.
- (instancetype)initWithSourceFrame:(CGRect)sourceFrame;

@end

NS_ASSUME_NONNULL_END

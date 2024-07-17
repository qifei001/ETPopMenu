//
//  ETPopMenuGradientView.h
//  ETPopMenu
//
//  Created by Flameliu liu on 2024/7/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ETPopMenuGradientView : UIView

@property (nonatomic, strong) UIColor *startColor;
@property (nonatomic, strong) UIColor *endColor;
@property (nonatomic, assign) double startLocation;
@property (nonatomic, assign) double endLocation;
@property (nonatomic, assign) BOOL horizontalMode;
@property (nonatomic, assign) BOOL diagonalMode;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;

- (void)setup;

@end

NS_ASSUME_NONNULL_END

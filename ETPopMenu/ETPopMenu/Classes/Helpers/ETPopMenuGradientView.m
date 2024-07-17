//
//  ETPopMenuGradientView.m
//  ETPopMenu
//
//  Created by Flameliu liu on 2024/7/15.
//

#import "ETPopMenuGradientView.h"

@implementation ETPopMenuGradientView

+ (Class)layerClass {
    return CAGradientLayer.class;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _startColor = UIColor.blackColor;
        _endColor = UIColor.whiteColor;
        _startLocation = 0.05;
        _endLocation = 0.95;
        _horizontalMode = NO;
        _diagonalMode = NO;
        [self setup];
    }
    return self;
}

- (CAGradientLayer *)gradientLayer {
    return (CAGradientLayer *)self.layer;
}

- (void)setStartColor:(UIColor *)startColor {
    if (_startColor != startColor) {
        _startColor = startColor;
        [self updateColors];
    }
}

- (void)setEndColor:(UIColor *)endColor {
    if (_endColor != endColor) {
        _endColor = endColor;
        [self updateColors];
    }
}

- (void)setStartLocation:(double)startLocation {
    if (_startLocation != startLocation) {
        _startLocation = startLocation;
        [self updateLocations];
    }
}

- (void)setEndLocation:(double)endLocation {
    if (_endLocation != endLocation) {
        _endLocation = endLocation;
        [self updateLocations];
    }
}

- (void)setHorizontalMode:(BOOL)horizontalMode {
    if (_horizontalMode != horizontalMode) {
        _horizontalMode = horizontalMode;
        [self updatePoints];
    }
}

- (void)setDiagonalMode:(BOOL)diagonalMode {
    if (_diagonalMode != diagonalMode) {
        _diagonalMode = diagonalMode;
        [self updatePoints];
    }
}

- (void)updatePoints {
    if (_horizontalMode) {
        self.gradientLayer.startPoint = _diagonalMode ? CGPointMake(1, 0) : CGPointMake(0, 0.5);
        self.gradientLayer.endPoint = _diagonalMode ? CGPointMake(0, 1) : CGPointMake(1, 0.5);
    } else {
        self.gradientLayer.startPoint = _diagonalMode ? CGPointMake(0, 0) : CGPointMake(0.5, 0);
        self.gradientLayer.endPoint = _diagonalMode ? CGPointMake(1, 1) : CGPointMake(0.5, 1);
    }
}

- (void)updateLocations {
    self.gradientLayer.locations = [NSArray arrayWithObjects:@(_startLocation), @(_endLocation), nil];
}

- (void)updateColors {
    self.gradientLayer.colors = [NSArray arrayWithObjects:(__bridge id)_startColor.CGColor, (__bridge id)_endColor.CGColor, nil];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self setup];
}

- (void)setup {
    [self updatePoints];
    [self updateLocations];
    [self updateColors];
}

@end

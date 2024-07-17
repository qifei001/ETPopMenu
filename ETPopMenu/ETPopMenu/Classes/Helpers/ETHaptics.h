//
//  ETHaptics.h
//  ETPopMenu
//
//  Created by Flameliu liu on 2024/7/15.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// Haptic Generator Helper.
typedef NS_ENUM(NSInteger, ETHapticType) {
    ETHapticTypeImpact,
    ETHapticTypeNotification,
    ETHapticTypeSelection
};

typedef NS_ENUM(NSInteger, ETHapticImpactStyle) {
    ETHapticImpactStyleNone = -1,
    ETHapticImpactStyleLight = UIImpactFeedbackStyleLight,
    ETHapticImpactStyleMedium = UIImpactFeedbackStyleMedium,
    ETHapticImpactStyleHeavy = UIImpactFeedbackStyleHeavy
};

typedef NS_ENUM(NSInteger, ETHapticNotificationType) {
    ETHapticNotificationTypeNone = -1,
    ETHapticNotificationTypeSuccess = UINotificationFeedbackTypeSuccess,
    ETHapticNotificationTypeError = UINotificationFeedbackTypeError,
    ETHapticNotificationTypeWarning = UINotificationFeedbackTypeWarning
};

@interface ETHaptics : NSObject

@property (nonatomic, readonly) ETHapticType type;
@property (nonatomic, readonly) ETHapticImpactStyle impactStyle;
@property (nonatomic, readonly) ETHapticNotificationType notificationType;

- (instancetype)initWithType:(ETHapticType)type;
- (instancetype)initWithType:(ETHapticType)type impactStyle:(ETHapticImpactStyle)impactStyle notificationType:(ETHapticNotificationType)notificationType;
- (void)generate;

@end

NS_ASSUME_NONNULL_END

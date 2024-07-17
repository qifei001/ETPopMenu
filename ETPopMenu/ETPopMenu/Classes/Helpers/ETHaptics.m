//
//  ETHaptics.m
//  ETPopMenu
//
//  Created by Flameliu liu on 2024/7/15.
//

#import "ETHaptics.h"

@implementation ETHaptics

- (instancetype)initWithType:(ETHapticType)type {
    return [self initWithType:type impactStyle:ETHapticImpactStyleNone notificationType:ETHapticNotificationTypeNone];
}

- (instancetype)initWithType:(ETHapticType)type impactStyle:(ETHapticImpactStyle)impactStyle notificationType:(ETHapticNotificationType)notificationType {
    self = [super init];
    if (self) {
        _type = type;
        _impactStyle = impactStyle;
        _notificationType = notificationType;
    }
    return self;
}

- (void)generate {
    if (@available(iOS 10.0, *)) {
        switch (self.type) {
            case ETHapticTypeImpact: {
                UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:(UIImpactFeedbackStyle)self.impactStyle];
                [generator prepare];
                [generator impactOccurred];
                break;
            }
            case ETHapticTypeNotification: {
                UINotificationFeedbackGenerator *notificationGenerator = [[UINotificationFeedbackGenerator alloc] init];
                [notificationGenerator prepare];
                [notificationGenerator notificationOccurred:(UINotificationFeedbackType)self.notificationType];
                break;
            }
            case ETHapticTypeSelection: {
                UISelectionFeedbackGenerator *selectionGenerator = [[UISelectionFeedbackGenerator alloc] init];
                [selectionGenerator prepare];
                [selectionGenerator selectionChanged];
                break;
            }
            default:
                break;
        }
    } else {
        
    }
}

@end

//
//  AppDelegate.h
//  OneCallKitDemo
//
//  Created by wintel on 16/8/17.
//  Copyright © 2016年 wintel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PushKit/PushKit.h>

#import "WTCallManager.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate,PKPushRegistryDelegate>
{
    NSMutableDictionary *notificationCenterRequired;
}
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) PKPushRegistry *pushRegistry;

@property (strong, nonatomic,readonly) WTCallManager *callManager;


- (NSDictionary *)ReadNotificationCenterRequired;
- (void)RemoveNotificationCenterRequired:(NSString *)key bySubInfo:(NSDictionary *)info;
- (void)RemoveNotificationCenterRequired:(NSString *)key;

+ (AppDelegate *)sharedDelegate;
- (void)displayIncomingCallUUID:(NSUUID *)uuid handle:(NSString *)handle hasVideo:(BOOL)hasVideo completion:(void (^)(NSError *_Nullable error))completion;

@end


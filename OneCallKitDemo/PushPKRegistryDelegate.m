//
//  PushPKRegistryDelegate.m
//  OneCallKitDemo
//
//  Created by wintel on 16/8/26.
//  Copyright © 2016年 wintel. All rights reserved.
//

#import "PushPKRegistryDelegate.h"

@implementation PushPKRegistryDelegate

- (instancetype)init{
    self = [super init];
    if (self)     {
        //iOS 8之后
        _pushRegistry = [[PKPushRegistry alloc] initWithQueue:dispatch_get_main_queue()];
        _pushRegistry.delegate = self;
        _pushRegistry.desiredPushTypes = [NSSet setWithObject:PKPushTypeVoIP];
    }
    return self;
}

#pragma mark - PKPushRegistryDelegate
- (void)pushRegistry:(PKPushRegistry *)registry didUpdatePushCredentials:(PKPushCredentials *)credentials forType:(PKPushType)type{
    NSLog(@"pushRegistry: didUpdatePushCredentials:");
}

/*!
 @method        pushRegistry:didReceiveIncomingPushWithPayload:forType:
 @abstract      This method is invoked when a push notification has been received for the specified PKPushType.
 @param         registry
 The PKPushRegistry instance responsible for the delegate callback.
 @param         payload
 The push payload sent by a developer via APNS server API.
 @param         type
 This is a PKPushType constant which is present in [registry desiredPushTypes].
 */
- (void)pushRegistry:(PKPushRegistry *)registry didReceiveIncomingPushWithPayload:(PKPushPayload *)payload forType:(PKPushType)type{
    if (type == PKPushTypeVoIP) {
        NSDictionary *dictionaryPayload = payload.dictionaryPayload;
        
        NSString *uuidString    = dictionaryPayload[@"UUID"];
        NSString *handle        = dictionaryPayload[@"handle"];
        NSNumber *hasVideo      = dictionaryPayload[@"hasVideo"];
        
        NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:uuidString];
        
        //[self displayIncomingCallUUID:uuid handle:handle hasVideo:[hasVideo boolValue] completion:^(NSError * _Nullable error) {
            
        //}];
    }
}
@end

//
//  IntentsInfo.m
//  OneCallKitDemo
//
//  Created by wintel on 16/8/23.
//  Copyright © 2016年 wintel. All rights reserved.
//

#import "IntentsInfo.h"

@implementation IntentsInfo

+ (NSString *)contactPersonHandleValueUserActivity:(NSUserActivity *)userActivity{
    INInteraction  *interaction = userActivity.interaction;
    INPerson *contact;
    if ([userActivity.activityType isEqualToString:@"INStartAudioCallIntent"]) {
        INStartAudioCallIntent *startAudioCallIntent = (INStartAudioCallIntent *)interaction.intent;
        contact = [startAudioCallIntent.contacts firstObject];
    }else if ([userActivity.activityType isEqualToString:@"INStartVideoCallIntent"]) {
        INStartVideoCallIntent *startVideoCallIntent = (INStartVideoCallIntent *)interaction.intent;
        contact = [startVideoCallIntent.contacts firstObject];
    }else if ([userActivity.activityType isEqualToString:@"INSendMessageIntent"]) {
        INSendMessageIntent *startVideoCallIntent = (INSendMessageIntent *)interaction.intent;
        contact = [startVideoCallIntent.recipients firstObject];
    }
    
    if (contact != nil) {
        return contact.personHandle.value;
    }
    
    return nil;
}
@end

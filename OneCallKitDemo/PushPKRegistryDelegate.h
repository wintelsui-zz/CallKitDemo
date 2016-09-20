//
//  PushPKRegistryDelegate.h
//  OneCallKitDemo
//
//  Created by wintel on 16/8/26.
//  Copyright © 2016年 wintel. All rights reserved.
//  Apple APNS 推送 的 PKPush 推送 , ios8 引入新的push通知类型，作为voip push
//  通过这种push方式可以使app执行制定的代码

#import <Foundation/Foundation.h>

#import <PushKit/PushKit.h>

@interface PushPKRegistryDelegate : NSObject <PKPushRegistryDelegate>

@property (strong, nonatomic) PKPushRegistry *pushRegistry;

@end

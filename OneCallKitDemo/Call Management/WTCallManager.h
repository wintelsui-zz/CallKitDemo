//
//  WTCallManager.h
//  OneCallKitDemo
//
//  Created by wintel on 16/8/22.
//  Copyright © 2016年 wintel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CallKit/CallKit.h>
#import "WTCall.h"



@interface WTCallManager : NSObject

@property (nonatomic ,strong) CXCallController *callController;

@property (nonatomic ,strong) NSMutableArray *calls;

- (void)startCallHandle:(NSString *)handle video:(BOOL)video;
- (void)endCall:(WTCall *)call;
- (void)setHeldCall:(WTCall *)call onHold:(BOOL)onHold;

#pragma mark - Call Management

- (WTCall *)callWithUUID:(NSUUID *)uuid;

- (void)addCall:(WTCall *)call;

- (void)removeCall:(WTCall *)call;

- (void)removeAllCalls;

#pragma mark - WTCallDelegate

- (void)wtCallDidChangeState:(WTCall *)call;
@end

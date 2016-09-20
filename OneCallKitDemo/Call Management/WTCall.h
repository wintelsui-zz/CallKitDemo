//
//  WTCall.h
//  OneCallKitDemo
//
//  Created by wintel on 16/8/22.
//  Copyright © 2016年 wintel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTCall : NSObject

typedef void(^StateDidChange)(BOOL successe);
typedef void(^HasStartedConnectingDidChange)(BOOL successe);
typedef void(^HasConnectedDidChange)(BOOL successe);
typedef void(^HasEndedDidChange)(BOOL successe);

@property (nonatomic, strong)   NSUUID *uuid;
@property (nonatomic, assign)   BOOL isOutgoing;
@property (nonatomic, copy)     NSString *handle;

@property (nonatomic, strong)   NSDate *connectingDate;
@property (nonatomic, strong)   NSDate *connectDate;
@property (nonatomic, strong)   NSDate *endDate;
@property (nonatomic, assign)   BOOL isOnHold;


@property (nonatomic, assign)   BOOL hasStartedConnecting;
@property (nonatomic, assign)   BOOL hasConnected;
@property (nonatomic, assign)   BOOL hasEnded;
@property (nonatomic, getter=getDuration)   NSTimeInterval duration;

@property (nonatomic, copy) StateDidChange stateDidChange;
@property (nonatomic, copy) HasStartedConnectingDidChange hasStartedConnectingDidChange;
@property (nonatomic, copy) HasConnectedDidChange hasConnectedDidChange;
@property (nonatomic, copy) HasEndedDidChange hasEndedDidChange;

- (instancetype)initWithUUID:(NSUUID *)uuid;
- (instancetype)initWithUUID:(NSUUID *)uuid isOutgoing:(BOOL)isOutgoing;



- (void)connectingDateChanged;
- (void)connectDateChanged;
- (void)endDateChanged;
- (void)isOnHoldChanged;

- (void)answerWTCallCall;
- (void)endWTCallCall;
- (void)startWTCallCallCompletion:(void (^)(BOOL success))completion;

@end

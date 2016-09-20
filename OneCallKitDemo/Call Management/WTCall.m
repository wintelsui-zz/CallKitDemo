//
//  WTCall.m
//  OneCallKitDemo
//
//  Created by wintel on 16/8/22.
//  Copyright © 2016年 wintel. All rights reserved.
//

#import "WTCall.h"

@implementation WTCall
//@synthesize uuid;
//@synthesize isOutgoing;
//@synthesize handle;

//@synthesize connectingDate;
//@synthesize connectDate;
//@synthesize endDate;
//@synthesize isOnHold;

@synthesize duration;

- (instancetype)initWithUUID:(NSUUID *)uuid{
    self = [super init];
    if (self){
        self.uuid = uuid;
        //[self setupKVO];
    }
    return self;
}

- (instancetype)initWithUUID:(NSUUID *)uuid isOutgoing:(BOOL)isOutgoing {
    self = [super init];
    if (self){
        self.uuid = uuid;
        self.isOutgoing = isOutgoing;
        
        //[self setupKVO];
    }
    return self;
}

- (void)setupKVO{
//    [self addObserver:self forKeyPath:@"connectingDate" options:NSKeyValueObservingOptionNew context:nil];
//    [self addObserver:self forKeyPath:@"connectDate" options:NSKeyValueObservingOptionNew context:nil];
//    [self addObserver:self forKeyPath:@"endDate" options:NSKeyValueObservingOptionNew context:nil];
//    [self addObserver:self forKeyPath:@"isOnHold" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context {
    if ([keyPath isEqualToString:@"connectingDate"]) {
        if (self.stateDidChange != nil) {
            self.stateDidChange(YES);
        }
        if (self.hasStartedConnectingDidChange != nil) {
            self.hasStartedConnectingDidChange(YES);
        }
    }else if ([keyPath isEqualToString:@"connectDate"]) {
        if (self.stateDidChange != nil) {
            self.stateDidChange(YES);
        }
        if (self.hasConnectedDidChange != nil) {
            self.hasConnectedDidChange(YES);
        }
    }else if ([keyPath isEqualToString:@"endDate"]) {
        if (self.stateDidChange != nil) {
            self.stateDidChange(YES);
        }
        if (self.hasEndedDidChange != nil) {
            self.hasEndedDidChange(YES);
        }
    }else if ([keyPath isEqualToString:@"isOnHold"]) {
        if (self.stateDidChange != nil) {
            self.stateDidChange(YES);
        }
    }
}
#pragma mark - Actions

- (void)connectingDateChanged{
    if (self.stateDidChange != nil) {
        self.stateDidChange(YES);
    }
    if (self.hasStartedConnectingDidChange != nil) {
        self.hasStartedConnectingDidChange(YES);
    }
}

- (void)connectDateChanged{
    if (self.stateDidChange != nil) {
        self.stateDidChange(YES);
    }
    if (self.hasConnectedDidChange != nil) {
        self.hasConnectedDidChange(YES);
    }
}

- (void)endDateChanged{
    if (self.stateDidChange != nil) {
        self.stateDidChange(YES);
    }
    if (self.hasEndedDidChange != nil) {
        self.hasEndedDidChange(YES);
    }
}

- (void)isOnHoldChanged{
    if (self.stateDidChange != nil) {
        self.stateDidChange(YES);
    }
}

- (void)startWTCallCallCompletion:(void (^)(BOOL success))completion {
    completion(YES);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.hasStartedConnecting = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.hasConnected = NO;
        });
    });
}

- (void)answerWTCallCall {
    /*
     Simulate the answer becoming connected immediately, since
     the example app is not backed by a real network service
     */
    self.hasConnected = YES;
}

- (void)endWTCallCall {
    /*
     Simulate the end taking effect immediately, since
     the example app is not backed by a real network service
     */
    self.hasEnded = YES;
}

//@synthesize ;
//@synthesize connectDate;
//@synthesize endDate;
//@synthesize isOnHold;
- (void)setConnectingDate:(NSDate *)connectingDate{
    _connectingDate = connectingDate;
    [self connectingDateChanged];
}

- (void)setConnectDate:(NSDate *)connectDate{
    _connectDate = connectDate;
    [self connectDateChanged];
}

- (void)setEndDate:(NSDate *)endDate{
    _endDate = endDate;
    [self endDateChanged];
    
}

- (void)setIsOnHold:(BOOL)isOnHold{
    _isOnHold = isOnHold;
    [self isOnHoldChanged];
}

- (void)setHasStartedConnecting:(BOOL)hasStartedConnecting{
    self.connectingDate = hasStartedConnecting ? [NSDate date] : nil;
    _hasStartedConnecting = hasStartedConnecting;
    
}

- (BOOL)isHasStartedConnecting{
    return self.connectingDate != nil;
}

- (void)setHasConnected:(BOOL)hasConnected{
    self.connectDate = hasConnected ? [NSDate date] : nil;
    _hasConnected = hasConnected;
}

- (BOOL)isHasConnected{
    return self.connectDate != nil;
}


- (void)setHasEnded:(BOOL)hasEnded{
    self.endDate = hasEnded ? [NSDate date] : nil;
    _hasEnded = hasEnded;
}

- (BOOL)isHasEnded{
    return self.endDate != nil;
}

- (NSTimeInterval)getDuration{
    if (self.connectDate == nil){
        return 0;
    }else{
        return [[NSDate date] timeIntervalSinceDate:self.connectDate];
    }
}

@end

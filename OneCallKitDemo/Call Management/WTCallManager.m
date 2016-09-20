//
//  WTCallManager.m
//  OneCallKitDemo
//
//  Created by wintel on 16/8/22.
//  Copyright © 2016年 wintel. All rights reserved.
//

#import "WTCallManager.h"

@implementation WTCallManager
@synthesize callController;
@synthesize calls;

- (void)startCallHandle:(NSString *)handle video:(BOOL)video{
    CXHandle *callhangle = [[CXHandle alloc] initWithType:CXHandleTypePhoneNumber value:handle];
    CXStartCallAction *startCallAction = [[CXStartCallAction alloc] initWithCallUUID:[[NSUUID alloc] init] handle:callhangle];
    [startCallAction setVideo:video];
    
    CXTransaction *transaction = [[CXTransaction alloc] init];
    [transaction addAction:startCallAction];
    
    [self requestTransaction:transaction];
}

- (void)endCall:(WTCall *)call{
    CXEndCallAction *endCallAction = [[CXEndCallAction alloc] initWithCallUUID:call.uuid];
    CXTransaction *transaction = [[CXTransaction alloc] init];
    [transaction addAction:endCallAction];
    
    [self requestTransaction:transaction];
}

- (void)setHeldCall:(WTCall *)call onHold:(BOOL)onHold{
    CXSetHeldCallAction *setHeldCallAction = [[CXSetHeldCallAction alloc] initWithCallUUID:call.uuid onHold:onHold];
    CXTransaction *transaction = [[CXTransaction alloc] init];
    [transaction addAction:setHeldCallAction];
    
    [self requestTransaction:transaction];
}

- (void)requestTransaction:(CXTransaction *)transaction{
    if (callController == nil) {
        callController = [[CXCallController alloc] init];
    }
    [callController requestTransaction:transaction completion:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error requesting transaction: \(error)");
        }else{
            NSLog(@"Requested transaction successfully");
        }
    }];
}


#pragma mark - Call Management

- (WTCall *)callWithUUID:(NSUUID *)uuid{
    NSInteger callIndex = -1;
    for (NSInteger index = 0; index < [calls count]; index ++) {
        NSUUID *uuidIn = ((WTCall *)calls[index]).uuid;
        if ([uuidIn.UUIDString isEqualToString:uuid.UUIDString]) {
            callIndex = index;
            break;
        }
    }
    if (callIndex == -1)
        return nil;
    return calls[callIndex];
}


- (void)addCall:(WTCall *)call{
    if (calls == nil) {
        calls = [[NSMutableArray alloc] init];
    }
    [calls addObject:call];
    

    __weak typeof(self) weakSelf = self;
    call.stateDidChange = ^(BOOL successe) {
        [weakSelf postCallsChangedNotification];
    };
    
    [self postCallsChangedNotification];
}


- (void)removeCall:(WTCall *)call{
    if (calls != nil && [calls containsObject:call]) {
        [calls removeObject:call];
    }
    [self postCallsChangedNotification];
}


- (void)removeAllCalls{
    [calls removeAllObjects];
    [self postCallsChangedNotification];
}

- (void)postCallsChangedNotification{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CallManagerCallsChangedNotification" object:[UIApplication sharedApplication]];
}

#pragma mark - WTCallDelegate

- (void)wtCallDidChangeState:(WTCall *)call{

}

@end






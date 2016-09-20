//
//  ProviderDelegate.h
//  OneCallKitDemo
//
//  Created by wintel on 16/8/23.
//  Copyright © 2016年 wintel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CallKit/CallKit.h>

#import "WTCallManager.h"

@interface ProviderDelegate : NSObject <CXProviderDelegate>
@property (nonatomic, strong) WTCallManager *callManager;

- (instancetype)initWithCallManager:(WTCallManager *)callManager;

- (void)reportIncomingCallUUID:(NSUUID *)uuid handle:(NSString *)handle hasVideo:(BOOL)hasVideo completion:(void (^ __nullable)(NSError *_Nullable error))completion;

+ (void)authorizationSiri;
@end

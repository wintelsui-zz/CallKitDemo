//
//  ProviderDelegate.m
//  OneCallKitDemo
//
//  Created by wintel on 16/8/23.
//  Copyright © 2016年 wintel. All rights reserved.
//

#import "ProviderDelegate.h"

#import "CallAudio.h"

#import <Intents/Intents.h>

@interface ProviderDelegate()
@property (nonatomic, strong) CXProvider *provider;
@end

@implementation ProviderDelegate
@synthesize provider;

- (instancetype)init{
    self = [super init];
    if (self) {
        self.callManager =  [[WTCallManager alloc] init];
        provider = [[CXProvider alloc] initWithConfiguration:[self providerConfiguration]];
        [provider setDelegate:self queue:nil];
    }
    return self;
}

- (instancetype)initWithCallManager:(WTCallManager *)callManager{
    self = [super init];
    if (self) {
        self.callManager = callManager;
        provider = [[CXProvider alloc] initWithConfiguration:[self providerConfiguration]];
        [provider setDelegate:self queue:nil];
    }
    return self;
}

- (CXProviderConfiguration *)providerConfiguration{
    NSString *localizedName = @"WTCallKit";
    CXProviderConfiguration *providerConfiguration = [[CXProviderConfiguration alloc] initWithLocalizedName:localizedName];
    providerConfiguration.supportsVideo = YES;
    providerConfiguration.maximumCallsPerCallGroup = 1;
    providerConfiguration.supportedHandleTypes = [NSSet setWithObjects:[NSNumber numberWithInteger:CXHandleTypePhoneNumber], nil];
    providerConfiguration.iconTemplateImageData = UIImagePNGRepresentation([UIImage imageNamed:@"icon_128x128"]);
    providerConfiguration.ringtoneSound = @"Ringtone.caf";
    return providerConfiguration;
}

//提交给系统一个新的来电,
- (void)reportIncomingCallUUID:(NSUUID *)uuid handle:(NSString *)handle hasVideo:(BOOL)hasVideo completion:(void (^)(NSError *_Nullable error))completion{
    CXCallUpdate *update = [[CXCallUpdate alloc] init];
    update.remoteHandle = [[CXHandle alloc] initWithType:CXHandleTypePhoneNumber value:handle];
    update.hasVideo = hasVideo;
    __weak typeof(self) weakSelf = self;
    [provider reportNewIncomingCallWithUUID:uuid update:update completion:^(NSError * _Nullable error) {
        if (error == nil) {
            WTCall *call = [[WTCall alloc] initWithUUID:uuid];
            call.handle = handle;
            [weakSelf.callManager addCall:call];
        }
        completion(error);
    }];
}

#pragma mark - CXProviderDelegate
- (void)providerDidReset:(CXProvider *)provider{
    NSLog(@"provider Did Reset");
    stopAudio();
    
    for (WTCall *call in _callManager.calls) {
        [call endWTCallCall];
    }
    [_callManager removeAllCalls];
}

- (void)provider:(CXProvider *)provider performStartCallAction:(CXStartCallAction *)action{
    WTCall *call = [[WTCall alloc] initWithUUID:action.callUUID isOutgoing:YES];
    call.handle = action.handle.value;
    
    configureAudioSession();
    
    __weak typeof(self) weakSelf = self;
    __weak typeof(WTCall *) weakCall = call;
    call.hasStartedConnectingDidChange = ^(BOOL success){
        [weakSelf.provider reportOutgoingCallWithUUID:weakCall.uuid startedConnectingAtDate:weakCall.connectingDate];
    };
    
    call.hasConnectedDidChange = ^(BOOL success){
        [weakSelf.provider reportOutgoingCallWithUUID:weakCall.uuid connectedAtDate:weakCall.connectDate];
    };
    [call startWTCallCallCompletion:^(BOOL success) {
        if (success) {
            [action fulfill];
            [weakSelf.callManager addCall:weakCall];
        }else{
            [action fail];
        }
    }];
}

- (void)provider:(CXProvider *)provider performAnswerCallAction:(CXAnswerCallAction *)action{
    WTCall *call = [_callManager callWithUUID:action.callUUID];
    if (call == nil) {
        [action fail];
    }else{
        configureAudioSession();
        [call answerWTCallCall];
        [action fulfill];
    }
}
- (void)provider:(CXProvider *)provider performEndCallAction:(CXEndCallAction *)action{
    WTCall *call = [_callManager callWithUUID:action.callUUID];
    if (call == nil) {
        [action fail];
    }else{
        stopAudio();
        [call endWTCallCall];
        [action fulfill];
        [_callManager removeCall:call];
    }
}
- (void)provider:(CXProvider *)provider performSetHeldCallAction:(CXSetHeldCallAction *)action{
    WTCall *call = [_callManager callWithUUID:action.callUUID];
    if (call == nil) {
        [action fail];
    }else{
        call.isOnHold = action.isOnHold;
        if (call.isOnHold) {
            stopAudio();
        }else{
            startAudio();
        }
        [action fulfill];
    }
}

- (void)provider:(CXProvider *)provider timedOutPerformingAction:(CXAction *)action{
    
}

- (void)provider:(CXProvider *)provider didActivateAudioSession:(AVAudioSession *)audioSession{
    startAudio();
}
- (void)provider:(CXProvider *)provider didDeactivateAudioSession:(AVAudioSession *)audioSession{
    
}


#pragma mark - CallAudio
void stopAudio(){
    CallAudio *audio = [CallAudio sharedCallAudio];
    [audio stopAudio];
}

void startAudio(){
    CallAudio *audio = [CallAudio sharedCallAudio];
    [audio startAudio];
}

void configureAudioSession(){
    CallAudio *audio = [CallAudio sharedCallAudio];
    [audio configureAudioSession];
}


+ (void)authorizationSiri{
    //Capabilities 中打开 Siri 的开关,仅仅支持付费开发者证书
//    switch ([INPreferences siriAuthorizationStatus]) {
//        case INSiriAuthorizationStatusNotDetermined://不确定
//            [INPreferences requestSiriAuthorization:^(INSiriAuthorizationStatus status) {
//                //请求Siri权限
//            }];
//            break;
//        case INSiriAuthorizationStatusRestricted://受限
//            
//            break;
//        case INSiriAuthorizationStatusDenied://拒绝
//            
//            break;
//        case INSiriAuthorizationStatusAuthorized://通过
//            
//            break;
//        default:
//            break;
//    }
}



@end

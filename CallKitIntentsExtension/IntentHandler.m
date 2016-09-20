//
//  IntentHandler.m
//  CallKitIntentsExtension
//  w
//  Created by wintel on 16/8/22.
//  Copyright © 2016年 wintel. All rights reserved.
//

#import "IntentHandler.h"

// As an example, this class is set up to handle Message intents.
// You will want to replace this or add other intents as appropriate.
// The intents you wish to handle must be declared in the extension's Info.plist.

@interface IntentHandler ()
<
INStartVideoCallIntentHandling,INStartAudioCallIntentHandling,INSendMessageIntentHandling
>

@end

@implementation IntentHandler

- (id)handlerForIntent:(INIntent *)intent {
    // This is the default implementation.  If you want different objects to handle different intents,
    // you can override this and return the handler you want for that particular intent.
    
    return self;
}


#pragma mark - INStartAudioCallIntentHandling

- (void)handleStartAudioCall:(INStartAudioCallIntent *)intent
                  completion:(void (^)(INStartAudioCallIntentResponse *response))completion NS_SWIFT_NAME(handle(startAudioCall:completion:)){
    INStartAudioCallIntentResponse *response;
    
    if  ([intent.contacts firstObject].personHandle == nil){
        response = [[INStartAudioCallIntentResponse alloc] initWithCode:INStartAudioCallIntentResponseCodeFailure userActivity:nil];
        completion(response);
        return;
    }
    
    NSUserActivity *userActivity = [[NSUserActivity alloc] initWithActivityType:INStartAudioCallIntent.self];
    
    response = [[INStartAudioCallIntentResponse alloc] initWithCode:INStartAudioCallIntentResponseCodeContinueInApp userActivity:userActivity];
    
    completion(response);
}

- (void)confirmStartAudioCall:(INStartAudioCallIntent *)intent
                   completion:(void (^)(INStartAudioCallIntentResponse *response))completion NS_SWIFT_NAME(confirm(startAudioCall:completion:)){
    
    INStartAudioCallIntentResponse *response;
    
    if  ([intent.contacts firstObject].personHandle == nil){
        response = [[INStartAudioCallIntentResponse alloc] initWithCode:INStartAudioCallIntentResponseCodeFailure userActivity:nil];
        completion(response);
        return;
    }
    
    NSUserActivity *userActivity = [[NSUserActivity alloc] initWithActivityType:INStartAudioCallIntent.self];
    
    response = [[INStartAudioCallIntentResponse alloc] initWithCode:INStartAudioCallIntentResponseCodeContinueInApp userActivity:userActivity];
    
    completion(response);
}

- (void)resolveContactsForStartAudioCall:(INStartAudioCallIntent *)intent
                          withCompletion:(void (^)(NSArray<INPersonResolutionResult *> *resolutionResults))completion NS_SWIFT_NAME(resolveContacts(forStartAudioCall:with:)){
    NSArray *contacts = intent.contacts;
    NSMutableArray *resolutionResults = [[NSMutableArray alloc] init];
    for (INPerson *contact in contacts){
        [resolutionResults addObject:[INPersonResolutionResult successWithResolvedPerson:contact]];
    }
    completion(resolutionResults);
}

#pragma mark - INStartVideoCallIntentHandling
- (void)handleStartVideoCall:(INStartVideoCallIntent *)intent
                  completion:(void (^)(INStartVideoCallIntentResponse *response))completion NS_SWIFT_NAME(handle(startVideoCall:completion:)){

}

- (void)confirmStartVideoCall:(INStartVideoCallIntent *)intent
                   completion:(void (^)(INStartVideoCallIntentResponse *response))completion NS_SWIFT_NAME(confirm(startVideoCall:completion:)){
    INStartVideoCallIntentResponse *response;
    
    if  ([intent.contacts firstObject].personHandle == nil){
        response = [[INStartVideoCallIntentResponse alloc] initWithCode:INStartVideoCallIntentResponseCodeFailure userActivity:nil];
        completion(response);
        return;
    }
    
    NSUserActivity *userActivity = [[NSUserActivity alloc] initWithActivityType:INStartAudioCallIntent.self];
    
    response = [[INStartVideoCallIntentResponse alloc] initWithCode:INStartVideoCallIntentResponseCodeContinueInApp userActivity:userActivity];
    
    completion(response);
}





- (void)handleSendMessage:(INSendMessageIntent *)intent
               completion:(void (^)(INSendMessageIntentResponse *response))completion NS_SWIFT_NAME(handle(sendMessage:completion:)){
    
}

- (void)confirmSendMessage:(INSendMessageIntent *)intent
                completion:(void (^)(INSendMessageIntentResponse *response))completion NS_SWIFT_NAME(confirm(sendMessage:completion:)){
    INSendMessageIntentResponse *response;
    
    if  ([intent.recipients firstObject].personHandle == nil){
        response = [[INSendMessageIntentResponse alloc] initWithCode:INSendMessageIntentResponseCodeFailure userActivity:nil];
        completion(response);
        return;
    }
    
    NSUserActivity *userActivity = [[NSUserActivity alloc] initWithActivityType:INSendMessageIntent.self];
    
    response = [[INSendMessageIntentResponse alloc] initWithCode:INSendMessageIntentResponseCodeSuccess userActivity:userActivity];
    
    completion(response);
}



@end

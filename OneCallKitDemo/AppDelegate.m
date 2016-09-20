//
//  AppDelegate.m
//  OneCallKitDemo
//
//  Created by wintel on 16/8/17.
//  Copyright © 2016年 wintel. All rights reserved.
//

#import "AppDelegate.h"

#import "BaseNavigationViewController.h"

#import "NSUserActivity+StartCallConvertible.h"
#import "NSURL+StartCallConvertible.h"

#import "ProviderDelegate.h"

#include <objc/runtime.h>


@interface AppDelegate ()
{
    ProviderDelegate *providerDelegate;
}
@end

@implementation AppDelegate
@synthesize callManager;


+ (AppDelegate *)sharedDelegate{
    return (AppDelegate *)([UIApplication sharedApplication].delegate);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    {
        _pushRegistry = [[PKPushRegistry alloc] initWithQueue:dispatch_get_main_queue()];
        _pushRegistry.delegate = self;
        _pushRegistry.desiredPushTypes = [NSSet setWithObject:PKPushTypeVoIP];
    }
    {
        callManager = [[WTCallManager alloc] init];
        
        providerDelegate = [[ProviderDelegate alloc] initWithCallManager:callManager];
    }
    
    [ProviderDelegate authorizationSiri];
    //3D touch
    {
        UIApplicationShortcutIcon *icon0 = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeBookmark];
        UIApplicationShortcutItem *item0 = [[UIApplicationShortcutItem alloc] initWithType:@"CallBlockingIdentificationViewController"
                                                                           localizedTitle:@"Call Blocking"
                                                                        localizedSubtitle:@"& Identification"
                                                                                     icon:icon0
                                                                                 userInfo:nil];
        
        UIApplicationShortcutIcon *icon1 = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeBookmark];
        UIApplicationShortcutItem *item1 = [[UIApplicationShortcutItem alloc] initWithType:@"CallVoIPManagerViewController"
                                                                            localizedTitle:@"VoIP"
                                                                         localizedSubtitle:@"Manager"
                                                                                      icon:icon1
                                                                                  userInfo:nil];
        NSMutableArray *shortcutItems = [[NSMutableArray alloc] init];
        [shortcutItems addObject:item0];
        [shortcutItems addObject:item1];
        
        {
            NSString *phone = [[NSUserDefaults standardUserDefaults] valueForKey:@"SimulateIncomingCallHandle"];
            BOOL video = [[NSUserDefaults standardUserDefaults] boolForKey:@"SimulateIncomingCallVideo"];
            float delay = [[NSUserDefaults standardUserDefaults] floatForKey:@"SimulateIncomingCallDelay"];
            if (phone != nil && phone.length > 0) {
                NSDictionary *callInfo = @{@"phone":phone,@"video":[NSNumber numberWithBool:video],@"delay":[NSNumber numberWithFloat:delay]};
                NSDictionary *userInfo = @{@"action":@"SimulateCall",@"data":callInfo};
                UIApplicationShortcutIcon *icon2 = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeAudio];
                UIApplicationShortcutItem *item2 = [[UIApplicationShortcutItem alloc] initWithType:@"CallVoIPManagerViewController"
                                                                                    localizedTitle:@"模拟呼叫"
                                                                                 localizedSubtitle:phone
                                                                                              icon:icon2
                                                                                          userInfo:userInfo];
                
                [shortcutItems addObject:item2];
            }
            
        }
        [UIApplication sharedApplication].shortcutItems = shortcutItems;
    }
    

    
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    NSString *urlString = url.absoluteString;

    if (urlString != nil && [[urlString lowercaseString] hasPrefix:insiderUrl]) {
        //内部调用
        if (notificationCenterRequired == nil) {
            notificationCenterRequired = [[NSMutableDictionary alloc] init];
        }
        
        NSString *stringInfo = [urlString substringFromIndex:insiderUrl.length];
        if (stringInfo != nil ) {
            NSArray *arrInfo = [stringInfo componentsSeparatedByString:insiderUrlPartition];
            if (arrInfo != nil && [arrInfo count] > 1) {
                NSString *action   = [arrInfo objectAtIndex:0];
                NSString *pageInfo = [arrInfo objectAtIndex:1];
                if ([action isEqualToString:@"openpage"]) {
                    //打开页面
                    NSDictionary *userInfo = @{@"name":pageInfo};
                    NSMutableArray *arrayUserInfo = [[NSMutableArray alloc] init];
                    [arrayUserInfo addObject:userInfo];
                    [notificationCenterRequired setObject:arrayUserInfo forKey:@"performActionForShortcutItem"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"performActionForShortcutItem" object:[UIApplication sharedApplication] userInfo:userInfo];
                }
                
            }
            
        }
        return NO;
    }else{
        
    }
    return YES;
}

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler{
    NSString *type = shortcutItem.type;
   // if ([type isEqualToString:@"CallBlockingIdentificationViewController"]) {
   //     NSDictionary *userInfo = @{@"name":@"CallBlockingIdentificationViewController"};
    NSDictionary *userInfo;
    if (shortcutItem.userInfo != nil) {
        userInfo = @{@"name":type,@"userInfo":shortcutItem.userInfo};
    }else{
        userInfo = @{@"name":type};
    }
    if (notificationCenterRequired == nil) {
        notificationCenterRequired = [[NSMutableDictionary alloc] init];
    }
    NSMutableArray *arrayUserInfo = [[NSMutableArray alloc] init];
    [arrayUserInfo addObject:userInfo];
    [notificationCenterRequired setObject:arrayUserInfo forKey:@"performActionForShortcutItem"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"performActionForShortcutItem" object:[UIApplication sharedApplication] userInfo:userInfo];
   // }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (NSDictionary *)ReadNotificationCenterRequired{
    return notificationCenterRequired;
}


- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options NS_AVAILABLE_IOS(9_0); // no equiv. notification. return NO if the application can't open for some reason
{
    NSString *urlString = url.absoluteString;
    
    if (urlString != nil && [[urlString lowercaseString] hasPrefix:insiderUrl]) {
        //内部调用
        if (notificationCenterRequired == nil) {
            notificationCenterRequired = [[NSMutableDictionary alloc] init];
        }
        
        NSString *stringInfo = [urlString substringFromIndex:insiderUrl.length];
        if (stringInfo != nil ) {
            NSArray *arrInfo = [stringInfo componentsSeparatedByString:insiderUrlPartition];
            if (arrInfo != nil && [arrInfo count] > 1) {
                NSString *action   = [arrInfo objectAtIndex:0];
                NSString *pageInfo = [arrInfo objectAtIndex:1];
                if ([action isEqualToString:@"openpage"]) {
                    //打开页面
                    NSDictionary *userInfo = @{@"name":pageInfo};
                    NSMutableArray *arrayUserInfo = [[NSMutableArray alloc] init];
                    [arrayUserInfo addObject:userInfo];
                    [notificationCenterRequired setObject:arrayUserInfo forKey:@"performActionForShortcutItem"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"performActionForShortcutItem" object:[UIApplication sharedApplication] userInfo:userInfo];
                }
                
            }
            
        }
        return NO;
    }else{
        {
            NSLog(@"url.absoluteString:%@",url.absoluteString);
            NSLog(@"url.relativeString:%@",url.relativeString);
            NSLog(@"url.baseURL:%@",url.baseURL);
            NSLog(@"url.absoluteURL:%@",url.absoluteURL);
            NSLog(@"url.scheme:%@",url.scheme);
            NSLog(@"url.resourceSpecifier:%@",url.resourceSpecifier);
            NSLog(@"url.host:%@",url.host);
            NSLog(@"url.port:%@",url.port);
            NSLog(@"url.user:%@",url.user);
            NSLog(@"url.password:%@",url.password);
            NSLog(@"url.path:%@",url.path);
            NSLog(@"url.fragment:%@",url.fragment);
            NSLog(@"url.parameterString:%@",url.parameterString);
            NSLog(@"url.query:%@",url.query);
            NSLog(@"url.relativePath:%@",url.relativePath);
            NSLog(@"url.hasDirectoryPath:%@",[NSNumber numberWithBool:url.hasDirectoryPath]);
        }
        NSString *handle = [url startCallHandle];
        if (handle != nil && handle.length > 0 ){
            [callManager startCallHandle:handle video:NO];
        }
        return NO;
    }

    return YES;
}
- (void)application:(UIApplication *)application didUpdateUserActivity:(NSUserActivity *)userActivity{
    
}

//通讯录中点击会到这里,在通话的时候,系统的通话界面中点击视频,音频会重复拨打电话呢,也会走这里
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void(^)(NSArray * __nullable restorableObjects))restorationHandler{
    {
        NSLog(@"userActivity.activityType:%@",userActivity.activityType);
        NSLog(@"userActivity.title:%@",userActivity.title);
        NSLog(@"userActivity.userInfo:%@",userActivity.userInfo);
        NSLog(@"userActivity.requiredUserInfoKeys:%@",userActivity.requiredUserInfoKeys);
        NSLog(@"userActivity.needsSave:%@",[NSNumber numberWithBool:userActivity.needsSave]);
        NSLog(@"userActivity.expirationDate:%@",userActivity.expirationDate);
        NSLog(@"userActivity.keywords:%@",userActivity.keywords);
        NSLog(@"userActivity.supportsContinuationStreams:%@",[NSNumber numberWithBool:userActivity.supportsContinuationStreams]);
        NSLog(@"userActivity.eligibleForHandoff:%@",[NSNumber numberWithBool:userActivity.eligibleForHandoff]);
        NSLog(@"userActivity.eligibleForSearch:%@",[NSNumber numberWithBool:userActivity.eligibleForSearch]);
        NSLog(@"userActivity.eligibleForPublicIndexing:%@",[NSNumber numberWithBool:userActivity.eligibleForPublicIndexing]);
        NSURL *url = userActivity.webpageURL;
        NSLog(@"url.absoluteString:%@",url.absoluteString);
        NSLog(@"url.relativeString:%@",url.relativeString);
        NSLog(@"url.baseURL:%@",url.baseURL);
        NSLog(@"url.absoluteURL:%@",url.absoluteURL);
        NSLog(@"url.scheme:%@",url.scheme);
        NSLog(@"url.resourceSpecifier:%@",url.resourceSpecifier);
        NSLog(@"url.host:%@",url.host);
        NSLog(@"url.port:%@",url.port);
        NSLog(@"url.user:%@",url.user);
        NSLog(@"url.password:%@",url.password);
        NSLog(@"url.path:%@",url.path);
        NSLog(@"url.fragment:%@",url.fragment);
        NSLog(@"url.parameterString:%@",url.parameterString);
        NSLog(@"url.query:%@",url.query);
        NSLog(@"url.relativePath:%@",url.relativePath);
        NSLog(@"url.hasDirectoryPath:%@",[NSNumber numberWithBool:url.hasDirectoryPath]);
    }
    NSString *handle = [userActivity startCallHandle];
    //handle为点击的联系人的电话号码
    BOOL hasVideo = NO;
    if ([userActivity.activityType isEqualToString:@"INStartVideoCallIntent"]) {
        hasVideo = YES;
    }
    
    if (handle != nil && handle.length > 0 ){
        //去拨打电话:电话号码 :视频
        NSUUID *uuid = [[NSUUID alloc] init];
        [self displayIncomingCallUUID:uuid handle:handle hasVideo:hasVideo completion:^(NSError * _Nullable error) {
            
        }];
    }
    return NO;
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
        
        [self displayIncomingCallUUID:uuid handle:handle hasVideo:[hasVideo boolValue] completion:^(NSError * _Nullable error) {
            
        }];
    }
}

/// Display the incoming call to the user
- (void)displayIncomingCallUUID:(NSUUID *)uuid handle:(NSString *)handle hasVideo:(BOOL)hasVideo completion:(void (^)(NSError *_Nullable error))completion{
    [providerDelegate reportIncomingCallUUID:uuid handle:handle hasVideo:hasVideo completion:^(NSError * _Nullable error) {
        
    }];
}




#pragma mark - 保证3D touch的操作可以被触发

- (void)RemoveNotificationCenterRequired:(NSString *)key bySubInfo:(NSDictionary *)info{
    NSArray *arrayInfos = [notificationCenterRequired objectForKey:key];
    if (arrayInfos != nil && [arrayInfos count] > 0) {
        NSMutableArray *arrayMuInfos = [[NSMutableArray alloc] initWithArray:arrayInfos];
        [arrayMuInfos removeObject:info];
        if ([arrayMuInfos count] == 0) {
            [notificationCenterRequired removeObjectForKey:key];
        }else{
            [notificationCenterRequired setObject:arrayMuInfos forKey:key];
        }
    }
}

- (void)RemoveNotificationCenterRequired:(NSString *)key{
    [notificationCenterRequired removeObjectForKey:key];
}

@end

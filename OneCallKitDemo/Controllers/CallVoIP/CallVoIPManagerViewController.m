//
//  CallVoIPManagerViewController.m
//  OneCallKitDemo
//
//  Created by wintel on 16/8/19.
//  Copyright © 2016年 wintel. All rights reserved.
//

#import "CallVoIPManagerViewController.h"

@interface CallVoIPManagerViewController ()
{
    WTCallManager *callManager;
}
@end

@implementation CallVoIPManagerViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCallsChangedNotification:) name:@"CallManagerCallsChangedNotification" object:[UIApplication sharedApplication]];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CallManagerCallsChangedNotification" object:[UIApplication sharedApplication]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    callManager = AppsDelegate.callManager;
    
    NSLog(@"additionalInfo:%@",self.additionalInfo);
}

- (void)SimulateIncomingCallHandle:(NSString *)handle hasVideo:(BOOL)hasVideo delay:(float)delay completion:(void (^)())completion{
    NSString *callhandle = [[NSString alloc] initWithString:handle];
    BOOL callhasVideo = hasVideo;
    float calldelay = delay;
    completion();
    
    UIBackgroundTaskIdentifier backgroundTaskIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(calldelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSUUID *uuid = [[NSUUID alloc] init];
        [[AppDelegate sharedDelegate] displayIncomingCallUUID:uuid handle:callhandle hasVideo:callhasVideo completion:^(NSError * _Nullable error) {
            [[UIApplication sharedApplication] endBackgroundTask:backgroundTaskIdentifier];
        }];
    });
}




#pragma mark tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (callManager.calls == nil)
        return 0;
    return [callManager.calls count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    
    static NSString *callIdentifier = @"callIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:callIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:callIdentifier];
    }
    WTCall *call = [callManager.calls objectAtIndex:row];
    NSMutableString *info = [[NSMutableString alloc] initWithCapacity:0];
    if (call != nil) {
        NSString *handle = call.handle;
        BOOL isHold = call.isOnHold;
        BOOL hasConnected = call.hasConnected;
        BOOL hasStartedConnecting = call.hasStartedConnecting;
        BOOL isOutgoing = call.isOutgoing;
        if (hasConnected) {
            if (isHold) {
                [info appendString:@"等待"];
            }else{
                [info appendString:@"活跃"];
            }
        }else if (hasStartedConnecting) {
            [info appendString:@"等待"];
        }else{
            if (isOutgoing) {
                [info appendString:@"呼叫中"];
            }else{
                [info appendString:@"响铃"];
            }
        }
        [cell.textLabel setText:handle];
    }else{
        [cell.textLabel setText:@""];
    }
    [cell.detailTextLabel setText:info];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"停止";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    WTCall *call = [callManager.calls objectAtIndex:row];
    if (call != nil) {
        [callManager endCall:call];
    }
}




- (void)handleCallsChangedNotification:(NSNotification *)info{
    [_tableview reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    id vc = [segue destinationViewController];
    if ([vc isKindOfClass:[SimulateIncomingCallViewController class]]) {
        ((SimulateIncomingCallViewController *)vc).delegate = self;
    }
}

@end

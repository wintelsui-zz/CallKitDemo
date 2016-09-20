//
//  TodayViewController.m
//  OneCallToday
//
//  Created by wintel on 16/8/22.
//  Copyright © 2016年 wintel. All rights reserved.
//


#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>



#define insiderUrl @"onecallkitdemoinsider://"
#define insiderUrlPartition @".orz/"
#define insiderUrlTypeOpen @"openpage"

@interface TodayViewController () <NCWidgetProviding>

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.preferredContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 120);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeCompact;
}

- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize {
    if (activeDisplayMode == NCWidgetDisplayModeCompact) {
        self.preferredContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 120);
    } else {
        self.preferredContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 240);
    }
}

- (IBAction)pressedAddBlocking:(id)sender {
    NSString *stringUrl = [NSString stringWithFormat:@"%@%@%@%@",insiderUrl,insiderUrlTypeOpen,insiderUrlPartition,@"CallBlockingIdentificationViewController"];
    NSURL *url = [NSURL URLWithString:stringUrl];
    [self.extensionContext openURL:url
                 completionHandler:^(BOOL success) {}];
}
- (IBAction)pressCallKit:(id)sender {
    NSString *stringUrl = [NSString stringWithFormat:@"%@%@%@%@",insiderUrl,insiderUrlTypeOpen,insiderUrlPartition,@"CallVoIPManagerViewController"];
    NSURL *url = [NSURL URLWithString:stringUrl];
    [self.extensionContext openURL:url
                 completionHandler:^(BOOL success) {}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

@end

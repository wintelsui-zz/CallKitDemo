//
//  CallVoIPManagerViewController.h
//  OneCallKitDemo
//
//  Created by wintel on 16/8/19.
//  Copyright © 2016年 wintel. All rights reserved.
//

#import "BaseViewController.h"
#import "SimulateIncomingCallViewController.h"

@interface CallVoIPManagerViewController : BaseViewController
<
UITableViewDelegate,
UITableViewDataSource,
SimulateIncomingCallDelegate
>

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

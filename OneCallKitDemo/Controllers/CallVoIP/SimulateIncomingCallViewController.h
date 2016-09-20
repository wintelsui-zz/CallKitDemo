//
//  SimulateIncomingCallViewController.h
//  OneCallKitDemo
//
//  Created by wintel on 16/8/24.
//  Copyright © 2016年 wintel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SimulateIncomingCallDelegate <NSObject>

@required
- (void)SimulateIncomingCallHandle:(NSString *)handle hasVideo:(BOOL)hasVideo delay:(float)delay completion:(void (^)())completion;

@end

@interface SimulateIncomingCallViewController : UIViewController

@property (nonatomic, copy)     NSString    *handle;
@property (nonatomic, assign)   BOOL        video;
@property (nonatomic, assign)   float       delay;

@property (nonatomic, weak)     id <SimulateIncomingCallDelegate> delegate;

@property (weak, nonatomic) IBOutlet UISwitch *videoSwitch;
@property (weak, nonatomic) IBOutlet UITextField *destinationTextField;
@property (weak, nonatomic) IBOutlet UISlider *delayStepper;
@property (weak, nonatomic) IBOutlet UILabel *delayExplanationLabel;

@end

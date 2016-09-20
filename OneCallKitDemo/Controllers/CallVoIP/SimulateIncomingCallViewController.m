//
//  SimulateIncomingCallViewController.m
//  OneCallKitDemo
//
//  Created by wintel on 16/8/24.
//  Copyright © 2016年 wintel. All rights reserved.
//

#import "SimulateIncomingCallViewController.h"

@interface SimulateIncomingCallViewController ()

@end

@implementation SimulateIncomingCallViewController
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupCallInfo];
    
    [_delayStepper addTarget:self action:@selector(delayStepperChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)delayStepperChanged:(id)sender{
    float delay = _delayStepper.value;
    [_delayExplanationLabel setText:[NSString stringWithFormat:@"%.1f",delay]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)pressedIncomingCall:(id)sender {
    _handle = [self fixPhone:_destinationTextField.text];
    _video = _videoSwitch.isOn;
    _delay = _delayStepper.value;
    
    [self saveCallInfo];
    __weak typeof(self) weakSelf = self;
    if (delegate != nil &&  [delegate respondsToSelector:@selector(SimulateIncomingCallHandle:hasVideo:delay:completion:)]) {
        [delegate SimulateIncomingCallHandle:_handle hasVideo:_video delay:_delay completion:^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
    }
}


- (void)setupCallInfo{
    NSString *phone = [[NSUserDefaults standardUserDefaults] valueForKey:@"SimulateIncomingCallHandle"];
    BOOL video = [[NSUserDefaults standardUserDefaults] boolForKey:@"SimulateIncomingCallVideo"];
    float delay = [[NSUserDefaults standardUserDefaults] floatForKey:@"SimulateIncomingCallDelay"];
    
    if (phone == nil) {
        phone = @"";
    }
    
    _handle = phone;
    _video = video;
    _delay = delay;
    
    [_destinationTextField setText:phone];
    [_videoSwitch setOn:video];
    _delayStepper.value = delay;
    [_delayExplanationLabel setText:[NSString stringWithFormat:@"%.1f",delay]];
}

- (void)saveCallInfo{
    [[NSUserDefaults standardUserDefaults] setValue:(_handle == nil ? @"" : _handle) forKey:@"SimulateIncomingCallHandle"];
    [[NSUserDefaults standardUserDefaults] setBool:_video forKey:@"SimulateIncomingCallVideo"];
    [[NSUserDefaults standardUserDefaults] setFloat:_delay forKey:@"SimulateIncomingCallDelay"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)fixPhone:(NSString *)phone{
    if (phone == nil || phone.length == 0) {
        return @"";
    }
    NSString *stringPhone = [phone stringByReplacingOccurrencesOfString:@"+" withString:@""];
    stringPhone = [stringPhone stringByReplacingOccurrencesOfString:@" " withString:@""];
    stringPhone = [stringPhone stringByReplacingOccurrencesOfString:@"-" withString:@""];
    stringPhone = [stringPhone stringByReplacingOccurrencesOfString:@"(" withString:@""];
    stringPhone = [stringPhone stringByReplacingOccurrencesOfString:@")" withString:@""];
    if (stringPhone != nil && stringPhone.length > 0) {
        NSInteger phonenumebr = [stringPhone longLongValue];
        NSString *stringFinal = [NSString stringWithFormat:@"%@%ld",([stringPhone hasPrefix:@"86"]?@"":@"86"),phonenumebr];
        return stringFinal;
    }
    return stringPhone;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

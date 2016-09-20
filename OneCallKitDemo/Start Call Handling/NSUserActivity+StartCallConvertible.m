//
//  NSUserActivity+StartCallConvertible.m
//  OneCallKitDemo
//
//  Created by wintel on 16/8/23.
//  Copyright © 2016年 wintel. All rights reserved.
//

#import "NSUserActivity+StartCallConvertible.h"
#import "IntentsInfo.h"

@implementation NSUserActivity (StartCallConvertible)

- (NSString *)startCallHandle{
    NSLog(@"activityType:%@",self.activityType);
    NSString *handleValue = [IntentsInfo contactPersonHandleValueUserActivity:self];
    return handleValue;
}

@end

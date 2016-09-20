//
//  CallDirectoryManager.m
//  OneCallKitDemo
//
//  Created by wintel on 16/8/22.
//  Copyright © 2016年 wintel. All rights reserved.
//

#import "CallDirectoryManager.h"

static CallDirectoryManager *_manager = nil;

@implementation CallDirectoryManager

+ (instancetype)sharedCallDirectoryManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[CallDirectoryManager alloc] init];
    });
    return _manager;
}

@end

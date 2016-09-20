//
//  NSURL+StartCallConvertible.m
//  OneCallKitDemo
//
//  Created by wintel on 16/8/23.
//  Copyright © 2016年 wintel. All rights reserved.
//

#import "NSURL+StartCallConvertible.h"

@implementation NSURL (StartCallConvertible)
- (NSString *)startCallHandle{
    if ([self.scheme isEqualToString:@"OneCallKitDemo"])
        return self.host;
    return nil;
}
@end

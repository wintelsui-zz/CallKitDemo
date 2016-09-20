//
//  CallDirectoryHandler.m
//  OneCallBlocking
//
//  Created by wintel on 16/9/14.
//  Copyright © 2016年 wintel. All rights reserved.
//
//  PS:iOS 10.0.1 暂时功能无效(系统问题,或者苹果问题)

#import "CallDirectoryHandler.h"

@interface CallDirectoryHandler () <CXCallDirectoryExtensionContextDelegate>
@end

@implementation CallDirectoryHandler

- (void)beginRequestWithExtensionContext:(CXCallDirectoryExtensionContext *)context {
    context.delegate = self;

    if (![self addBlockingPhoneNumbersToContext:context]) {
        NSLog(@"Unable to add blocking phone numbers");
        NSError *error = [NSError errorWithDomain:@"CallDirectoryHandler" code:1 userInfo:nil];
        [context cancelRequestWithError:error];
        return;
    }
    
    [context completeRequestWithCompletionHandler:nil];
}

- (BOOL)addBlockingPhoneNumbersToContext:(CXCallDirectoryExtensionContext *)context {
    // Retrieve phone numbers to block from data store. For optimal performance and memory usage when there are many phone numbers,
    // consider only loading a subset of numbers at a given time and using autorelease pool(s) to release objects allocated during each batch of numbers which are loaded.
    //
    // Numbers must be provided in numerically ascending order.
    
    NSString *filePathBlock = [self readPathBlock];
    NSDictionary *dicBlock = [[NSDictionary alloc] initWithContentsOfFile:filePathBlock];
    NSArray *arrBlockPhones = [dicBlock allKeys];
    NSUInteger count = [arrBlockPhones count];
    
    NSArray *sortedPhones = [self ArraySort:arrBlockPhones ASC:YES];
    
    for (NSUInteger i = 0; i < count; i += 1) {
        NSString *phone = [sortedPhones objectAtIndex:i];
        CXCallDirectoryPhoneNumber phoneNumber = [phone longLongValue];
        [context addBlockingEntryWithNextSequentialPhoneNumber:phoneNumber];
    }
    
//    CXCallDirectoryPhoneNumber phoneNumbers[] = { 14085555555, 18005555555 };
//    NSUInteger count = (sizeof(phoneNumbers) / sizeof(CXCallDirectoryPhoneNumber));
//
//    for (NSUInteger index = 0; index < count; index += 1) {
//        CXCallDirectoryPhoneNumber phoneNumber = phoneNumbers[index];
//        [context addBlockingEntryWithNextSequentialPhoneNumber:phoneNumber];
//    }

    return YES;
}
#pragma mark - CXCallDirectoryExtensionContextDelegate

- (void)requestFailedForExtensionContext:(CXCallDirectoryExtensionContext *)extensionContext withError:(NSError *)error {
    // An error occurred while adding blocking or identification entries, check the NSError for details.
    // For Call Directory error codes, see the CXErrorCodeCallDirectoryManagerError enum in <CallKit/CXError.h>.
    //
    // This may be used to store the error details in a location accessible by the extension's containing app, so that the
    // app may be notified about errors which occured while loading data even if the request to load data was initiated by
    // the user in Settings instead of via the app itself.
}






- (NSString *)time{
    NSDate *date = [NSDate date];
    NSTimeInterval timeIntervalSince1970 = [date timeIntervalSince1970];
    return [NSString stringWithFormat:@"%.0f",timeIntervalSince1970 * 1000];
}




- (NSString *)readPathBlock{
    NSURL *fileUrl = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.wintel.OneCallKitDemo"];
    NSString *filePath = [fileUrl.absoluteString substringFromIndex:(@"file://".length)];
    NSString *filePathBlock = [filePath stringByAppendingString:@"Block.plist"];
    return filePathBlock;
    
}

//数字数字从小到大排序
- (NSArray *)ArraySort:(NSArray *)array ASC:(BOOL)ASC
{
    if (array == nil || [array count] == 0) {
        return nil;
    }
    return [array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if(ASC){
            if([obj1 integerValue] > [obj2 integerValue]) {
                return(NSComparisonResult)NSOrderedDescending;
            }
            if([obj1 integerValue] < [obj2 integerValue]) {
                return(NSComparisonResult)NSOrderedAscending;
            }
        }else{
            if([obj1 integerValue] < [obj2 integerValue]) {
                return(NSComparisonResult)NSOrderedDescending;
            }
            if([obj1 integerValue] > [obj2 integerValue]) {
                return(NSComparisonResult)NSOrderedAscending;
            }
        }
        return(NSComparisonResult)NSOrderedSame;
    }];
}

@end

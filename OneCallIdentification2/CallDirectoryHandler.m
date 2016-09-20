//
//  CallDirectoryHandler.m
//  OneCallIdentification
//
//  Created by wintel on 16/9/14.
//  Copyright © 2016年 wintel. All rights reserved.
//

#import "CallDirectoryHandler.h"

@interface CallDirectoryHandler () <CXCallDirectoryExtensionContextDelegate>
@end

@implementation CallDirectoryHandler

- (void)beginRequestWithExtensionContext:(CXCallDirectoryExtensionContext *)context {
    context.delegate = self;
    
    if (![self addIdentificationPhoneNumbersToContext:context]) {
        NSLog(@"Unable to add identification phone numbers");
        NSError *error = [NSError errorWithDomain:@"CallDirectoryHandler" code:2 userInfo:nil];
        [context cancelRequestWithError:error];
        return;
    }
    
    [context completeRequestWithCompletionHandler:nil];
}


- (BOOL)addIdentificationPhoneNumbersToContext:(CXCallDirectoryExtensionContext *)context {
    // Retrieve phone numbers to identify and their identification labels from data store. For optimal performance and memory usage when there are many phone numbers,
    // consider only loading a subset of numbers at a given time and using autorelease pool(s) to release objects allocated during each batch of numbers which are loaded.
    //
    // Numbers must be provided in numerically ascending order.
    
    
    NSString *filePathIdentification = [self readPathIdentification];
    NSDictionary *dicIdentification = [[NSDictionary alloc] initWithContentsOfFile:filePathIdentification];
    NSArray *arrIdentificationPhones = [dicIdentification allKeys];
    NSUInteger count = [arrIdentificationPhones count];
    
    NSArray *sortedPhones = [self ArraySort:arrIdentificationPhones ASC:YES];
    
    for (NSUInteger i = 0; i < count; i += 1) {
        NSString *phone = [sortedPhones objectAtIndex:i];
        NSString *label = dicIdentification[phone];
        if (phone == nil || label == nil) {
            break;
        }
        label = [NSString stringWithFormat:@"2:%@",label];
        CXCallDirectoryPhoneNumber phoneNumber = [phone longLongValue];
        [context addIdentificationEntryWithNextSequentialPhoneNumber:phoneNumber label:label];
    }
    
    //    CXCallDirectoryPhoneNumber phoneNumbers[] = { 18775555555, 18885555555 };
    //    NSArray<NSString *> *labels = @[ @"Telemarketer", @"Local business" ];
    //    NSUInteger count = (sizeof(phoneNumbers) / sizeof(CXCallDirectoryPhoneNumber));
    //
    //    for (NSUInteger i = 0; i < count; i += 1) {
    //        CXCallDirectoryPhoneNumber phoneNumber = phoneNumbers[i];
    //        NSString *label = labels[i];
    //        [context addIdentificationEntryWithNextSequentialPhoneNumber:phoneNumber label:label];
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

- (NSString *)readPathIdentification{
    NSURL *fileUrl = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.wintel.OneCallKitDemo"];
    NSString *filePath = [fileUrl.absoluteString substringFromIndex:(@"file://".length)];
    NSString *filePathIdentification = [filePath stringByAppendingString:@"Identification2.plist"];
    return filePathIdentification;
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

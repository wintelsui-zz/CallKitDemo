//
//  JSONFighting.h
//  doc360StudyCircles
//
//  Created by 隋文涛 on 15/08/19.
//  Copyright (c) 2014年 ids. All rights reserved.

#import <Foundation/Foundation.h>

@interface NSString (JSONFightingDeserializingSerializing)
- (id)objectFromJSONString;

- (NSData *)JSONData;
@end

@interface NSData (JSONFightingDeserializingSerializing)
// The NSData MUST be UTF8 encoded JSON.
- (id)objectFromJSONData;

- (NSString *)JSONString;
@end

@interface NSArray (JSONFightingSerializing)
- (NSData *)JSONData;
- (NSString *)JSONString;
@end

@interface NSDictionary (JSONFightingSerializing)
- (NSData *)JSONData;
- (NSString *)JSONString;
@end


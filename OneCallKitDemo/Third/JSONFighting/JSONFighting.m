//
//  JSONFighting.m
//  doc360StudyCircles
//
//  Created by 隋文涛 on 15/08/19.
//  Copyright (c) 2014年 ids. All rights reserved.

#import "JSONFighting.h"


@implementation NSString (JSONFightingDeserializingSerializing)
- (id)objectFromJSONString{
    if (self == nil) {return nil;}
    NSMutableString *string_self = [[NSMutableString alloc] initWithCapacity:1];
    if (self.length > 1) {
        if ([self characterAtIndex:0] == '(' && [self characterAtIndex:(self.length - 1) == ')']) {
            [string_self appendString:[self stringByPaddingToLength:(self.length - 1) withString:@"" startingAtIndex:1]];
            NSRange rang = [string_self rangeOfString:@"("];
            [string_self deleteCharactersInRange:rang];
        }else{
            [string_self appendString:self];
        }
    }else{
        [string_self appendString:@""];
    }
    
    [string_self replaceOccurrencesOfString:@"\n"
                                 withString:@" "
                                    options:NSLiteralSearch
                                      range:NSMakeRange(0, [string_self length])];
    [string_self replaceOccurrencesOfString:@"\r"
                                 withString:@" "
                                    options:NSLiteralSearch
                                      range:NSMakeRange(0, [string_self length])];
    [string_self replaceOccurrencesOfString:@"	"
                                 withString:@" "
                                    options:NSLiteralSearch
                                      range:NSMakeRange(0, [string_self length])];
    [string_self replaceOccurrencesOfString:@"\t"
                                 withString:@" "
                                    options:NSLiteralSearch
                                      range:NSMakeRange(0, [string_self length])];
    [string_self replaceOccurrencesOfString:@"\f"
                                 withString:@" "
                                    options:NSLiteralSearch
                                      range:NSMakeRange(0, [string_self length])];
    [string_self replaceOccurrencesOfString:@"\b"
                                 withString:@""
                                    options:NSLiteralSearch
                                      range:NSMakeRange(0, [string_self length])];
    [string_self replaceOccurrencesOfString:@"\v"
                                 withString:@""
                                    options:NSLiteralSearch
                                      range:NSMakeRange(0, [string_self length])];
    NSData* data = [string_self dataUsingEncoding:NSUTF8StringEncoding];
    __autoreleasing NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    if (error != nil) return nil;
    return result;
}

- (NSData *)JSONData{
    if (self == nil) {return nil;}
    NSMutableString *string_self = [[NSMutableString alloc] initWithCapacity:1];
    if (self.length > 1) {
        if ([self characterAtIndex:0] == '(' && [self characterAtIndex:(self.length - 1) == ')']) {
            [string_self appendString:[self stringByPaddingToLength:(self.length - 1) withString:@"" startingAtIndex:1]];
            NSRange rang = [string_self rangeOfString:@"("];
            [string_self deleteCharactersInRange:rang];
        }else{
            [string_self appendString:self];
        }
    }else{
        [string_self appendString:@""];
    }
    [string_self replaceOccurrencesOfString:@"\n"
                             withString:@""
                                options:NSLiteralSearch
                                  range:NSMakeRange(0, [string_self length])];
    
    NSData *data = [string_self dataUsingEncoding:NSUTF8StringEncoding];
    return data;
}



@end

@implementation NSData (JSONFightingDeserializingSerializing)
// The NSData MUST be UTF8 encoded JSON.
- (id)objectFromJSONData{
    if (self == nil) {return nil;}
    __autoreleasing NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:self options:NSJSONReadingAllowFragments error:&error];
    if (error != nil) return nil;
    return result;
}

- (NSString *)JSONString{
    if (self == nil) {return nil;}
    NSString *json =[[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
    return json;
}


@end

@implementation NSArray (JSONFightingSerializing)
- (NSData *)JSONData{    if (self == nil) {return nil;}
    if ([NSJSONSerialization isValidJSONObject:self])
    {
        __autoreleasing NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
        if (error != nil) return nil;
        return jsonData;
    }
    return nil;
}


- (NSString *)JSONString{
    if (self == nil) {return nil;}
    if ([NSJSONSerialization isValidJSONObject:self])
    {
        __autoreleasing NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
        NSString *json =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        if (json!=nil && json.length > 0) {
            NSMutableString *string_self = [[NSMutableString alloc] initWithCapacity:1];
            [string_self appendString:json];
            [string_self replaceOccurrencesOfString:@"\n"
                                         withString:@""
                                            options:NSLiteralSearch
                                              range:NSMakeRange(0, [string_self length])];
            
            return string_self;
        }
        return json;
    }
    return nil;
}


@end

@implementation NSDictionary (JSONFightingSerializing)
- (NSData *)JSONData{
    if (self == nil) {return nil;}
    if ([NSJSONSerialization isValidJSONObject:self])
    {
        __autoreleasing NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
        if (error != nil) return nil;
        return jsonData;
    }
    return nil;
}


- (NSString *)JSONString{
    if (self == nil) {return nil;}
    if ([NSJSONSerialization isValidJSONObject:self])
    {
        __autoreleasing NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
        NSString *json =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        if (json!=nil && json.length > 0) {
            NSMutableString *string_self = [[NSMutableString alloc] initWithCapacity:1];
            [string_self appendString:json];
            [string_self replaceOccurrencesOfString:@"\n"
                                         withString:@""
                                            options:NSLiteralSearch
                                              range:NSMakeRange(0, [string_self length])];
            
            return string_self;
        }
        return json;
    }
    return nil;
}


@end


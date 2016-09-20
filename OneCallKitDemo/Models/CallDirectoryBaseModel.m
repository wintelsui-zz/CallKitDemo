//
//  CallDirectoryBaseModel.m
//
//  Created by wintel sui on 16/8/18
//  Copyright (c) 2016 Chinasofti. All rights reserved.
//

#import "CallDirectoryBaseModel.h"


@interface CallDirectoryBaseModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation CallDirectoryBaseModel

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)init{
    self = [super init];
    
    if(self) {
        
    }
    
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    if(self && [dict isKindOfClass:[NSDictionary class]]) {

    }
    
    return self;
    
}

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
}

- (id)copyWithZone:(NSZone *)zone
{
    CallDirectoryBaseModel *copy = [[CallDirectoryBaseModel alloc] init];
    
    if (copy) {
    }
    
    return copy;
}
@end

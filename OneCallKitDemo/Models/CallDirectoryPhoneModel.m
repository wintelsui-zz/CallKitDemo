//
//  CallDirectoryPhoneModel.m
//
//  Created by wintel sui on 16/8/18
//  Copyright (c) 2016 Chinasofti. All rights reserved.
//

#import "CallDirectoryPhoneModel.h"


NSString *const kCallDirectoryBaseModelPhone = @"phone";
NSString *const kCallDirectoryBaseModelType = @"type";
NSString *const kCallDirectoryBaseModelDesc = @"desc";


@interface CallDirectoryPhoneModel ()

@end

@implementation CallDirectoryPhoneModel

@synthesize phone = _phone;
@synthesize type = _type;
@synthesize desc = _desc;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.phone = [self objectOrNilForKey:kCallDirectoryBaseModelPhone fromDictionary:dict];
            self.type = [self objectOrNilForKey:kCallDirectoryBaseModelType fromDictionary:dict];
            self.desc = [self objectOrNilForKey:kCallDirectoryBaseModelDesc fromDictionary:dict];

    }
    
    return self;
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.phone forKey:kCallDirectoryBaseModelPhone];
    [mutableDict setValue:self.type forKey:kCallDirectoryBaseModelType];
    [mutableDict setValue:self.desc forKey:kCallDirectoryBaseModelDesc];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.phone = [aDecoder decodeObjectForKey:kCallDirectoryBaseModelPhone];
    self.type = [aDecoder decodeObjectForKey:kCallDirectoryBaseModelType];
    self.desc = [aDecoder decodeObjectForKey:kCallDirectoryBaseModelDesc];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_phone forKey:kCallDirectoryBaseModelPhone];
    [aCoder encodeObject:_type forKey:kCallDirectoryBaseModelType];
    [aCoder encodeObject:_desc forKey:kCallDirectoryBaseModelDesc];
}

- (id)copyWithZone:(NSZone *)zone
{
    CallDirectoryPhoneModel *copy = [[CallDirectoryPhoneModel alloc] init];
    
    if (copy) {

        copy.phone = [self.phone copyWithZone:zone];
        copy.type = [self.type copyWithZone:zone];
        copy.desc = [self.desc copyWithZone:zone];
    }
    
    return copy;
}


@end

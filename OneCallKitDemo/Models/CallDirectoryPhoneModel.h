//
//  CallDirectoryPhoneModel.h
//
//  Created by wintel sui on 16/8/18
//  Copyright (c) 2016 Chinasofti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CallDirectoryBaseModel.h"


@interface CallDirectoryPhoneModel : CallDirectoryBaseModel

@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *desc;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end

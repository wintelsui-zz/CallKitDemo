//
//  CallDirectoryBaseModel.h
//
//  Created by wintel sui on 16/8/18
//  Copyright (c) 2016 Chinasofti. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CallDirectoryBaseModel : NSObject <NSCoding, NSCopying>

- (instancetype)init;
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;
@end

//
//  Collection.m
//  FibaRule
//
//  Created by sungeo on 15/1/4.
//  Copyright (c) 2015年 buddysoft. All rights reserved.
//

#import "Collection.h"

@implementation Collection

- (id)init{
    if (self = [super init]) {
        self.oid = @"503";
        self.comment = @"BuddySoft";
        
        NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
        self.createTime = [formatter stringFromDate:[NSDate date]];
    }
    
    return self;
}

@end

//
//  Collection.h
//  FibaRule
//
//  Created by sungeo on 15/1/4.
//  Copyright (c) 2015年 buddysoft. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    CollectionFiba2012 = 1,
    CollectionFiba2014,
    
}CollectionType;

@interface Collection : NSObject

@property (nonatomic, copy) NSString * oid;
@property (nonatomic, copy) NSString * type;
@property (nonatomic, copy) NSString * url;
@property (nonatomic, copy) NSString * createTime;
@property (nonatomic, copy) NSString * comment;

@end

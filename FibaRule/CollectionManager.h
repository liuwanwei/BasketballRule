//
//  CollectionManager.h
//  FibaRule
//
//  Created by sungeo on 15/1/4.
//  Copyright (c) 2015年 buddysoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DataSource.h"

#define kCollectionChanged          @"Fiba2014CollectionChanged"

@class Collection;

@interface CollectionManager : NSObject 

+ (CollectionManager *)defaultInstance;

- (void)addCollection:(Collection *)collection;
- (void)removeCollection:(Collection *)collection;
- (NSArray *)collectionsForType:(DataType)type;

@end

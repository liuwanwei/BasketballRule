//
//  CollectionManager.h
//  FibaRule
//
//  Created by sungeo on 15/1/4.
//  Copyright (c) 2015年 buddysoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define kCollectionChanged          @"Fiba2014CollectionChanged"

@class Collection;

@interface CollectionManager : NSObject 

@property (nonatomic, strong) NSArray * fiba2014Collections;
@property (nonatomic, strong) NSArray * fiba2014InterpretationCollections;
@property (nonatomic, strong) NSArray * nbaCollections;

+ (CollectionManager *)defaultInstance;

- (void)addCollection:(Collection *)collection;
- (void)removeCollection:(Collection *)collection;

@end

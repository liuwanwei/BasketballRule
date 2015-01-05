//
//  CollectionManager.h
//  FibaRule
//
//  Created by sungeo on 15/1/4.
//  Copyright (c) 2015年 buddysoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "IDMPhotoBrowser.h"

@class Collection;

@interface CollectionManager : NSObject <IDMPhotoBrowserDelegate>

@property (nonatomic, strong) NSArray * fiba2014Collections;

+ (CollectionManager *)defaultInstance;

- (void)addCollection:(Collection *)collection;
- (void)removeCollection:(Collection *)collection;

- (void)showFibaRulesInViewController:(UIViewController *)viewController withPage:(NSUInteger)page;

@end

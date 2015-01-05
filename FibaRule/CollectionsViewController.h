//
//  CollectionsViewController.h
//  FibaRule
//
//  Created by sungeo on 15/1/4.
//  Copyright (c) 2015年 buddysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Collection.h"

@interface CollectionsViewController : UITableViewController

@property (nonatomic, weak) NSArray * collections;
@property (nonatomic) CollectionType collectionType;

@end

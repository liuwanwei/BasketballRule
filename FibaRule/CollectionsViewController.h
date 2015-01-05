//
//  CollectionsViewController.h
//  FibaRule
//
//  Created by sungeo on 15/1/4.
//  Copyright (c) 2015年 buddysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Collection.h"
#import "DataSource.h"

@interface CollectionsViewController : UITableViewController

@property (nonatomic, weak) NSArray * collections;
@property (nonatomic) DataType collectionType;

@end

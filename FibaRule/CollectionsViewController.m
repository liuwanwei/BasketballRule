//
//  CollectionsViewController.m
//  FibaRule
//
//  Created by sungeo on 15/1/4.
//  Copyright (c) 2015年 buddysoft. All rights reserved.
//

#import "CollectionsViewController.h"
#import "Collection.h"
#import "DataSource.h"
#import "CollectionManager.h"
#import "PhotoViewer.h"

@implementation CollectionsViewController

#pragma mark - UIViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"我的收藏";
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kCollectionChanged object:nil queue:nil usingBlock:^(NSNotification * note){
        self.collections = [[CollectionManager defaultInstance] fiba2014Collections];
        [self.tableView reloadData];
    }];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.collections.count;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * sIdentifier = @"CollectionCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:sIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:sIdentifier];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    Collection * collection = self.collections[indexPath.row];
    cell.textLabel.text = collection.comment;
    cell.detailTextLabel.text = collection.createTime;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Collection * collection = self.collections[indexPath.row];
    NSArray * urls = [DataSource photoUrlsForCollectionType:self.collectionType];
    NSArray * photos = [DataSource photosForCollectionType:self.collectionType];
    NSUInteger index = [urls indexOfObject:collection.url];
    if (index != NSNotFound) {
        [[PhotoViewer defaultInstance] showPhotos:photos withFirstPage:index];
    }
    
}

@end

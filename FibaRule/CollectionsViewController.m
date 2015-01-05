//
//  CollectionsViewController.m
//  FibaRule
//
//  Created by sungeo on 15/1/4.
//  Copyright (c) 2015年 buddysoft. All rights reserved.
//

#import "CollectionsViewController.h"
#import "Collection.h"
#import "DataManager.h"
#import "CollectionManager.h"
#import <IDMPhotoBrowser.h>

@implementation CollectionsViewController

#pragma mark - UIViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"我的收藏";
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
    NSArray * urls = [DataManager fiba2014PhotoUrls];   // TODO: 不同的收藏应该展示不同的源图
//    NSArray * photos = [DataManager fiba2014Photos];    // TODO: 同上
    NSUInteger index = [urls indexOfObject:collection.url];
    if (index != NSNotFound) {
        [[CollectionManager defaultInstance] showFibaRulesInViewController:self withPage:index];
    }
    
}

@end

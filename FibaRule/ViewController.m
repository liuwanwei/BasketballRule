//
//  ViewController.m
//  FibaRule
//
//  Created by sungeo on 15/1/4.
//  Copyright (c) 2015年 buddysoft. All rights reserved.
//

#import "ViewController.h"
#import "CollectionsViewController.h"
#import "PhotoViewer.h"
#import "DataSource.h"
#import "CollectionManager.h"
#import "BDFoundation.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.clearsSelectionOnViewWillAppear = YES;
    [[NSNotificationCenter defaultCenter] addObserverForName:kCollectionChanged object:nil queue:nil usingBlock:^(NSNotification * note){
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        NSInteger collectionCount = 0;
        CollectionManager * cm = [CollectionManager defaultInstance];
        switch (indexPath.section) {
            case 0:
                collectionCount = [cm collectionsForType:DataFiba2014].count;
                break;
            case 1:
                collectionCount = [cm collectionsForType:DataFiba2014Interpretation].count;
                break;
            case 2:
                collectionCount = [cm collectionsForType:DataNba].count;
                break;
            default:
                break;
        }
        
        NSString * text;
        if (collectionCount != 0) {
            text = [NSString stringWithFormat:@"%d", (int)collectionCount];
        }else{
            text = @"空";
        }
        
        cell.detailTextLabel.text = text;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DataType type = DataNone;
    if (indexPath.row == 0) {
        type = DataFiba2014;
//        if (indexPath.row == 0) {
//            // 展示图片浏览器
//            NSArray * photos = [DataSource photosForCollectionType:DataFiba2014];
//            [[PhotoViewer defaultInstance] showPhotos:photos withFirstPage:0];
//        }
    }else if(indexPath.row == 1){
        type = DataFiba2014Interpretation;
    }else if(indexPath.section == 2){
        type = DataNba;
    }
    
    // 展示我的收藏
    [self showCollectionsWithType:type];

    
//    if (indexPath.row == 0) {
//        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
//    }
}


- (void)showCollectionsWithType:(DataType)type{
    NSArray * collections = [[CollectionManager defaultInstance] collectionsForType:type];
    UIStoryboard * sb = STORYBOARD(@"Main");
    CollectionsViewController * vc = [sb instantiateViewControllerWithIdentifier:@"CollectionsViewController"];
    vc.collections = collections;
    vc.collectionType = type;
    
    [self.navigationController pushViewController:vc animated:YES];
}

@end

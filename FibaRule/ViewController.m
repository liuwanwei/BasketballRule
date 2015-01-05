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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            // 展示图片浏览器
            NSArray * photos = [DataSource photosForCollectionType:DataFiba2014];
            [[PhotoViewer defaultInstance] showPhotos:photos withFirstPage:0];
        }else if(indexPath.row == 1){
            // 展示我的收藏
            [self showCollections:[[CollectionManager defaultInstance] fiba2014Collections]];
        }
    }else if(indexPath.section == 1){
        if (indexPath.row == 0) {
            NSArray * photos = [DataSource photosForCollectionType:DataFiba2014Interpretation];
            [[PhotoViewer defaultInstance] showPhotos:photos withFirstPage:0];
        }else if(indexPath.row == 1){
            [self showCollections:[[CollectionManager defaultInstance] fiba2014InterpretationCollections]];
        }
    }else if(indexPath.section == 2){
        if (indexPath.row == 0) {
            NSArray * photos = [DataSource photosForCollectionType:DataNba];
            [[PhotoViewer defaultInstance] showPhotos:photos withFirstPage:0];
        }else if(indexPath.row == 1){
            [self showCollections:[[CollectionManager defaultInstance] nbaCollections]];
        }
    }
    
    if (indexPath.row == 0) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}


- (void)showCollections:(NSArray *)collections{
    CollectionsViewController * vc = [[CollectionsViewController alloc] initWithStyle:UITableViewStylePlain];
    vc.collections = collections;
    if (collections.count > 0) {
        Collection * collection = collections[0];
        vc.collectionType = (DataType)[collection.type integerValue];
    }
    
    [self.navigationController pushViewController:vc animated:YES];
}

@end

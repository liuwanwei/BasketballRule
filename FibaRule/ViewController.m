//
//  ViewController.m
//  FibaRule
//
//  Created by sungeo on 15/1/4.
//  Copyright (c) 2015年 buddysoft. All rights reserved.
//

#import "ViewController.h"
#import "Collection.h"
#import "CollectionManager.h"
#import "CollectionsViewController.h"
#import "DataManager.h"
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
            [[CollectionManager defaultInstance] showFibaRulesInViewController:self withPage:0];
        }else if(indexPath.row == 1){
            // 展示我的收藏
            [self showFiba2014Collections];
        }
    }
}


- (void)showFiba2014Collections{
    CollectionsViewController * vc = [[CollectionsViewController alloc] initWithStyle:UITableViewStylePlain];
    vc.collections = [[CollectionManager defaultInstance] fiba2014Collections];
    [self.navigationController pushViewController:vc animated:YES];
}

@end

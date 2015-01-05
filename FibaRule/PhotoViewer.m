//
//  PhotoViewer.m
//  FibaRule
//
//  Created by sungeo on 15/1/5.
//  Copyright (c) 2015年 buddysoft. All rights reserved.
//

#import "PhotoViewer.h"
#import "Collection.h"
#import "CollectionManager.h"
#import "BDFoundation.h"
#import "DataSource.h"

@implementation PhotoViewer

+ (PhotoViewer *)defaultInstance{
    static PhotoViewer * sPhotoViewer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (sPhotoViewer == nil) {
            sPhotoViewer = [[PhotoViewer alloc] init];
        }
    });
    
    return sPhotoViewer;
}

- (void)showPhotos:(NSArray *)photos withFirstPage:(NSUInteger)firstPage{
    // TODO: 隐藏向前向后按钮
    IDMPhotoBrowser * pb = [[IDMPhotoBrowser alloc] initWithPhotos:photos];
    pb.delegate = self;
    pb.displayActionButton = YES;
    pb.displayCounterLabel = YES;
    pb.actionButtonTitles = @[@"收藏"];
    [pb setInitialPageIndex:firstPage];
    
    [kWindow.rootViewController presentViewController:pb animated:YES completion:nil];
}

#pragma mark IDMPhotoBrowserDelegate
- (void)photoBrowser:(IDMPhotoBrowser *)photoBrowser didDismissActionSheetWithButtonIndex:(NSUInteger)buttonIndex photoIndex:(NSUInteger)photoIndex{
    if (buttonIndex == 0) {
        [[AlertViewTextEditor defaultInstance] showText:@"帮我记住" title:@"收藏" message:@"收藏后可以随时查看" completed:^(NSString * text){
            // 收藏
            IDMPhoto * photo = [photoBrowser photoAtIndex:photoIndex];
            NSURL * photoUrl = photo.photoURL;
            
            Collection * collection = [[Collection alloc] init];
            collection.url = photoUrl.relativeString;
            collection.comment = text;
            collection.type = [DataSource dataTypeForUrl:collection.url];
            
            [[CollectionManager defaultInstance] addCollection:collection];
        }];
    }
}

@end

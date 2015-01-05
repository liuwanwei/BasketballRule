//
//  PhotoViewer.h
//  FibaRule
//
//  Created by sungeo on 15/1/5.
//  Copyright (c) 2015年 buddysoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDMPhotoBrowser.h"

@interface PhotoViewer : NSObject <IDMPhotoBrowserDelegate>

+ (PhotoViewer *)defaultInstance;

- (void)showPhotos:(NSArray *)photos withFirstPage:(NSUInteger)firstPage;

@end

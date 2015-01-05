//
//  DataManager.m
//  FibaRule
//
//  Created by sungeo on 15/1/5.
//  Copyright (c) 2015年 buddysoft. All rights reserved.
//

#import "DataManager.h"
#import <IDMPhotoBrowser.h>

@implementation DataManager

+ (NSArray *)fiba2014Photos{
    NSString * baseUrl = @"http://cbagm.com/Rules/FIBARulesCHN2014/FIBA%E8%A7%84%E5%88%992014%E4%B8%AD%E6%96%87%E7%89%88_%E9%A1%B5%E9%9D%A2_";
    int maxIndex = 101;
    NSMutableArray * photos = [NSMutableArray array];
    for (int i = 1; i <= maxIndex; i++) {
        NSString * string = [NSString stringWithFormat:@"%@%03d.jpg", baseUrl, i];
        NSURL * url = [NSURL URLWithString:string];
        [photos addObject:[IDMPhoto photoWithURL:url]];
    }

    return photos;
}

+ (NSArray *)fiba2014PhotoUrls{
    NSString * baseUrl = @"http://cbagm.com/Rules/FIBARulesCHN2014/FIBA%E8%A7%84%E5%88%992014%E4%B8%AD%E6%96%87%E7%89%88_%E9%A1%B5%E9%9D%A2_";
    int maxIndex = 101;
    NSMutableArray * urls = [NSMutableArray array];
    for (int i = 1; i <= maxIndex; i++) {
        NSString * string = [NSString stringWithFormat:@"%@%03d.jpg", baseUrl, i];
        [urls addObject:string];
    }
    
    return urls;
    
}

@end

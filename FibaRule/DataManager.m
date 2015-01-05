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

#pragma mark - 生成数据的内部接口

+ (NSArray *)urlArrayWithBaseUrl:(NSString *)baseUrl maxIndex:(NSInteger)max{
    NSMutableArray * mutable = [NSMutableArray array];
    for (int i = 1; i<= max; i++) {
        NSString * urlString = nil;
        if (max/100 > 0) {
            urlString = [NSString stringWithFormat:@"%@%03d.jpg", baseUrl, i];
        }else{
            urlString = [NSString stringWithFormat:@"%@%02d.jpg", baseUrl, i];
        }
        
        [mutable addObject:urlString];
    }
    
    return mutable;
}

+ (NSArray *)photoArrayWithBaseUrl:(NSString *)baseUrl maxIndex:(NSInteger)max{
    NSMutableArray * mutable = [NSMutableArray array];
    for (int i = 1; i<= max; i++) {
        NSString * urlString = nil;
        if (max/100 > 0) {
            urlString = [NSString stringWithFormat:@"%@%03d.jpg", baseUrl, i];
        }else{
            urlString = [NSString stringWithFormat:@"%@%02d.jpg", baseUrl, i];
        }
        
        NSURL * url = [NSURL URLWithString:urlString];
        
        [mutable addObject:[IDMPhoto photoWithURL:url]];
    }
    
    return mutable;
}

+ (NSArray *)fiba2014PhotoUrls{
    static NSArray * sUrls = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (sUrls == nil) {
            sUrls = [DataManager urlArrayWithBaseUrl:kFiba2014DataSource maxIndex:101];
        }
    });
    
    return sUrls;
}

+ (NSArray *)fiba2014Photos{
    static NSArray * sPhotos = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (sPhotos == nil) {
            sPhotos = [DataManager photoArrayWithBaseUrl:kFiba2014DataSource maxIndex:101];
        }
    });
    
    return sPhotos;
}


+ (NSArray *)fiba2014InterpretationPhotoUrls{
    static NSArray * sUrls = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (sUrls == nil) {
            sUrls = [DataManager urlArrayWithBaseUrl:kFiba2014InterpretationDataSource maxIndex:58];
        }
    });
    
    return sUrls;
}

+ (NSArray *)fiba2014InterpretationPhotos{
    static NSArray * sPhotos = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (sPhotos == nil) {
            sPhotos = [DataManager photoArrayWithBaseUrl:kFiba2014InterpretationDataSource maxIndex:58];
        }
    });
    
    return sPhotos;
}


#pragma mark - 生成数据的外部接口

+ (NSArray *)photosForCollectionType:(CollectionType)type{
    if (type == CollectionFiba2014) {
        return [DataManager fiba2014Photos];
    }else if(type == CollectionFiba2014Interpretation){
        return [DataManager fiba2014InterpretationPhotos];
    }else{
        return nil;
    }
}

+ (NSArray *)photoUrlsForCollectionType:(CollectionType)type{
    if (type == CollectionFiba2014) {
        return [DataManager fiba2014PhotoUrls];
    }else if(type == CollectionFiba2014Interpretation){
        return [DataManager fiba2014InterpretationPhotoUrls];
    }else{
        return nil;
    }
}

@end

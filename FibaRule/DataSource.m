//
//  DataManager.m
//  FibaRule
//
//  Created by sungeo on 15/1/5.
//  Copyright (c) 2015年 buddysoft. All rights reserved.
//

#import "DataSource.h"
#import <IDMPhotoBrowser.h>

@implementation DataSource

#pragma mark - 生成数据的内部接口

- (NSArray *)urlArrayWithBaseUrl:(NSString *)baseUrl maxIndex:(NSInteger)max{
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

- (NSArray *)photoArrayWithBaseUrl:(NSString *)baseUrl maxIndex:(NSInteger)max{
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

- (id)initWithType:(DataType)type andMaxPage:(NSUInteger)max{
    if (self = [super init]) {
        self.type = type;
        
        NSString * urlPrefix = nil;
        switch (type) {
            case DataFiba2014:
                urlPrefix = kFiba2014DataSource;
                break;
            case DataFiba2014Interpretation:
                urlPrefix = kFiba2014InterpretationDataSource;
                break;
            case DataNba:
                urlPrefix = kNbaDataSource;
                break;
            default:
                break;
        }
        self.urlPrefix = urlPrefix;
        self.photos = [self photoArrayWithBaseUrl:urlPrefix maxIndex:max];
        self.photoUrls = [self urlArrayWithBaseUrl:urlPrefix maxIndex:max];
    }
    
    return self;
}


#pragma mark - 生成数据的外部接口

static NSArray * sDataSources = nil;

+ (void)initDataSource{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (sDataSources == 0) {
            DataSource * ds1, *ds2, *ds3;
            
            ds1 = [[DataSource alloc] initWithType:DataFiba2014 andMaxPage:101];
            ds2 = [[DataSource alloc] initWithType:DataFiba2014Interpretation andMaxPage:58];
            ds3 = [[DataSource alloc] initWithType:DataNba andMaxPage:55];

            sDataSources = @[ds1, ds2, ds3];
        }
    });
}

+ (NSArray *)photosForCollectionType:(DataType)type{
    [DataSource initDataSource];
    
    for (DataSource * ds in sDataSources) {
        if (ds.type == type) {
            return ds.photos;
        }
    }
    
    return nil;
}

+ (NSArray *)photoUrlsForCollectionType:(DataType)type{
    [DataSource initDataSource];
    
    for (DataSource * ds in sDataSources) {
        if (ds.type == type) {
            return ds.photoUrls;
        }
    }
    
    return nil;
}

+ (NSString *)dataTypeForUrl:(NSString *)url{
    for (DataSource * ds in sDataSources) {
        if ([url hasPrefix:ds.urlPrefix]) {
            return [NSString stringWithFormat:@"%d", (int)ds.type];
        }
    }
    
    return @"";
}

@end

//
//  CollectionManager.m
//  FibaRule
//
//  Created by sungeo on 15/1/4.
//  Copyright (c) 2015年 buddysoft. All rights reserved.
//

#import "CollectionManager.h"
#import <FMDatabase.h>
#import <FMDatabaseAdditions.h>
#import "Collection.h"
#import "DataManager.h"
#import "BDFoundation.h"

#define kCollectionTable        @"CollectionTable"

@interface CollectionManager()

@property (nonatomic, strong) FMDatabase * database;
@property (nonatomic, copy) NSComparisonResult (^compareCollection)(Collection * obj1, Collection * obj2);

@end

@implementation CollectionManager

+ (CollectionManager *)defaultInstance{
    static CollectionManager * sCm = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (sCm == nil) {
            sCm = [[CollectionManager alloc] init];
        }
    });
    
    return sCm;
}

- (id)init{
    if (self = [super init]) {
        // 初始化排序器
        self.compareCollection = ^(Collection * obj1, Collection * obj2){
            NSComparisonResult result = [obj1.createTime compare:obj2.createTime];
            if (result == NSOrderedAscending) {
                return NSOrderedDescending;
            }else if(result == NSOrderedDescending){
                return NSOrderedAscending;
            }else{
                return NSOrderedSame;
            }
        };
        
        [self initDb];
    }
    
    return self;
}

- (void)initDb{
    NSLog(@"Fmdb database: %@", [self databasePath]);
    self.database = [FMDatabase databaseWithPath:[self databasePath]];
    [self.database open];
    
    NSString * table = kCollectionTable;
    NSString * sql;
    NSMutableArray * objects = [NSMutableArray array];
    if (![self.database tableExists:table]) {
        sql = [NSString stringWithFormat:@"create table \"%@\" (\"oid\" text, \"type\" text, \"url\" text, \"createTime\" text, \"comment\" text)", table];
        [self.database executeUpdate:sql];
    }else{
        sql = [NSString stringWithFormat:@"select \"oid\", \"type\", \"url\", \"createTime\", \"comment\" from \"%@\"", table];
        FMResultSet * rs = [self.database executeQuery:sql];
        
        while ([rs next]) {
            Collection * object = [[Collection alloc] init];
            object.oid = [rs stringForColumn:@"oid"];
            object.type = [rs stringForColumn:@"type"];
            object.url = [rs stringForColumn:@"url"];
            object.createTime = [rs stringForColumn:@"createTime"];
            object.comment = [rs stringForColumn:@"comment"];
            
            [objects addObject:object];
        }
    }
    
    self.fiba2014Collections = [self sortedCollections:objects];
}

// 对收藏进行排序，按照日期由近到远，返回排序后的数组
- (NSArray *)sortedCollections:(NSArray *)collections{
    return [collections sortedArrayUsingComparator:self.compareCollection];
}



- (NSString *)databasePath {
    static NSString *sDatabasePath = nil;
    if (!sDatabasePath) {
        NSString *cacheDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        sDatabasePath = [cacheDirectory stringByAppendingPathComponent:@"rules.db"];
    }
    return sDatabasePath;
}


- (void)addCollection:(Collection *)collection{
    // 更新数据库
    NSString * sql = [NSString stringWithFormat:@"insert into \"%@\" (\"oid\", \"type\", \"url\", \"comment\",\"createTime\") values(?,?,?,?,?)", kCollectionTable];
    BOOL result = [self.database executeUpdate:sql withArgumentsInArray:@[collection.oid, collection.type, collection.url, collection.comment,collection.createTime]];
    if (! result) {
        NSLog(@"%@", [self.database lastErrorMessage]);
    }else{
        // 更新缓存
        NSMutableArray * mutable = [self.fiba2014Collections mutableCopy];
        
        // 查找插入位置
        NSUInteger insertionIndex = [mutable indexOfObject:collection
                                             inSortedRange:NSMakeRange(0, mutable.count)
                                                   options:NSBinarySearchingInsertionIndex
                                           usingComparator:self.compareCollection];
        [mutable insertObject:collection atIndex:insertionIndex];
        self.fiba2014Collections = mutable;
        
        // 发消息，触发更新收藏界面
        // TODO: 区分不同的规则状态
        [[NSNotificationCenter defaultCenter] postNotificationName:kFiba2014CollectionChanged object:self];
    }
}

- (void)removeCollection:(Collection *)collection{
    // 更新数据库
    NSString * sql = [NSString stringWithFormat:@"delete from \"%@\" where \"url\"=\"%@\" and \"createTime\"=\"%@\"", kCollectionTable, collection.url, collection.createTime];
    if([self executeUpdate:sql]){
        NSMutableArray * mutable = [self.fiba2014Collections mutableCopy];
        [mutable removeObject:collection];
        self.fiba2014Collections = mutable;
        
//        [[NSNotificationCenter defaultCenter] postNotificationName:kQuestionnairesChanged object:self];
//        NSLog(@"发送消息：%@", kQuestionnairesChanged);
    }

}

- (BOOL)executeUpdate:(NSString *)sql{
    if(! [self.database executeUpdate:sql]){
        NSLog(@"%d : %@", [self.database lastErrorCode],[self.database lastErrorMessage]);
        return NO;
    }else{
        return YES;
    }
}

- (void)showFibaRulesInViewController:(UIViewController *)viewController withPage:(NSUInteger)page{
    NSArray * photos = [DataManager fiba2014Photos];
    
    if (photos.count > 0) {
        IDMPhotoBrowser * pb = [[IDMPhotoBrowser alloc] initWithPhotos:photos];
        pb.delegate = self;
        pb.displayActionButton = YES;
        pb.displayCounterLabel = YES;
        pb.actionButtonTitles = @[@"收藏"];
        [pb setInitialPageIndex:page];
        
        [viewController presentViewController:pb animated:YES completion:nil];
    }
}

#pragma mark IDMPhotoBrowserDelegate
- (void)photoBrowser:(IDMPhotoBrowser *)photoBrowser didDismissActionSheetWithButtonIndex:(NSUInteger)buttonIndex photoIndex:(NSUInteger)photoIndex{
    if (buttonIndex == 0) {
        [[AlertViewTextEditor defaultInstance] showText:@"帮我记住" title:@"收藏" message:@"收藏后可以随时查看" completed:^(NSString * text){
            // 收藏
            IDMPhoto * photo = [photoBrowser photoAtIndex:photoIndex];
            NSURL * photoUrl = photo.photoURL;
            NSString * string = photoUrl.relativeString;
            
            Collection * collection = [[Collection alloc] init];
            collection.type = [NSString stringWithFormat:@"%d", (int)CollectionFiba2014];
            collection.url = string;
            collection.comment = text;
            
            [[CollectionManager defaultInstance] addCollection:collection];
        }];
    }
}


@end

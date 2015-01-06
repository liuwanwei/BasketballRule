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
#import "DataSource.h"
#import "BDFoundation.h"

#define kCollectionTable        @"CollectionTable"

@interface CollectionManager()

@property (nonatomic, strong) NSArray * fiba2014Collections;
@property (nonatomic, strong) NSArray * fiba2014InterpretationCollections;
@property (nonatomic, strong) NSArray * nbaCollections;

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
        
        self.fiba2014Collections = [NSMutableArray array];
        self.fiba2014InterpretationCollections = [NSMutableArray array];
        
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
    
    NSMutableArray * fiba2014Tmp = [NSMutableArray array];
    NSMutableArray * fiba2014IntTmp = [NSMutableArray array];
    NSMutableArray * nbaTmp = [NSMutableArray array];

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

            if ([object.type integerValue] == DataFiba2014) {
                [fiba2014Tmp addObject:object];
            }else if([object.type integerValue] == DataFiba2014Interpretation){
                [fiba2014IntTmp addObject:object];
            }else if([object.type integerValue] == DataNba){
                [nbaTmp addObject:object];
            }

        }
    }
 
    // 对收藏进行排序，按照日期由近到远，返回排序后的数组
    self.fiba2014Collections = [fiba2014Tmp sortedArrayUsingComparator:self.compareCollection];
    self.fiba2014InterpretationCollections = [fiba2014IntTmp sortedArrayUsingComparator:self.compareCollection];
    self.nbaCollections = [nbaTmp sortedArrayUsingComparator:self.compareCollection];
}

- (NSString *)databasePath {
    static NSString *sDatabasePath = nil;
    if (!sDatabasePath) {
        NSString *cacheDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        sDatabasePath = [cacheDirectory stringByAppendingPathComponent:@"rules.db"];
    }
    return sDatabasePath;
}

- (NSArray *)insertCollection:(Collection *)collection toArray:(NSArray *)array{
    NSMutableArray * mutable = [array mutableCopy];
    
    // 查找插入位置
    NSUInteger insertionIndex = [mutable indexOfObject:collection
                                         inSortedRange:NSMakeRange(0, mutable.count)
                                               options:NSBinarySearchingInsertionIndex
                                       usingComparator:self.compareCollection];
    [mutable insertObject:collection atIndex:insertionIndex];
    return mutable;
}


- (void)addCollection:(Collection *)collection{
    // 更新数据库
    NSString * sql = [NSString stringWithFormat:@"insert into \"%@\" (\"oid\", \"type\", \"url\", \"comment\",\"createTime\") values(?,?,?,?,?)", kCollectionTable];
    BOOL result = [self.database executeUpdate:sql withArgumentsInArray:@[collection.oid, collection.type, collection.url, collection.comment,collection.createTime]];
    if (! result) {
        NSLog(@"%@", [self.database lastErrorMessage]);
    }else{
        // 更新缓存
        if ([collection.type integerValue] == DataFiba2014) {
            self.fiba2014Collections = [self insertCollection:collection toArray:self.fiba2014Collections];
        }else if([collection.type integerValue] == DataFiba2014Interpretation){
            self.fiba2014InterpretationCollections = [self insertCollection:collection toArray:self.fiba2014InterpretationCollections];
        }else if([collection.type integerValue] == DataNba){
            self.nbaCollections = [self insertCollection:collection toArray:self.nbaCollections];
        }
        
        // 发消息，触发更新收藏界面
        [[NSNotificationCenter defaultCenter] postNotificationName:kCollectionChanged object:self userInfo:@{@"type":collection.type}];
    }
}

- (NSArray *)deleteCollection:(Collection *)collection fromArray:(NSArray *)array{
    NSMutableArray * mutable = [array mutableCopy];
    [mutable removeObject:collection];
    return mutable;
}

- (void)removeCollection:(Collection *)collection{
    // 更新数据库
    NSString * sql = [NSString stringWithFormat:@"delete from \"%@\" where \"url\"=\"%@\" and \"createTime\"=\"%@\"", kCollectionTable, collection.url, collection.createTime];
    if([self executeUpdate:sql]){
        if ([collection.type integerValue] == DataFiba2014) {
            self.fiba2014Collections = [self deleteCollection:collection fromArray:self.fiba2014Collections];
        }else if([collection.type integerValue] == DataFiba2014Interpretation){
            self.fiba2014InterpretationCollections = [self deleteCollection:collection fromArray:self.fiba2014InterpretationCollections];
        }else if([collection.type integerValue] == DataNba){
            self.nbaCollections = [self deleteCollection:collection fromArray:self.nbaCollections];
        }
        
        //  区分不同的规则分类
        [[NSNotificationCenter defaultCenter] postNotificationName:kCollectionChanged object:self userInfo:@{@"type":collection.type}];
    }

}

// 根据数据类型获取收藏信息
- (NSArray *)collectionsForType:(DataType)type{
    NSArray * array = nil;
    switch (type) {
        case DataFiba2014:
            array = self.fiba2014Collections;
            break;
        case DataFiba2014Interpretation:
            array = self.fiba2014InterpretationCollections;
            break;
        case DataNba:
            array = self.nbaCollections;
            break;
        default:
            break;
    }
    
    return array;
}

- (BOOL)executeUpdate:(NSString *)sql{
    if(! [self.database executeUpdate:sql]){
        NSLog(@"%d : %@", [self.database lastErrorCode],[self.database lastErrorMessage]);
        return NO;
    }else{
        return YES;
    }
}


@end

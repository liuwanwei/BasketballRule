//
//  DataManager.h
//  FibaRule
//
//  Created by sungeo on 15/1/5.
//  Copyright (c) 2015年 buddysoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Collection.h"

#define kFiba2014DataSource @"http://cbagm.com/Rules/FIBARulesCHN2014/FIBA%E8%A7%84%E5%88%992014%E4%B8%AD%E6%96%87%E7%89%88_%E9%A1%B5%E9%9D%A2_"

#define kFiba2014InterpretationDataSource @"http://cbagm.com/Rules/FIBARulesInterpretationsCHN2014/FIBA2014%E8%A7%84%E5%88%99%E8%A7%A3%E9%87%8A%E4%B8%AD%E6%96%87%E7%89%88_%E9%A1%B5%E9%9D%A2_"


@interface DataManager : NSObject

+ (NSArray *)photosForCollectionType:(CollectionType)type;
+ (NSArray *)photoUrlsForCollectionType:(CollectionType)type;

//+ (NSArray *)fiba2014Photos;
//+ (NSArray *)fiba2014PhotoUrls;
//
//+ (NSArray *)fiba2014InterpretationPhotos;
//+ (NSArray *)fiba2014InterpretationPhotoUrls;

@end

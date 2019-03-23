//
//  CSStorageManager.h
//  FMDB_Demo
//
//  Created by cs on 2019/3/23.
//  Copyright © 2019 cs. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class Student;

/// 数据库存储
@interface CSStorageManager : NSObject

+ (instancetype)sharedManager;

#pragma mark - motion Model Actions

/**
 Save a motion model to database.
 */
- (BOOL)saveStudentModel:(Student *)model;

/**
 Get all motion models in database(this time). If nothing, it will return an emtpy array.
 */
- (NSArray <Student *>*)getAllStudentModels;

/**
 According to the models to remove the motion models where happened in dataBase.
 If any one fails, it returns to NO, and any failure will not affect others.
 */
- (BOOL)removeStudentModels:(NSArray <Student *>*)models;

@end

NS_ASSUME_NONNULL_END

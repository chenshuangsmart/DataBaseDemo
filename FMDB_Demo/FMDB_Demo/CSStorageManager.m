//
//  CSStorageManager.m
//  FMDB_Demo
//
//  Created by cs on 2019/3/23.
//  Copyright © 2019 cs. All rights reserved.
//

#import "CSStorageManager.h"
#import <FMDB/FMDB.h>
#import "Student.h"

static CSStorageManager *_instance = nil;

// Table SQL
static NSString *const kCreateStudentModelTableSQL = @"CREATE TABLE IF NOT EXISTS StudentModelTable(ObjectData BLOB NOT NULL,CreatehDate TEXT NOT NULL);";

// Table Name
static NSString *const kStudentModelTable = @"StudentModelTable";

// Column Name
static NSString *const kObjectDataColumn = @"ObjectData";
static NSString *const kIdentityColumn = @"Identity";
static NSString *const kCreateDateColumn = @"CreatehDate";

@interface CSStorageManager()

@property (strong , nonatomic) FMDatabaseQueue * dbQueue;

@end

@implementation CSStorageManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[CSStorageManager alloc] init];
        [_instance initial];
    });
    return _instance;
}

#pragma mark - Student Model

- (BOOL)saveStudentModel:(Student *)model {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
    if (data.length == 0) {
        NSLog(@"CSStorageManager save student model fail, because model's data is null");
        return NO;
    }
    
    __block NSArray *arguments = @[data, model.startTime];
    __block BOOL ret = NO;
    
    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        NSError *error;
        ret = [db executeUpdate:[NSString stringWithFormat:@"INSERT INTO %@(%@,%@) VALUES (?,?);",kStudentModelTable,kObjectDataColumn,kCreateDateColumn] values:arguments error:&error];
        if (!ret) {
            NSLog(@"CSStorageManager save student model fail,Error = %@",error.localizedDescription);
        } else {
            NSLog(@"CSStorageManager save student success!");
        }
    }];
    return ret;
}

- (BOOL)removeStudentModels:(NSArray <Student *>*)models {
    BOOL ret = YES;
    for (Student *model in models) {
        ret = ret && [self _removeMotionModel:model];
    }
    return ret;
}

- (NSArray <Student *>*)getAllStudentModels {
    __block NSMutableArray *modelArray = [[NSMutableArray alloc] init];
    
    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        FMResultSet *set = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@",kStudentModelTable]];
        while ([set next]) {
            NSData *objectData = [set dataForColumn:kObjectDataColumn];
            Student *model = [NSKeyedUnarchiver unarchiveObjectWithData:objectData];
            if (model) {
                [modelArray insertObject:model atIndex:0];
            }
        }
    }];
    
    return modelArray.copy;
}

- (BOOL)_removeMotionModel:(Student *)model {
    __block BOOL ret = NO;
    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        NSError *error;
        ret = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = ?",kStudentModelTable,kCreateDateColumn] values:@[model.startTime] error:&error];
        if (!ret) {
            NSLog(@"Delete Student model fail,error = %@",error);
        }
    }];
    return ret;
}

#pragma mark - Primary

/**
 Initialize something
 */
- (void)initial {
    __unused BOOL result = [self initDatabase];
    NSAssert(result, @"Init Database fail");
}

/**
 Init database.
 */
- (BOOL)initDatabase {
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    doc = [doc stringByAppendingPathComponent:@"LDebugTool"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:doc]) {
        NSError *error;
        [[NSFileManager  defaultManager] createDirectoryAtPath:doc withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSLog(@"CSStorageManager create folder fail, error = %@",error.description);
        }
        NSAssert(!error, error.description);
    }
    NSString *filePath = [doc stringByAppendingPathComponent:@"LDebugTool.db"];
    
    _dbQueue = [FMDatabaseQueue databaseQueueWithPath:filePath];
    
    __block BOOL ret1 = NO;
    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        // ObjectData use to convert to Student, launchDate use as identity
        ret1 = [db executeUpdate:kCreateStudentModelTableSQL];
        if (!ret1) {
            NSLog(@"LLStorageManager create StudentModelTable fail");
        }
    }];
    return ret1;
}


@end

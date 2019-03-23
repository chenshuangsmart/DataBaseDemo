//
//  Student.h
//  FMDB_Demo
//
//  Created by cs on 2019/3/23.
//  Copyright © 2019 cs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSArchiveBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface Student : CSArchiveBaseModel

@property (nonatomic) int age;
@property (nonatomic) int height;
@property (nullable, nonatomic, copy) NSString *name;
@property (nonatomic) int number;
@property (nullable, nonatomic, copy) NSString *sex;

/** time */
@property(nonatomic, strong)NSString *startTime;

@end

NS_ASSUME_NONNULL_END

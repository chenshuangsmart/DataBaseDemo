//
//  Student+CoreDataProperties.m
//  CoreDataDemo
//
//  Created by cs on 2019/3/21.
//  Copyright © 2019 cs. All rights reserved.
//
//

#import "Student+CoreDataProperties.h"

@implementation Student (CoreDataProperties)

+ (NSFetchRequest<Student *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Student"];
}

@dynamic age;
@dynamic height;
@dynamic name;
@dynamic number;
@dynamic sex;

@end

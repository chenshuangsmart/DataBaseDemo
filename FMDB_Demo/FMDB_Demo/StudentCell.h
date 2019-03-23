//
//  StudentCell.h
//  CoreDataDemo
//
//  Created by cs on 2019/3/22.
//  Copyright © 2019 cs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Student.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

NS_ASSUME_NONNULL_BEGIN

@interface StudentCell : UITableViewCell

/** model */
@property(nonatomic, strong)Student *student;

@end

NS_ASSUME_NONNULL_END

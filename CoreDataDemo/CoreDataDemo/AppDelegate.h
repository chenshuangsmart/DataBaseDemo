//
//  AppDelegate.h
//  CoreDataDemo
//
//  Created by cs on 2019/3/21.
//  Copyright © 2019 cs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end


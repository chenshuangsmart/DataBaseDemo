//
//  ViewController.m
//  sqlite3Demo
//
//  Created by cs on 2019/3/9.
//  Copyright © 2019 cs. All rights reserved.
//

#import "ViewController.h"
#import <sqlite3.h>

@interface ViewController ()

@end

@implementation ViewController {
    sqlite3 *_db;    // 句柄
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // 1.打开数据库
    [self openSqlDataBase];
    // 2.插入数据
//    [self insertData];
    // 3.查询数据
    [self sqlData];
}

// 打开数据库
- (void)openSqlDataBase {
    // db是数据库的句柄,即数据库的象征,如果对数据库进行增删改查,就得操作这个示例
    
    // 获取数据库文件的路径
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName = [docPath stringByAppendingPathComponent:@"student.sqlite"];
    NSLog(@"fileNamePath = %@",fileName);
    // 将 OC 字符串转换为 C 语言的字符串
    const char *cFileName = fileName.UTF8String;
    
    // 打开数据库文件(如果数据库文件不存在,那么该函数会自动创建数据库文件)
    int result = sqlite3_open(cFileName, &_db);
    
    if (result != SQLITE_OK) {  // 打开失败
        NSLog(@"打开数据库失败");
        return;
    }
    NSLog(@"打开数据库成功");
    
    // 创建表
    const char *sql = "CREATE TABLE IF NOT EXISTS t_students (id integer PRIMARY KEY AUTOINCREMENT,name text NOT NULL,age integer NOT NULL);";
    char *errMsg = NULL;
    
    result = sqlite3_exec(_db, sql, NULL, NULL, &errMsg);
    if (result == SQLITE_OK) {
        NSLog(@"创建表成功");
    } else {
        NSLog(@"创建表失败");
        printf("创表失败---%s----%s---%d",errMsg,__FILE__,__LINE__);
    }
}

// 插入数据
- (void)insertData {
    for (int i = 0; i < 20; i++) {
        NSString *name = [NSString stringWithFormat:@"韩雪--%d",arc4random_uniform(100)];
        int age = arc4random_uniform(20) + 10;
        
        // 拼接 sql 语句
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO t_students (name,age) VALUES ('%@',%d);",name,age];
        
        // 执行 sql 语句
        char *errMsg = NULL;
        int result = sqlite3_exec(_db, sql.UTF8String, NULL, NULL, &errMsg);
        
        if (result == SQLITE_OK) {
            NSLog(@"插入数据成功 - %@",name);
        } else {
            NSLog(@"插入数据失败 - %s",errMsg);
        }
    }
}

// 查询操作
- (void)sqlData {
    // sql语句
    const char *sql="SELECT id,name,age FROM t_students WHERE age<20;";
    sqlite3_stmt *stmt = NULL;
    
    // 进行查询前的准备工作
    if (sqlite3_prepare_v2(_db, sql, -1, &stmt, NULL) == SQLITE_OK) {   // sql语句没有问题
        NSLog(@"sql语句没有问题");
        
        // 每调用一次sqlite3_step函数，stmt就会指向下一条记录
        while (sqlite3_step(stmt) == SQLITE_ROW) {  // 找到一条记录
            // 取出数据
            int ID = sqlite3_column_int(stmt, 0);   // 取出第0列字段的值
            const unsigned char *name = sqlite3_column_text(stmt, 1);   // 取出第1列字段的值
            int age = sqlite3_column_int(stmt, 2);  // 取出第2列字段的值
            printf("%d %s %d\n",ID,name,age);
        }
    } else {
        NSLog(@"查询语句有问题");
    }
}

@end

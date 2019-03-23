//
//  ViewController.m
//  CoreDataDemo
//
//  Created by cs on 2019/3/21.
//  Copyright © 2019 cs. All rights reserved.
//

#import "ViewController.h"
#import <CoreData/CoreData.h>
#import "StudentCell.h"
#import "UIView+CSLFrame.h"
#import "Student.h"
#import <FMDB/FMDB.h>
#import "CSStorageManager.h"

static NSString *cellId = @"studentCellId";

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>
/** dataSources */
@property(nonatomic, strong)NSMutableArray *dataSources;
/** tableView */
@property(nonatomic, strong)UITableView *tableView;
/** result */
@property(nonatomic, strong)UILabel *resultLbe;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self drawUI];
    // search
    [self tapSearchBtn];
}

- (void)drawUI {
    UIButton *insertBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 50, 100, 25)];
    insertBtn.layer.borderColor = [[UIColor grayColor] CGColor];
    insertBtn.layer.borderWidth = 1;
    [insertBtn setTitle:@"插入" forState:UIControlStateNormal];
    [insertBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [insertBtn addTarget:self action:@selector(tapInsertBtn) forControlEvents:UIControlEventTouchUpInside];
    insertBtn.centerX = kScreenWidth * 0.25;
    [self.view addSubview:insertBtn];
    
    UIButton *searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 50, 100, 25)];
    searchBtn.layer.borderColor = [[UIColor grayColor] CGColor];
    searchBtn.layer.borderWidth = 1;
    [searchBtn setTitle:@"查找" forState:UIControlStateNormal];
    [searchBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(tapSearchBtn) forControlEvents:UIControlEventTouchUpInside];
    searchBtn.centerX = kScreenWidth * 0.75;
    [self.view addSubview:searchBtn];
    
    UIButton *modifyBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 100, 100, 25)];
    modifyBtn.layer.borderColor = [[UIColor grayColor] CGColor];
    modifyBtn.layer.borderWidth = 1;
    [modifyBtn setTitle:@"修改" forState:UIControlStateNormal];
    [modifyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [modifyBtn addTarget:self action:@selector(tapModifyBtn) forControlEvents:UIControlEventTouchUpInside];
    modifyBtn.centerX = kScreenWidth * 0.25;
    [self.view addSubview:modifyBtn];
    
    UIButton *deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 100, 100, 25)];
    deleteBtn.layer.borderColor = [[UIColor grayColor] CGColor];
    deleteBtn.layer.borderWidth = 1;
    [deleteBtn setTitle:@"删除全部" forState:UIControlStateNormal];
    [deleteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(tapDeleteAllBtn) forControlEvents:UIControlEventTouchUpInside];
    deleteBtn.centerX = kScreenWidth * 0.75;
    [self.view addSubview:deleteBtn];
    
    _resultLbe = [[UILabel alloc] initWithFrame:CGRectMake(20, deleteBtn.bottom + 20, kScreenWidth - 40, 20)];
    _resultLbe.textColor = [UIColor blackColor];
    _resultLbe.layer.borderWidth = 1;
    _resultLbe.layer.borderColor = [[UIColor grayColor] CGColor];
    [self.view addSubview:_resultLbe];
    
    self.tableView.y = _resultLbe.bottom + 20;
    [self.view addSubview:self.tableView];
}

#pragma mark - action

- (void)tapInsertBtn {
    Student *student = [self insert];
    if (student != nil) {
        [self.dataSources addObject:student];
        [self.tableView reloadData];
    }
}

// 获取数据的请求对象，指明对实体进行查询操作
- (void)tapSearchBtn {
    NSArray *students = [self search];
    if (students.count == 0) {
        return;
    }
    
    // 遍历
    [self.dataSources removeAllObjects];
    [students enumerateObjectsUsingBlock:^(Student * obj, NSUInteger idx, BOOL *stop) {
        [self.dataSources addObject:obj];
    }];
    
    [self.tableView reloadData];
}

- (void)tapModifyBtn {
    [self modify:self.dataSources];
}

- (void)tapDeleteAllBtn {
    [self delete:self.dataSources];
}

#pragma mark - 数据库操作

- (Student *)insert {
    Student * student = [[Student alloc] init];
    //2.根据表Student中的键值，给NSManagedObject对象赋值
    student.name = [NSString stringWithFormat:@"Mr-%d",arc4random() % 100];
    student.age = arc4random() % 20;
    student.sex = arc4random() % 2 == 0 ?  @"男" : @"女" ;
    student.height = arc4random() % 180;
    student.number = arc4random() % 100;
    student.startTime = [NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]];
    
    BOOL result = [[CSStorageManager sharedManager] saveStudentModel:student];
    if (result) {
        self.resultLbe.text = @"插入数据成功";
        return student;
    } else {
        return nil;
    }
}

- (NSArray *)search {
    NSArray *students = [[CSStorageManager sharedManager] getAllStudentModels];
    if (students.count > 0) {
        self.resultLbe.text = @"查找数据成功";
    }
    return students;
}

- (void)delete:(NSArray *)delStudents {
    BOOL result = [[CSStorageManager sharedManager] removeStudentModels:delStudents];
    
    if (!result) {
        self.resultLbe.text = @"删除数据失败";
        return;
    }
    self.resultLbe.text = @"删除数据成功";
    
    NSArray *newDelStudents = delStudents.copy;
    // 将已经在数据库中被删除的对象从内存中移除
    [newDelStudents enumerateObjectsUsingBlock:^(Student *obj, NSUInteger idx, BOOL *stop) {
        [self.dataSources removeObject:obj];
    }];
    [self.tableView reloadData];
}

- (void)modify:(NSArray *)modifyStudents {
    // 1.先执行删除操作
    __block BOOL result = [[CSStorageManager sharedManager] removeStudentModels:modifyStudents];
    if (!result) {
        self.resultLbe.text = @"修改数据失败";
        return;
    }
    
    // 2.执行更新操作
    [modifyStudents enumerateObjectsUsingBlock:^(Student *obj, NSUInteger idx, BOOL *stop) {
        obj.age += 1;
        obj.sex = [obj.sex isEqualToString:@"男"] ? @"女" : @"男";
    }];
    
    // 3.再重新插入
    [modifyStudents enumerateObjectsUsingBlock:^(Student *obj, NSUInteger idx, BOOL *stop) {
        result = [[CSStorageManager sharedManager] saveStudentModel:obj];
        if (!result) {
            *stop = YES;
        }
    }];
    if (!result) {
        self.resultLbe.text = @"修改数据失败";
        return;
    }
    
    NSArray *news = [self search];
    [self.dataSources removeAllObjects];
    [self.dataSources addObjectsFromArray:news];
    [self.tableView reloadData];
    
    self.resultLbe.text = @"修改数据成功";
}

- (void)testAction {
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [docPath stringByAppendingPathComponent:@"student.sqlite"];
    NSLog(@"path = %@",path);
    
    // 1..创建数据库对象
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    // 2.打开数据库
    if ([db open]) {
        // 建表操作
//        NSString *createTableSqlString = @"CREATE TABLE IF NOT EXISTS t_student (id integer PRIMARY KEY AUTOINCREMENT, name text NOT NULL, age integer NOT NULL)";
//        [db executeUpdate:createTableSqlString];
        
        // 写入数据 - 不确定的参数用？来占位
//        NSString *sql = @"insert into t_student (name, age) values (?, ?)";
//        NSString *name = [NSString stringWithFormat:@"韩雪 - %d",arc4random()];
//        NSNumber *age = [NSNumber numberWithInt:arc4random_uniform(100)];
//        [db executeUpdate:sql, name, age];
        
        // 删除数据
//        NSString *sql = @"delete from t_student where id = ?";
//        [db executeUpdate:sql, [NSNumber numberWithInt:1]];
        
        // 更改数据
//        NSString *sql = @"update t_student set name = '齐天大圣'  where id = ?";
//        [db executeUpdate:sql, [NSNumber numberWithInt:2]];
        
        // 使用executeUpdateWithFormat: - 不确定的参数用%@，%d等来占位
//        NSString *sql = @"insert into t_student (name,age) values (%@,%i)";
//        NSString *name = [NSString stringWithFormat:@"孙悟空 - %d",arc4random()];
//        [db executeUpdateWithFormat:sql, name, arc4random_uniform(100)];
        
        // 使用 executeUpdate:withParameterDictionary:
        NSString *name = [NSString stringWithFormat:@"玉皇大帝 - %d",arc4random()];
        NSNumber *age = [NSNumber numberWithInt:arc4random_uniform(100)];
        NSDictionary *studentDict = [NSDictionary dictionaryWithObjectsAndKeys:name, @"name", age, @"age", nil];
        [db executeUpdate:@"insert into t_student (name, age) values (:name, :age)" withParameterDictionary:studentDict];
        
    } else {
        NSLog(@"fail to open database");
    }
}

- (void)executeMuchSql {
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [docPath stringByAppendingPathComponent:@"student.sqlite"];
    NSLog(@"path = %@",path);
    
    // 1..创建数据库对象
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    // 2.打开数据库
    if ([db open]) {
        NSString *sql = @"CREATE TABLE IF NOT EXISTS bulktest1 (id integer PRIMARY KEY AUTOINCREMENT, x text);"
        "CREATE TABLE IF NOT EXISTS bulktest2 (id integer PRIMARY KEY AUTOINCREMENT, y text);"
        "CREATE table IF NOT EXISTS bulktest3 (id integer primary key autoincrement, z text);"
        "insert into bulktest1 (x) values ('XXX');"
        "insert into bulktest2 (y) values ('YYY');"
        "insert into bulktest3 (z) values ('ZZZ');";
        
        BOOL result = [db executeStatements:sql];
        
        sql = @"select count(*) as count from bulktest1;"
        "select count(*) as count from bulktest2;"
        "select count(*) as count from bulktest3;";
        
        result = [db executeStatements:sql withResultBlock:^int(NSDictionary *resultsDictionary) {
            NSLog(@"dictionary=%@", resultsDictionary);
            return 0;
        }];
    } else {
        NSLog(@"fail to open database");
    }
}

#pragma mark - UITableViewDataSource

//每组显示几个
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSources.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Student *student = [self.dataSources objectAtIndex:indexPath.row];
    StudentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    cell.student = student;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - 左滑删除

//tableView自带的左滑删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// 定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

// 进入编辑模式，按下出现的编辑按钮后,进行删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Student *student = [self.dataSources objectAtIndex:indexPath.row];
        [self delete:@[student]];
    }
}
// 修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

#pragma mark - lazy


#pragma mark - lazy

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 150)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
        [_tableView registerClass:[StudentCell class] forCellReuseIdentifier:cellId];
        _tableView.rowHeight = 70;
    }
    return _tableView;
}

- (NSMutableArray *)dataSources {
    if (_dataSources == nil) {
        _dataSources = [NSMutableArray array];
    }
    return _dataSources;
}


@end

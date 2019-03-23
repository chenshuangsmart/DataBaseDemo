//
//  ViewController.m
//  CoreDataDemo
//
//  Created by cs on 2019/3/21.
//  Copyright © 2019 cs. All rights reserved.
//

#import "ViewController.h"
#import "Student+CoreDataClass.h"
#import "Student+CoreDataProperties.h"
#import <CoreData/CoreData.h>
#import "StudentCell.h"
#import "UIView+CSLFrame.h"

static NSString *cellId = @"studentCellId";

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (readonly, strong) NSPersistentContainer *persistentContainer;
/** NSManagedObjectContext */
@property(nonatomic, strong)NSManagedObjectContext *context;
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
    // setupData
    [self tapSearchBtn];
    NSLog(@"path=%@",NSHomeDirectory());
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
    Student *student = [self insert1];
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
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    
    Student * student = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:context];
    //2.根据表Student中的键值，给NSManagedObject对象赋值
    student.name = [NSString stringWithFormat:@"Mr-%d",arc4random() % 100];
    student.age = arc4random() % 20;
    student.sex = arc4random() % 2 == 0 ?  @"男" : @"女" ;
    student.height = arc4random() % 180;
    student.number = arc4random() % 100;
    
    if ([context hasChanges] && ![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        _resultLbe.text = [NSString stringWithFormat:@"CoreData Error:%@",error.userInfo];
        abort();
        return nil;
    } else {
        _resultLbe.text = @"插入数据成功";
    }
    
    return student;
}

- (Student *)insert1 {
    NSError *error = nil;
    
   // 开始创建托管对象，并指明好创建的托管对象所属实体名
    Student * student = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:self.context];
    
    //2.根据表Student中的键值，给NSManagedObject对象赋值
    student.name = [NSString stringWithFormat:@"Mr-%d",arc4random() % 100];
    student.age = arc4random() % 20;
    student.sex = arc4random() % 2 == 0 ?  @"男" : @"女" ;
    student.height = arc4random() % 180;
    student.number = arc4random() % 100;
    
    if ([self.context hasChanges] && ![self.context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        _resultLbe.text = [NSString stringWithFormat:@"CoreData Error:%@",error.userInfo];
        abort();
        return nil;
    } else {
        _resultLbe.text = @"插入数据成功";
    }
    
    return student;
}

- (NSArray *)search {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Student"];
    
    // 执行获取操作，获取所有Student托管对象
    NSError *error = nil;
    NSArray<Student *> *students = [self.context executeFetchRequest:request error:&error];
    
    if (error) {
        _resultLbe.text = [NSString stringWithFormat:@"CoreData Error:%@",error.description];
    } else {
        _resultLbe.text = @"查找数据成功";
    }
    
    return students;
}

- (void)delete:(NSArray *)delStudents {
    // 获取数据的请求对象，指明对实体进行删除操作
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Student"];
    
    NSMutableArray *delStudentSucces = [NSMutableArray array];  // 保存在数据库中成功被删除的对象
    [delStudents enumerateObjectsUsingBlock:^(Student *obj, NSUInteger idx, BOOL *stop) {
        // 通过创建谓词对象，然后过滤掉符合要求的对象，也就是要删除的对象
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"number = %d",obj.number];
        request.predicate = predicate;
        
        // 通过执行获取操作，找到要删除的对象即可
        NSError *error = nil;
        NSArray<Student *> *students = [self.context executeFetchRequest:request error:&error];
        
        // 开始真正操作，一一遍历，遍历符合删除要求的对象数组，执行删除操作
        [students enumerateObjectsUsingBlock:^(Student *obj, NSUInteger idx, BOOL *stop) {
            [self.context deleteObject:obj];
        }];
        
        // 错误处理
        if (error) {
            self.resultLbe.text = [NSString stringWithFormat:@"CoreData Error:%@",error.description];
        } else {
            [delStudentSucces addObject:obj];
        }
    }];
    
    // 最后保存数据，保存上下文。
    if (self.context.hasChanges) {
        [self.context save:nil];
    }
    
    if (delStudentSucces.count > 0) {
        self.resultLbe.text = @"删除数据成功";
    }
    
    // 将已经在数据库中被删除的对象从内存中移除
    [delStudentSucces enumerateObjectsUsingBlock:^(Student *obj, NSUInteger idx, BOOL *stop) {
        [self.dataSources removeObject:obj];
    }];
    [self.tableView reloadData];
}

- (void)modify:(NSArray *)modifyStudents {
    // 获取数据的请求对象，指明对实体进行删除操作
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Student"];
    
    NSMutableArray *modifyStudentSucces = [NSMutableArray array];
    [modifyStudents enumerateObjectsUsingBlock:^(Student *obj, NSUInteger idx, BOOL *stop) {
        // 通过创建谓词对象，然后过滤掉符合要求的对象，也就是要删除的对象
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"number = %d",obj.number];
        request.predicate = predicate;
        
        // 通过执行获取操作，找到要删除的对象即可
        NSError *error = nil;
        NSArray<Student *> *students = [self.context executeFetchRequest:request error:&error];
        
        // 开始真正操作，一一遍历，遍历符合删除要求的对象数组，执行删除操作
        [students enumerateObjectsUsingBlock:^(Student *obj, NSUInteger idx, BOOL *stop) {
            obj.age += 1;
            obj.sex = [obj.sex isEqualToString:@"男"] ? @"女" : @"男";
        }];
        
        // 错误处理
        if (error) {
            self.resultLbe.text = [NSString stringWithFormat:@"CoreData Error:%@",error.description];
        } else {
            [modifyStudentSucces addObject:obj];
        }
    }];
    
    // 最后保存数据，保存上下文。
    if (self.context.hasChanges) {
        [self.context save:nil];
    }
    
    if (modifyStudentSucces.count > 0) {
        self.resultLbe.text = @"修改数据成功";
    }
    
    NSArray *news = [self search];
    [self.dataSources removeAllObjects];
    [self.dataSources addObjectsFromArray:news];
    [self.tableView reloadData];
    
    self.resultLbe.text = @"修改数据成功";
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

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"CoreDataDemo"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

- (NSManagedObjectContext *)context {
    if (_context == nil) {
        // 创建上下文对象，并发队列设置为主队列
        _context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        
        // 创建托管对象模型，并使用Student.momd路径当做初始化参数
        // .xcdatamodeld文件 编译之后变成.momd文件  （.mom文件）
        NSURL *modelPath = [[NSBundle mainBundle] URLForResource:@"CoreDataDemo" withExtension:@"momd"];
        NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelPath];
        
        // 创建持久化存储调度器
        NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        
        // 创建并关联SQLite数据库文件，如果已经存在则不会重复创建
        NSString *dataPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
        dataPath = [dataPath stringByAppendingFormat:@"/%@.sqlite",@"Student"];
        
        [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:dataPath] options:nil error:nil];
        
        // 上下文对象设置属性为持久化存储器
        _context.persistentStoreCoordinator = coordinator;
    }
    return _context;
}

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

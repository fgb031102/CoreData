//
//  NSCollegeManager.m
//  CollegeManagementSystem
//
//  Created by guogangj on 14-4-7.
//  Copyright (c) 2014年 guogangj. All rights reserved.
//


#import "CollegeManager.h"
#import "AppDelegate.h"
#import "MyClass.h"
#import "Student.h"
#import "Teacher.h"
#import "Course.h"

static CollegeManager* _sharedManager = nil;

@implementation CollegeManager{
    AppDelegate* appDelegate;
    NSManagedObjectContext* appContext;
}

+ (CollegeManager*)sharedManager
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

- (id)init
{
    self = [super init];
    appDelegate = [[UIApplication sharedApplication] delegate];
    appContext = [appDelegate managedObjectContext];
    return self;
}

- (void)save
{
    [appDelegate saveContext];
}

- (void)deleteEntity:(NSManagedObject*)obj
{
    [appContext deleteObject:obj];
    [self save];
}

-(void)initData
{
    //插入一些班级实体
    //这个Mutable Array是为了方便后面建立实体关系使用（后面的也是）
    NSMutableArray* arrMyClasses = [[NSMutableArray alloc] init];
    NSArray* arrMyClassesName = @[@"99级1班",@"99级2班",@"99级3班"];
    for (NSString* className in arrMyClassesName) {
        MyClass* newMyClass = [NSEntityDescription insertNewObjectForEntityForName:@"MyClass" inManagedObjectContext:appContext];
        newMyClass.name = className;
        [arrMyClasses addObject:newMyClass];
    }
    
    //插入一些学生实体
    NSMutableArray *arrStudents = [[NSMutableArray alloc] init];
    NSArray *studentInfo = @[
                             @{@"name":@"李斌", @"age":@20},
                             @{@"name":@"李鹏", @"age":@19},
                             @{@"name":@"朱文", @"age":@21},
                             @{@"name":@"李强", @"age":@21},
                             @{@"name":@"高崇", @"age":@18},
                             @{@"name":@"薛大", @"age":@19},
                             @{@"name":@"裘千仞", @"age":@21},
                             @{@"name":@"王波", @"age":@18},
                             @{@"name":@"王鹏", @"age":@19},
                             ];
    for (id info in studentInfo) {
        NSString* name = [info objectForKey:@"name"];
        NSNumber* age = [info objectForKey:@"age"];
        Student* newStudent = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:appContext];
        newStudent.name = name;
        newStudent.age = age;
        [arrStudents addObject:newStudent];
    }
    
    //插入一些教师实体
    NSMutableArray* arrTeachers = [[NSMutableArray alloc] init];
    NSArray* arrTeachersName = @[@"王刚",@"谢力",@"徐开义",@"许宏权"];
    for (NSString* teacherName in arrTeachersName) {
        Teacher* newTeacher = [NSEntityDescription insertNewObjectForEntityForName:@"Teacher" inManagedObjectContext:appContext];
        newTeacher.name = teacherName;
        [arrTeachers addObject:newTeacher];
    }
    
    //插入一些课程实体
    NSMutableArray* arrCourses = [[NSMutableArray alloc] init];
    NSArray* arrCoursesName = @[@"CAD",@"软件工程",@"线性代数",@"微积分",@"大学物理"];
    for (NSString* courseName in arrCoursesName) {
        Course* newCourse = [NSEntityDescription insertNewObjectForEntityForName:@"Course" inManagedObjectContext:appContext];
        newCourse.name = courseName;
        [arrCourses addObject:newCourse];
    }
    
    //创建学生和班级的关系
    //往班级1中加入几个学生（方法有多种）
    MyClass* classOne = [arrMyClasses objectAtIndex:0];
    [classOne addStudentsObject:[arrStudents objectAtIndex:0]];
    [classOne addStudentsObject:[arrStudents objectAtIndex:1]];
    [[arrStudents objectAtIndex:2] setMyclass:classOne]; //或者这样也可以
    //往班级2中加入几个学生（用不同方法）
    MyClass* classTwo = [arrMyClasses objectAtIndex:1];
    [classTwo addStudents:[NSSet setWithArray:[arrStudents subarrayWithRange:NSMakeRange(3, 3)]]];
    //往班级3中加入几个学生（再用不同的方法）
    MyClass* classThree = [arrMyClasses objectAtIndex:2];
    [classThree setStudents:[NSSet setWithArray:[arrStudents subarrayWithRange:NSMakeRange(6, 3)]]];
    
    //给三个班指派班主任
    Teacher* wanggang = [arrTeachers objectAtIndex:0];
    Teacher* xieli = [arrTeachers objectAtIndex:1];
    Teacher* xukaiyi = [arrTeachers objectAtIndex:2];
    Teacher* xuhongquan = [arrTeachers objectAtIndex:3];
    
    [classOne setTeacher:wanggang];
    classTwo.teacher = xieli; //或这样（可能不太好）
    [xukaiyi setMyclass: classThree]; //或这样反过来也行
    
    //创建教师和课程的对应关系
    Course* cad = [arrCourses objectAtIndex:0];
    Course* software = [arrCourses objectAtIndex:1];
    Course* linear = [arrCourses objectAtIndex:2];
    Course* calculus = [arrCourses objectAtIndex:3];
    Course* physics = [arrCourses objectAtIndex:4];
    [wanggang setCourses:[NSSet setWithObjects:cad, software, nil]];
    [linear setTeacher:xieli];
    [calculus setTeacher:xuhongquan];
    [physics setTeacher:xukaiyi];
    
    //设置学生所选修的课程
    [[arrStudents objectAtIndex:0] setCourses:[NSSet setWithObjects:cad, software, nil]];
    [[arrStudents objectAtIndex:1] setCourses:[NSSet setWithObjects:cad, linear, nil]];
    [[arrStudents objectAtIndex:2] setCourses:[NSSet setWithObjects:linear, physics, nil]];
    [[arrStudents objectAtIndex:3] setCourses:[NSSet setWithObjects:physics, cad, nil]];
    [[arrStudents objectAtIndex:4] setCourses:[NSSet setWithObjects:calculus, physics, nil]];
    [[arrStudents objectAtIndex:5] setCourses:[NSSet setWithObjects:software, linear, nil]];
    [[arrStudents objectAtIndex:6] setCourses:[NSSet setWithObjects:software, physics, nil]];
    [[arrStudents objectAtIndex:7] setCourses:[NSSet setWithObjects:linear, software, nil]];
    [[arrStudents objectAtIndex:8] setCourses:[NSSet setWithObjects:calculus, software, cad, nil]];

    //保存
    //如不保存，上面的所有动作都不会写入sqlite
    NSError* error;
    [appContext save:&error];
    if (error!=nil) {
        NSLog(@"%@",error);
    }
}

-(void)fetchTest
{
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Student" inManagedObjectContext:appContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    //排序
    //NSSortDescriptor* sorting = [NSSortDescriptor sortDescriptorWithKey:@"age" ascending:YES];
    //[request setSortDescriptors:[NSArray arrayWithObject:sorting]];
    
    //过滤1
    //NSPredicate *filter = [NSPredicate predicateWithFormat:@"name BEGINSWITH '李'"];
    //[request setPredicate:filter];
    
    //过滤2
    //NSPredicate *filter = [NSPredicate predicateWithFormat:@"SUBQUERY(courses, $course, $course.name == '大学物理').@count > 0"];
    //[request setPredicate:filter];
    
    //分页
    [request setFetchOffset:3];
    [request setFetchLimit:3];
    
    NSError *error = nil;
    NSArray *arrStudents = [appContext executeFetchRequest:request error:&error];
    if (error!=nil) {
        NSLog(@"%@",error);
    }
    else{
        for (Student* stu in arrStudents) {
            NSLog(@"%@ (%@岁)",stu.name,stu.age);
        }
    }
}

-(void)fetchMyClasses
{
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"MyClass" inManagedObjectContext:appContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    //预查询
    //[request setRelationshipKeyPathsForPrefetching:[NSArray arrayWithObjects:@"students",nil]];
    
    NSError *error = nil;
    NSArray *arrClasses = [appContext executeFetchRequest:request error:&error];
    if (error!=nil) {
        NSLog(@"%@",error);
    }
    else{
        for (MyClass* myclass in arrClasses) {
            NSLog(@"%@",myclass.name);
            for (Student* student in myclass.students) {
                NSLog(@"    %@", student.name);
            }
        }
    }
}

-(void)updateTest
{
    //将“CAD”这门课的名称改为“CAD设计”，并将其授课教师改为“许宏权”
    
    //查出Teacher
    //NSEntityDescription* entityDescription = [NSEntityDescription entityForName:@"Teacher" inManagedObjectContext:appContext];
    //[request setEntity:entityDescription];
    //前面这两步可以换成下面的一步
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Teacher"];
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"name = '许宏权'"];
    [request setPredicate:filter];
    NSError *error = nil;
    NSArray *arrResult = [appContext executeFetchRequest:request error:&error];
    Teacher* xuhongquan = [arrResult objectAtIndex:0];
    
    //查出Course
    request = [NSFetchRequest fetchRequestWithEntityName:@"Course"];
    filter = [NSPredicate predicateWithFormat:@"name =[cd] 'cad'"]; //这里的[cd]表示大小写和音标不敏感
    [request setPredicate:filter];
    arrResult = [appContext executeFetchRequest:request error:&error];
    Course* cad = [arrResult objectAtIndex:0];
    
    //修改
    [cad setName:@"CAD设计"];
    [cad setTeacher:xuhongquan];
    
    //保存
    [self save];
}

-(void)deleteTest
{
    //删除学生“王波”
    //查询出“王波”
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Student"];
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"name = '王波'"];
    [request setPredicate:filter];
    NSError *error = nil;
    NSArray *arrResult = [appContext executeFetchRequest:request error:&error];
    Student* wangbo = [arrResult objectAtIndex:0];
    //执行删除
    [self deleteEntity:wangbo];
    //保存
    [self save];
    
    //删除“99届2班”
    request = [NSFetchRequest fetchRequestWithEntityName:@"MyClass"];
    filter = [NSPredicate predicateWithFormat:@"name = '99级2班'"];
    [request setPredicate:filter];
    arrResult = [appContext executeFetchRequest:request error:&error];
    MyClass* myClassTwo = [arrResult objectAtIndex:0];
    //执行删除
    //注意！由于设置了删除规则为Cascade，所以“99届2班”的所有学生也会被同时删除掉
    [self deleteEntity:myClassTwo];
    //保存（其实也可以一起保存）
    [self save];
    
    //删除教师“徐开义”
    request = [NSFetchRequest fetchRequestWithEntityName:@"Teacher"];
    filter = [NSPredicate predicateWithFormat:@"name='徐开义'"];
    [request setPredicate:filter];
    arrResult = [appContext executeFetchRequest:request error:&error];
    Teacher* teacher = [arrResult objectAtIndex:0];
    //执行删除
    //注意！由于设置了删除规则为Cascade，所以“徐开义”的课程也会被删掉
    [self deleteEntity:teacher];
    //保存
    [self save];
}

-(void)countTest
{
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"Course"];
    [request setResultType:NSCountResultType];
    NSError* error;
    id result = [appContext executeFetchRequest:request error:&error];
    NSLog(@"%@", [result objectAtIndex:0]);
}

-(void)maxTest
{
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"Student"];
    [request setResultType:NSDictionaryResultType]; //必须设置为这个类型
    
    //构造用于sum的ExpressionDescription（稍微有点繁琐啊）
    NSExpression *theMaxExpression = [NSExpression expressionForFunction:@"max:" arguments:[NSArray arrayWithObject:[NSExpression expressionForKeyPath:@"age"]]];
    NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];
    [expressionDescription setName:@"maxAge"];
    [expressionDescription setExpression:theMaxExpression];
    [expressionDescription setExpressionResultType:NSInteger32AttributeType];
    
    //加入Request
    [request setPropertiesToFetch:[NSArray arrayWithObjects:expressionDescription,nil]];

    NSError* error;
    id result = [appContext executeFetchRequest:request error:&error];
    //返回的对象是一个字典的数组，取数组第一个元素，再用我们前面指定的key（也就是"maxAge"）去获取我们想要的值
    NSLog(@"The max age is : %@", [[result objectAtIndex:0] objectForKey:@"maxAge"]);
}


-(void)studentNumGroupByAge
{
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"Student"];
    [request setResultType:NSDictionaryResultType]; //必须是这个
    
    NSExpression *theCountExpression = [NSExpression expressionForFunction:@"count:" arguments:[NSArray arrayWithObject:[NSExpression expressionForKeyPath:@"name"]]];
    NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];
    [expressionDescription setName:@"num"];
    [expressionDescription setExpression:theCountExpression];
    [expressionDescription setExpressionResultType:NSInteger32AttributeType];
    
    
    //构造并加入Group By
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Student" inManagedObjectContext:appContext];
    NSAttributeDescription* adultNumGroupBy = [entity.attributesByName objectForKey:@"age"];
    [request setPropertiesToGroupBy:[NSArray arrayWithObject: adultNumGroupBy]];
    
    
    [request setPropertiesToFetch:[NSArray arrayWithObjects:@"age",expressionDescription,nil]];
    
    NSError* error;
    id result = [appContext executeFetchRequest:request error:&error];
    for (id item in result) {
        NSLog(@"Age:%@ Student Num:%@", [item objectForKey:@"age"], [item objectForKey:@"num"]);
    }
}

-(void)studentId{
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"Student"];
    NSError* error;
    id result = [appContext executeFetchRequest:request error:&error];
    for (id stu in result) {
        NSLog(@"%@", [stu objectID]); //objectID 返回的类型是 NSManagedObjectID
    }
    
    //用ID获取MO的方法
    NSManagedObjectID* firstStudentId = [[result objectAtIndex:0] objectID];
    NSLog(@"%@",[firstStudentId URIRepresentation]);
    Student* firstStudent = (Student*)[appContext existingObjectWithID:firstStudentId error:&error];
    NSLog(@"First student name : %@", firstStudent.name);
    
    //将NSManagedObjectID转为NSURL
    NSURL* urlFirstStudent = [firstStudentId URIRepresentation];
    //将NSURL转为NSManagedObjectID
    NSPersistentStoreCoordinator* coordinator = [appDelegate persistentStoreCoordinator];
    NSManagedObjectID* firstStudentIdConvertBack = [coordinator managedObjectIDForURIRepresentation:urlFirstStudent];
    NSLog(@"%@",firstStudentIdConvertBack);
}

-(NSFetchedResultsController*) allCourses
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    //Entity
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Course" inManagedObjectContext:appContext];
    [request setEntity:entityDescription];
    
    //Sort
    //NSFetchedResultController必须有Sort
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    [request setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    NSFetchedResultsController* controller = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:appContext sectionNameKeyPath:nil cacheName:nil];
    
    //Must perform fetch once.
    NSError *error = nil;
    [controller performFetch:&error];
    
    return controller;
}

-(void)addCourseWithName:(NSString*)name
{
    Course *course = [NSEntityDescription insertNewObjectForEntityForName:@"Course" inManagedObjectContext:appContext];
    course.name = name;
    [self save];
}
@end

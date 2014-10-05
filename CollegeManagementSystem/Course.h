//
//  Course.h
//  CollegeManagementSystem
//
//  Created by guogangj on 14-4-7.
//  Copyright (c) 2014年 guogangj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Student, Teacher;

@interface Course : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *students;
@property (nonatomic, retain) Teacher *teacher;
@end

@interface Course (CoreDataGeneratedAccessors)

- (void)addStudentsObject:(Student *)value;
- (void)removeStudentsObject:(Student *)value;
- (void)addStudents:(NSSet *)values;
- (void)removeStudents:(NSSet *)values;

@end

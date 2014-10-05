//
//  Student.h
//  CollegeManagementSystem
//
//  Created by guogangj on 14-4-7.
//  Copyright (c) 2014年 guogangj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Course, MyClass;

@interface Student : NSManagedObject

@property (nonatomic, retain) NSNumber * age;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *courses;
@property (nonatomic, retain) MyClass *myclass;
@end

@interface Student (CoreDataGeneratedAccessors)

- (void)addCoursesObject:(Course *)value;
- (void)removeCoursesObject:(Course *)value;
- (void)addCourses:(NSSet *)values;
- (void)removeCourses:(NSSet *)values;

@end

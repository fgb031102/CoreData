//
//  NSCollegeManager.h
//  CollegeManagementSystem
//
//  Created by guogangj on 14-4-7.
//  Copyright (c) 2014年 guogangj. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface CollegeManager : NSObject

+ (CollegeManager*)sharedManager;

- (void)save;
- (void)deleteEntity:(NSManagedObject*)obj;

-(void)initData;
-(void)fetchTest;
-(void)fetchMyClasses;
-(void)updateTest;
-(void)deleteTest;
-(void)countTest;
-(void)maxTest;
-(void)studentNumGroupByAge;
-(void)studentId;

-(NSFetchedResultsController*) allCourses;
-(void)addCourseWithName:(NSString*)name;

@end

//
//  CourseDetailViewController.h
//  CollegeManagementSystem
//
//  Created by guogangj on 14-4-7.
//  Copyright (c) 2014年 guogangj. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "Course.h"

enum{
    NewOrEditModeNew,
    NewOrEditModeEdit
};

@interface CourseDetailViewController : UIViewController
@property (nonatomic,assign) uint32_t controllerMode;
@property (nonatomic,strong) Course* moCourse;
@end

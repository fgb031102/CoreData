//
//  CourseDetailViewController.m
//  CollegeManagementSystem
//
//  Created by guogangj on 14-4-7.
//  Copyright (c) 2014年 guogangj. All rights reserved.
//


#import "CourseDetailViewController.h"
#import "CollegeManager.h"

@interface CourseDetailViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textfieldName;

@end

@implementation CourseDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.controllerMode==NewOrEditModeNew) {
        self.title = @"新建课程";
    }
    else{
        self.title = @"编辑课程";
        self.textfieldName.text = self.moCourse.name;
    }
    [self.textfieldName addTarget:self action:@selector(onTextFileNameChanged:) forControlEvents:UIControlEventEditingChanged];
    [self checkTextFieldAndMakeDoneButtonState];}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (void)onTextFileNameChanged:(id)sender {
    [self checkTextFieldAndMakeDoneButtonState];
}
-(void)checkTextFieldAndMakeDoneButtonState{
    if ([self.textfieldName.text length]==0) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    else {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
}
- (IBAction)onSave:(id)sender {
    CollegeManager* mgr = [CollegeManager sharedManager];
    if (self.controllerMode==NewOrEditModeNew) {
        [mgr addCourseWithName:self.textfieldName.text];
    }
    else{
        self.moCourse.name = self.textfieldName.text;
        [mgr save];
    }
    [self.navigationController popViewControllerAnimated:YES];
}


@end

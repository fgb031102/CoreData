//
//  MainViewController.m
//  CollegeManagementSystem
//
//  Created by guogangj on 14-4-7.
//  Copyright (c) 2014年 guogangj. All rights reserved.
//


#import "MainViewController.h"
#import "CollegeManager.h"

@interface MainViewController ()

@end

@implementation MainViewController

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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)onInitData:(id)sender {
    [[CollegeManager sharedManager] initData];
}
- (IBAction)onFetchAllStudents:(id)sender {
    [[CollegeManager sharedManager] fetchTest];
}
- (IBAction)onFetchClasses:(id)sender {
    [[CollegeManager sharedManager] fetchMyClasses];
}
- (IBAction)onUpdateTest:(id)sender {
    [[CollegeManager sharedManager] updateTest];
}
- (IBAction)onDeleteTest:(id)sender {
    [[CollegeManager sharedManager] deleteTest];
}
- (IBAction)onCountTest:(id)sender {
    [[CollegeManager sharedManager] countTest];
}
- (IBAction)onMaxTest:(id)sender {
    [[CollegeManager sharedManager] maxTest];
}
- (IBAction)onCountCourseTest:(id)sender {
    [[CollegeManager sharedManager] studentNumGroupByAge];
}
- (IBAction)onGetId:(id)sender {
    [[CollegeManager sharedManager] studentId];
}

@end

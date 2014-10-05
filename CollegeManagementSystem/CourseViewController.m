//
//  CourseViewController.m
//  CollegeManagementSystem
//
//  Created by guogangj on 14-4-7.
//  Copyright (c) 2014年 guogangj. All rights reserved.
//


#import "CourseViewController.h"
#import "CollegeManager.h"
#import "Course.h"
#import "CourseDetailViewController.h"

@interface CourseViewController ()
@property(nonatomic,strong) NSFetchedResultsController* fetchResultController;
@end

@implementation CourseViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.clearsSelectionOnViewWillAppear = YES;
    
    //Eidt button at the left navigation bar.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    //Set the FetchedResultController
    NSFetchedResultsController* resultController = [[CollegeManager sharedManager] allCourses];
    resultController.delegate = self;
    self.fetchResultController = resultController;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark TableView source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"number of sections %d", [[self.fetchResultController sections] count]);
    return [[self.fetchResultController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchResultController sections] objectAtIndex:section];
    NSLog(@"number of rows %d", [sectionInfo numberOfObjects]);
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    Course *course = [self.fetchResultController objectAtIndexPath:indexPath];
    cell.textLabel.text = course.name;
    return cell;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    // Prevent new objects being added when in editing mode.
    [super setEditing:(BOOL)editing animated:(BOOL)animated];
    self.navigationItem.rightBarButtonItem.enabled = !editing;
}

#pragma mark TableView eidt support
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObject* obj = [self.fetchResultController objectAtIndexPath:indexPath];
        CollegeManager* mgr = [CollegeManager sharedManager];
        [mgr deleteEntity:obj];
    }
}

#pragma mark NSFetchedResultsControllerDelegate
-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    NSLog(@"controllerWillChangeContent");
    [self.tableView beginUpdates];
}

-(void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    NSLog(@"didChangeSection");
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
    
}

-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    NSLog(@"didChangeObject");
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate:
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    NSLog(@"controllerDidChangeContent");
    [self.tableView endUpdates];
}

#pragma mark For Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    CourseDetailViewController* destController = [segue destinationViewController];
    
    if ([[segue identifier] isEqualToString:@"Add"]) {
        destController.controllerMode = NewOrEditModeNew;
    }
    if ([[segue identifier] isEqualToString:@"Edit"]) {
        destController.controllerMode = NewOrEditModeEdit;
        destController.moCourse = [self.fetchResultController objectAtIndexPath:[self.tableView indexPathForSelectedRow]];
    }
}

@end

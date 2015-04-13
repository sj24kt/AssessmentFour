//
//  ViewController.m
//  Assessment4
//
//  Created by Vik Denic on 8/11/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

#import "ViewController.h"
#import "DogsViewController.h"
#import "AppDelegate.h"
#import "Person.h"
#import "APIData.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property UIAlertView *addAlert;
@property UIAlertView *colorAlert;
@property NSManagedObjectContext *moc;
@property NSArray *ownersArray;
@property APIData *apiData;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    self.moc = delegate.managedObjectContext;

    self.apiData = [[APIData alloc] initWithObjectContext:self.moc];
    self.title = @"Dog Owners";

    NSData *barColorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultColor"];
    if (barColorData) {
        self.navigationController.navigationBar.tintColor = [NSKeyedUnarchiver unarchiveObjectWithData:barColorData];
    }
    [self loadOwners];
}

#pragma mark - Helper Methods

- (void)loadOwners {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Person class])];

    NSArray *results = [self.moc executeFetchRequest:request error:nil];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    self.ownersArray = [results sortedArrayUsingDescriptors:@[sortDescriptor]];

    //If no owners in CoreData, get data from json.
    if (self.ownersArray.count == 0) {
        self.ownersArray = [self.apiData getDogArrayFromAPIData];
    }
    [self.myTableView reloadData];
}

#pragma mark - UITableView Delegate Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //TODO: UPDATE THIS ACCORDINGLY
    return self.ownersArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"myCell"];
    //TODO: UPDATE THIS ACCORDINGLY
    Person *person = [self.ownersArray objectAtIndex:indexPath.row];
    cell.textLabel.text = person.name;
    cell.textLabel.textColor = self.navigationController.navigationBar.tintColor;
    return cell;
}

#pragma mark - UIAlertView Methods

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    //TODO: SAVE USER'S DEFAULT COLOR PREFERENCE USING THE CONDITIONAL BELOW

    UIColor *newColor;
    if (buttonIndex == 0) {
        newColor = [UIColor purpleColor];
    } else if (buttonIndex == 1) {
        newColor = [UIColor blueColor];
    } else if (buttonIndex == 2) {
        newColor = [UIColor orangeColor];
    } else if (buttonIndex == 3)  {
       newColor = [UIColor greenColor];
    }

    self.navigationController.navigationBar.tintColor = newColor;

    NSData *barColorData = [NSKeyedArchiver archivedDataWithRootObject:newColor];
    [[NSUserDefaults standardUserDefaults] setObject:barColorData forKey:@"defaultColor"];

    [self.myTableView reloadData];
}

//METHOD FOR PRESENTING USER'S COLOR PREFERENCE
- (IBAction)onColorButtonTapped:(UIBarButtonItem *)sender {
    self.colorAlert = [[UIAlertView alloc]
                       initWithTitle:@"Choose a default color!"
                             message:nil
                            delegate:self
                   cancelButtonTitle:nil
                   otherButtonTitles:@"Purple", @"Blue", @"Orange", @"Green", nil];
    self.colorAlert.tag = 1;
    [self.colorAlert show];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UITableViewCell *selectedCell = sender;
    Person *selected = [self.ownersArray objectAtIndex:[self.myTableView indexPathForCell:selectedCell].row];
    DogsViewController *vc = segue.destinationViewController;
    vc.person = selected;
}

@end

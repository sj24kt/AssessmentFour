//
//  DogsViewController.m
//  Assessment4
//
//  Created by Vik Denic on 8/11/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

#import "DogsViewController.h"
#import "AddDogViewController.h"
#import "Person.h"
#import "Dog.h"

@interface DogsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *dogsTableView;
@property NSManagedObjectContext *moc;
@property NSArray *dogArray;
@end

@implementation DogsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.moc = [self.person managedObjectContext];
    self.title = @"Dogs";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadDogs];
}

#pragma mark - Helper Methods
- (void)loadDogs {
    NSArray *dogs = [self.person.dogs allObjects];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    self.dogArray = [dogs sortedArrayUsingDescriptors:@[sortDescriptor]];
    [self.dogsTableView reloadData];
}

#pragma mark - UITableView Delegate Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //TODO: UPDATE THIS ACCORDINGLY
    return self.dogArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"dogCell"];
    //TODO: UPDATE THIS ACCORDINGLY
    Dog *dog = [self.dogArray objectAtIndex:indexPath.row];
    cell.textLabel.text = dog.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Breed: %@\tColor: %@", dog.breed, dog.color];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObject *character = self.dogArray[indexPath.row];
        [self.moc deleteObject:character];
        [self.moc save:nil];
        [self loadDogs];
    }
}

#pragma mark - Actions & Segues

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    UINavigationController *nvc = segue.destinationViewController;
    AddDogViewController *vc = [[AddDogViewController alloc] init];
    vc = nvc.viewControllers[0];
    vc.moc = self.moc;
    vc.person = self.person;
    
    if ([segue.identifier isEqualToString: @"AddDogSegue"]) {
        vc.dog = nil;
    } else {
        UITableViewCell *cell = sender;
        Dog *selected = [self.dogArray objectAtIndex:[self.dogsTableView indexPathForCell:cell].row];
        vc.dog = selected;
    }
}

@end

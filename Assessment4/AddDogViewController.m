//
//  AddDogViewController.m
//  Assessment4
//
//  Created by Vik Denic on 8/11/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

#import "AddDogViewController.h"
#import "Person.h"
#import "Dog.h"

@interface AddDogViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *breedTextField;
@property (weak, nonatomic) IBOutlet UITextField *colorTextField;

@end

@implementation AddDogViewController

//TODO: UPDATE CODE ACCORDINGLY

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Add Dog";

    self.nameTextField.clearButtonMode = YES;
    self.breedTextField.clearButtonMode = self.nameTextField.clearButtonMode;
    self.colorTextField.clearButtonMode = self.nameTextField.clearButtonMode;

    //If editing instead of adding
    if (self.dog) {
        self.nameTextField.text = self.dog.name;
        self.breedTextField.text = self.dog.breed;
        self.colorTextField.text = self.dog.color;
    }
}

- (IBAction)onPressedUpdateDog:(UIButton *)sender {
    if ([self.nameTextField.text isEqualToString:@""] ||
        [self.breedTextField.text isEqualToString:@""] ||
        [self.colorTextField.text isEqualToString:@""]) {
        UIAlertView *message = [[UIAlertView alloc]
                                initWithTitle:@"Warning! You missed an item."
                                      message:@"Please note that all fields are required."
                                     delegate:self
                            cancelButtonTitle:@"cancel"
                            otherButtonTitles:nil, nil];
        [message show];
    } else {
        if (!self.dog) {
            self.dog = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Dog class]) inManagedObjectContext:self.moc];
            [self.dog setOwner:self.person];
        }
        self.dog.name = self.nameTextField.text;
        self.dog.breed = self.breedTextField.text;
        self.dog.color = self.colorTextField.text;

        [self.moc save:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end























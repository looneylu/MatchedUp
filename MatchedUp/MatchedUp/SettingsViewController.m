//
//  SettingsViewController.m
//  MatchedUp
//
//  Created by Luis Carbuccia on 8/10/14.
//  Copyright (c) 2014 Luis Carbuccia. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@property (strong, nonatomic) IBOutlet UILabel *ageLabel;
@property (strong, nonatomic) IBOutlet UISlider *ageSlider;
@property (strong, nonatomic) IBOutlet UISwitch *showMenSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *showWomenSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *singlesOnlySwitch;
@property (strong, nonatomic) IBOutlet UIButton *logOutButton;
@property (strong, nonatomic) IBOutlet UIButton *editProfileButton;

@end

@implementation SettingsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - IBActions

- (IBAction)logOutButtonPressed:(id)sender {
}

- (IBAction)editProfileButtonPressed:(id)sender {
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

@end

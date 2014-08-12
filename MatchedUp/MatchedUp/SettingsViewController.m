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


@end

@implementation SettingsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.ageSlider.value = [[NSUserDefaults standardUserDefaults] integerForKey:kCCAgeMaxKey];
    self.showMenSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:kCCMenEnabledKey];
    self.showWomenSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:kCCWomenEnabledKey];
    self.singlesOnlySwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:kCCSingleEnabledKey];
    
    [self.ageSlider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.showMenSwitch addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.showWomenSwitch addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.singlesOnlySwitch addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    
    self.ageLabel.text = [NSString stringWithFormat:@"%i", (int)self.ageSlider.value];
}

#pragma mark - IBActions

- (IBAction)logOutButtonPressed:(id)sender
{
    [PFUser logOut];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)editProfileButtonPressed:(UIButton *)sender
{
    NSLog(@"Edit Profile Button Pressed");
//    [self performSegueWithIdentifier:@"toEditProfileSegue" sender:self];
}

#pragma mark - Helper Methods

- (void) valueChanged:(id)sender
{
    if (sender == self.ageSlider)
    {
        [[NSUserDefaults standardUserDefaults] setInteger:self.ageSlider.value forKey:kCCAgeMaxKey];
        self.ageLabel.text = [NSString stringWithFormat:@"%i", (int)self.ageSlider.value];
    }
    else if (sender == self.showMenSwitch)
        [[NSUserDefaults standardUserDefaults] setBool:self.showMenSwitch.isOn forKey:kCCMenEnabledKey];
    else if (sender == self.showWomenSwitch)
        [[NSUserDefaults standardUserDefaults] setBool:self.showWomenSwitch.isOn forKey:kCCWomenEnabledKey];
    else if (sender == self.singlesOnlySwitch)
        [[NSUserDefaults standardUserDefaults] setBool:self.singlesOnlySwitch.isOn forKey:kCCSingleEnabledKey];

    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
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

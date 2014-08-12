//
//  EditProfileViewController.m
//  MatchedUp
//
//  Created by Luis Carbuccia on 8/10/14.
//  Copyright (c) 2014 Luis Carbuccia. All rights reserved.
//

#import "EditProfileViewController.h"

@interface EditProfileViewController () <UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UITextView *tagLineTextView;
@property (strong, nonatomic) IBOutlet UIImageView *profilePictureImageView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveButton;

@end

@implementation EditProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   PFQuery *query = [PFQuery queryWithClassName:kCCUserPhotoClassKey];
    [query whereKey:kCCUserPhotoUserKey equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([objects count] > 0)
        {
            PFObject *photo = objects[0];
            PFFile *pictureFile = [photo objectForKey:kCCUserPhotoPictureKey];
            [pictureFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                self.profilePictureImageView.image = [UIImage imageWithData:data];
            }];
        }
    }];
    self.tagLineTextView.text = [[PFUser currentUser] objectForKey:kCCUserTagLineKey];
}

#pragma mark - IBACtions

- (IBAction)saveButtonPressed:(id)sender
{
    [[PFUser currentUser] setObject:self.tagLineTextView.text forKey:kCCUserTagLineKey];
    [[PFUser currentUser] saveInBackground];
    
    [self.navigationController popViewControllerAnimated:YES];
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

//
//  MULoginViewController.m
//  MatchedUp
//
//  Created by Luis Carbuccia on 8/9/14.
//  Copyright (c) 2014 Luis Carbuccia. All rights reserved.
//

#import "MULoginViewController.h"

@interface MULoginViewController () <NSURLConnectionDataDelegate>

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) NSMutableData *imageData;

@end

@implementation MULoginViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.activityIndicator.hidden = YES;
}

- (void) viewDidAppear:(BOOL)animated
{
    if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]])
    {
        [self updateUserInformation];
        [self performSegueWithIdentifier:@"logInToHomeSegue" sender:self];
    }
}

#pragma mark - IBActions

- (IBAction)loginButtonPressed:(UIButton *)sender
{
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    NSArray *permissionsArray = @[@"user_about_me", @"user_interests", @"user_relationships", @"user_birthday", @"user_location", @"user_relationship_details"];
    
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        [self.activityIndicator stopAnimating];
        self.activityIndicator.hidden = YES;
        
        if (!user)
        {
            if (!error)
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Login Error" message:@"The Facebook login was cancelled" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alertView show];
            }
            else
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:[error description] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alertView show];
            }
        }
        else
        {
            [self updateUserInformation];
            [self performSegueWithIdentifier:@"logInToHomeSegue" sender:self];
        }
    }];
}

#pragma mark - Helper Methods

- (void) updateUserInformation
{
    FBRequest *request = [FBRequest requestForMe];
    
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error)
        {
            NSDictionary *userDictionary = (NSDictionary *) result;
            
            // create URL
            NSString *facebookID = userDictionary[@"id"];
            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
            
            NSMutableDictionary *userProfile = [[NSMutableDictionary alloc] initWithCapacity:8];
            if (userDictionary[@"name"])
            {
                userProfile[kCCUserProfileNameKey] = userDictionary[@"name"];
            }
            if (userDictionary[@"first_name"])
            {
                userProfile[kCCUserProfileFirstNameKey] = userDictionary[@"first_name"];
            }
            if (userDictionary[@"location"][@"name"])
            {
                userProfile[kCCUserProfileLocationKey] = userDictionary[@"location"][@"name"];
            }
            if (userDictionary[@"gender"])
            {
                userProfile[kCCUserProfileGenderKey] = userDictionary[@"gender"];
            }
            if (userDictionary[@"birthday"])
            {
                userProfile[kCCUserProfileBirthdayKey] = userDictionary[@"birthday"];
            }
            if (userDictionary[@"interested_in"])
            {
                userProfile[kCCUserProfileInterestedInKey] = userDictionary[@"interested_in"];
            }
            
            if ([pictureURL absoluteString])
            {
                userProfile[kCCUserProfilePictureURL] = [pictureURL absoluteString];
            }
            if (userDictionary[@"relationship_status"])
            {
                userProfile[kCCUserProfileRelationshipStatusKey] = userDictionary[@"relationship_status"];
            }
            if (userDictionary[@"birthday"])
            {
                userProfile[kCCUserProfileBirthdayKey] = userDictionary[@"birthday"];
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateStyle:NSDateFormatterShortStyle];
                NSDate *date = [formatter dateFromString:userDictionary[@"birthday"]];
                NSDate *now = [NSDate date];
                NSTimeInterval seconds = [now timeIntervalSinceDate:date];
                int age = seconds / 31536000;
                userProfile[kCCuserProfileAgeKey] = @(age); 
            }
            
            [[PFUser currentUser] setObject:userProfile forKey:@"profile"];
            [[PFUser currentUser] saveInBackground];
            [self requestImage]; 
        }
        else
        {
            NSLog(@"Error in FB request: %@", error);
        }
    }];
}

- (void) uploadPFFileToParse: (UIImage *)image
{
    NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
    
    if (!imageData)
    {
        NSLog(@"imageData was not found");
        return;
    }
    
    PFFile *photoFile = [PFFile fileWithData:imageData];
    [photoFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded)
        {
            PFObject *photo = [PFObject objectWithClassName:kCCUserPhotoClassKey];
            [photo setObject:[PFUser currentUser] forKey:kCCUserPhotoUserKey];
            
            [photo setObject:photoFile forKey:kCCUserPhotoPictureKey];
            
            [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                NSLog(@"Photo saved successfully");
            }];
        }
    }];
}

- (void) requestImage
{
    PFQuery *query = [PFQuery queryWithClassName:kCCUserPhotoClassKey];
    [query whereKey:kCCUserPhotoUserKey equalTo:[PFUser currentUser]];
    
    [query countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if (number == 0)
        {
            PFUser *user = [PFUser currentUser];
            self.imageData = [[NSMutableData alloc] init];
            
            NSURL *profilePictureURL = [NSURL URLWithString:user[kCCUserProfileKey] [kCCUserProfilePictureURL]];
            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:profilePictureURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:4.0f]
            ;
            NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
            if (!urlConnection)
            {
                NSLog(@"Failed to Download Picture"); 
            }
        }
    }];
}

#pragma mark - Delegate Methods

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.imageData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    UIImage *profileImage = [UIImage imageWithData:self.imageData];
    [self uploadPFFileToParse:profileImage];
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

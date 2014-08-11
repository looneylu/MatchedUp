//
//  HomeViewController.m
//  
//
//  Created by Luis Carbuccia on 8/10/14.
//
//

#import "HomeViewController.h"

@interface HomeViewController ()

#pragma mark - Properties

@property (nonatomic, strong) NSArray *photos;
@property (nonatomic) int photoIndex;
@property (strong, nonatomic) PFObject *photo;
@property (nonatomic) BOOL isLikedByCurrentUser;
@property (nonatomic) BOOL isDislikedByCurrentUser;
@property (nonatomic,strong) NSMutableArray *activities;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *chatBarButtonItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *settingsBarButtonItem;
@property (strong, nonatomic) IBOutlet UIImageView *photoImageView;
@property (strong, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *ageLabel;
@property (strong, nonatomic) IBOutlet UILabel *tagLineLabel;
@property (strong, nonatomic) IBOutlet UIButton *likeButton;
@property (strong, nonatomic) IBOutlet UIButton *infoButton;
@property (strong, nonatomic) IBOutlet UIButton *dislikeButton;

@end

#pragma mark - Implementation of HomeViewController

@implementation HomeViewController

#pragma mark - viewDidLoad

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // view controller setup
//    self.likeButton.enabled = NO;
//    self.dislikeButton.enabled = NO;
    self.infoButton.enabled = NO;
    self.photoIndex = 0;
    
    PFQuery *query = [PFQuery queryWithClassName:kCCUserPhotoClassKey];
    [query includeKey:kCCUserPhotoUserKey];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        // do additional code
        if (!error)
        {
            self.photos = objects;
            [self queryForCurrentPhotoIndex]; 
        }
        else
            NSLog(@"%@", error);
    }];
}

#pragma mark - IBActions

- (IBAction)chatBarButtonPressed:(UIButton *)sender
{

}

- (IBAction)settingsBarButtonPressed:(UIButton *)sender
{

}

- (IBAction)likeButtonPressed:(UIButton *)sender
{
    [self checkLike];
}

- (IBAction)infoButtonPressed:(UIButton *)sender
{

}

- (IBAction)dislikeButtonPressed:(UIButton *)sender
{
    [self checkDislike];
}

#pragma mark - Helper Methods

- (void) queryForCurrentPhotoIndex
{
    if ([self.photos count] > 0)
    {
        self.photo = self.photos[self.photoIndex];
        PFFile *file = self.photo[kCCUserPhotoPictureKey];
        [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error)
            {
                UIImage *image = [UIImage imageWithData:data];
                self.photoImageView.image = image;
                [self updateView];
            }
            else
                NSLog(@"%@", error);
        }];
        
        PFQuery *queryForLike = [PFQuery queryWithClassName:kCCActivityClassKey];
        [queryForLike whereKey:kCCActivityTypeKey equalTo:kCCActivityTypeLikeKey];
        [queryForLike whereKey:kCCActivityPhotoKey equalTo:self.photo];
        [queryForLike whereKey:kCCActivityFromUserKey equalTo:[PFUser currentUser]];
        
        PFQuery *queryForDislike = [PFQuery queryWithClassName:kCCActivityClassKey];
        [queryForLike whereKey:kCCActivityTypeKey equalTo:kCCActivityTypeDislikeKey];
        [queryForLike whereKey:kCCActivityPhotoKey equalTo:self.photo];
        [queryForLike whereKey:kCCActivityFromUserKey equalTo:[PFUser currentUser]];
        
        PFQuery *likeAndDislikeQuery = [PFQuery orQueryWithSubqueries:@[queryForLike, queryForDislike]];
        [likeAndDislikeQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error)
            {
                self.activities = [objects mutableCopy];
                if ([self.activities count] == 0)
                {
                    self.isLikedByCurrentUser = NO;
                    self.isDislikedByCurrentUser = NO;
                }
                else
                {
                    PFObject *activity = self.activities[0];
                    if ([activity[kCCActivityTypeKey] isEqualToString:kCCActivityTypeLikeKey])
                    {
                        self.isLikedByCurrentUser = YES;
                        self.isDislikedByCurrentUser = NO;
                    }
                    else if ([activity[kCCActivityTypeKey] isEqualToString:kCCActivityTypeDislikeKey])
                    {
                        self.isLikedByCurrentUser = NO;
                        self.isDislikedByCurrentUser = YES;
                    }
                    else
                    {
                        //some other type of activity
                    }
                }
                
                self.likeButton.enabled = YES;
                self.dislikeButton.enabled = YES;
            }
        }];
    }
}

- (void) updateView
{
    self.firstNameLabel.text = self.photo[kCCUserPhotoUserKey][kCCUserProfileKey][kCCUserProfileFirstNameKey];
    self.ageLabel.text = [NSString stringWithFormat:@"%@", self.photo[kCCUserPhotoUserKey][kCCUserProfileKey][kCCuserProfileAgeKey]];
    self.tagLineLabel.text = self.photo[kCCUserPhotoUserKey][kCCUserTagLineKey];
    
}

- (void) setUpNextPhoto
{
    if (self.photoIndex + 1 < [self.photos count])
    {
        self.photoIndex++;
        [self queryForCurrentPhotoIndex];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No More Users To View" message:@"Check Back Later for More People" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alertView show];
    }
}

- (void)saveLike
{
    PFObject *likeActivity = [PFObject objectWithClassName:kCCActivityClassKey];
    [likeActivity setObject:kCCActivityTypeLikeKey forKey:kCCActivityTypeKey];
    [likeActivity setObject:[PFUser currentUser] forKey:kCCActivityFromUserKey];
    [likeActivity setObject:[self.photo objectForKey:kCCUserPhotoUserKey] forKey:kCCActivityToUserKey];
    [likeActivity setObject:self.photo forKey:kCCActivityPhotoKey];
    
    [likeActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        self.isLikedByCurrentUser = YES;
        self.isDislikedByCurrentUser = NO;
        [self.activities addObject: likeActivity];
        [self setUpNextPhoto];
    }];
}

- (void)saveDislike
{
    PFObject *dislikeActivity = [PFObject objectWithClassName:kCCActivityClassKey];
    [dislikeActivity setObject:kCCActivityTypeDislikeKey forKey:kCCActivityTypeKey];
    [dislikeActivity setObject:[PFUser currentUser] forKey:kCCActivityFromUserKey];
    [dislikeActivity setObject: [self.photo objectForKey:kCCUserPhotoUserKey] forKey:kCCActivityToUserKey];
    [dislikeActivity setObject:self.photo forKey:kCCActivityPhotoKey];
    
    [dislikeActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        self.isLikedByCurrentUser = NO;
        self.isDislikedByCurrentUser = YES;
        
        [self.activities addObject:dislikeActivity];
        [self setUpNextPhoto];
    }];
}

- (void)checkLike
{
    if (self.isLikedByCurrentUser)
    {
        [self setUpNextPhoto];
        return;
    }
    else if (self.isDislikedByCurrentUser)
    {
        for (PFObject *activity in self.activities)
            [activity deleteInBackground];
        [self.activities removeLastObject];
        [self saveLike];
    }
    else
        [self saveLike];
}

- (void) checkDislike
{
    if (self.isDislikedByCurrentUser)
    {
        [self setUpNextPhoto];
        return;
    }
    else if (self.isLikedByCurrentUser)
    {
        for (PFObject *activity in self.activities)
        {
            [activity deleteInBackground];
        }
        [self.activities removeLastObject];
        [self saveDislike];
    }
    else
        [self saveDislike];
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

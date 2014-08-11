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
    
    PFQuery *query = [PFQuery queryWithClassName:@"Photo"];
    [query includeKey:@"user"];
    
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
        PFFile *file = self.photo[@"image"];
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
        
        PFQuery *queryForLike = [PFQuery queryWithClassName:@"Activity"];
        [queryForLike whereKey:@"type" equalTo:@"like"];
        [queryForLike whereKey:@"photo" equalTo:self.photo];
        [queryForLike whereKey:@"fromUser" equalTo:[PFUser currentUser]];
        
        PFQuery *queryForDislike = [PFQuery queryWithClassName:@"Activity"];
        [queryForLike whereKey:@"type" equalTo:@"dislike"];
        [queryForLike whereKey:@"photo" equalTo:self.photo];
        [queryForLike whereKey:@"fromUser" equalTo:[PFUser currentUser]];
        
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
                    if ([activity[@"type"] isEqualToString:@"like"])
                    {
                        self.isLikedByCurrentUser = YES;
                        self.isDislikedByCurrentUser = NO;
                    }
                    else if ([activity[@"type"] isEqualToString:@"dislike"])
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
    self.firstNameLabel.text = self.photo[@"user"][@"profile"][@"firstName"];
    self.ageLabel.text = [NSString stringWithFormat:@"%@", self.photo[@"user"][@"profile"][@"age"]];
    self.tagLineLabel.text = self.photo[@"user"][@"tagLine"];
    
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
    PFObject *likeActivity = [PFObject objectWithClassName:@"Activity"];
    [likeActivity setObject:@"like" forKey:@"type"];
    [likeActivity setObject:[PFUser currentUser] forKey:@"fromUser"];
    [likeActivity setObject:[self.photo objectForKey:@"user"] forKey:@"toUser"];
    [likeActivity setObject:self.photo forKey:@"photo"];
    
    [likeActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        self.isLikedByCurrentUser = YES;
        self.isDislikedByCurrentUser = NO;
        [self.activities addObject: likeActivity];
        [self setUpNextPhoto];
    }];
}

- (void)saveDislike
{
    PFObject *dislikeActivity = [PFObject objectWithClassName:@"Activity"];
    [dislikeActivity setObject:@"dislike" forKey:@"type"];
    [dislikeActivity setObject:[PFUser currentUser] forKey:@"fromUser"];
    [dislikeActivity setObject: [self.photo objectForKey:@"user"] forKey:@"toUser"];
    [dislikeActivity setObject:self.photo forKey:@"photo"];
    
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

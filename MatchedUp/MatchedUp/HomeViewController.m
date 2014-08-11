//
//  HomeViewController.m
//  
//
//  Created by Luis Carbuccia on 8/10/14.
//
//

#import "HomeViewController.h"

@interface HomeViewController ()

@property (nonatomic, strong) NSArray *photos;
@property (nonatomic) int photoIndex;
@property (strong, nonatomic) PFObject *photo;

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

@implementation HomeViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // view controller setup
    self.likeButton.enabled = NO;
    self.dislikeButton.enabled = NO;
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

}

- (IBAction)infoButtonPressed:(UIButton *)sender
{

}

- (IBAction)dislikeButtonPressed:(UIButton *)sender
{

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
    }
}

- (void) updateView
{
    self.firstNameLabel.text = self.photo[@"user"][@"profile"][@"firstName"];
    self.ageLabel.text = [NSString stringWithFormat:@"%@", self.photo[@"user"][@"profile"][@"age"]];
    self.tagLineLabel.text = self.photo[@"user"][@"tagLine"];
    
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

//
//  MUSecondViewController.m
//  MatchedUp
//
//  Created by Luis Carbuccia on 8/9/14.
//  Copyright (c) 2014 Luis Carbuccia. All rights reserved.
//

#import "MUSecondViewController.h"

@interface MUSecondViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *profilePicImageView;

@end

@implementation MUSecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    PFQuery *query = [PFQuery queryWithClassName:kCCUserPhotoClassKey];
    [query whereKey:kCCUserPhotoUserKey equalTo:[PFUser currentUser]];

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([objects count] > 0)
        {
            PFObject *photo = objects[0];
            PFFile *pictureFile = photo[kCCUserPhotoPictureKey];
            [pictureFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                self.profilePicImageView.image = [UIImage imageWithData:data];
            }];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

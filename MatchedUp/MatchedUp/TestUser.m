//
//  TestUser.m
//  MatchedUp
//
//  Created by Luis Carbuccia on 8/11/14.
//  Copyright (c) 2014 Luis Carbuccia. All rights reserved.
//

#import "TestUser.h"

@implementation TestUser

+ (void) saveTestUserToParse
{
    PFUser *newUser = [PFUser user];
    newUser.username = @"user1";
    newUser.password = @"password1";
    
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error)
        {
            NSDictionary *profile = @{@"age" : @28, @"birthday" : @"11/22/1985", @"firstName" : @"Julie", @"gender" : @"female", @"location" : @"Berlin, Germany", @"name" : @"Julie Adams"};
            
            [newUser setObject:profile forKey:@"profile"];
            [newUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                UIImage *profileImage = [UIImage imageNamed:@"MudZone.jpg"];
                NSData *imageData = UIImageJPEGRepresentation(profileImage, .8);
                PFFile *photoFile = [PFFile fileWithData:imageData];
                [photoFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded)
                    {
                        PFObject *photo  = [PFObject objectWithClassName:kCCUserPhotoClassKey];
                        [photo setObject:newUser forKey:kCCUserPhotoUserKey];
                        [photo setObject:photoFile forKey:kCCUserPhotoPictureKey];
                        [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            NSLog(@"Photo saved successfully");
                        }];
                    }
                }];
            }];
        }
    }];
}

@end

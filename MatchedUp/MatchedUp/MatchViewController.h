//
//  MatchViewController.h
//  MatchedUp
//
//  Created by Luis Carbuccia on 8/12/14.
//  Copyright (c) 2014 Luis Carbuccia. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MatchViewControllerDelegate <NSObject>

- (void)presentMatchesViewController;

@end

@interface MatchViewController : UIViewController

@property (strong, nonatomic) UIImage *matchedUserImage;

@property (weak, nonatomic) id <MatchViewControllerDelegate> delegate;
@end

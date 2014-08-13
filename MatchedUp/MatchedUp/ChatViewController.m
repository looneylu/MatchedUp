//
//  ChatViewController.m
//  MatchedUp
//
//  Created by Luis Carbuccia on 8/12/14.
//  Copyright (c) 2014 Luis Carbuccia. All rights reserved.
//

#import "ChatViewController.h"

#pragma mark - Interface
@interface ChatViewController ()

#pragma mark - Properties
@property (strong,nonatomic) PFUser *withUser;
@property (strong, nonatomic) PFUser *currentUser;

@property (strong, nonatomic) NSTimer *chatsTimer;
@property (nonatomic) BOOL initialLoadComplete;

@property (strong, nonatomic) NSMutableArray *chats;

@end

#pragma mark - Implementation
@implementation ChatViewController

#pragma mark - View
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Lazy Instantiation

-(NSMutableArray *)chats
{
    if (!_chats)
        _chats = [[NSMutableArray alloc] init];
    
    return _chats;
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

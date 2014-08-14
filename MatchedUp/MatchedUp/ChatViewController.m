//
//  ChatViewController.m
//  MatchedUp
//
//  Created by Luis Carbuccia on 8/12/14.
//  Copyright (c) 2014 Luis Carbuccia. All rights reserved.
//

#import "ChatViewController.h"

#pragma mark - Interface
@interface ChatViewController () <JSMessagesViewDataSource, JSMessagesViewDelegate>

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
    
    self.delegate = self;
    self.dataSource = self;
    
    [[JSBubbleView appearance] setFont:[UIFont systemFontOfSize:16.0f]];
    self.messageInputView.textView.placeHolder = @"NewMessage";
    [self setBackgroundColor:[UIColor whiteColor]];
    
    self.currentUser = [PFUser currentUser];
    PFUser *testUser1 = self.chatRoom[@"user1"];
    
    if ([testUser1.objectId isEqual:self.currentUser.objectId])
        self.withUser = self.chatRoom[@"user2"];
    else
        self.withUser = self.chatRoom[@"user1"];
    
    self.title = self.withUser[@"profile"][@"firstName"];
    self.initialLoadComplete = NO;
}

#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.chats count];
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

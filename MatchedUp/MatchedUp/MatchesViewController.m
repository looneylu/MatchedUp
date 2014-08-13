//
//  MatchesViewController.m
//  MatchedUp
//
//  Created by Luis Carbuccia on 8/12/14.
//  Copyright (c) 2014 Luis Carbuccia. All rights reserved.
//

#import "MatchesViewController.h"
#import "ChatViewController.h"

@interface MatchesViewController () <UITableViewDataSource, UITableViewDelegate>

#pragma mark - Properties

@property (strong, nonatomic) IBOutlet UITableView *matchesTableView;
@property (strong, nonatomic) NSMutableArray *availableChatRooms;

@end

@implementation MatchesViewController

#pragma mark - viewDidLoad

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.matchesTableView.delegate = self;
    self.matchesTableView.dataSource = self;
}

#pragma mark - Lazy Instantiation

- (NSMutableArray *)availableChatRooms
{
    if (!_availableChatRooms)
        _availableChatRooms = [[NSMutableArray alloc] init];
    
    return _availableChatRooms;
}

#pragma mark - TableView setup

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    PFObject *chatroom = [self.availableChatRooms objectAtIndex:indexPath.row];
    PFUser *likedUser;
    PFUser *currentUser = [PFUser currentUser];
    PFUser *testUser1 = chatroom[@"user1"];
    
    if ([testUser1.objectId isEqual:currentUser.objectId])
    {
        likedUser = [chatroom objectForKey:@"user2"];
    }
    else
    {
        likedUser = [chatroom objectForKey:@"user1"];
    }
    
    cell.textLabel.text = likedUser[@"profile"][@"firstName"];
    
    //cell.imageview.image = placeholder image
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    PFQuery *queryForPhoto = [[PFQuery alloc] initWithClassName:@"Photo"];
    [queryForPhoto whereKey:@"user" equalTo:likedUser];
    [queryForPhoto findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([objects count] > 0)
        {
            PFObject *photo = objects[0];
            PFFile *pictureFile = photo[kCCUserPhotoPictureKey];
            [pictureFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                cell.imageView.image = [UIImage imageWithData:data];
                cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
            }];
        }
    }];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.availableChatRooms count];
}

#pragma mark - TableView Delegates

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"matchesToChatSegue" sender:indexPath];
}

#pragma mark - Helper Methods

- (void)updateAvailableChatRooms
{
    PFQuery *query = [PFQuery queryWithClassName:@"ChatRoom"];
    [query whereKey:@"user1" equalTo:[PFUser currentUser]];
    PFQuery *queryInverse = [PFQuery queryWithClassName:@"ChatRoom"];
    [query whereKey:@"user2" equalTo:[PFUser currentUser]];
    PFQuery *queryCombined = [PFQuery orQueryWithSubqueries:@[query, queryInverse]];
    [queryCombined includeKey:@"chat"];
    [queryCombined includeKey:@"user1"];
    [queryCombined includeKey:@"user2"];
    [queryCombined findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error)
        {
            [self.availableChatRooms removeAllObjects];
            self.availableChatRooms = [objects mutableCopy];
            [self.matchesTableView reloadData];
        }
        }];
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    ChatViewController *chatVC = segue.destinationViewController;
    NSIndexPath *indexPath = sender;
    chatVC.chatRoom = [self.availableChatRooms objectAtIndex:indexPath.row]; 
}

@end

//
//  ChatViewController.h
//  MatchedUp
//
//  Created by Luis Carbuccia on 8/12/14.
//  Copyright (c) 2014 Luis Carbuccia. All rights reserved.
//

#import "JSMessagesViewController.h"

@interface ChatViewController : JSMessagesViewController

@property (strong,nonatomic) PFObject *chatRoom;

@end

//
//  MUConstants.m
//  MatchedUp
//
//  Created by Luis Carbuccia on 8/9/14.
//  Copyright (c) 2014 Luis Carbuccia. All rights reserved.
//

#import "MUConstants.h"

@implementation MUConstants

#pragma - User Profile

NSString *const kCCUserTagLineKey                       = @"tagLine"; 

NSString *const kCCUserProfileKey                       = @"profile";
NSString *const kCCUserProfileNameKey                   = @"name";
NSString *const kCCUserProfileFirstNameKey              = @"firstName";
NSString *const kCCUserProfileLocationKey               = @"location";
NSString *const kCCUserProfileGenderKey                 = @"gender";
NSString *const kCCUserProfileBirthdayKey               = @"birthday";
NSString *const kCCUserProfileInterestedInKey           = @"interestedIn";
NSString *const kCCUserProfilePictureURL                = @"pictureURL";
NSString *const kCCUserProfileRelationshipStatusKey     = @"relationshipStatus";
NSString *const kCCuserProfileAgeKey                    = @"age";

#pragma mark - Photo Class

NSString *const kCCUserPhotoClassKey                    = @"Photo";
NSString *const kCCUserPhotoUserKey                     = @"user";
NSString *const kCCUserPhotoPictureKey                  = @"image";

#pragma mark - Activity Class

NSString *const kCCActivityClassKey                     = @"Activity";
NSString *const kCCActivityTypeKey                      = @"type";
NSString *const kCCActivityFromUserKey                  = @"fromUser";
NSString *const kCCActivityToUserKey                    = @"toUser";
NSString *const kCCActivityPhotoKey                     = @"photo";
NSString *const kCCActivityTypeLikeKey                  = @"like";
NSString *const kCCActivityTypeDislikeKey               = @"dislike";

#pragma mark - Settings

NSString *const kCCMenEnabledKey                        = @"men";
NSString *const kCCWomenEnabledKey                      = @"women";
NSString *const kCCSingleEnabledKey                     = @"single";
NSString *const kCCAgeMaxKey                            = @"ageMax";

@end

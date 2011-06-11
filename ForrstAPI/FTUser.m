//
//  FTUser.m
//  ForrstAPI
//
//  Created by Kyle Hickinson on 11-06-04.
//  Copyright 2011 Kyle Hickinson. All rights reserved.
//

#import "FTUser.h"
#import "FTCache.h"

#import <UIKit/UIKit.h>

@implementation FTUser
@synthesize userID          = _userID,
            username        = _username,
            name            = _name,
            url             = _url,
            posts           = _posts,
            comments        = _comments,
            likes           = _likes,
            followers       = _followers,
            following       = _following,
            bio             = _bio,
            type            = _type,
            homepage        = _homepage,
            twitter         = _twitter,
            inDirectory     = _inDirectory,
            tags            = _tags;

- (void)photoForSize:(FTUserPhotoSize)size completion:(void (^)(UIImage *image))completion {
    __block NSURL *_photoURL;
    NSString *_photoSize = nil;
    
    switch (size) {
        case FTUserPhotoSizeXL: _photoURL = _photosXLURL; _photoSize = @"xl"; break;
        case FTUserPhotoSizeLarge: _photoURL = _photosLargeURL; _photoSize = @"lg"; break;
        case FTUserPhotoSizeMedium: _photoURL = _photosMediumURL; _photoSize = @"md"; break;
        case FTUserPhotoSizeSmall: _photoURL = _photosSmallURL; _photoSize = @"sm"; break;
        case FTUserPhotoSizeThumb: _photoURL = _photosThumbURL; _photoSize = @"th"; break;
    }
    
    NSString *key = [NSString stringWithFormat:@"%d_%@", self.userID, _photoSize];
    [[FTCache cache] imageForKey:key type:FTCacheTypeUserAvatar completion:^(UIImage *image) {
        if (image == nil) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                UIImage *_imageFromFile = [UIImage imageWithData:[NSData dataWithContentsOfURL:_photoURL]];
                [[FTCache cache] addImage:_imageFromFile forKey:key type:FTCacheTypeUserAvatar];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    completion(_imageFromFile);
                });
            });
        } else {
            completion(image);
        }
    }];
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
    if ((self = [super init])) {
        
        _userID = [[dictionary objectForKey:@"id"] unsignedIntegerValue];
        _username = [[dictionary objectForKey:@"username"] copy];
        _name = [[dictionary objectForKey:@"name"] copy];
        _url = [[NSURL alloc] initWithString:[dictionary objectForKey:@"url"]];
        _posts = [((NSString *)[dictionary objectForKey:@"posts"]) integerValue];
        _comments = [((NSString *)[dictionary objectForKey:@"comments"]) integerValue];
        _likes = [((NSString *)[dictionary objectForKey:@"likes"]) integerValue];
        _followers = [((NSString *)[dictionary objectForKey:@"followers"]) integerValue];
        _following = [((NSString *)[dictionary objectForKey:@"following"]) integerValue];
        _bio = [[dictionary objectForKey:@"bio"] copy];
        _type = [[dictionary objectForKey:@"is_a"] copy];
        _homepage = [[NSURL alloc] initWithString:[dictionary objectForKey:@"homepage_url"]];
        _twitter = [[dictionary objectForKey:@"twitter"] copy];
        _inDirectory = [[dictionary objectForKey:@"in_directory"] boolValue];
        
        NSMutableString *__tags = [[dictionary objectForKey:@"tag_string"] copy];
        _tags = [[NSMutableArray alloc] initWithArray:[__tags componentsSeparatedByString:@","] copyItems:YES];
        FT_RELEASE(__tags);
    
        NSDictionary *photos = [[NSDictionary alloc] initWithDictionary:[dictionary objectForKey:@"photos"]];
        _photosXLURL = [[NSURL alloc] initWithString:[photos objectForKey:@"xl_url"]];
        _photosLargeURL = [[NSURL alloc] initWithString:[photos objectForKey:@"large_url"]];
        _photosMediumURL = [[NSURL alloc] initWithString:[photos objectForKey:@"medium_url"]];
        _photosSmallURL = [[NSURL alloc] initWithString:[photos objectForKey:@"small_url"]];
        _photosThumbURL = [[NSURL alloc] initWithString:[photos objectForKey:@"thumb_url"]];
        [photos release];
        
    }
    return self;
}

- (void)dealloc {
    FT_RELEASE(_username);
    FT_RELEASE(_name);
    FT_RELEASE(_url);
    FT_RELEASE(_bio);
    FT_RELEASE(_type);
    FT_RELEASE(_homepage);
    FT_RELEASE(_twitter);
    FT_RELEASE(_tags);
    
    FT_RELEASE(_photosXLURL);
    FT_RELEASE(_photosLargeURL);
    FT_RELEASE(_photosMediumURL);
    FT_RELEASE(_photosSmallURL);
    FT_RELEASE(_photosThumbURL);
    
    [super dealloc];
}

@end

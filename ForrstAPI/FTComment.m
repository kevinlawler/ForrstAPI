//
//  FTComment.m
//  ForrstAPI
//
//  Created by Kyle Hickinson on 11-06-06.
//  Copyright 2011 Kyle Hickinson. All rights reserved.
//

#import "FTComment.h"
#import "FTUser.h"
#import "FTConstants.h"

@implementation FTComment
@synthesize commentID   = _commentID,
            user        = _user,
            body        = _body,
            createdAt   = _createdAt,
            updatedAt   = _updatedAt;

- (id)initWithDictionary:(NSDictionary *)dictionary {
    if ((self = [super init])) {
        
        _commentID = [[dictionary objectForKey:@"id"] unsignedIntegerValue];
        _user = [[FTUser alloc] initWithDictionary:[dictionary objectForKey:@"user"]];
        _body = [[dictionary objectForKey:@"body"] copy];
        _createdAt = [[dictionary objectForKey:@"created_at"] copy];
        _updatedAt = [[dictionary objectForKey:@"updated_at"] copy];
        
    }
    return self;
}

- (void)dealloc {
    FT_RELEASE(_user);
    FT_RELEASE(_body);
    FT_RELEASE(_createdAt);
    FT_RELEASE(_updatedAt);
    
    [super dealloc];
}

@end
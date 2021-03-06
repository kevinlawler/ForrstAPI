//
//  FTComment.h
//  ForrstAPI
//
//  Created by Kyle Hickinson on 11-06-06.
//  Copyright 2011 Kyle Hickinson. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FTUser;

@interface FTComment : NSObject {
    NSUInteger  _commentID;
    FTUser      *_user;
    
    NSString    *_body;
    NSString    *_createdAt;
    NSString    *_updatedAt;
}

@property (readonly) NSUInteger     commentID;
@property (readonly) FTUser         *user;
@property (readonly) NSString       *body;
@property (readonly) NSString       *createdAt;
@property (readonly) NSString       *updatedAt;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end

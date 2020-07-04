//
//  APIManager.h
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "BDBOAuth1SessionManager.h"
#import "BDBOAuth1SessionManager+SFAuthenticationSession.h"
#import "Tweet.h"

@interface APIManager : BDBOAuth1SessionManager

+ (instancetype)shared;

- (void)getHomeTimelineWithCompletion:( void(^) (NSMutableArray *tweets, NSError *error) )completion;

- (void)postStatusWithText:(NSString *)text completion:( void (^) (Tweet *, NSError *) )completion;

- (void)favorite:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion;

- (void)retweet:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion;

- (void)getMentions:(void(^) (NSMutableArray *tweets, NSError *error) )completion;

- (void)getCurrentUser:(void(^) (User *user, NSError *error) )completion;

- (void)getUserTimeline:(User *)user completion:(void(^) (NSMutableArray *tweets, NSError *error) )completion;

- (void)reply:(NSString *)text replyId:(NSString *)idString completion:(void(^) (Tweet *, NSError *))completion;

@end

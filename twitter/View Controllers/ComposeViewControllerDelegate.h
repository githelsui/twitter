//
//  ComposeViewControllerDelegate.h
//  twitter
//
//  Created by Githel Lynn Suico on 6/30/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ComposeViewControllerDelegate 

- (void)didTweet:(Tweet *)tweet;
- (void)didRetweet:(Tweet *)tweet;
- (void)didFavorite:(Tweet *)tweet;
- (void)didReply:(Tweet *)tweet;

@end

NS_ASSUME_NONNULL_END

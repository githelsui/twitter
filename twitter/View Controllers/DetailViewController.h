//
//  DetailViewController.h
//  twitter
//
//  Created by Githel Lynn Suico on 6/30/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TweetCell.h"
#import "Tweet.h"
#import "ComposeViewControllerDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailViewController : UIViewController
@property (nonatomic, strong) Tweet *tweet;
@property (nonatomic, strong) TweetCell *cell;
@property (nonatomic, strong) User *currentUser;
@property (nonatomic, weak) id<ComposeViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END

//
//  ReplyViewController.h
//  twitter
//
//  Created by Githel Lynn Suico on 7/1/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComposeViewControllerDelegate.h"
NS_ASSUME_NONNULL_BEGIN

@interface ReplyViewController : UIViewController
@property (nonatomic, weak) id<ComposeViewControllerDelegate> delegate;
@property (nonatomic, strong) Tweet *tweet;
@property (nonatomic, strong) User *currentUser;
@end

NS_ASSUME_NONNULL_END

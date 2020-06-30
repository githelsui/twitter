//
//  ComposeViewController.h
//  twitter
//
//  Created by Githel Lynn Suico on 6/29/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComposeViewControllerDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface ComposeViewController : UIViewController

@property (nonatomic, weak) id<ComposeViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
